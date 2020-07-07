//
//  PostCell.m
//  ian-instagram-app
//
//  Created by Ian Andre Aragon Saenz on 07/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post{
    //self.userImage.image = post.author.profilePic;
    self.userName.text = post.author.username;
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error)
            self.postImage.image = [UIImage imageWithData:data];
    }];
    self.likeCount.text = [[post.likeCount stringValue] stringByAppendingString:@" Likes"];
    self.postDescription.text = [self.userName.text stringByAppendingFormat:@" %@", post.caption];
}

@end
