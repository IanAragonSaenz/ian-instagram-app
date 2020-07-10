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
#import "DetailPostViewController.h"
#import "PostCell.h"
#import <Parse/Parse.h>

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (assign, nonatomic) BOOL isLoadingMoreData;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.posts = [NSArray array];
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refresh atIndex:0];
    [self fetchPosts];
}

#pragma mark - Infinite Scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isLoadingMoreData){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging){
            self.isLoadingMoreData = YES;
            [self fetchPosts];
        }
    }
}

- (void)fetchPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 10;
    BOOL isRefreshing = [self.refresh isRefreshing];
    if(!isRefreshing)
        query.skip = self.posts.count;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(!error){
            if(isRefreshing)
                self.posts = posts;
            else
                self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
            [self.tableView reloadData];
        }else{
            NSLog(@"error getting posts: %@", error.localizedDescription);
        }
    }];
    self.isLoadingMoreData = false;
    [self.refresh endRefreshing];
}

#pragma mark - Logout

- (IBAction)doLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //need this open so that PFUser.current()  sets to nil
    }];
}

#pragma mark - Table View Data Source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    [cell setPost:self.posts[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"DetailSegue" sender:self.posts[indexPath.row]];
}

#pragma mark - Post Actions

- (IBAction)onLike:(id)sender {
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"DetailSegue"]){
        DetailPostViewController *detailView = [segue destinationViewController];
        detailView.post = sender;
    }
}

@end
