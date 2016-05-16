//
//  ForgotPasswordViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()
{
    BOOL checkBlankField;
}
@end

@implementation ForgotPasswordViewController
@synthesize forgotEmailTextField;


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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onResetPassword:(id)sender
{
    [self.view endEditing:YES];
    
    if (![self checkBlankView:self.view]) {
        
        [self showAlertView:@"Warning" :@"Invalid input E-mail information. please try again." :1000];
        
        return;
    }
    
    
    // Sign up...
    [SVProgressHUD showWithStatus:@"Reset Password..."];
    
    NSDictionary *param = @{
                            
                            account_email_Cap : forgotEmailTextField.text,
                            
                            };
    [APIService makeApiCallWithMethodUrl:API_FORGOT_PASSWORD andRequestType:RequestTypePost andPathParams:nil andQueryParams:param resultCallback:^(NSObject *result) {
        NSDictionary *jsonResult = (NSDictionary*) result;
        
        NSLog(@"Reset Password : %@", jsonResult);
        
        if ([jsonResult[@"success"] boolValue]) {
           
            [SVProgressHUD dismiss];
            NSString *message = @"Password reset link has been sent to your email";
            [self showAlertView:@"" :message :2000];
            
        } else {
            [SVProgressHUD dismiss];
            
            [self showAlertView:@"Error" : jsonResult[@"message"]:1000];
//            [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonResult[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    } faultCallback:^(NSError *fault) {
        [SVProgressHUD dismiss];
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
    
    
}

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
    
    if (checkField == forgotEmailTextField) {
        if (![self checkEmailValidField: checkField]) {
            
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

- (void)promptViewWillDismiss:(MONPromptView *)promptView
{
    if(promptView.tag == 2000)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
