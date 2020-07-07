//
//  HomeFeedViewController.m
//  ian-instagram-app
//
//  Created by Ian Andre Aragon Saenz on 06/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "PostCell.h"
#import <Parse/Parse.h>

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchPosts];
}

- (void)fetchPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(!error){
            self.posts = posts;
            [self.tableView reloadData];
        }else{
            NSLog(@"error getting posts: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Logout

- (IBAction)doLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - Table View

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    [cell setPost:self.posts[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - Post Actions

- (IBAction)onLike:(id)sender {
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
