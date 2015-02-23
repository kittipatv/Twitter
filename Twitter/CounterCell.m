//
//  CounterCell.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/22/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "CounterCell.h"

@interface CounterCell()

@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;

@end

@implementation CounterCell

- (void)setRetweetCount:(NSInteger)retweetCount {
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", retweetCount];
    if (retweetCount == 1) {
        self.retweetLabel.text = @"RETWEET";
    } else {
        self.retweetLabel.text = @"RETWEETS";
    }
}

- (void)setFavoriteCount:(NSInteger)favoriteCount {
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", favoriteCount];
    if (favoriteCount == 1) {
        self.favoriteLabel.text = @"FAVORITE";
    } else {
        self.favoriteLabel.text = @"FAVORITES";
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
