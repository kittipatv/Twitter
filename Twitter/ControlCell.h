//
//  ControlCell.h
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/22/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tweet.h"

@class ControlCell;

@protocol ControlCellDelegate <NSObject>

@optional
- (void)controlCell:(ControlCell *)controlCell replyCreated:(Tweet *)tweet;
- (void)controlCell:(ControlCell *)controlCell retweetDidChange:(Tweet *)tweet;
- (void)controlCell:(ControlCell *)controlCell favoriteDidChange:(Tweet *)tweet;

@end

@interface ControlCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<ControlCellDelegate> delegate;

@end
