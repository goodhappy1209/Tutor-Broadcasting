//
//  SessionManager.m
//  Tutor App
//
//  Created by Yosemite on 9/19/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager

static SessionManager* _sharedSession;

+ (SessionManager*) sharedSession {
    if (_sharedSession == nil) {
        _sharedSession = [[SessionManager alloc] init];
    }
    
    return _sharedSession;
}

@end
