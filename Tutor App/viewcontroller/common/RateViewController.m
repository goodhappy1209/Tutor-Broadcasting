//
//  RateViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "RateViewController.h"
#import "MHCustomTabBarController.h"

@interface RateViewController ()

@end

@implementation RateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CALayer *btnLayer = [self.commentTextView layer];
    [btnLayer setBorderColor:[UIColor colorWithHexString:@"#6FBD39"].CGColor];
    btnLayer.borderWidth = 0.6f;
    btnLayer.cornerRadius = 0.0f;
    
    _starRatingView.maximumValue = 5;
    _starRatingView.minimumValue = 0;
    _starRatingView.value = 0;
    _starRatingView.tintColor = [UIColor colorWithHexString:@"#6FBD39"];
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

- (IBAction)onOK:(id)sender
{
    MHCustomTabBarController *vc =   (MHCustomTabBarController *)self.presentingViewController;
    NSString *role = [[NSUserDefaults standardUserDefaults] valueForKey:USER_ROLE];
    if ([role isEqualToString:@"student"])
    {
        if ([(UINavigationController *)vc.destinationViewController viewControllers].count > 2)
            [(UINavigationController *)vc.destinationViewController popToViewController:[[(UINavigationController *)vc.destinationViewController viewControllers] objectAtIndex:1] animated:NO];
        else
            [(UINavigationController *)vc.destinationViewController popViewControllerAnimated:NO];

    }
    else
    {
        [(UINavigationController *)vc.destinationViewController popViewControllerAnimated:NO];

    }
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        
        
    }];
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
