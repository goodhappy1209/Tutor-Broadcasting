//
//  StudentProfileViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "SVProgressHUD.h"

@interface ProfileViewController : UIViewController

@property (nonatomic, assign) IBOutlet UILabel * fullnameLabel;
@property (nonatomic, assign) IBOutlet UILabel * emailLabel;
@property (nonatomic, assign) IBOutlet UILabel * education_attLabel;
@property (nonatomic, assign) IBOutlet UILabel * grade_levelLabel;
@property (nonatomic, assign) IBOutlet UILabel * cityLabel;
@property (nonatomic, assign) IBOutlet UILabel * countryLabel;
@property (nonatomic, assign) IBOutlet UITextView * aboutmeTextView;

@property (nonatomic, assign) IBOutlet UIImageView * profileImageView;

@end
