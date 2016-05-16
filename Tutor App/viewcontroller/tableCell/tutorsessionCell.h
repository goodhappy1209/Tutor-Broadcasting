//
//  UITableViewCell+tutorsessionCell.h
//  Tutor App
//
//  Created by aa on 12/13/15.
//  Copyright © 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tutorsessionCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel * lblSubjects;
@property (nonatomic, assign) IBOutlet UILabel * lblUserName;
@property (nonatomic, assign) IBOutlet UILabel * lblSessionID;
@property (nonatomic, assign) IBOutlet UILabel * lblSessionDuration;

@end
