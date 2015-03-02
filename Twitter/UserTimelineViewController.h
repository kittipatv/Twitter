//
//  UserTimelineViewController.h
//  Twitter
//
//  Created by Kittipat Virochsiri on 3/1/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "TweetsViewController.h"

#import "User.h"

@interface UserTimelineViewController : TweetsViewController

- (id)initWithUser:(User *)user;

@end
