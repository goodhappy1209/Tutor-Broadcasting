//
//  SignupSelectViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "SignupSelectViewController.h"
#import "HomeViewController.h"

@interface SignupSelectViewController ()

@end

@implementation SignupSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onLogin:(id)sender
{
    HomeViewController *vc = (HomeViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    vc.b_fromSignup = YES;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

@end
