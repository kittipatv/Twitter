//
//  Tweet.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "Tweet.h"

#import "TwitterClient.h"

@interface Tweet()

@end

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSDictionary *originalTweet = dictionary[@"retweeted_status"] ?: dictionary;
        
        self.text = originalTweet[@"text"];
        self.user = [[User alloc] initWithDictionary:originalTweet[@"user"]];
        
        NSString *createdStr = originalTweet[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdStr];
        
        if (originalTweet != dictionary) {
            self.retweeter = [[User alloc] initWithDictionary:dictionary[@"user"]];
        }
        
        self.favorited = [originalTweet[@"favorited"] boolValue];
        self.favoriteCount = [originalTweet[@"favorite_count"] integerValue];
        self.retweeted = [originalTweet[@"retweeted"] boolValue];
        self.retweetCount = [originalTweet[@"retweet_count"] integerValue];
        
        self.tweetID = [originalTweet[@"id"] integerValue];
        if (originalTweet[@"in_reply_to_status_id"] != [NSNull null]) {
            self.inReplyToTweetID = [originalTweet[@"in_reply_to_status_id"] integerValue];
        } else {
            self.inReplyToTweetID = 0;
        }
    }
    
    return self;
}

- (void)favorite {
    self.favorited = YES;
    ++self.favoriteCount;
    [[TwitterClient sharedInstance] favoriteTweet:self completion:nil];
}

- (void)unfavorite {
    self.favorited = NO;
    --self.favoriteCount;
    [[TwitterClient sharedInstance] unfavoriteTweet:self completion:nil];
}

- (Tweet *)replyWithText:(NSString *)text {
    [[TwitterClient sharedInstance] createTweetWithText:text inReplyTo:self completion:nil];
    
    Tweet *tweet = [Tweet tweetForCurrentUserWithText:text];
    tweet.inReplyToTweetID = self.tweetID;
    
    return tweet;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

+ (void)homeTimelineWithCompletion:(void (^)(NSMutableArray *tweets, NSError *error))completion {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:completion];
}

+ (Tweet *)tweetWithText:(NSString *)text {
    [[TwitterClient sharedInstance] createTweetWithText:text completion:nil];
    return [Tweet tweetForCurrentUserWithText:text];
}

+ (Tweet *)tweetForCurrentUserWithText:(NSString *)text {
    Tweet *tweet = [[Tweet alloc] init];
    tweet.text = text;
    tweet.user = [User currentUser];
    tweet.createdAt = [NSDate date];
    return tweet;
}

@end
