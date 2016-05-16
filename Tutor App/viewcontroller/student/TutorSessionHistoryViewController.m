//
//  TutorSessionHistoryViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/11/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "TutorSessionHistoryViewController.h"
#import "SVProgressHUD.h"
#import "tutorsessionCell.h"
#import "UserInfo.h"
#import "TutorSessionDetailViewController.h"
@interface TutorSessionHistoryViewController ()
{
    
}
@end

@implementation TutorSessionHistoryViewController
@synthesize hisSessionArray;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self onInitTutorData:nil];
    [self getHistorySession];
}
- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    hisSessionArray = [[NSMutableArray alloc] init];
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


- (IBAction) onFilterAction : (id) sender
{
    if (hisSessionArray != nil) {
        hisSessionArray  = nil;
    }
    hisSessionArray = [[NSMutableArray alloc] init];
    
    [self getHistorySession];
}

- (IBAction)onMathFilterAction:(id)sender
{
    
}

- (IBAction)onScienceFilterAction:(id)sender
{
    
}

- (IBAction)onEnglishFilterAction:(id)sender
{
    
}

- (IBAction)onHistoryFilterAction:(id)sender
{
    
}

- (void) getHistorySession
{
    [SVProgressHUD show];
    
    NSDictionary * requestParam;
    requestParam = @{
                    
                     account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                     account_device_token : @"TEMPORARY"
                     
                    };
    
    [APIService makeApiCallWithMethodUrl:API_SESSION_HISTORY andRequestType:RequestTypePost andPathParams:nil andQueryParams:requestParam resultCallback:[self successResultCallback : API_SESSION_HISTORY] faultCallback:[self faultCallback : API_SESSION_HISTORY]];

}

#pragma Define init available Tutors.
- (void) onInitTutorData : (NSMutableArray *) hisArray
{
    
    int mathCount = 0;
    int sciencesCount = 0;
    int englishCount = 0;
    int historyCount = 0;
    
    if (hisArray == nil) {
        
        [_lblMathsHisCount setText:[NSString stringWithFormat:@"%d", mathCount]];
        [_lblScienceHisCount setText:[NSString stringWithFormat:@"%d",sciencesCount]];
        [_lblEnglishHisCount setText:[NSString stringWithFormat:@"%d", englishCount]];
        [_lblHistoryHisCount setText:[NSString stringWithFormat:@"%d", historyCount]];
        
        return;
    }
    
    for (NSDictionary * hisSession in hisArray) {
        
        NSString * subject_str = [hisSession objectForKey:account_subjects];
        if ([subject_str isEqualToString:@"Maths"]) {
            mathCount ++;
        }
        else if([subject_str isEqualToString:@"Sciences"])
        {
            sciencesCount++;
        }
        else if([subject_str isEqualToString:@"English"])
        {
            englishCount++;
        }
        else if([subject_str isEqualToString:@"History"])
        {
            historyCount++;
        }
    }
    
    [_lblMathsHisCount setText:[NSString stringWithFormat:@"%d", mathCount]];
    [_lblScienceHisCount setText:[NSString stringWithFormat:@"%d",sciencesCount]];
    [_lblEnglishHisCount setText:[NSString stringWithFormat:@"%d", englishCount]];
    [_lblHistoryHisCount setText:[NSString stringWithFormat:@"%d", historyCount]];
    
    
    [_tblHisSessionView reloadData];
}

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
    
    
    return ^(NSObject * result){
        NSDictionary * jsonDic = (NSDictionary *) result;
        NSLog(@"Tutoring Session Queue : %@", jsonDic);
        
        [SVProgressHUD dismiss];
        
        if([jsonDic[@"success"] boolValue])
        {
            
            NSObject * obj = (NSObject *)jsonDic[ tutoring_history_sessions ];
            
            if (![obj isKindOfClass:[NSArray class]]) {
                
                [self performSelectorOnMainThread:@selector(onInitTutorData :) withObject:nil waitUntilDone:NO];
            }
            else
            {
                NSArray * objSessionQueue = (NSArray * )obj;
                
                if (![_tfSubjects.text isEqualToString:@""] || ![_tfUserName.text isEqualToString:@""]) {
                    
                    for (NSDictionary * reteriveSession in objSessionQueue) {
                        
                        NSDictionary * dictSessionUser;
                        if([SessionManager sharedSession].userInfo.isTutor)
                        {
                            dictSessionUser = [reteriveSession objectForKey:account_student];
                        }
                        else
                        {
                            dictSessionUser = [reteriveSession objectForKey:account_tutor];
                        }
                        
                        
                        NSString * reteriveTutorName = [NSString stringWithFormat:@"%@ %@", [dictSessionUser objectForKey:account_first_name], [dictSessionUser objectForKey:account_last_name]];
                        NSString * reteriveTutorSubject = [dictSessionUser objectForKey:account_subjects];
                        
                        if ([_tfUserName.text isEqualToString:reteriveTutorName] || [_tfSubjects.text isEqualToString:reteriveTutorSubject]) {
                            
                            [hisSessionArray addObject: reteriveSession];
                            
                        }
                        
                    }
                    
                }
                
                if (hisSessionArray.count != 0) {
                    [self performSelectorOnMainThread:@selector(onInitTutorData :) withObject:hisSessionArray waitUntilDone:NO];
                }
                else
                {
                    hisSessionArray = [objSessionQueue copy];
                    [self performSelectorOnMainThread:@selector(onInitTutorData :) withObject:hisSessionArray waitUntilDone:NO];
                }
        
            }
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonDic[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    };
}

- (void)gotoView : (NSString *)strStoryboard : (NSString *) strIdentifier : (NSDictionary *) selectedData
{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:strStoryboard bundle:nil];
    TutorSessionDetailViewController * viewController = [storyBoard instantiateViewControllerWithIdentifier:strIdentifier];
    
    viewController.dictSessionData = selectedData;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource ,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hisSessionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tutorsessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tutorsessionCell" forIndexPath:indexPath];
    
    NSDictionary * dictHistoryInfo = [[NSDictionary alloc] init];
    
    if([SessionManager sharedSession].userInfo.isTutor)
    {
        dictHistoryInfo = [[hisSessionArray objectAtIndex:indexPath.row] objectForKey:account_student];
    }
    else
    {
        dictHistoryInfo = [[hisSessionArray objectAtIndex:indexPath.row] objectForKey:account_tutor];
    }
    
    cell.lblSubjects.text = [dictHistoryInfo objectForKey:account_subjects];
    cell.lblUserName.text = [NSString stringWithFormat: @"%@ %@",[dictHistoryInfo objectForKey:account_first_name], [dictHistoryInfo objectForKey:account_last_name]];
    cell.lblSessionID.text = [[hisSessionArray objectAtIndex:indexPath.row] objectForKey:tutoring_session_id];
    cell.lblSessionDuration.text = [[hisSessionArray objectAtIndex:indexPath.row] objectForKey:session_duration];
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([SessionManager sharedSession].userInfo.isTutor)
    {
        [self gotoView:@"Tutor" : @"TutorSessionDetailViewController":[hisSessionArray objectAtIndex:indexPath.row]];
    }
    else
    {
        [self gotoView:@"Student" : @"TutorSessionDetailViewController":[hisSessionArray objectAtIndex:indexPath.row]];
    }
    
}


@end
