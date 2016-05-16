//
//  TutorSessionDetailViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "TutorSessionDetailViewController.h"
#import "UserInfo.h"

@interface TutorSessionDetailViewController ()

@end

@implementation TutorSessionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUIData];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRateSession:(id)sender
{
    UIViewController *vc = self.parentViewController.parentViewController;
    [vc performSegueWithIdentifier:@"rateSegue" sender:nil];
}


- (void) initUIData
{
    
    NSDictionary * userInfo ;
    NSString * userName;
    NSString * SubjectStr;
    NSString * tutorCost;
   
    
    if([SessionManager sharedSession].userInfo.isTutor)
    {
        userInfo = [_dictSessionData objectForKey:account_student];
    }
    else
    {
        userInfo = [_dictSessionData objectForKey:account_tutor];
    }
    
    if (![[userInfo objectForKey:account_profile_image] isEqualToString:@""]) {
        
        NSString * profileImageURL = [SERVER_URL_PROFILE stringByAppendingString:[userInfo objectForKey:account_profile_image]];
        
        [_ivUserProfView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageURL]]]];
        
    }
    
    userName = [NSString stringWithFormat:@"%@ %@", [userInfo objectForKey:account_first_name], [userInfo objectForKey:account_last_name]];
    SubjectStr = [userInfo objectForKey:account_subjects];
    tutorCost = [userInfo objectForKey:@"tutor_rate"];
    NSString * SessionInitDays = [_dictSessionData objectForKey:@"initiated"];
    NSString * SessionID = [_dictSessionData objectForKey:tutoring_session_id];
    
    [_lblUserName setText:userName];
    [_lblSubjects setText:SubjectStr];
    [_lblSessionID setText:SessionID];
    [_lblSessionDays setText:SessionInitDays];
    [_lblSessionCost setText:tutorCost];
    
    
}
@end
