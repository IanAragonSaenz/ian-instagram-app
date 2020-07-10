//
//  Post.h
//  ian-instagram-app
//
//  Created by Ian Andre Aragon Saenz on 07/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;

+ (void)postUserImage:(UIImage *_Nullable)image withCaption:(NSString *_Nullable)caption withCompletion:(PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
