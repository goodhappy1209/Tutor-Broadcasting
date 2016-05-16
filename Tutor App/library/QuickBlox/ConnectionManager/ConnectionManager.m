//
//  ConnectionManager.m
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 12.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import "ConnectionManager.h"

const NSTimeInterval kChatPresenceTimeInterval = 45;

@interface ConnectionManager()

<QBChatDelegate>

@property (copy, nonatomic) void(^chatLoginCompletionBlock)(BOOL error);
@property (strong, nonatomic) QBUUser *me;
@property (strong, nonatomic) NSTimer *presenceTimer;

@end

@implementation ConnectionManager

@dynamic users;
@dynamic usersWithoutMe;

+ (instancetype)instance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark - Login / Logout

- (void)logInWithUser:(QBUUser *)user
           completion:(void (^)(BOOL error))completion {
    
    [QBChat.instance loginWithUser:user];
    [QBChat.instance addDelegate:self];
    
    self.me = user;
    
    if (QBChat.instance.isLoggedIn) {
        completion(NO);
    }
    else {
        
        self.chatLoginCompletionBlock = completion;
    }
}

- ( void ) loginWithEmailUser : (NSString *) user_email : (NSString * ) user_password : (void (^)(QBResponse *response, QBUUser *user))successBlock : (QBRequestErrorBlock) errorBlock
{
    [QBRequest logInWithUserEmail:user_email password:user_password
                     successBlock:successBlock errorBlock:errorBlock];
}

- ( void ) signUpQBUser : (QBUUser *) signup_user : (void (^)(QBResponse *response, QBUUser *user))successBlock : (QBRequestErrorBlock) errorBlock
{
    // Registration/sign up of User
    [QBRequest signUp:signup_user successBlock:successBlock errorBlock:errorBlock];
}

- (void)logOut {
    
    [self.presenceTimer invalidate];
    self.presenceTimer = nil;
    if ([QBChat.instance isLoggedIn]) {
        
        [QBChat.instance logout];
    }
    
    self.me = nil;
}

#pragma mark - QBChatDelegate

- (void)chatDidNotLogin {
    
    if (self.chatLoginCompletionBlock) {
        self.chatLoginCompletionBlock(YES);
        self.chatLoginCompletionBlock = nil;
    }
}

- (void)chatDidFailWithError:(NSInteger)code {
    
    if (self.chatLoginCompletionBlock) {
        self.chatLoginCompletionBlock(YES);
        self.chatLoginCompletionBlock = nil;
    }
}

- (void)chatDidLogin {
    
    self.presenceTimer =
    [NSTimer scheduledTimerWithTimeInterval:kChatPresenceTimeInterval
                                     target:self
                                   selector:@selector(sendChatPresence:)
                                   userInfo:nil
                                    repeats:YES];
    
    if (self.chatLoginCompletionBlock) {
        self.chatLoginCompletionBlock(NO);
        self.chatLoginCompletionBlock = nil;
    }
}

#pragma mark - Send chat presence

- (void)sendChatPresence:(NSTimer *)timer {
    
    [[QBChat instance] sendPresence];
}
@end

