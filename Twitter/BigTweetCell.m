//
//  BigTweetCell.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/22/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "BigTweetCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

@interface BigTweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIView *retweetView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetHeight;
@property (weak, nonatomic) IBOutlet UILabel *retweeterLabel;

@end

@implementation BigTweetCell

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    self.tweetLabel.text = tweet.text;
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.timestampLabel.text = [formatter stringFromDate:tweet.createdAt];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
    
    if (tweet.retweeter) {
        self.retweeterLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweeter.name];
        [self showRetweetView];
    } else {
        [self hideRetweetView];
    }
}

- (void)showRetweetView {
    self.retweetView.hidden = NO;
    self.retweetHeight.constant = 16;
    self.retweetTop.constant = 8;
}

- (void)hideRetweetView {
    self.retweetView.hidden = YES;
    self.retweetHeight.constant = 0;
    self.retweetTop.constant = 0;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
