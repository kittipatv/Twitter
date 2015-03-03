//
//  TweetsViewController.h
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TweetsViewControllerDatasource

- (void)timelineWithCompletion:(void (^)(NSMutableArray *tweets, NSError *error))completion;
- (void)timelineWithMaxID:(NSInteger)maxTweetID completion:(void (^)(NSMutableArray *tweets, NSError *error))completion;

@end

@interface TweetsViewController : UIViewController

@property (nonatomic, weak) id<TweetsViewControllerDatasource> tweetDataSource;

- (void)onNew;

- (BOOL)shouldOpenUserTimeline:(NSInteger)userID;

@end
