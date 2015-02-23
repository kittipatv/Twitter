//
//  TweetsViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "TweetsViewController.h"

#include "ComposeViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TweetViewController.h"
#import "TwitterClient.h"
#import "User.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetCellDelegate, TweetViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIRefreshControl *refresh;
@property (nonatomic, strong) NSMutableArray *tweets;

@end

@implementation TweetsViewController

NSString * const kTweetCell = @"TweetCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOut)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNew)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    [self.tableView registerNib:[UINib nibWithNibName:kTweetCell bundle:nil] forCellReuseIdentifier:kTweetCell];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refresh atIndex:0];
    
    [self onRefresh];
}

- (void)onRefresh {
    [Tweet homeTimelineWithCompletion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"failed to get tweets");
        }
        [self.refresh endRefreshing];
    }];
}

- (void)onSignOut {
    [User logout];
}

- (void)onNew {
    NSLog(@"new tweet");
    
    ComposeViewController *composeVC = [[ComposeViewController alloc] init];
    composeVC.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:composeVC];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)composeViewController:(ComposeViewController *)composeViewController tweeted:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = (TweetCell *)[self.tableView dequeueReusableCellWithIdentifier:kTweetCell];
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewController *tweetVC = [[TweetViewController alloc] initWithTweet:self.tweets[indexPath.row]];
    tweetVC.delegate = self;
    [self.navigationController pushViewController:tweetVC animated:YES];
}

- (void)updateTweetCell:(TweetCell *)tweetCell {
    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:tweetCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertNewTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)tweetCell:(TweetCell *)tweetCell replyCreated:(Tweet *)tweet {
    [self insertNewTweet:tweet];
}

- (void)tweetViewController:(TweetViewController *)tweetViewController replyCreated:(Tweet *)tweet {
    [self insertNewTweet:tweet];
}

- (void)tweetViewController:(TweetViewController *)tweetViewController tweetUpdated:(Tweet *)tweet {
    // TODO update row
    // [self.tableView reloadRowsAtIndexPaths:@[[self.tableView]] withRowAnimation:<#(UITableViewRowAnimation)#>];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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
