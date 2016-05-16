//
//  ConnectionManager.h
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 12.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionManager : NSObject


@property (strong, nonatomic, readonly) NSArray *users;
@property (strong, nonatomic, readonly) NSArray *usersWithoutMe;
@property (strong, nonatomic, readonly) QBUUser *me;

+ (instancetype)instance;

- (void)logInWithUser:(QBUUser *)user completion:(void (^)(BOOL error))completion;
- ( void ) loginWithEmailUser : (NSString *) user_email : (NSString * ) user_password : (void (^)(QBResponse *response, QBUUser *user))successBlock : (QBRequestErrorBlock) errorBlock;
- ( void ) signUpQBUser : (QBUUser *) signup_user : (void (^)(QBResponse *response, QBUUser *user))successBlock : (QBRequestErrorBlock) errorBlock;

- (void)logOut;

@end
