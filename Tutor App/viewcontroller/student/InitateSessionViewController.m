//
//  InitateSessionViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "InitateSessionViewController.h"
#import "ChechoutViewController.h"

@interface InitateSessionViewController ()

@end

@implementation InitateSessionViewController
@synthesize selectedTutor;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.stepper.value = 4.0f;
    self.stepper.stepInterval = 1.0f;
    self.stepper.countLabel.textColor = [UIColor redColor];
    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    };
    [self.stepper setup];
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


#pragma NSError from Server Request.

- (void (^)(NSError *fault)) faultCallback : (NSString *) requestName
{
    return ^(NSError * fault){
        
        [SVProgressHUD dismiss];
        
        NSLog(@"Available Tutor Error : %@", fault.description);
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    };
}
#pragma NSDictionary result from Server Request.

- (void (^)(NSObject * result)) successResultCallback : (NSString *)requestName
{
    return ^(NSObject * result){
        NSDictionary * jsonDic = (NSDictionary *) result;
        NSLog(@"Initate Tutor Session: %@", jsonDic);
        if([jsonDic[@"success"] boolValue])
        {
            [SVProgressHUD dismiss];
            NSObject * sessionInfoDic = (NSObject *) jsonDic[account_tutoring_session];
            
            if ([sessionInfoDic isKindOfClass:[NSDictionary class]]) {
            
                NSDictionary * dicSession = (NSDictionary *) sessionInfoDic;
                [self gotoView:@"Student" :@"ChechoutViewController" :dicSession];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonDic[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonDic[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    };
}




- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Initate tutor session.
- (IBAction)onCheckOutInitSession:(id)sender
{
    NSDictionary * requestParam;
    requestParam = @{
                     
                     account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                     account_device_token : @"TEMPORARY",
                     account_tutor_id : [selectedTutor objectForKey:account_member_id],
                     session_duration : [NSString stringWithFormat:@"%d",(int)self.stepper.value]
                     
                     };

    [SVProgressHUD show];
    
    [APIService makeApiCallWithMethodUrl:API_INITIATETUTORSESSION andRequestType:RequestTypePost andPathParams:nil andQueryParams:requestParam resultCallback:[self successResultCallback : API_INITIATETUTORSESSION] faultCallback:[self faultCallback : API_INITIATETUTORSESSION]];

}

- (void)gotoView : (NSString *)strStoryboard : (NSString *) strIdentifier : (NSDictionary *) SessionInfoDic
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:strStoryboard bundle:nil];
    ChechoutViewController * viewController = [storyBoard instantiateViewControllerWithIdentifier:strIdentifier];
    
    viewController.sessionInfo = SessionInfoDic;
    
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
