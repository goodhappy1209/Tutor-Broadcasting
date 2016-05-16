//
//  InitateSessionViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKYStepper.h"
#import "SVProgressHUD.h"
#include "UserInfo.h"

@interface InitateSessionViewController : UIViewController

@property(nonatomic, weak) IBOutlet PKYStepper *stepper;

@property (nonatomic, assign) NSDictionary * selectedTutor;


@end
