//
//  CkechoutViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "ChechoutViewController.h"
#import "STPCardParams.h"
#import "STPAPIClient.h"
#import "STPToken.h"
#import "ConcludeSessionViewController.h"

@interface ChechoutViewController ()
{
    BOOL checkBlankField;
    NSInteger oppenentID;
}
@end

@implementation ChechoutViewController
@synthesize sessionInfo;

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
        NSLog(@"Pay for Tutor Session: %@", jsonDic);
        if([jsonDic[@"success"] boolValue])
        {
            [SVProgressHUD dismiss];
            
             NSObject * sessionInfoDic = (NSObject *) jsonDic[account_tutoring_session];
            if ([sessionInfoDic isKindOfClass:[NSDictionary class]]) {
                
                sessionInfo = (NSDictionary *) sessionInfoDic;
                
                [self initReadyVideoConference:[sessionInfo objectForKey:account_tutor]];
               
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


#pragma  Define function that get the QB-oppenent id.

- (void) initReadyVideoConference : (NSDictionary *) userDict
{
    [SVProgressHUD showInfoWithStatus:@"initial oppenent information"];
    
    
    
    NSMutableArray * emails = [[NSMutableArray alloc] init];
    [emails addObject:[userDict objectForKey:account_email]];
    [QBRequest usersWithEmails: emails
                          page:[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10]
                  successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
                      // Successful response with page information and users array
                      [SVProgressHUD dismiss];
                      
                      
                      QBUUser * tmpUser = [[QBUUser alloc] init];
                      
                      tmpUser = [users objectAtIndex:0];
                      oppenentID = tmpUser.ID;
                      
                      NSString *message = @"Your payment has been received successfully!";
                      [self showAlertView:@"Success" :message :2000];
                      
                  } errorBlock:^(QBResponse *response) {
                      // Handle error
                      
                      [SVProgressHUD dismiss];
                      [[[UIAlertView alloc] initWithTitle:@"Error" message:response.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                  }];
}

# pragma  Initiate Payment by the Stripe.
- (void) handleError : (NSError *) error
{
    [SVProgressHUD dismiss];
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void) createBackendChargeWithToken : (STPToken * ) token
{
    

//    NSDictionary * dict = (NSDictionary *) token;
    
    
    NSDictionary * requestParam;
    requestParam = @{
                     
                     account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                     account_device_token : @"TEMPORARY",
                     tutoring_session_id : [sessionInfo objectForKey:tutoring_session_id],
                     payment_transaction_id : token.tokenId
                     
                     };
    
    
    
    [APIService makeApiCallWithMethodUrl:API_PAYFOR_SESSION andRequestType:RequestTypePost andPathParams:nil andQueryParams:requestParam resultCallback:[self successResultCallback : API_PAYFOR_SESSION] faultCallback:[self faultCallback : API_PAYFOR_SESSION]];

}

- (void) StripeCreateTonkenChange
{
    STPCardParams *card = [[STPCardParams alloc] init];
    card.number = _tfPaymentCardNamber.text;
    
    card.expMonth = [[[_tfPaymentDate.text componentsSeparatedByString:@"/"] objectAtIndex:0] intValue];
    card.expYear = [[[_tfPaymentDate.text componentsSeparatedByString:@"/"] objectAtIndex:1] intValue];
    
    card.cvc = _tfPaymentCCV.text;
    
    
    
    [[STPAPIClient sharedClient] createTokenWithCard:card
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
                                                  [self handleError:error];
                                              } else {
                                                  [self createBackendChargeWithToken:token];
                                              }
                                          }];
}

- (IBAction)onCheckout:(id)sender
{
    
    if(![self checkBlankView:self.view])
    {
        [self showAlertView:@"Warning" :@"Invalid input information. please try again." :1000];
        
        return;
    }
    
    [SVProgressHUD show];
    
    [self StripeCreateTonkenChange];
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
    if (checkField == _tfPaymentEmail) {
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

- ( NSDictionary * ) checkValidateDateField : (UITextField *) dateTextField
{
    NSDictionary * dictDate = [[NSDictionary alloc] init];
    
    NSString * strExpireMonth = [[dateTextField.text componentsSeparatedByString:@"/"] objectAtIndex:0];
    NSString * strExpireDate = [[dateTextField.text componentsSeparatedByString:@"/"] objectAtIndex:1];
    
    [dictDate setValue:strExpireMonth forKey:@"ExpireMonth"];
    [dictDate setValue:strExpireDate forKey:@"ExpireDate"];
    
    return dictDate;
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
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_tfPaymentDate]) {
        if (range.location==2) {
            [textField setText:[textField.text stringByAppendingString:@"/"]];
        }
    }
    
    return YES;
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

- (void)gotoView : (NSString *)strStoryboard : (NSString *) strIdentifier : (NSDictionary *) SessionInfoDic
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:strStoryboard bundle:nil];
    ConcludeSessionViewController * viewController = [storyBoard instantiateViewControllerWithIdentifier:strIdentifier];
    
    viewController.AcceptedDict = SessionInfoDic;
    viewController.oppenentGlobalID = oppenentID;
    
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - MONPromptView Delegate

- (void)promptViewWillDismiss:(MONPromptView *)promptView {
    // TODO Handle on dismiss
    if (promptView.tag == 2000)
        [self gotoView:@"Student" :@"ConcludeSessionViewController" : sessionInfo];
}
@end
