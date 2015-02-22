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


@property (nonatomic, strong) UIImage *favoriteOnImage;
@property (nonatomic, strong) UIImage *favoriteOffImage;

@end

@implementation TweetCell

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    self.tweetLabel.text = tweet.text;
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.timestampLabel.text = [tweet.createdAt timeAgoSimple];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
    
    if (tweet.retweeter) {
        self.retweeterLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweeter.name];
        [self showRetweetView];
    } else {
        [self hideRetweetView];
    }
    
    [self updateFavoriteElements];
    
    if (tweet.retweetCount > 0) {
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", tweet.retweetCount];
    } else {
        self.retweetCountLabel.text = @"";
    }
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

- (void)updateFavoriteElements {
    // self.favoriteButton.imageView.image = self.tweet.favorited ? self.favoriteOnImage : self.favoriteOffImage;
    self.favoriteButton.imageView.image = self.tweet.favorited ? [UIImage imageNamed:@"favorite_on"] : [UIImage imageNamed:@"favorite"];
    //[self.favoriteButton.imageView setNeedsDisplay];
    
    if (self.tweet.favoriteCount > 0) {
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favoriteCount];
    } else {
        self.favoriteCountLabel.text = @"";
    }
}

- (void)awakeFromNib {
    self.favoriteOnImage = [UIImage imageNamed:@"favorite_on" inBundle:nil compatibleWithTraitCollection:nil];
    self.favoriteOffImage = [UIImage imageNamed:@"favorite" inBundle:nil compatibleWithTraitCollection:nil];
}

- (IBAction)onReply:(id)sender {
    NSLog(@"reply");
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
    NSLog(@"retweet");
}

- (IBAction)onFavorite:(id)sender {
    if (self.tweet.favorited) {
        [self.tweet unfavorite];
    } else {
        [self.tweet favorite];
    }
    [self updateFavoriteElements];
    if ([self.delegate respondsToSelector:@selector(tweetCell:favoritedDidChange:)]) {
        // [self.delegate tweetCell:self favoritedDidChange:self.tweet.favorited];
    }
    if ([self.delegate respondsToSelector:@selector(tweetCell:favoriteCountDidChange:)]) {
        // [self.delegate tweetCell:self favoriteCountDidChange:self.tweet.favoriteCount];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
