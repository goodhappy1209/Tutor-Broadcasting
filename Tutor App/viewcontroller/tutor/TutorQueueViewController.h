//
//  TutorQueueViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TutorQueueViewController : UIViewController <UITableViewDataSource ,UITableViewDelegate ,MONPromptViewDelegate>

- (IBAction)onConfirm:(id)sender;

- (void) didConfirmAction : (NSDictionary * ) confirmTutorSession;
- (void) didDenyAction : (NSDictionary * ) denyTutorSession;

@property (nonatomic, retain) IBOutlet UITableView * tblCurSessionList;
@property (nonatomic, retain) NSMutableArray * hasCurSessionArray;
@property (nonatomic, retain) NSDictionary * dictSessionInfo;
@end
