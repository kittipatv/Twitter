//
//  HamburgerMenuViewController.h
//  Twitter
//
//  Created by Kittipat Virochsiri on 3/1/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HamburgerMenuViewController : UIViewController

@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, strong) UIViewController *menuViewController;

- (id)initWithContentViewController:(UIViewController *)contentViewController;

@end
