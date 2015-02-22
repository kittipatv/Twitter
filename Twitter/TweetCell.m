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

@interface TweetCell()

@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *retweeterLabel;
@property (weak, nonatomic) IBOutlet UIView *retweetView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetViewTop;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end

@implementation TweetCell

- (void)setTweet:(Tweet *)tweet {
    _tweet  = tweet;
    
    self.tweetLabel.text = tweet.text;
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.timestampLabel.text = [tweet.createdAt timeAgoSimple];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
    
    BOOL retweetViewHidden = self.retweetView.hidden;
    
    if (tweet.retweeter) {
        self.retweeterLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweeter.name];
        [self showRetweetView];
    } else {
        [self hideRetweetView];
    }
    
    if (self.retweetView.hidden != retweetViewHidden) {
        [self setNeedsUpdateConstraints];
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
