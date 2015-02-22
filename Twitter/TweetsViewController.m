//
//  TweetsViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "TweetsViewController.h"

#import "Tweet.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "User.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TweetCell *prototypeTweetCell;
@property (nonatomic, strong) UIRefreshControl *refresh;
@property (nonatomic, strong) NSArray *tweets;

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
    
    self.prototypeTweetCell = [[TweetCell alloc] init];
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refresh atIndex:0];
    
    [self onRefresh];
}

- (void)onRefresh {
    [Tweet homeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
    //[self.prototypeTweetCell fillWithTweet:self.tweets[indexPath.row]];
    //CGSize size = [self.prototypeTweetCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    //return size.height + 1;
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
