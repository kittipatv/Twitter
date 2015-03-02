//
//  HomeTimelineViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 3/1/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "HomeTimelineViewController.h"

#import "Tweet.h"

@interface HomeTimelineViewController () <TweetsViewControllerDatasource>

@end

@implementation HomeTimelineViewController

- (id)init {
    self = [super init];
    if (self) {
        self.tweetDataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOut)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNew)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timelineWithCompletion:(void (^)(NSMutableArray *, NSError *))completion {
    [Tweet homeTimelineWithCompletion:completion];
}

- (void)timelineWithMaxID:(NSInteger)maxTweetID completion:(void (^)(NSMutableArray *, NSError *))completion {
    [Tweet homeTimelineWithMaxID:maxTweetID completion:completion];
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
