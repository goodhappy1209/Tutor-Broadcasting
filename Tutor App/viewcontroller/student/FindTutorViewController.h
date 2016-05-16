//
//  FindTutorViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "UserInfo.h"

@interface FindTutorViewController : UIViewController<UITextFieldDelegate, MONPromptViewDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) IBOutlet UITextField * retTutorName;
@property (nonatomic, assign) IBOutlet UITextField * retLocation;
@property (nonatomic, assign) IBOutlet UITextField * retFirstSubField;
@property (nonatomic, assign) IBOutlet UITextField * retSecondSubField;
@property (nonatomic, assign) IBOutlet UITextField * retThirdSubField;
@property (nonatomic, assign) IBOutlet UILabel * mathSubCount;
@property (nonatomic, assign) IBOutlet UILabel * ScienceSubCount;
@property (nonatomic, assign) IBOutlet UILabel * englishSubCount;
@property (nonatomic, assign) IBOutlet UILabel * historySubCount;


@end
