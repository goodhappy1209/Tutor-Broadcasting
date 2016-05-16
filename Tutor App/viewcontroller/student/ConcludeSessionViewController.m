//
//  ConcludeSessionViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "ConcludeSessionViewController.h"
#import "NYAlertViewController.h"
#import "SVProgressHUD.h"
#import "CallManager.h"
#import "UserInfo.h"

const NSTimeInterval kRefreshTimeInterval = 1.f;


@interface ConcludeSessionViewController () <QBRTCClientDelegate, UIAlertViewDelegate> {
    IBOutlet QBGLVideoView * opponentVideoView;
    QBRTCSession *_session;
    NSInteger SessionDuration;
}

@end

@implementation ConcludeSessionViewController
@synthesize AcceptedDict, oppenentGlobalID;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CALayer *btnLayer = [self.chatTextView layer];
    [btnLayer setBorderColor:[UIColor colorWithHexString:@"#1D6AA8"].CGColor];
    btnLayer.borderWidth = 0.6f;
    btnLayer.cornerRadius = 0.0f;
    
    opponentVideoView.contentMode = UIViewContentModeScaleAspectFill;
    [QBRTCClient.instance addDelegate:self];
    
    if (![SessionManager sharedSession].userInfo.isTutor) {
        [self initializeSession:oppenentGlobalID];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSString *role = [[NSUserDefaults standardUserDefaults] valueForKey:USER_ROLE];
//    if ([role isEqualToString:@"student"])
//    {
//        NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
//        alertViewController.title = @"Session Alert";
//        alertViewController.message = @"Session duration is now remaining 3 mins, do you want to conclude the session?";
//        alertViewController.buttonCornerRadius = 0.0f;
//
//        alertViewController.buttonColor = [UIColor colorWithHexString:@"#00527D"];
//        alertViewController.buttonTitleColor = [UIColor whiteColor];
//        
//        alertViewController.cancelButtonColor = [UIColor grayColor];
//        alertViewController.cancelButtonTitleColor = [UIColor whiteColor];
//        
//        [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"No", nil)
//                                                                style:UIAlertActionStyleCancel
//                                                              handler:^(NYAlertAction *action) {
//                                                                  
//                                                                  [self dismissViewControllerAnimated:YES completion:nil];
//                                                                  
//                                                                  
//                                                              }]];
//        [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil)
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(NYAlertAction *action) {
//
//                                                                  [self dismissViewControllerAnimated:YES completion:^(void){
//                                                                      
//                                                                      UIViewController *vc = self.parentViewController.parentViewController;
//                                                                      [vc performSegueWithIdentifier:@"rateSegue" sender:nil];
//                                                                  }];
//                                                                  
//                                                                  
//                                                              }]];
//        
//
//        
//        [self presentViewController:alertViewController animated:YES completion:nil];
//    }
    
    
}

- (void)refreshCallTime:(NSTimer *)sender {
    
    NSInteger Session_time_interval = SessionDuration * 60;
    
    self.timeDuration += kRefreshTimeInterval;
    
    NSTimeInterval remTimeInterval = Session_time_interval - self.timeDuration;
    
    NSString * progressTimeStr = [NSString stringWithFormat:@"Progress %@ gone,", [self stringWithTimeDuration:self.timeDuration]];
    NSString * remainedTimeStr = [NSString stringWithFormat:@"%@ remaining", [self stringWithTimeDuration:remTimeInterval]];
    
    [_lblProgressView setText:[NSString stringWithFormat:@"%@ %@", progressTimeStr, remainedTimeStr]];
    
    if((self.timeDuration / Session_time_interval) * 100 == 85)
    {
        [self showCustomAlertView];
    }
    
}

- (NSString *)stringWithTimeDuration:(NSTimeInterval )timeDuration {
    
    NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
    dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    
    NSString * timeStr = [dateComponentsFormatter stringFromTimeInterval:timeDuration];
    
    return timeStr;
}

#pragma mark - Failure Conculde Action.
- (void (^)(NSError *fault)) faultCallback : (NSString *) requestName
{
    return ^(NSError * fault){
        
        [SVProgressHUD dismiss];
        
        NSLog(@"Available Tutor Error : %@", fault.description);
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    };
}
#pragma NSDictionary result from Server Request.
#pragma mark - Success Conculde Action.
- (void (^)(NSObject * result)) successResultCallback : (NSString *)requestName
{
    return ^(NSObject * result){
        NSDictionary * jsonDic = (NSDictionary *) result;
        NSLog(@"Pay for Tutor Session: %@", jsonDic);
        if([jsonDic[@"success"] boolValue])
        {
            [SVProgressHUD dismiss];
            
            NSObject * sessionInfoDic = (NSObject *) jsonDic[account_tutoring_session];
            if ([sessionInfoDic isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *userInfo = @{@"hangup" : @"hang up"};
                [[CallManager instance].session hangUp:userInfo];
                _session = nil;
                
                [self.callTimer invalidate];
                self.callTimer = nil;
                
                UIViewController *vc = self.parentViewController.parentViewController;
                [vc performSegueWithIdentifier:@"rateSegue" sender:nil];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonDic[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonDic[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    };
}


#pragma mark - Calling Features

- (void) initializeSession : (NSInteger) oppenentID {
    
    [SVProgressHUD showInfoWithStatus:@"Connecting now..."];
    
    [[CallManager instance] callToUser:oppenentID withConferenceType:QBConferenceTypeVideo];
    [[CallManager instance].session startCall:@{@"newcall" : @"newcall", session_duration : [AcceptedDict objectForKey:session_duration]}];
    _session = [CallManager instance].session;

}


#pragma mark - QuickBlox Session Delegate
#pragma mark - QBWebRTCChatDelegate
- (void) didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo
{
    _session = [CallManager instance].session;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        // Wait...
        
    }
    else {
        
        [[CallManager instance].session acceptCall:@{@"accept" : @"hello", session_duration : [userInfo objectForKey:session_duration]}];
        
        SessionDuration = [[userInfo objectForKey:session_duration] integerValue];
        
    }
}


//- (void)session:(QBRTCSession *)session initializedLocalMediaStream:(QBRTCMediaStream *)mediaStream {
//    NSLog(@"Initialized local media stream %@", mediaStream);
//    
//}

/**
 * Called in case when you are calling to user, but he hasn't answered
 */
- (void)session:(QBRTCSession *)session userDoesNotRespond:(NSNumber *)userID {
    
    if (session == _session) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"User Does not Respond" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        NSLog(@"User Does Not Respond...");
    }
}

- (void)session:(QBRTCSession *)session acceptByUser:(NSNumber *)userID userInfo:(NSDictionary * ) userInfo{
    if (session == _session) {
        SessionDuration = [[userInfo objectForKey:session_duration] integerValue];
    }
}

/**
 * Called in case when opponent has rejected you call
 */
- (void)session:(QBRTCSession *)session rejectedByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    
    if (session == _session) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Rejected By User." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

/**
 *  Called in case when opponent hung up
 */
- (void)session:(QBRTCSession *)session hungUpByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    
    if (_session == session) {
        [self DidConcludedByUser];
    }
}

/**
 *  Called in case when receive local video track
 */
- (void)session:(QBRTCSession *)session didReceiveLocalVideoTrack:(QBRTCVideoTrack *)videoTrack {

}

/**
 *  Called in case when receive remote video track from opponent
 */
- (void)session:(QBRTCSession *)session didReceiveRemoteVideoTrack:(QBRTCVideoTrack *)videoTrack fromUser:(NSNumber *)userID {
    
    [opponentVideoView setVideoTrack:videoTrack];
    
}

/**
 *  Called in case when connection initiated
 */
- (void)session:(QBRTCSession *)session startConnectionToUser:(NSNumber *)userID {
    NSLog(@"=========== Start Connection To User %d ===============", [userID intValue]);
    
    opponentVideoView.hidden = NO;
}


/**
 *  Called in case when connection is established with opponent
 */
- (void)session:(QBRTCSession *)session connectedToUser:(NSNumber *)userID {
    NSLog(@"=========== Conected To User %d ===============", [userID intValue]);
    
    if (!self.callTimer) {
        self.callTimer = [NSTimer scheduledTimerWithTimeInterval:kRefreshTimeInterval
                                                          target:self
                                                        selector:@selector(refreshCallTime:)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    
}

/**
 *  Called in case when connection state changed
 */
- (void)session:(QBRTCSession *)session connectionClosedForUser:(NSNumber *)userID {
    NSLog(@"=========== Connection Closed For User %d ===============", [userID intValue]);
}

/**
 *  Called in case when disconnected from opponent
 */
- (void)session:(QBRTCSession *)session disconnectedFromUser:(NSNumber *)userID {
    NSLog(@"=========== Disconnected From User %d ===============", [userID intValue]);
}

/**
 *  Called in case when disconnected by timeout
 */
- (void)session:(QBRTCSession *)session disconnectTimeoutForUser:(NSNumber *)userID {
    NSLog(@"=========== disconnectTimeoutForUser %d ===============", [userID intValue]);
}

/**
 *  Called in case when connection failed with user
 */
- (void)session:(QBRTCSession *)session connectionFailedWithUser:(NSNumber *)userID {
    NSLog(@"=========== connectionFailedWithUser %d ===============", [userID intValue]);
}

/**
 *  Called in case when session will close
 */
- (void)sessionWillClose:(QBRTCSession *)session {
    NSLog(@"=========== sessionWillClose ===============");
    [CallManager instance].session = nil;
    _session = nil;
}

#pragma UIAlertView Delegate.
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2000)
    {
        if (buttonIndex == 0) {
            [self onConclude:nil];
        }
    }
}

#pragma mark - UI Events

- (IBAction)onBack:(id)sender
{
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Close Session" message:@"Are you want to conclude the session now?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alertView.tag = 2000;
    [alertView show];
    
}
- (IBAction)onConclude:(id)sender
{
    NSDictionary * requestParam;
    requestParam = @{
                     
                     account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                     account_device_token : @"TEMPORARY",
                     tutoring_session_id : [AcceptedDict objectForKey:tutoring_session_id],
                                        
                     };
    [APIService makeApiCallWithMethodUrl:API_END_SESSION andRequestType:RequestTypePost andPathParams:nil andQueryParams:requestParam resultCallback:[self successResultCallback : API_END_SESSION] faultCallback:[self faultCallback : API_END_SESSION]];
}

- (void) DidConcludedByUser
{
    NSDictionary *userInfo = @{@"hangup" : @"hang up"};
    [[CallManager instance].session hangUp:userInfo];
    _session = nil;
    
    [self.callTimer invalidate];
    self.callTimer = nil;
    
    UIViewController *vc = self.parentViewController.parentViewController;
    [vc performSegueWithIdentifier:@"rateSegue" sender:nil];
}

- (void) showCustomAlertView
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = @"Session Alert";
    alertViewController.message = @"Session duration is now remaining 3 mins, do you want to conclude the session?";
    alertViewController.buttonCornerRadius = 0.0f;
    
    alertViewController.buttonColor = [UIColor colorWithHexString:@"#00527D"];
    alertViewController.buttonTitleColor = [UIColor whiteColor];
    
    alertViewController.cancelButtonColor = [UIColor grayColor];
    alertViewController.cancelButtonTitleColor = [UIColor whiteColor];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"No", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                              
                                                          }]];
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              
                                                              [self dismissViewControllerAnimated:YES completion:^(void){
                                                                  
                                                                  [self onConclude:nil];
                                                                  
                                                              }];
                                                              
                                                              
                                                          }]];
    
    
    
    [self presentViewController:alertViewController animated:YES completion:nil];

}
@end
