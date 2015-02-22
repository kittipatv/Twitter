//
//  Tweet.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "Tweet.h"

#import "TwitterClient.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSDictionary *originalTweet = dictionary[@"retweeted_status"] ?: dictionary;
        
        self.text = originalTweet[@"text"];
        self.user = [[User alloc] initWithDictionary:originalTweet[@"user"]];
        
        NSString *createdStr = originalTweet[@"created_at"];
        NSLog(@"created time: %@", createdStr);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdStr];
        NSLog(@"parsed:  %@", self.createdAt);
        
        if (originalTweet != dictionary) {
            self.retweeter = [[User alloc] initWithDictionary:dictionary[@"user"]];
        }
    }
    
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

+ (void)homeTimelineWithCompletion:(void (^)(NSArray *tweets, NSError *error))completion {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:completion];
}

@end
