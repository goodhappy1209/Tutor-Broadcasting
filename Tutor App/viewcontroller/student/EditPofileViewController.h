//
//  StudentEditPofileViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "UserInfo.h"

@interface EditPofileViewController : UIViewController <MONPromptViewDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) IBOutlet UITextView *aboutTextView;
@property (nonatomic, assign) IBOutlet UITextField * fullnameTextField;
@property (nonatomic, assign) IBOutlet UITextField * emailTextField;
@property (nonatomic, assign) IBOutlet UITextField * passwordTextField;
@property (nonatomic, assign) IBOutlet UITextField * phoneTextField;
@property (nonatomic, assign) IBOutlet UITextField * birthdayTextField;
@property (nonatomic, assign) IBOutlet UITextField * education_attendingTextField;
@property (nonatomic, assign) IBOutlet UITextField * gradelevelTextField;
@property (nonatomic, assign) IBOutlet UITextField * cityTextField;
@property (nonatomic, assign) IBOutlet UITextField * countryTextField;
@property (nonatomic, assign) IBOutlet UITextField * subjectsTextField;

@property (nonatomic, assign) IBOutlet UIImageView * profileImageView;
@property (nonatomic, assign) IBOutlet UIImage * profileImage;

@end
