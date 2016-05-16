//
//  UserInfo.h
//  Tutor App
//
//  Created by Yosemite on 9/19/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

//@property (nonatomic, copy) NSString *userId;
//@property (nonatomic, copy) NSString *userName;
//
//@property (nonatomic, copy) NSString *qbUserId;
//@property (nonatomic, copy) NSString *qbUserLogin;
//@property (nonatomic, copy) NSString *qbUserName;
//@property (nonatomic, copy) NSString *qbUserPassword;

@property (nonatomic, copy) NSDictionary * dictServerUser;
@property (nonatomic, copy) QBUUser * qbUserInfo;

@property (nonatomic) BOOL isTutor;

- (instancetype) initWithDictionary:(NSDictionary*)dic;
- ( void ) updateQBUserInfo : ( QBUUser * ) dicQBUser;

@end
