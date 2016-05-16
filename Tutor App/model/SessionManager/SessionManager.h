//
//  SessionManager.h
//  Tutor App
//
//  Created by Yosemite on 9/19/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

@interface SessionManager : NSObject

@property (nonatomic, retain) UserInfo *userInfo;

+ (SessionManager*) sharedSession;

@end
