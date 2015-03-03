//
//  LoginViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/21/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "LoginViewController.h"

#import "AppDelegate.h"
#import "HamburgerMenuViewController.h"
#import "HomeTimelineViewController.h"
#import "MenuViewController.h"
#import "TwitterClient.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user) {
            NSLog(@"welcome, %@", user.name);
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[HomeTimelineViewController alloc] init]];
            MenuViewController *menuViewController = [[MenuViewController alloc] init];
            UINavigationController *menuNavigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
            
            HamburgerMenuViewController *hamburgerViewController = [[HamburgerMenuViewController alloc] initWithContentViewController:navigationController menuViewController:menuNavigationController];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [UIView transitionWithView:appDelegate.window duration:0.3 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                appDelegate.window.rootViewController = hamburgerViewController;
            } completion:nil];
        } else {
            NSLog(@"no...");
        }
    }];
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
