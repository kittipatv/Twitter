//
//  TwitterClient.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "TwitterClient.h"

#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"olBsWJc8mwdZ4DMbXKrI6Gift";
NSString * const kTwitterConsumerSecret = @"qQqPSZOnANz7Ndb6htieA3HcULh20nMLlHTCfXFZkYmriMJOGW";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Got the request token");
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"Failed to request token");
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got the access token: %@", accessToken.token);
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user: %@", user.name);
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to get current user");
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get access token");
        self.loginCompletion(nil, error);
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"tweets: %@", responseObject);
        completion([Tweet tweetsWithArray:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)params completionWithTweetOrError:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion ) {
            completion([[Tweet alloc] initWithDictionary:responseObject], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (NSDictionary *)parametersWithID:(NSInteger)ID {
    return @{@"id": [NSNumber numberWithInteger:ID]};
}

- (void)createTweetWithText:(NSString *)text completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:@"1.1/statuses/update.json" parameters:@{@"status": text} completionWithTweetOrError:completion];
}

- (void)createTweetWithText:(NSString *)text inReplyTo:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSDictionary *parameters =
    @{
      @"status": text,
      @"in_reply_to_status_id": [NSString stringWithFormat:@"%ld", tweet.tweetID]
    };
    [self POST:@"1.1/statuses/update.json" parameters:parameters completionWithTweetOrError:completion];
}

- (void)deleteTweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self deleteTweetWithID:tweet.tweetID completion:completion];
}

- (void)deleteTweetWithID:(NSInteger)tweetID completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *postURL = [NSString stringWithFormat:@"1.1/statuses/destroy/%ld.json", tweetID];
    [self POST:postURL parameters:nil completionWithTweetOrError:completion];
}

- (void)favoriteTweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:@"1.1/favorites/create.json" parameters:[self parametersWithID:tweet.tweetID] completionWithTweetOrError:completion];
}

- (void)unfavoriteTweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:@"1.1/favorites/destroy.json" parameters:[self parametersWithID:tweet.tweetID] completionWithTweetOrError:completion];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *postURL = [NSString stringWithFormat:@"1.1/statuses/retweet/%ld.json", tweet.tweetID];
    [self POST:postURL parameters:nil completionWithTweetOrError:completion];
}

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self deleteTweetWithID:tweet.retweetID completion:completion];
}

@end
