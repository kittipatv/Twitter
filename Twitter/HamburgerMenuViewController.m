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
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation HamburgerMenuViewController

const CGFloat kMenuWidth = 260.0;

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController {
    self = [super init];
    if (self) {
        self.contentViewController = contentViewController;
        self.menuViewController = menuViewController;
    }
    
    return self;
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    if (_contentViewController) {
        [_contentViewController willMoveToParentViewController:nil];
        [_contentViewController.view removeFromSuperview];
        [_contentViewController removeFromParentViewController];
    }
    _contentViewController = contentViewController;
    [self addChildViewController:contentViewController];

    contentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentView.frame = self.view.bounds;
    [self.contentView insertSubview:contentViewController.view atIndex:0];
    [contentViewController didMoveToParentViewController:self];
}

- (void)setMenuViewController:(UIViewController *)menuViewController {
    if (_menuViewController) {
        [_menuViewController willMoveToParentViewController:nil];
        [_menuViewController.view removeFromSuperview];
        [_menuViewController removeFromParentViewController];
    }
    _menuViewController = menuViewController;
    [self addChildViewController:menuViewController];
    
    menuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGRect bounds = self.view.bounds;
    self.menuView.frame = CGRectMake(0, 0, kMenuWidth, bounds.size.height);
    [self.menuView insertSubview:menuViewController.view atIndex:0];
    [menuViewController didMoveToParentViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuRevealed = NO;
    [self.view bringSubviewToFront:self.contentView];
    [self addShadowToView:self.contentView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITapGestureRecognizer *)tapRecognizer {
    if (_tapRecognizer == nil) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHideTapGesture)];
    }
    return _tapRecognizer;
}

- (void)onHideTapGesture {
    [self hideMenu];
}

- (void)showMenu {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.frame = CGRectMake(kMenuWidth, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.contentView addGestureRecognizer:self.tapRecognizer];
        self.contentViewController.view.userInteractionEnabled = NO;
        self.menuRevealed = YES;
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.contentView removeGestureRecognizer:self.tapRecognizer];
        self.contentViewController.view.userInteractionEnabled = YES;
        self.menuRevealed = NO;
    }];
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender translationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.dragStartX = self.contentView.frame.origin.x;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat dragX = self.dragStartX + translation.x;
        if (dragX >= 0 && dragX <= kMenuWidth) {
            self.contentView.frame = CGRectMake(dragX, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            [self showMenu];
        } else {
            [self hideMenu];
        }
    }
}

-(void)addShadowToView:(UIView*)aView {
    aView.clipsToBounds = NO;
    aView.layer.shadowPath = [UIBezierPath bezierPathWithRect:aView.bounds].CGPath;
    aView.layer.shadowRadius = 10;
    aView.layer.shadowOpacity = 0.75;
    aView.layer.shadowOffset = CGSizeMake(0., 0.);
    aView.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (UINavigationController *)navigationController {
    if ([self.contentViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self.contentViewController;
    } else {
        return [super navigationController];
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

@implementation UIViewController(UIViewControllerHamburgerMenu)

- (HamburgerMenuViewController *)hamburgerMenuViewController {
    if ([self isKindOfClass:[HamburgerMenuViewController class]]) {
        return (HamburgerMenuViewController *)self;
    } else {
        return [[self parentViewController] hamburgerMenuViewController];
    }
}

@end
