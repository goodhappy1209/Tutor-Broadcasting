//
//  CallManager.h
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 17.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

@interface CallManager : NSObject

<QBRTCClientDelegate>

@property (strong, nonatomic) QBRTCSession *session;

+ (instancetype) instance;

- (void) callToUser:(NSInteger) oppenentID withConferenceType:(QBConferenceType)conferenceType;

@end
