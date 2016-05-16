//
//  TutorSessionDetailViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorSessionDetailViewController : UIViewController

@property (nonatomic, assign) NSDictionary * dictSessionData;

@property (nonatomic, assign) IBOutlet UIImageView * ivUserProfView;
@property (nonatomic, assign) IBOutlet UILabel * lblUserName;
@property (nonatomic, assign) IBOutlet UILabel * lblSubjects;
@property (nonatomic, assign) IBOutlet UILabel * lblSessionID;
@property (nonatomic, assign) IBOutlet UILabel * lblSessionDays;
@property (nonatomic, assign) IBOutlet UILabel * lblSessionCost;




//@property (nonatomic, assign) IBOutlet UILabel

@end
