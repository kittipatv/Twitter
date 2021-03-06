//
//  TweetViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/22/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "TweetViewController.h"

#import "BigTweetCell.h"
#import "ComposeViewController.h"
#import "ControlCell.h"
#import "CounterCell.h"
#import "TwitterClient.h"

@interface TweetViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, ControlCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) NSMutableArray *inReplyToTweets;

@end

@implementation TweetViewController

- (id)initWithTweet:(Tweet *)tweet {
    self = [super init];
    
    if (self) {
        self.tweet = tweet;
        [self loadInReplyToTweet:tweet];
    }
    
    return self;
}

- (void)loadInReplyToTweet:(Tweet *)tweet {
    if (self.inReplyToTweets.count > 10) {
        // Don't want to go too deep
        return;
    }
    if (tweet.inReplyToTweetID == 0) {
        // End of chain
        return;
    }
    [[TwitterClient sharedInstance] getTweetWithID:tweet.inReplyToTweetID completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            [self.inReplyToTweets addObject:tweet];
            [self.tableView reloadData];
            [self loadInReplyToTweet:tweet];
        } else {
            NSLog(@"failed to load in-reply-to tweet: %@", error);
        }
    }];
}

NSString * const kBigTweetCell = @"BigTweetCell";
NSString * const kControlCell = @"ControlCell";
NSString * const kCounterCell = @"CounterCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tweet";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:kBigTweetCell bundle:nil] forCellReuseIdentifier:kBigTweetCell];
    [self.tableView registerNib:[UINib nibWithNibName:kCounterCell bundle:nil] forCellReuseIdentifier:kCounterCell];
    [self.tableView registerNib:[UINib nibWithNibName:kControlCell bundle:nil] forCellReuseIdentifier:kControlCell];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.inReplyToTweets = [NSMutableArray array];
}

- (void)onReply {
    ComposeViewController *composerVC = [[ComposeViewController alloc] initWithReplyToTweet:self.tweet];
    composerVC.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:composerVC];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)composeViewController:(ComposeViewController *)composeViewController tweeted:(Tweet *)tweet {
    if ([self.delegate respondsToSelector:@selector(tweetViewController:replyCreated:)]) {
        [self.delegate tweetViewController:self replyCreated:tweet];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3 + self.inReplyToTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        CounterCell *cell = (CounterCell *)[self.tableView dequeueReusableCellWithIdentifier:kCounterCell];
        cell.retweetCount = self.tweet.retweetCount;
        cell.favoriteCount = self.tweet.favoriteCount;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 2) {
        ControlCell *cell = (ControlCell *)[self.tableView dequeueReusableCellWithIdentifier:kControlCell];
        cell.tweet = self.tweet;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        BigTweetCell *cell = (BigTweetCell *)[self.tableView dequeueReusableCellWithIdentifier:kBigTweetCell];
        if (indexPath.row == 0) {
            cell.tweet = self.tweet;
        } else {
            cell.tweet = self.inReplyToTweets[indexPath.row - 3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3) {
        // Don't handle the first three rows
        return;
    }
    TweetViewController *tweetVC = [[TweetViewController alloc] initWithTweet:self.inReplyToTweets[indexPath.row - 3]];
    [self.navigationController pushViewController:tweetVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)updateRow:(NSInteger)row {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)controlCell:(ControlCell *)controlCell favoriteDidChange:(Tweet *)tweet {
    [self updateRow:1];
    if ([self.delegate respondsToSelector:@selector(tweetViewController:tweetUpdated:)]) {
        [self.delegate tweetViewController:self tweetUpdated:tweet];
    }
}

- (void)controlCell:(ControlCell *)controlCell retweetDidChange:(Tweet *)tweet {
    [self updateRow:0];
    [self updateRow:1];
    if ([self.delegate respondsToSelector:@selector(tweetViewController:tweetUpdated:)]) {
        [self.delegate tweetViewController:self tweetUpdated:tweet];
    }
}

- (void)controlCell:(ControlCell *)controlCell replyCreated:(Tweet *)tweet {
    if ([self.delegate respondsToSelector:@selector(tweetViewController:replyCreated:)]) {
        [self.delegate tweetViewController:self replyCreated:tweet];
    }
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
