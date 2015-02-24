//
//  TwitterClient.h
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "Tweet.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *tweets, NSError *error))completion;
- (void)getTweetWithID:(NSInteger)tweetID completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)createTweetWithText:(NSString *)text completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)createTweetWithText:(NSString *)text inReplyTo:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)deleteTweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)deleteTweetWithID:(NSInteger)tweetID completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)favoriteTweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)unfavoriteTweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
