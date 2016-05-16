//
//  UITableViewCell+hasCurrentTutorCell.h
//  Tutor App
//
//  Created by aa on 12/11/15.
//  Copyright © 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hasCurrentTutorCell : UITableViewCell


@property (nonatomic, retain) id  delegate;

@property (nonatomic, assign)   NSDictionary * dictCurSessionInfo;

@property (nonatomic, assign) IBOutlet UIImageView * studentProfImgView;
@property (nonatomic, assign) IBOutlet UILabel * lblCurStudentName;
@property (nonatomic, assign) IBOutlet UILabel * lblCurStudentSubject;
@property (nonatomic, assign) IBOutlet UILabel * lblCurDuration;
@property (nonatomic, assign) IBOutlet UILabel * lblCurStudentLocation;


- ( void ) initHasCurrentTutorCell : (NSDictionary *) dictTutorInfo;

@end
