//
//  ComposePostViewController.m
//  ian-instagram-app
//
//  Created by Ian Andre Aragon Saenz on 07/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "ComposePostViewController.h"
#import "SceneDelegate.h"
#import "Post.h"

@interface ComposePostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *captionText;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.captionText.delegate = self;
    self.captionText.text = @"Type your caption here...";
    self.captionText.textColor = UIColor.lightGrayColor;

    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)];
    [self.postImage addGestureRecognizer:tapImage];
    [self.postImage setUserInteractionEnabled:YES];
}

#pragma mark - Setting Image

- (void)takePhoto{
    UIImagePickerController *imagePickerC = [UIImagePickerController new];
    imagePickerC.delegate = self;
    imagePickerC.allowsEditing = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Media" message:@"Choose camera vs photo library" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            [self sendError:@"Camera source not found"];
            return;
        }
        [self presentViewController:imagePickerC animated:YES completion:nil];
    }];
    [alert addAction:camera];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            imagePickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            [self sendError:@"Photo library source not found"];
            return;
        }
        [self presentViewController:imagePickerC animated:YES completion:nil];
    }];
    [alert addAction:photoLibrary];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    //UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.postImage.image = [self resizeImage:originalImage withSize:(CGSizeMake(325, 325))];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Sizing Image

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size{
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Buttons

- (IBAction)onCancel:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *feedView = [storyBoard instantiateViewControllerWithIdentifier:@"FeedView"];
    sceneDelegate.window.rootViewController = feedView;
}

- (IBAction)onShare:(id)sender {
    [Post postUserImage:self.postImage.image withCaption:self.captionText.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"post succeeded");
        } else {
            NSLog(@"error with sending post: %@", error.localizedDescription);
        }
    }];
    [self onCancel:nil];
}

#pragma mark - Changing Placeholder Text

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if(self.captionText.textColor == UIColor.lightGrayColor){
        self.captionText.text = nil;
        self.captionText.textColor = UIColor.blackColor;
    }
}

#pragma mark - Error

-(void)sendError:(NSString *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
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
