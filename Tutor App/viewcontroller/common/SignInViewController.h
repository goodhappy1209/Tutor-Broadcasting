//
//  SignInViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController<UIAlertViewDelegate, MONPromptViewDelegate, UITextFieldDelegate>

@property (nonatomic ,assign) IBOutlet UITextField *emailTextField;
@property (nonatomic ,assign) IBOutlet UITextField *passwordTextField;
@property (nonatomic ,assign) IBOutlet UISegmentedControl *roleSegment;

@end
