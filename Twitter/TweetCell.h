//
//  TweetCell.h
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

@optional
- (void)tweetCell:(TweetCell *)tweetCell replyCreated:(Tweet *)tweet;
- (void)photoTabbedInTweetCell:(TweetCell *)tweetCell;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

@end
