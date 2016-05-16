//
//  StudentMainViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "StudentMainViewController.h"

@interface StudentMainViewController ()

@end

@implementation StudentMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self performSegueWithIdentifier:@"viewController1" sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onLogout:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onProfile:(id)sender
{

    _profileBtn.backgroundColor = [UIColor colorWithHexString:GREEN_COLOR];
    _tutorBtn.backgroundColor = [UIColor colorWithHexString:GRAY_COLOR];
    _historyBtn.backgroundColor = [UIColor colorWithHexString:GRAY_COLOR];
    
   [self performSegueWithIdentifier:@"viewController1" sender:nil];
}

- (IBAction)onFindTutor:(id)sender
{
    _tutorBtn.backgroundColor = [UIColor colorWithHexString:GREEN_COLOR];
    _profileBtn.backgroundColor = [UIColor colorWithHexString:GRAY_COLOR];
    _historyBtn.backgroundColor = [UIColor colorWithHexString:GRAY_COLOR];
    
    [self performSegueWithIdentifier:@"viewController2" sender:nil];
}

- (IBAction)onHistory:(id)sender
{
    _historyBtn.backgroundColor = [UIColor colorWithHexString:GREEN_COLOR];
    _profileBtn.backgroundColor = [UIColor colorWithHexString:GRAY_COLOR];
    _tutorBtn.backgroundColor = [UIColor colorWithHexString:GRAY_COLOR];
    
    [self performSegueWithIdentifier:@"viewController3" sender:nil];
}

@end
