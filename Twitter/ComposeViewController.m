//
//  ComposeViewController.m
//  Twitter
//
//  Created by Kittipat Virochsiri on 2/22/15.
//  Copyright (c) 2015 Kittipat Virochsiri. All rights reserved.
//

#import "ComposeViewController.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "Tweet.h"
#import "User.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) UILabel *remainingCharacterLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    User *user = [User currentUser];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:user.profileImageURL]];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.textView.text = @"";
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
    
    self.remainingCharacterLabel = [[UILabel alloc] init];
    self.remainingCharacterLabel.text = @"140";
    [self.remainingCharacterLabel sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
    UIBarButtonItem *counterButton = [[UIBarButtonItem alloc] initWithCustomView:self.remainingCharacterLabel];
    self.navigationItem.rightBarButtonItems = @[tweetButton, counterButton];
}

- (void)onTweet {
    if (self.textView.text.length == 0 || self.textView.text.length > 140) {
        return;
    }
    Tweet *tweet = [[Tweet alloc] init];
    tweet.text = self.textView.text;
    tweet.user = [User currentUser];
    tweet.createdAt = [NSDate date];
    [tweet save];
    
    [self.delegate composeViewController:self tweeted:tweet];
    
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCancel {
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger remainingCharacters = 140 - textView.text.length;
    self.remainingCharacterLabel.text = [NSString stringWithFormat:@"%ld", remainingCharacters];
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
