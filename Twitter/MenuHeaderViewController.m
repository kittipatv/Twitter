//
//  MenuHeaderViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 3/2/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "MenuHeaderViewController.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MenuHeaderViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;

@property (nonatomic, strong) User *user;

@end

@implementation MenuHeaderViewController

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
    self.taglineLabel.text = self.user.tagline;
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageURL]];
    self.profileImageView.layer.cornerRadius = 4;
    self.profileImageView.clipsToBounds = YES;
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
