//
//  TweetCell.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "TweetCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

#import "ComposeViewController.h"

@interface TweetCell() <ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *retweeterLabel;
@property (weak, nonatomic) IBOutlet UIView *retweetView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetViewTop;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetCell

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    self.tweetLabel.text = tweet.text;
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.timestampLabel.text = [tweet.createdAt timeAgoSimple];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
    self.profileImage.layer.cornerRadius = 4;
    self.profileImage.clipsToBounds = YES;
    
    if (tweet.retweeter) {
        self.retweeterLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweeter.name];
        [self showRetweetView];
    } else {
        [self hideRetweetView];
    }
    
    [self updateFavoriteElements];
    [self updateRetweetElements];
}

- (void)showRetweetView {
    self.retweetView.hidden = NO;
    self.retweetViewHeight.constant = 16;
    self.retweetViewTop.constant = 8;
}

- (void)hideRetweetView {
    self.retweetView.hidden = YES;
    self.retweetViewHeight.constant = 0;
    self.retweetViewTop.constant = 0;
}

- (void)updateRetweetElements {
    self.retweetButton.selected = self.tweet.retweeted;
    
    if (self.tweet.retweetCount > 0) {
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
    } else {
        self.retweetCountLabel.text = @"";
    }
}

- (void)updateFavoriteElements {
    self.favoriteButton.selected = self.tweet.favorited;
    
    if (self.tweet.favoriteCount > 0) {
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favoriteCount];
    } else {
        self.favoriteCountLabel.text = @"";
    }
}

- (void)awakeFromNib {
    UITapGestureRecognizer *photoTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPhotoTap)];
    [self.profileImage addGestureRecognizer:photoTapGesture];
    self.profileImage.userInteractionEnabled = YES;
}

- (IBAction)onReply:(id)sender {
    ComposeViewController *composerVC = [[ComposeViewController alloc] initWithReplyToTweet:self.tweet];
    composerVC.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:composerVC];
    [self.window.rootViewController presentViewController:nvc animated:YES completion:nil];
}

-(void)composeViewController:(ComposeViewController *)composeViewController tweeted:(Tweet *)tweet {
    if ([self.delegate respondsToSelector:@selector(tweetCell:replyCreated:)]) {
        [self.delegate tweetCell:self replyCreated:tweet];
    }
}

- (IBAction)onRetweet:(id)sender {
    if (self.tweet.retweeted) {
        [self.tweet unretweet];
    } else {
        [self.tweet retweet];
    }
    [self updateRetweetElements];
}

- (IBAction)onFavorite:(id)sender {
    if (self.tweet.favorited) {
        [self.tweet unfavorite];
    } else {
        [self.tweet favorite];
    }
    [self updateFavoriteElements];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)onPhotoTap {
    NSLog(@"onPhotoTap");
    if ([self.delegate respondsToSelector:@selector(photoTabbedInTweetCell:)]) {
        [self.delegate photoTabbedInTweetCell:self];
    }
}

@end
