//
//  UITableCell+findTutorCell.m
//  Tutor App
//
//  Created by aa on 12/10/15.
//  Copyright © 2015 ancheng1114. All rights reserved.
//

#import "findTutorCell.h"
#import "TutorListViewController.h"


@implementation findTutorCell
@synthesize delegate, tutorProfImgView, lblTutorEmail, lblTutorName, lblTutorRating, lblTutorRatingBase;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma  Define tutor data into TableViewCell
- ( void ) initAvailableTutorCell : (NSDictionary *) dictTutorInfo
{
    
    _dictTutorUser = dictTutorInfo;
    
    NSString * fullnameStr = [NSString stringWithFormat:@"%@ %@", [_dictTutorUser objectForKey:account_first_name], [_dictTutorUser objectForKey:account_last_name]];
    NSString * emailStr = [_dictTutorUser objectForKey:account_email];
    NSString * ratingStr = [_dictTutorUser objectForKey:account_tutor_rate];
    if (![[_dictTutorUser objectForKey:account_profile_image] isEqualToString:@""]) {
        
        NSString * profileImageURL = [SERVER_URL_PROFILE stringByAppendingString:[dictTutorInfo objectForKey:account_profile_image]];
        
        [tutorProfImgView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageURL]]]];
    }
    
    [lblTutorName setText:fullnameStr];
    [lblTutorEmail setText:emailStr];
    [lblTutorRating setText:ratingStr];

}

- (IBAction)onInitSession:(id)sender
{
    if( [ delegate respondsToSelector : @selector( didIniteSession: ) ] )
    {
        [ delegate performSelector : @selector( didIniteSession : ) withObject : _dictTutorUser ] ;
    }

}

@end
