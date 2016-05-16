//
//  ConcludeSessionViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConcludeSessionViewController : UIViewController

@property (nonatomic) NSInteger oppenentGlobalID;
@property (nonatomic, assign) NSDictionary * AcceptedDict;
@property (assign, nonatomic) NSTimeInterval timeDuration;
@property (strong, nonatomic) NSTimer *callTimer;

@property (nonatomic ,assign) IBOutlet UITextView *chatTextView;
@property (nonatomic ,assign) IBOutlet UILabel * lblProgressView;

@end
