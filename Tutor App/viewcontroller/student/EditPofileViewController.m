//
//  StudentEditPofileViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "EditPofileViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface EditPofileViewController ()
{
    BOOL checkBlankField;
}
@end

@implementation EditPofileViewController
@synthesize fullnameTextField, emailTextField, passwordTextField, phoneTextField, birthdayTextField, education_attendingTextField, gradelevelTextField, cityTextField, countryTextField, aboutTextView, subjectsTextField, profileImage, profileImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CALayer *btnLayer = [self.aboutTextView layer];
    [btnLayer setBorderColor:[UIColor whiteColor].CGColor];
    btnLayer.borderWidth = 0.6f;
    btnLayer.cornerRadius = 0.0f;

    [self showProfileInitFunc];
    
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

/**
 ** init Account information on UI.
 **/

- ( void ) showProfileInitFunc
{
    NSDictionary * dicUserInfo = [SessionManager sharedSession].userInfo.dictServerUser;
    
    NSString * fullnameStr = [NSString stringWithFormat:@"%@ %@", [dicUserInfo objectForKey:account_first_name], [dicUserInfo objectForKey:account_last_name]];
    NSString * emailStr = [dicUserInfo objectForKey:account_email];
    
    NSString * passwordStr = [dicUserInfo objectForKey:account_password];
    
    NSString * birthdayStr = [dicUserInfo objectForKey:account_birthday];
    NSString * subjectStr = [dicUserInfo objectForKey:account_subjects];
    NSString * phoneStr = [dicUserInfo objectForKey:account_phone];
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
    
    [fullnameTextField setText:fullnameStr];
    [emailTextField setText:emailStr];
    [birthdayTextField setText:birthdayStr];
    [phoneTextField setText:phoneStr];
    [education_attendingTextField setText:schoolAttStr];
    [gradelevelTextField setText:gradeLevelStr];
    [cityTextField setText:cityStr];
    [countryTextField setText:countryStr];
    [aboutTextView setText:aboutmeStr];
    [subjectsTextField setText:subjectStr];
//    [passwordTextField setText:passwordStr];
    
 
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSave:(id)sender
{
    [self.view endEditing:YES];
    
    
    
    if (profileImage != nil) {
        [self onEditSubmitWithProfileImage];
    }
    else
    {
        [self onEditSubmitWithoutProfileImage];
    }
    
    
    
//    NSString *message = @"Your profile has been updated successfully!";
    
}

- ( void ) onEditSubmitWithoutProfileImage
{
    if (![self checkBlankView:self.view]) {
        
        [self showAlertView:@"Warning" :@"Invalid input information, Can not submit the blank field. please try again." :1000];
        
        return;
    }
    
    NSString * firstName = [[fullnameTextField.text componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString * lastName = [[fullnameTextField.text componentsSeparatedByString:@" "] objectAtIndex:1];
    
    if ([lastName isEqualToString:@""]) {
        [self showAlertView:@"Warning" :@"Invalid account name type. please try again." :1000];
        
        return;
    }
    
    // Edit...
    [SVProgressHUD showWithStatus:@"Updating profile..."];
    NSLog(@"NSDic Data : %@", [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id]);
    
    NSDictionary *param ;
    
    if ([[[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_type] isEqualToString:account_student]) {
        
        if (profileImage != nil) {
            NSData * NSprofileData = UIImageJPEGRepresentation(profileImage, 1.0);
            [param setValue:NSprofileData forKey:account_profile_image];
        }
        param   = @{
                    
                    account_device_token : @"TEMPORARY",
                    account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                    account_first_name : firstName,
                    account_last_name : lastName,
                    account_email : emailTextField.text,
                    account_password : passwordTextField.text,
                    account_phone : phoneTextField.text,
                    account_birthday : birthdayTextField.text,
                    account_city : cityTextField.text,
                    account_country : countryTextField.text,
                    account_school_attending : education_attendingTextField.text,
                    account_grade_level : gradelevelTextField.text,
                    account_subjects : subjectsTextField.text,
                    account_about_me : aboutTextView.text
                    
                    };
    }
    if ([[[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_type] isEqualToString:account_tutor])
    {
        if (profileImage != nil) {
            NSData * NSprofileData = UIImageJPEGRepresentation(profileImage, 1.0);
            [param setValue:NSprofileData forKey:account_profile_image];
        }
        
        param   = @{
                    
                    account_device_token : @"TEMPORARY",
                    account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                    account_first_name : firstName,
                    account_last_name : lastName,
                    account_email : emailTextField.text,
                    account_password : passwordTextField.text,
                    account_phone : phoneTextField.text,
                    account_birthday : birthdayTextField.text,
                    account_city : cityTextField.text,
                    account_country : countryTextField.text,
                    account_university_tutor : education_attendingTextField.text,
                    account_course_tutor : gradelevelTextField.text,
                    account_subjects : subjectsTextField.text,
                    account_about_me : aboutTextView.text
                    
                    };
    }

    
    [APIService makeApiCallWithMethodUrl:API_EDIT_ACCOUNT andRequestType:RequestTypePost andPathParams:nil andQueryParams:param resultCallback:^(NSObject *result) {
        NSDictionary *jsonResult = (NSDictionary*) result;
        
        NSLog(@"Edit Profile Return : %@", jsonResult);
        
        if ([jsonResult[@"success"] boolValue]) {
            
            NSDictionary *param = @{
                                    
                                    account_device_token : @"TEMPORARY",
                                    account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                                    
                                    };
            
            [APIService makeApiCallWithMethodUrl:API_GET_ACCOUNT andRequestType:RequestTypePost andPathParams:nil andQueryParams:param resultCallback:^(NSObject *result) {
                NSDictionary *jsonResult = (NSDictionary*) result;
                
                NSLog(@"Get Profile Return : %@", jsonResult);
                
                if ([jsonResult[@"success"] boolValue]) {
                    [SVProgressHUD dismiss];
                    [SessionManager sharedSession].userInfo = [[UserInfo alloc] initWithDictionary:jsonResult];
                    
                    NSString *message = @"Your profile has been updated successfully!";
                    [self showAlertView:@"Success" :message :2000];
                    
                } else {
                    [SVProgressHUD dismiss];
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonResult[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                
            } faultCallback:^(NSError *fault) {
                [SVProgressHUD dismiss];
                NSLog(@"Error Value : %@ : %@", fault.description, fault);
                
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
            
            
            
        } else {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonResult[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    } faultCallback:^(NSError *fault) {
        [SVProgressHUD dismiss];
        NSLog(@"Error Value : %@ : %@", fault.description, fault);
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];

    
}
- ( void ) onEditSubmitWithProfileImage
{
    
    if (![self checkBlankView:self.view]) {
        
        [self showAlertView:@"Warning" :@"Invalid input information, Can not submit the blank field. please try again." :1000];
        
        return;
    }
    
    NSString * firstName = [[fullnameTextField.text componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString * lastName = [[fullnameTextField.text componentsSeparatedByString:@" "] objectAtIndex:1];
    
    if ([lastName isEqualToString:@""]) {
        [self showAlertView:@"Warning" :@"Invalid account name type. please try again." :1000];
        
        return;
    }
    
    // Edit...
    [SVProgressHUD showWithStatus:@"Updating profile..."];
    NSLog(@"NSDic Data : %@", [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id]);
    
    NSDictionary *param ;
    NSData * NSprofileData = UIImagePNGRepresentation(profileImage);
    
    
    if ([[[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_type] isEqualToString:account_student]) {
        param   = @{
                    
                    account_device_token : @"TEMPORARY",
                    account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                    account_first_name : firstName,
                    account_last_name : lastName,
                    account_email : emailTextField.text,
                    account_password : passwordTextField.text,
                    account_phone : phoneTextField.text,
                    account_birthday : birthdayTextField.text,
                    account_city : cityTextField.text,
                    account_country : countryTextField.text,
                    account_school_attending : education_attendingTextField.text,
                    account_grade_level : gradelevelTextField.text,
                    account_subjects : subjectsTextField.text,
                    account_profile_image : NSprofileData,
                    account_about_me : aboutTextView.text
                    
                    };
    }
    if ([[[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_type] isEqualToString:account_tutor])
    {
        param   = @{
                    
                    account_device_token : @"TEMPORARY",
                    account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                    account_first_name : firstName,
                    account_last_name : lastName,
                    account_email : emailTextField.text,
                    account_password : passwordTextField.text,
                    account_phone : phoneTextField.text,
                    account_birthday : birthdayTextField.text,
                    account_city : cityTextField.text,
                    account_country : countryTextField.text,
                    account_university_tutor : education_attendingTextField.text,
                    account_course_tutor : gradelevelTextField.text,
                    account_subjects : subjectsTextField.text,
                    account_profile_image : NSprofileData,
                    account_about_me : aboutTextView.text
                    
                    };
    }
    
    
    [APIService makeMultipartApiCallWithMethodUrl:API_EDIT_ACCOUNT andQueryParams:param resultCallback:^(NSObject * result){
        
        [SVProgressHUD dismiss];
        NSDictionary *jsonResult = (NSDictionary*) result;
        if ([jsonResult[@"success"] boolValue]) {
            
            NSDictionary *param = @{
                                    
                                    account_device_token : @"TEMPORARY",
                                    account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                                    
                                    };
            
            [APIService makeApiCallWithMethodUrl:API_GET_ACCOUNT andRequestType:RequestTypePost andPathParams:nil andQueryParams:param resultCallback:^(NSObject *result) {
                NSDictionary *jsonResult = (NSDictionary*) result;
                
                NSLog(@"Get Profile Return : %@", jsonResult);
                
                if ([jsonResult[@"success"] boolValue]) {
                    [SVProgressHUD dismiss];
                    [SessionManager sharedSession].userInfo = [[UserInfo alloc] initWithDictionary:jsonResult];
                    
                    NSString *message = @"Your profile has been updated successfully!";
                    [self showAlertView:@"Success" :message :2000];
                    
                } else {
                    [SVProgressHUD dismiss];
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonResult[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                
            } faultCallback:^(NSError *fault) {
                [SVProgressHUD dismiss];
                NSLog(@"Error Value : %@ : %@", fault.description, fault);
                
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
            
            
            
        } else {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonResult[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }

        
    } faultCallback:^(NSError * fault){
        
        [SVProgressHUD dismiss];
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }];
}

- (IBAction)onUpdatePicture:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Library", nil];
    [actionSheet showInView:self.view];
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
        if (checkField == passwordTextField) {
            return YES;
        }
        return NO;
    }
    if (checkField == emailTextField) {
        if (![self checkEmailValidField : checkField]) {
            
            return NO;
        }
        return YES;
    }
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

#pragma UITextView Delegate.

- ( void ) textViewDidBeginEditing:(UITextView *)textView
{
    
}

- ( void ) textViewDidChange:(UITextView *)textView
{
    
}

- ( void ) textViewDidEndEditing:(UITextView *)textView
{
    
}

- ( BOOL ) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    return TRUE;
}
#pragma getPhoto
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    
    if (buttonIndex == 0) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.delegate = self;
        imgPicker.allowsEditing = TRUE;
        
        [self presentViewController:imgPicker animated:TRUE completion:nil];
    }
    else if (buttonIndex == 1)
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.delegate = self;
        imgPicker.allowsEditing = TRUE;
        
        [self presentViewController:imgPicker animated:TRUE completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    [profileImageView setImage:image];
    
    profileImage = image;

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}


#pragma defined MONPromptView.
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


#pragma promptView Dismissed.
- (void)promptViewWillDismiss:(MONPromptView *)promptView
{
    if (promptView.tag == 2000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
