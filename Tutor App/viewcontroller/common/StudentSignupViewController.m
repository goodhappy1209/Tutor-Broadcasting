//
//  StudentSignupViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "StudentSignupViewController.h"

@interface StudentSignupViewController ()
{
    BOOL checkBlankField;
    NSDictionary * signUpUser;
}
@end

@implementation StudentSignupViewController

@synthesize first_nameTextField, last_nameTextField, emailTextField, phoneTextField, birthdayTextField, cityTextField, countryTextField, schoolAttTextField, gra_eduTextField, subjectTextField, passwordTextField;


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

- (IBAction)onSignUp:(id)sender
{
    [self.view endEditing:YES];
    
    if (![self checkBlankView:self.view]) {
        
        [self showAlertView:@"Warning" :@"Invalid input information. please try again." :1000];
        
        return;
    }
    
    
    // Sign up...
    [SVProgressHUD showWithStatus:@"Sign up..."];
    
    NSDictionary *param = @{
                            
                            account_type : account_student,
                            account_first_name : first_nameTextField.text,
                            account_last_name : last_nameTextField.text,
                            account_email : emailTextField.text,
                            account_password : passwordTextField.text,
                            account_phone : phoneTextField.text,
                            account_birthday : birthdayTextField.text,
                            account_city : cityTextField.text,
                            account_state : @"",
                            account_country : countryTextField.text,
                            account_school_attending : schoolAttTextField.text,
                            account_grade_level : gra_eduTextField.text,
                            account_subjects : subjectTextField.text
                            
                            };
    signUpUser = param;
    
    [APIService makeApiCallWithMethodUrl:API_SIGN_UP andRequestType:RequestTypePost andPathParams:nil andQueryParams:signUpUser resultCallback:^(NSObject *result) {
        NSDictionary *jsonResult = (NSDictionary*) result;
        
        NSLog(@"Sign up Return : %@", jsonResult);
        
        if ([jsonResult[@"success"] boolValue]) {
            [SessionManager sharedSession].userInfo = [[UserInfo alloc] initWithDictionary:signUpUser];
            
            [self performSelectorOnMainThread:@selector(signUpQuickBlox) withObject:nil waitUntilDone:NO];
            
        } else {
            [SVProgressHUD dismiss];
        
            [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonResult[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    } faultCallback:^(NSError *fault) {
        [SVProgressHUD dismiss];
        
        NSLog(@"Sign up Error : %@", fault.description);
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
}

#pragma Quickblox Signup

- (void (^)(QBResponse *response, QBUUser *user))successBlock
{
    return ^(QBResponse *response, QBUUser *user) {
        // Sign Up succeeded
        
        NSLog(@"Sign up success : %@", response);
        
        [SVProgressHUD dismiss];
        
        NSString *message = @"Your account has been created!";
        [self showAlertView:@"Success" :message :2000];
        
//        QBUUser * _qbUser = [[QBUUser alloc] init];
//        _qbUser.ID = user.ID;
//        _qbUser.login = user.login;
//        _qbUser.fullName = user.fullName;
//        _qbUser.password = [signUpUser objectForKey:@"password"];
//        
//        [[ConnectionManager instance] logInWithUser:_qbUser completion:^(BOOL error) {
//            [SVProgressHUD dismiss];
//                    if (!error) {
//                        [QBRTCClient.instance addDelegate:CallManager.instance];
//                        
//                        [[SessionManager sharedSession].userInfo updateQBUserInfo:_qbUser];
//                        
//                        NSString *message = @"Your account has been created!";
//                        [self showAlertView:@"Success" :message :2000];
//                        
//                    } else {
//                        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                    }
//        }];
    };
    
}

- (QBRequestErrorBlock)errorBlock
{
    return ^(QBResponse *response) {
        // Handle error
        NSLog(@"Sign up Error : %@", response);
        [SVProgressHUD dismiss];
        [self showAlertView:@"Sign Up Error" : [NSString stringWithFormat:@"%@", response.description] : 1000];
    };
}

- ( void ) signUpQuickBlox
{
    QBUUser *_qbUser = [[QBUUser alloc] init];
    
    _qbUser.login = [[[signUpUser objectForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0];
    _qbUser.email = [signUpUser objectForKey:@"email"];
    _qbUser.fullName = [NSString stringWithFormat:@"%@ %@",[signUpUser objectForKey:@"first_name"],[signUpUser objectForKey:@"last_name"]];
    _qbUser.password = quickbloxPass;
    _qbUser.phone = [signUpUser objectForKey:@"phone"];
    
    
    [[ConnectionManager instance] signUpQBUser:_qbUser :[self successBlock] :[self errorBlock]];

}

- (void) jumpToMainView {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Student" bundle:nil];
//    
//    [[NSUserDefaults standardUserDefaults] setValue:@"student" forKey:USER_ROLE];
//    if ([SessionManager sharedSession].userInfo.isTutor)
//    {
//        storyboard = [UIStoryboard storyboardWithName:@"Tutor" bundle:nil];
//        [[NSUserDefaults standardUserDefaults] setValue:@"tutor" forKey:USER_ROLE];
//    }
//    
//    [self.navigationController pushViewController:storyboard.instantiateInitialViewController animated:YES];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *
 **/

- ( BOOL )checkBlankView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] != 0)
    {
        for (UIView *subview in subviews) {
            
            // Do what you want to do with the subview
            if ([subview isMemberOfClass:[UITextField class]])
            {
                UITextField * nextField = (UITextField *)subview;
                checkBlankField = [self checkFieldValidate:nextField];
                if(checkBlankField == NO)
                {
                    break;
                }
                NSLog(@"Blank View Flag : %d", checkBlankField);
            }
            
            // List the subviews of subview
            [self checkBlankView:subview];
        }
    }
    
    return checkBlankField;
}


/**
 * Check Field Validate.
 **/
- ( BOOL ) checkFieldValidate : (id) sender
{
    
    UITextField * checkField = (UITextField *) sender;
    if ([checkField.text isEqualToString:@""])
    {
        return NO;
    }
    if (checkField == emailTextField) {
        if (![self checkEmailValidField : checkField]) {

            return NO;
        }
        return YES;
    }
//    if (checkField == passwordTextField) {
//        if (checkField.text.length < 8)
//        {
//            return NO;
//        }
//        return YES;
//    }
    
    return YES;
}

- ( BOOL ) checkEmailValidField : (UITextField * ) eTextField
{
    
    BOOL            filter = YES ;
    NSString*       filterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    NSString*       laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*" ;
    NSString*       emailRegex = filter ? filterString : laxString ;
    NSPredicate*    emailTest = [ NSPredicate predicateWithFormat : @"SELF MATCHES %@", emailRegex ] ;
    
    if( [ emailTest evaluateWithObject : eTextField.text ] == NO )
    {
        return NO ;
    }
    return YES ;
}

#pragma UITextFieldView Delegate
- ( void ) textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}
- ( void ) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- ( BOOL ) textFieldShouldReturn:(UITextField *)textField
{
 
    [textField resignFirstResponder];
    
    return TRUE;
}

#pragma defined UIAlertView
- ( void )showAlertView : ( NSString* ) _title : ( NSString * ) _message : ( NSInteger ) alertTag
{
    NSDictionary *attributes = @{ kMONPromptViewAttribDismissButtonBackgroundColor: [UIColor colorWithRed:111/255.0f green:189/255.0f blue:57/255.0f alpha:1.0f],
                                  kMONPromptViewAttribDismissButtonTextColor: [UIColor whiteColor],
                                  };
    
    MONPromptView *promptView = [[MONPromptView alloc] initWithTitle:_title
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
    if(promptView.tag == 2000)
    {
        [self performSelectorOnMainThread:@selector(jumpToMainView) withObject:nil waitUntilDone:NO];
    }
}


@end
