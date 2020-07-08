//
//  DetailPostViewController.m
//  ian-instagram-app
//
//  Created by Ian Andre Aragon Saenz on 08/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "DetailPostViewController.h"
#import "DateTools.h"

@interface DetailPostViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *timeAgo;
@property (weak, nonatomic) IBOutlet UILabel *caption;

@end

@implementation DetailPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userName.text = self.post.author.username;
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error)
            self.postImage.image = [UIImage imageWithData:data];
    }];
    self.likeCount.text = [[self.post.likeCount stringValue] stringByAppendingString:@" Likes"];
    self.commentCount.text = [[self.post.commentCount stringValue] stringByAppendingString:@" Comments"];
    self.caption.text = [self.userName.text stringByAppendingFormat:@" %@", self.post.caption];
    self.timeAgo.text = self.post.createdAt.timeAgoSinceNow;
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
