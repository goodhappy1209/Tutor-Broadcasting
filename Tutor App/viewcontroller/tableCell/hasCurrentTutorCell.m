//
//  UITableViewCell+hasCurrentTutorCell.m
//  Tutor App
//
//  Created by aa on 12/11/15.
//  Copyright © 2015 ancheng1114. All rights reserved.
//

#import "hasCurrentTutorCell.h"
#import "TutorQueueViewController.h"

@implementation hasCurrentTutorCell : UITableViewCell
@synthesize lblCurStudentName, lblCurStudentSubject, lblCurDuration, lblCurStudentLocation, studentProfImgView, delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma  Define tutor data into TableViewCell
- ( void ) initHasCurrentTutorCell : (NSDictionary *) dictSessionInfo
{
    
    _dictCurSessionInfo = dictSessionInfo;
    
    NSDictionary * dictUserInfo = [_dictCurSessionInfo objectForKey:account_student];
    NSString * fullnameStr = [NSString stringWithFormat:@"%@ %@", [dictUserInfo objectForKey:account_first_name], [dictUserInfo objectForKey:account_last_name]];
    
    NSString * SubjectStr = [dictUserInfo objectForKey:account_subjects];
    NSString * durationStr = [_dictCurSessionInfo objectForKey:session_duration];
    
    NSString * LocationStr = [NSString stringWithFormat:@"%@, %@", [dictUserInfo objectForKey: account_city], [dictUserInfo objectForKey: account_country]];
    
//    if (![[_dictCurSessionInfo objectForKey:account_profile_image] isEqualToString:@""]) {
//        
//        NSString * profileImageURL = [SERVER_URL_PROFILE stringByAppendingString:[_dictCurSessionInfo objectForKey:account_profile_image]];
//        
//        [studentProfImgView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageURL]]]];
//    }
    
    [lblCurStudentName setText:fullnameStr];
    [lblCurStudentSubject setText:SubjectStr];
    [lblCurDuration setText:durationStr];
    [lblCurStudentLocation setText:LocationStr];
    
}

- (IBAction) onConfirmAction : ( id ) sender
{
    if( [ delegate respondsToSelector : @selector( didConfirmAction: ) ] )
    {
        [ delegate performSelector : @selector( didConfirmAction : ) withObject : _dictCurSessionInfo ] ;
    }
    
}

 - (IBAction) onDenyAction :( id ) sender
{
    if( [ delegate respondsToSelector : @selector( didDenyAction: ) ] )
    {
        [ delegate performSelector : @selector( didDenyAction : ) withObject : _dictCurSessionInfo ] ;
    }
    
}


@end
