//
//  ControlCell.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/22/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "ControlCell.h"

#import "ComposeViewController.h"

@interface ControlCell() <ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation ControlCell

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    [self updateRetweetButton];
    [self updateFavoriteButton];
    
}

- (void)updateRetweetButton {
    self.retweetButton.selected = self.tweet.retweeted;
}

- (void)updateFavoriteButton {
    self.favoriteButton.selected = self.tweet.favorited;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onReply:(id)sender {
    ComposeViewController *composerVC = [[ComposeViewController alloc] initWithReplyToTweet:self.tweet];
    composerVC.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:composerVC];
    [self.window.rootViewController presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onRetweet:(id)sender {
    if (self.tweet.retweeted) {
        [self.tweet unretweet];
    } else {
        [self.tweet retweet];
    }
    [self updateRetweetButton];
    if ([self.delegate respondsToSelector:@selector(controlCell:retweetDidChange:)]) {
        [self.delegate controlCell:self retweetDidChange:self.tweet];
    }
}

- (IBAction)onFavorite:(id)sender {
    if (self.tweet.favorited) {
        [self.tweet unfavorite];
    } else {
        [self.tweet favorite];
    }
    [self updateFavoriteButton];
    if ([self.delegate respondsToSelector:@selector(controlCell:favoriteDidChange:)]) {
        [self.delegate controlCell:self favoriteDidChange:self.tweet];
    }
}

- (void)composeViewController:(ComposeViewController *)composeViewController tweeted:(Tweet *)tweet {
    if ([self.delegate respondsToSelector:@selector(controlCell:replyCreated:)]) {
        [self.delegate controlCell:self replyCreated:tweet];
    }
}

@end
