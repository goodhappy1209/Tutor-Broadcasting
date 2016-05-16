//
//  CallManager.m
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 17.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import "CallManager.h"
#import "ConnectionManager.h"
#import "QMSoundManager.h"
#import "SVProgressHUD.h"

NSString *const kCallViewControllerID = @"CallViewController";
NSString *const kIncomingCallViewControllerID = @"IncomingCallViewController";
NSString *const kContainerViewControllerID = @"ContainerViewController";

@interface CallManager ()

@property (weak, nonatomic, readonly) UIViewController *rootViewController;
@property (strong, nonatomic, readonly) UIStoryboard *mainStoryboard;

@end

@implementation CallManager

@dynamic rootViewController;

+ (instancetype)instance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _mainStoryboard =
        [UIStoryboard storyboardWithName:@"Main"
                                  bundle:[NSBundle mainBundle]];
    }
    
    return self;
}

#pragma mark - RootViewController

- (UIViewController *)rootViewController {
    
    return UIApplication.sharedApplication.delegate.window.rootViewController;
}

#pragma mark - Public methods

- (void) callToUser:(NSInteger) oppenentID withConferenceType:(QBConferenceType)conferenceType {
    
    if (self.session) {
        return;
    }
    
    [QBSoundRouter.instance initialize];
    
    NSArray *opponentsIDs = @[[NSNumber numberWithInteger:oppenentID]];
    
    QBRTCSession *session =
    [QBRTCClient.instance createNewSessionWithOpponents:opponentsIDs  withConferenceType:conferenceType];
    
    if (session) {
        self.session = session;
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:@"Creating new session - Failure"];
    }
    
}

#pragma mark - QBWebRTCChatDelegate

- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    
    
    if (self.session) {
        
        [session rejectCall:@{@"reject" : @"busy"}];
        return;
    }
    
    self.session = session;
    
    [QBSoundRouter.instance initialize];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        // Wait...
        
    }
    else {
        
    }
}

- (void)sessionWillClose:(QBRTCSession *)session {
    
    NSLog(@"session will close");
}

- (void)sessionDidClose:(QBRTCSession *)session {
    
    if (session == self.session ) {
    }
}

@end
