//
//  RateViewController.h
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface RateViewController : UIViewController

@property (nonatomic ,assign) IBOutlet UITextView *commentTextView;
@property (nonatomic ,assign) IBOutlet HCSStarRatingView * starRatingView;

@end
