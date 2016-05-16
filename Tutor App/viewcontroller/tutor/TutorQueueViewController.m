//
//  TutorQueueViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "TutorQueueViewController.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "hasCurrentTutorCell.h"
#import "ConcludeSessionViewController.h"

@interface TutorQueueViewController ()

@end

@implementation TutorQueueViewController
@synthesize hasCurSessionArray;
- ( void ) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self hasCurrentTutorSession];
    hasCurSessionArray = [[NSMutableArray alloc] init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma NSError from Server Request.

- (void (^)(NSError *fault)) faultCallback : (NSString *) requestName
{
    return ^(NSError * fault){
        
        [SVProgressHUD dismiss];
        
        NSLog(@"Available Tutor Error : %@", fault.description);
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    };
}
#pragma NSDictionary result from Server Request.

- (void (^)(NSObject * result)) successResultCallback : (NSString *)requestName
{
    
    
    if ([requestName isEqualToString:API_SESSION_ACCEPT]) {
        return ^(NSObject * result){
            [SVProgressHUD dismiss];
            
            NSDictionary * jsonDic = (NSDictionary * ) result;
            NSLog(@"Tutoring Session Accepted : %@", jsonDic);
            
            if ([jsonDic[@"success"] boolValue]) {
                
                if ([jsonDic[@"message"] isEqualToString:@"Session Accepted."]) {
                    NSString *message = @"Brayant Webster tutoring in English: May I-Cannect with you ?";
                    [self showAlertView:@"Confirm" :message :2000];
                    
                    _dictSessionInfo = (NSDictionary *)jsonDic[account_tutoring_session];
                    
                }
                else
                {
                    NSString *message = jsonDic[@"message"];
                    [self showAlertView:@"Deny" :message :1000];
                }
                
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonDic[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        };
    }
    else if ([requestName isEqualToString:API_SESSION_HISTORY]) {
        return ^(NSObject * result){
            NSDictionary * jsonDic = (NSDictionary *) result;
            NSLog(@"Tutoring Session Queue : %@", jsonDic);
            
            [SVProgressHUD dismiss];
            
            if([jsonDic[@"success"] boolValue])
            {
            
                NSObject * obj = (NSObject *)jsonDic[ tutoring_history_sessions];
                
                if (![obj isKindOfClass:[NSArray class]]) {
                    
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonDic[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                else
                {
                    NSArray * objSessionQueue = (NSArray * )obj;
                    
                    for (NSDictionary * sessionInfo in objSessionQueue) {
                        
                        if ([[sessionInfo objectForKey:session_is_accepted] intValue] == 0) {
                            [hasCurSessionArray addObject: sessionInfo];
                        }
                        
                    }
                    
                    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                    
                }
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonDic[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        };
    }
    
    return nil;
}

- (void) reloadTableView
{
    [SVProgressHUD dismiss];
    [_tblCurSessionList reloadData];
}


- (void) hasCurrentTutorSession
{
    [SVProgressHUD show];
    
    NSDictionary * requestParam;
    requestParam = @{
                     account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                     account_device_token : @"TEMPORARY"
                     };
    
    [APIService makeApiCallWithMethodUrl:API_SESSION_HISTORY andRequestType:RequestTypePost andPathParams:nil andQueryParams:requestParam resultCallback:[self successResultCallback : API_SESSION_HISTORY] faultCallback:[self faultCallback : API_SESSION_HISTORY]];
}

#pragma IBAction Component of the TableCell
- (void) didConfirmAction : (NSDictionary * ) confirmTutorSession
{
   
    
    [SVProgressHUD show];
    
    NSDictionary * acceptRequest = @{
                                     
                                     account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                                     account_device_token : @"TEMPORARY",
                                     tutoring_session_id : [confirmTutorSession objectForKey:tutoring_session_id],
                                     session_is_accepted : @"1"
                                     
                                     };
    
    [APIService makeApiCallWithMethodUrl:API_SESSION_ACCEPT andRequestType:RequestTypePost andPathParams:nil andQueryParams:acceptRequest resultCallback:[self successResultCallback : API_SESSION_ACCEPT] faultCallback:[self faultCallback : API_SESSION_ACCEPT]];
    
    
}
- (void) didDenyAction : (NSDictionary * ) denyTutorSession
{
   
    [SVProgressHUD show];
    
    NSDictionary * acceptRequest = @{
                                     
                                     account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                                     account_device_token : @"TEMPORARY",
                                     tutoring_session_id : [denyTutorSession objectForKey:tutoring_session_id],
                                     session_is_accepted : @"2"
                                     
                                     };
    
    [APIService makeApiCallWithMethodUrl:API_SESSION_ACCEPT andRequestType:RequestTypePost andPathParams:nil andQueryParams:acceptRequest resultCallback:[self successResultCallback : API_SESSION_ACCEPT] faultCallback:[self faultCallback : API_SESSION_ACCEPT]];
    
}

#pragma mark - UITableViewDataSource ,UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hasCurSessionArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    hasCurrentTutorCell * cell = (hasCurrentTutorCell*) [tableView dequeueReusableCellWithIdentifier:@"hasCurrentTutorCell"];
    cell.delegate = self;
    NSDictionary* studenInfo = [hasCurSessionArray objectAtIndex:indexPath.row];
    
    NSLog(@"student info : %@", studenInfo);
    
    [cell initHasCurrentTutorCell:studenInfo];
    
    return cell;
}


- (IBAction)onConfirm:(id)sender
{
    NSString *message = @"Brayant Webster tutoring in English: May I-Cannect with you ?";
    NSDictionary *attributes = @{ kMONPromptViewAttribDismissButtonBackgroundColor: [UIColor colorWithRed:111/255.0f green:189/255.0f blue:57/255.0f alpha:1.0f],
                                  kMONPromptViewAttribDismissButtonTextColor: [UIColor whiteColor],
                                  };
    
    MONPromptView *promptView = [[MONPromptView alloc] initWithTitle:@"Confirm"
                                                             message:message
                                                  dismissButtonTitle:@"Confirm" attributes:attributes];
    promptView.delegate = self;
    [promptView showInView:self.navigationController.view];

}

- (void)gotoView : (NSString *)strStoryboard : (NSString *) strIdentifier : (NSDictionary *) SessionInfoDic
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:strStoryboard bundle:nil];
    ConcludeSessionViewController * viewController = [storyBoard instantiateViewControllerWithIdentifier:strIdentifier];
    
    viewController.AcceptedDict = SessionInfoDic;
    
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - MONPromptView Delegate

- (void)promptViewWillDismiss:(MONPromptView *)promptView {
    // TODO Handle on dismiss
    if (promptView.tag == 2000)
        [self gotoView:@"Tutor" :@"ConcludeSessionViewController" : _dictSessionInfo];
}



#pragma defined UIAlertView
- ( void )showAlertView : ( NSString* ) _title : ( NSString * ) _message : ( NSInteger ) alertTag
{
   
    NSDictionary *attributes = @{ kMONPromptViewAttribDismissButtonBackgroundColor: [UIColor colorWithRed:111/255.0f green:189/255.0f blue:57/255.0f alpha:1.0f],
                                  kMONPromptViewAttribDismissButtonTextColor: [UIColor whiteColor],
                                  };
    
    MONPromptView *promptView = [[MONPromptView alloc] initWithTitle:_title
                                                             message:_message
                                                  dismissButtonTitle:_title attributes:attributes];
    [promptView setDelegate:self];
    [promptView setTag:alertTag];
    [promptView showInView:self.navigationController.view];
    
}

@end
