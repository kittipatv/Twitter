//
//  Tweet.h
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, assign) NSInteger tweetID;
@property (nonatomic, assign) NSInteger inReplyToTweetID;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User *retweeter;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) NSInteger retweetCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)favorite;
- (void)unfavorite;
- (Tweet *)replyWithText:(NSString *)text;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;
+ (void)homeTimelineWithCompletion:(void (^)(NSMutableArray *tweets, NSError *error))completion;
+ (Tweet *)tweetWithText:(NSString *)text;

@end
