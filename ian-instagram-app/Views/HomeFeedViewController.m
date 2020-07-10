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

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIRefreshControl *refresh;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchPosts];
    
    [self.refresh addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refresh atIndex:0];
}

#pragma mark - Posts Fetching

- (void)fetchPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(!error){
            self.posts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"error getting posts: %@", error.localizedDescription);
        }
    }];
    [self.refresh endRefreshing];
}

#pragma mark - Logout

- (IBAction)doLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:nil];
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
