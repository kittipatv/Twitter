//
//  MenuItemCell.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 3/1/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "MenuItemCell.h"

@interface MenuItemCell()

@property (weak, nonatomic) IBOutlet UILabel *menuLabel;

@end

@implementation MenuItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMenuText:(NSString *)menuText {
    _menuText = menuText;
    self.menuLabel.text = menuText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
