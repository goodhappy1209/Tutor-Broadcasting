//
//  TutorSessionHistoryViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorSessionHistoryViewController : UIViewController <UITableViewDataSource ,UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray * hisSessionArray;
@property (nonatomic, retain) IBOutlet UITableView * tblHisSessionView;
@property (nonatomic, assign) IBOutlet UITextField * tfUserName;
@property (nonatomic, assign) IBOutlet UITextField * tfSubjects;
@property (nonatomic, assign) IBOutlet UILabel * lblMathsHisCount;
@property (nonatomic, assign) IBOutlet UILabel * lblScienceHisCount;
@property (nonatomic, assign) IBOutlet UILabel * lblEnglishHisCount;
@property (nonatomic, assign) IBOutlet UILabel * lblHistoryHisCount;





@end
