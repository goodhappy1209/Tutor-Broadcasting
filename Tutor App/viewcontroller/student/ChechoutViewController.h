//
//  CkechoutViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "SVProgressHUD.h"

@interface ChechoutViewController : UIViewController <MONPromptViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) NSDictionary * sessionInfo;

@property (nonatomic, retain) IBOutlet UITextField * tfPaymentEmail;
@property (nonatomic, retain) IBOutlet UITextField * tfPaymentCardNamber;
@property (nonatomic, retain) IBOutlet UITextField * tfPaymentDate;
@property (nonatomic, retain) IBOutlet UITextField * tfPaymentCCV;


@end
