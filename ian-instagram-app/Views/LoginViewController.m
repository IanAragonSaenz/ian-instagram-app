//
//  LoginViewController.m
//  ian-instagram-app
//
//  Created by Ian Andre Aragon Saenz on 06/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Login/Sign Up

- (IBAction)doSignUp:(id)sender {
    if([self usernameEmpty:self.usernameText.text password:self.passwordText.text])
        return;
    
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameText.text;
    newUser.password = self.passwordText.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"user registered");
            [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
        } else {
            NSLog(@"error occure at signup: %@", error.localizedDescription);
            [self errorFound:error.localizedDescription];
        }
    }];
}

- (IBAction)doLogin:(id)sender {
    if([self usernameEmpty:self.usernameText.text password:self.passwordText.text])
        return;
    
    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;

    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if(error){
            NSLog(@"error at login: %@", error.localizedDescription);
            [self errorFound:error.localizedDescription];
        } else {
            NSLog(@"login succesful");
            [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
        }
    }];
}

#pragma mark - Input Checkers

- (BOOL)usernameEmpty:(NSString *)username password:(NSString *)password{
    if([username isEqualToString:@""]){
        [self errorFound:@"Username is empty"];
        return YES;
    }
    else if([password isEqualToString:@""]){
        [self errorFound:@"Password is empty"];
        return YES;
    }
    return NO;
}

#pragma mark - Error Alerts

- (void)errorFound:(NSString *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:(UIAlertActionStyleDefault) handler:nil];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
