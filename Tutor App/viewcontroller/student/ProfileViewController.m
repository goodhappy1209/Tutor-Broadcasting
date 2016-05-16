//
//  StudentProfileViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize fullnameLabel, emailLabel, education_attLabel, grade_levelLabel, cityLabel, countryLabel, aboutmeTextView, profileImageView;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self showProfileDataFunc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void ) showProfileDataFunc
{
    
    [aboutmeTextView setEditable:NO];
    
    NSDictionary * dicUserInfo = [SessionManager sharedSession].userInfo.dictServerUser;
    
    NSString * fullnameStr = [NSString stringWithFormat:@"%@ %@", [dicUserInfo objectForKey:account_first_name], [dicUserInfo objectForKey:account_last_name]];
    NSString * emailStr = [dicUserInfo objectForKey:account_email];
    
    NSString * schoolAttStr;
    NSString * gradeLevelStr;
    
    if ([SessionManager sharedSession].userInfo.isTutor == YES) {
        schoolAttStr = [dicUserInfo objectForKey:account_university_tutor];
        gradeLevelStr = [dicUserInfo objectForKey:account_course_tutor];
    }
    else
    {
        schoolAttStr = [dicUserInfo objectForKey:account_school_attending];
        gradeLevelStr = [dicUserInfo objectForKey:account_grade_level];
    }
    
    if (![[dicUserInfo objectForKey:account_profile_image] isEqualToString:@""]) {
        
        NSString * profileImageURL = [SERVER_URL_PROFILE stringByAppendingString:[dicUserInfo objectForKey:account_profile_image]];
        
        [profileImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageURL]]]];
        
    }
    
    
    NSString * cityStr = [dicUserInfo objectForKey:account_city];
    NSString * countryStr = [dicUserInfo objectForKey:account_country];
    NSString * aboutmeStr = [dicUserInfo objectForKey:account_about_me];
    
    [fullnameLabel setText:fullnameStr];
    [emailLabel setText:emailStr];
    [education_attLabel setText:schoolAttStr];
    [grade_levelLabel setText:gradeLevelStr];
    [cityLabel setText:cityStr];
    [countryLabel setText:countryStr];
    [aboutmeTextView setText:aboutmeStr];
    
    
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
