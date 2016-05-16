//
//  SignInViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "SignInViewController.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "ConnectionManager.h"
#import "CallManager.h"

@interface SignInViewController ()
{
    NSDictionary * signin_user;
    NSString * loginSelectUsertype;
}
@end

@implementation SignInViewController
@synthesize roleSegment;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loginSelectUsertype = account_student;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Events

- (IBAction)onBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onSignIn:(id)sender
{
    if ([self.emailTextField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please enter your email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    } else if ([self.passwordTextField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please enter your email password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    // Sign in...
    [SVProgressHUD showWithStatus:@"Sign in..."];
    
    NSDictionary *param = @{
                            @"Email":self.emailTextField.text,
                            @"Password":self.passwordTextField.text,
                            @"device_token":@"TEMPORARY"
                            };
    signin_user = param;
    
    
    [APIService makeApiCallWithMethodUrl:API_SIGN_IN andRequestType:RequestTypePost andPathParams:nil andQueryParams:signin_user resultCallback:^(NSObject *result) {
        NSDictionary *jsonResult = (NSDictionary*) result;
        if ([jsonResult[@"success"] boolValue]) {
            if ([jsonResult[account_type] isEqualToString:loginSelectUsertype]) {
                [SessionManager sharedSession].userInfo = [[UserInfo alloc] initWithDictionary:jsonResult];
                [self performSelectorOnMainThread:@selector(signInQuickBlox) withObject:nil waitUntilDone:NO];
            }
            else
            {
                [SVProgressHUD dismiss];
                
                [self showAlertView:@"Login Failed." :@"Not matched login user type. please switch the login type" :1000];
            }
            
        } else {
            [SVProgressHUD dismiss];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonResult[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    } faultCallback:^(NSError *fault) {
        [SVProgressHUD dismiss];

        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

#pragma Quickblox Sign In

- (void (^)(QBResponse *response, QBUUser *user))successBlock
{
    return ^(QBResponse *response, QBUUser *user) {
        // Sign Up succeeded
        
        NSLog(@"Sign up success : %@", response);
        
        QBUUser * _qbUser = [[QBUUser alloc] init];
        _qbUser.ID = user.ID;
        _qbUser.login = user.login;
        _qbUser.fullName = user.fullName;
        _qbUser.password = quickbloxPass;
        
        [[ConnectionManager instance] logInWithUser:_qbUser completion:^(BOOL error) {
            [SVProgressHUD dismiss];
            if (!error) {
                [QBRTCClient.instance addDelegate:CallManager.instance];
                [[SessionManager sharedSession].userInfo updateQBUserInfo:_qbUser];
                
                [self performSelectorOnMainThread:@selector(jumpToMainView) withObject:nil waitUntilDone:NO];
                
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    };
    
}

- (QBRequestErrorBlock)errorBlock
{
    return ^(QBResponse *response) {
        // Handle error
        NSLog(@"Sign In Error : %@", response);
        [SVProgressHUD dismiss];
        [self showAlertView:@"Sign In Error" : [NSString stringWithFormat:@"%@", response.description] : 1000];
    };
}

- (void) signInQuickBlox {
    
    [[ConnectionManager instance] loginWithEmailUser:[signin_user objectForKey:@"Email"] :quickbloxPass :[self successBlock] : [self errorBlock]];
}



- (void) jumpToMainView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Student" bundle:nil];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"student" forKey:USER_ROLE];
    if ([SessionManager sharedSession].userInfo.isTutor)
    {
        storyboard = [UIStoryboard storyboardWithName:@"Tutor" bundle:nil];
        [[NSUserDefaults standardUserDefaults] setValue:@"tutor" forKey:USER_ROLE];
    }
    
    [self.navigationController pushViewController:storyboard.instantiateInitialViewController animated:YES];
}

#pragma defined action of the segmentcontroller.
- (IBAction)segmentUserType:(id)sender
{
    UISegmentedControl * usertypeSegment = (UISegmentedControl *) sender;
    
    if (usertypeSegment.selectedSegmentIndex == 0) {
        loginSelectUsertype = account_student;
    }
    else
    {
        loginSelectUsertype = account_tutor;
    }
    
}

#pragma defined UIAlertView
- ( void )showAlertView : ( NSString* ) _title : ( NSString * ) _message : ( NSInteger ) alertTag
{
    NSDictionary *attributes = @{ kMONPromptViewAttribDismissButtonBackgroundColor: [UIColor colorWithRed:111/255.0f green:189/255.0f blue:57/255.0f alpha:1.0f],
                                  kMONPromptViewAttribDismissButtonTextColor: [UIColor whiteColor],
                                  };
        
    MONPromptView * promptView = [[MONPromptView alloc] initWithTitle:_title
                                                                 message:_message
                                                      dismissButtonTitle:@"Ok" attributes:attributes];
   [promptView setDelegate:self];
   [promptView setTag:alertTag];
   [promptView showInView:self.navigationController.view];
        
}
     
/**
*
*  Init UIAlertviewDelegate Action.
**/
- ( void ) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        
}
     
- (void)promptViewWillDismiss:(MONPromptView *)promptView
{
    
}

     
@end
