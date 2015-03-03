//
//  MentionsTimelineViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 3/2/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "MentionsTimelineViewController.h"

#import "Tweet.h"

@interface MentionsTimelineViewController () <TweetsViewControllerDatasource>

@end

@implementation MentionsTimelineViewController

- (id)init {
    self = [super init];
    if (self) {
        self.tweetDataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Mentions";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timelineWithCompletion:(void (^)(NSMutableArray *, NSError *))completion {
    [Tweet mentionsTimelineWithCompletion:completion];
}

- (void)timelineWithMaxID:(NSInteger)maxTweetID completion:(void (^)(NSMutableArray *, NSError *))completion {
    [Tweet mentionsTimelineWithMaxID:maxTweetID completion:completion];
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
