//
//  UserInfo.m
//  Tutor App
//
//  Created by Yosemite on 9/19/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (instancetype) initWithDictionary:(NSDictionary*)dic{
    self = [super init];
    
    self.dictServerUser = [dic copy];
    self.qbUserInfo = [[QBUUser alloc] init];
    
    self.isTutor = YES;
    if ([[self.dictServerUser objectForKey:account_type] isEqualToString:account_student]) {
        self.isTutor = NO;
    }
    
    
    
//    if (self) {
//        self.userId = dic[@"member_id"];
//        self.userName = [NSString stringWithFormat:@"%@ %@", dic[@"first_name"], dic[@"last_name"]];
//    }
//    
//    // Temporary...
//    if ([dic[@"email"] isEqualToString:@"admin@hyperpma.com"]) {
//        self.qbUserId = @"5546349";
//        self.qbUserLogin = @"test1";
//        self.qbUserName = @"Test1";
//        self.qbUserPassword = @"123456789";
//        self.isTutor = YES;
//    } else {
//        self.qbUserId = @"5546351";
//        self.qbUserLogin = @"test2";
//        self.qbUserName = @"Test2";
//        self.qbUserPassword = @"123456789";
//        self.isTutor = NO;
//    }
    
    return self;
}

- ( void ) updateQBUserInfo : ( QBUUser * ) dicQBUser
{
    self.qbUserInfo = dicQBUser;
}

@end
