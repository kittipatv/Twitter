//
//  TweetViewController.h
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/22/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tweet.h"

@class TweetViewController;

@protocol TweetViewControllerDelegate <NSObject>

- (void)tweetViewController:(TweetViewController *)tweetViewController replyCreated:(Tweet *)tweet;
- (void)tweetViewController:(TweetViewController *)tweetViewController tweetUpdated:(Tweet *)tweet;

@end

@interface TweetViewController : UIViewController

@property (nonatomic, weak) id<TweetViewControllerDelegate> delegate;

- (id)initWithTweet:(Tweet *)tweet;

@end
