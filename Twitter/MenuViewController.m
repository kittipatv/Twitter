//
//  MenuViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 3/1/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "MenuViewController.h"

#import "HamburgerMenuViewController.h"
#import "MentionsTimelineViewController.h"
#import "MenuHeaderViewController.h"
#import "MenuItemCell.h"
#import "User.h"
#import "UserTimelineViewController.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MenuHeaderViewController *headerViewController;

@end

@implementation MenuViewController

NSString * const kMenuItemCell = @"MenuItemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView registerNib:[UINib nibWithNibName:kMenuItemCell bundle:nil] forCellReuseIdentifier:kMenuItemCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.headerViewController = [[MenuHeaderViewController alloc] initWithUser:[User currentUser]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOut)];
}

- (void)onSignOut {
    [User logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItemCell *cell = (MenuItemCell *)[self.tableView dequeueReusableCellWithIdentifier:kMenuItemCell];
    switch (indexPath.row) {
        case 0:
            cell.menuText = @"Home";
            break;
        case 1:
            cell.menuText = @"My timeline";
            break;
        case 2:
            cell.menuText = @"Mentions";
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HamburgerMenuViewController *hamburgerMenuViewController = self.hamburgerMenuViewController;
    switch (indexPath.row) {
        case 0:
            [hamburgerMenuViewController.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 1:
        {
            UserTimelineViewController *userTimelineViewController = [[UserTimelineViewController alloc] initWithUser:[User currentUser]];
            [hamburgerMenuViewController.navigationController pushViewController:userTimelineViewController animated:YES];
            break;
        }
        case 2:
        {
            MentionsTimelineViewController *mentionsTimelineViewController = [[MentionsTimelineViewController alloc] init];
            [hamburgerMenuViewController.navigationController pushViewController:mentionsTimelineViewController animated:YES];
            break;
        }
        default:
            break;
    }
    [hamburgerMenuViewController hideMenu];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerViewController.view;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 88;
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
