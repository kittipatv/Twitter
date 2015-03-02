//
//  UserTimelineViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 3/1/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "UserTimelineViewController.h"

#import "Tweet.h"
#import "User.h"

@interface UserTimelineViewController () <TweetsViewControllerDatasource>

@end

@implementation UserTimelineViewController

- (id)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        self.user = user;
        self.tweetDataSource = self;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.user.userID == [User currentUser].userID ? @"Me" : self.user.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)timelineWithCompletion:(void (^)(NSMutableArray *, NSError *))completion {
    [Tweet userTimeline:self.user.userID completion:completion];
}

- (void)timelineWithMaxID:(NSInteger)maxTweetID completion:(void (^)(NSMutableArray *, NSError *))completion {
    [Tweet userTimeline:self.user.userID maxID:maxTweetID completion:completion];
}

- (BOOL)shouldOpenUserTimeline:(NSInteger)userID {
    return self.user.userID != userID;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
