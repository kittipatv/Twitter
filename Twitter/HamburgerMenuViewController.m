//
//  HamburgerMenuViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 3/1/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "HamburgerMenuViewController.h"

@interface HamburgerMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (nonatomic, assign) BOOL menuRevealed;
@property (nonatomic, assign) CGFloat dragStartX;

@end

@implementation HamburgerMenuViewController

const CGFloat kMenuWidth = 260.0;

- (id)initWithContentViewController:(UIViewController *)contentViewController {
    self = [super init];
    if (self) {
        self.contentViewController = contentViewController;
    }
    
    return self;
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    if (_contentViewController) {
        [_contentViewController willMoveToParentViewController:nil];
        [_contentViewController.view removeFromSuperview];
        [_contentViewController removeFromParentViewController];
    }
    NSLog(@"setContentViewController");
    _contentViewController = contentViewController;
    [self addChildViewController:contentViewController];

    contentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentView.frame = self.view.bounds;
    [self.contentView insertSubview:contentViewController.view atIndex:0];
    [contentViewController didMoveToParentViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuRevealed = NO;
    [self.view bringSubviewToFront:self.contentView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender translationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.dragStartX = self.contentView.frame.origin.x;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.contentView.frame = CGRectMake(self.dragStartX + translation.x, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            if (velocity.x > 0) {
                self.contentView.frame = CGRectMake(kMenuWidth, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
            } else {
                self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
            }
        } completion:^(BOOL finished) {
            self.menuRevealed = velocity.x > 0;
        }];
    }
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
