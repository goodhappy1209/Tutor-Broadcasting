//
//  ForgotPasswordViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface ForgotPasswordViewController : UIViewController <MONPromptViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) IBOutlet UITextField * forgotEmailTextField;

@end
