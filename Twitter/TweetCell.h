//
//  TweetCell.h
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tweet.h"

@interface TweetCell : UITableViewCell

- (void)fillWithTweet:(Tweet *)tweet;

@end
