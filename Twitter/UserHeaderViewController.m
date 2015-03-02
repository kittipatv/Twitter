//
//  UserHeaderViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 3/1/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "UserHeaderViewController.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface UserHeaderViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;

@property (nonatomic, strong) User *user;

@end

@implementation UserHeaderViewController

- (id)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.tweetCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.followingCount];
    self.followerCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.followerCount];
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageURL]];
    self.profileImageView.layer.cornerRadius = 4;
    self.profileImageView.clipsToBounds = YES;
    if (self.user.profileBannerURL) {
        [self.backgroundImageView setImageWithURL:[NSURL URLWithString:self.user.profileBannerURL]];
    } else {
        self.backgroundImageView.image = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
