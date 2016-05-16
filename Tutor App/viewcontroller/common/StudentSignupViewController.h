//
//  StudentSignupViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "ConnectionManager.h"
#import "CallManager.h"

@interface StudentSignupViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate, MONPromptViewDelegate>


@property (nonatomic ,assign) IBOutlet UITextField *first_nameTextField;
@property (nonatomic ,assign) IBOutlet UITextField *last_nameTextField;
@property (nonatomic ,assign) IBOutlet UITextField *emailTextField;
@property (nonatomic ,assign) IBOutlet UITextField *passwordTextField;
@property (nonatomic ,assign) IBOutlet UITextField *phoneTextField;
@property (nonatomic ,assign) IBOutlet UITextField *birthdayTextField;
@property (nonatomic ,assign) IBOutlet UITextField *cityTextField;
@property (nonatomic ,assign) IBOutlet UITextField *countryTextField;
@property (nonatomic ,assign) IBOutlet UITextField *schoolAttTextField;
@property (nonatomic ,assign) IBOutlet UITextField *gra_eduTextField;
@property (nonatomic ,assign) IBOutlet UITextField *subjectTextField;

@end
