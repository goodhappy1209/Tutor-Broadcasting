//
//  TutorListViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "UserInfo.h"

@interface TutorListViewController : UIViewController <UITableViewDataSource ,UITableViewDelegate>

- (void) didIniteSession : (NSDictionary * ) initSessionTutor;

@property (nonatomic, assign) IBOutlet UITableView * tblTutorListView;
@property (nonatomic, retain) NSMutableArray * findTutorsArray;

@end
