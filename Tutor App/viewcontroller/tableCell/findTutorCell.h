//
//  UITableCell+findTutorCell.h
//  Tutor App
//
//  Created by aa on 12/10/15.
//  Copyright © 2015 ancheng1114. All rights reserved.
//



@interface findTutorCell :UITableViewCell
{
    
}
@property (nonatomic, retain) id  delegate;

@property (nonatomic, assign)   NSDictionary * dictTutorUser;

@property (nonatomic, assign) IBOutlet UIImageView * tutorProfImgView;

- ( void ) initAvailableTutorCell : (NSDictionary *) dictTutorInfo;


@property (nonatomic, assign) IBOutlet UILabel * lblTutorName;
@property (nonatomic, assign) IBOutlet UILabel * lblTutorEmail;
@property (nonatomic, assign) IBOutlet UILabel * lblTutorRating;
@property (nonatomic, assign) IBOutlet UILabel * lblTutorRatingBase;
@property (nonatomic, assign) IBOutlet UIButton * btnInitSession;


@end
