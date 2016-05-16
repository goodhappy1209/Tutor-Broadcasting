//
//  FindTutorViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "FindTutorViewController.h"
#import "TutorListViewController.h"


@interface FindTutorViewController ()
{
    NSArray * availTutorArray;
    
}
@end

@implementation FindTutorViewController
@synthesize retTutorName, retLocation, retFirstSubField, retSecondSubField, retThirdSubField, mathSubCount, ScienceSubCount, englishSubCount, historySubCount;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self onInitTutorData:nil];
    [self getTutorArray];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Define init available Tutors.
- (void) onInitTutorData : (NSArray *) availTutors
{
    
    int mathCount = 0;
    int sciencesCount = 0;
    int englishCount = 0;
    int historyCount = 0;
    
    if (availTutors == nil) {
        
        [mathSubCount setText:[NSString stringWithFormat:@"%d", mathCount]];
        [ScienceSubCount setText:[NSString stringWithFormat:@"%d",sciencesCount]];
        [englishSubCount setText:[NSString stringWithFormat:@"%d", englishCount]];
        [historySubCount setText:[NSString stringWithFormat:@"%d", historyCount]];
        
        return;
    }
    
    for (NSDictionary * availTutor in availTutors) {
        
        NSString * subject_str = [availTutor objectForKey:account_subjects];
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
    
    [mathSubCount setText:[NSString stringWithFormat:@"%d", mathCount]];
    [ScienceSubCount setText:[NSString stringWithFormat:@"%d",sciencesCount]];
    [englishSubCount setText:[NSString stringWithFormat:@"%d", englishCount]];
    [historySubCount setText:[NSString stringWithFormat:@"%d", historyCount]];
    
    
    availTutorArray = availTutors;
    
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
        NSLog(@"Available Tutor : %@", jsonDic);
        
        if([jsonDic[@"success"] boolValue])
        {
            NSObject * obj = jsonDic[ available_tutors ];
            
            
            if(![obj isKindOfClass:[NSArray class]])
            {
                [SVProgressHUD dismiss];
                [self performSelectorOnMainThread:@selector(onInitTutorData :) withObject:nil waitUntilDone:NO];
            }
            else
            {
                [SVProgressHUD dismiss];
                NSArray * availableTutors = (NSArray * ) jsonDic[available_tutors];
                [self performSelectorOnMainThread:@selector(onInitTutorData :) withObject:availableTutors waitUntilDone:NO];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:jsonDic[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    };
}


#pragma Define get Tutor Array from Server.
- (void) getTutorArray
{
    NSDictionary * requestParam;
    requestParam = @{
                     account_member_id : [[SessionManager sharedSession].userInfo.dictServerUser objectForKey:account_member_id],
                     account_device_token : @"TEMPORARY"
                     };
    
    [SVProgressHUD show];
    
    [APIService makeApiCallWithMethodUrl:API_AVAILABLE_TUTORS andRequestType:RequestTypePost andPathParams:nil andQueryParams:requestParam resultCallback:[self successResultCallback : API_AVAILABLE_TUTORS] faultCallback:[self faultCallback : API_AVAILABLE_TUTORS]];
}

#pragma Define UITextField Delegate.
- ( void ) textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}
- ( void ) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- ( BOOL ) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}


#pragma IBAction for Reterive collect Subject.

- (IBAction)onMathsSel:(id)sender
{
    
}

- (IBAction)onScienceSel:(id)sender
{
    
}

- (IBAction)onEnglishSel:(id)sender
{
    
}
- (IBAction)onHistorySel:(id)sender
{
    
}
- (IBAction)onCannectNowSel:(id)sender
{
    NSMutableArray * reteriveTutors = [[NSMutableArray alloc] init];
    
    for (NSDictionary * reteriveTutor in availTutorArray ) {
        
//        if (![retTutorName.text isEqualToString:@""]) {
//            
//        }
//        else if(![retLocation.text isEqualToString:@""])
//        {
//            
//        }
//        else if(![retFirstSubField.text isEqualToString:@""])
//        {
//            
//        }
//        else if(![retSecondSubField.text isEqualToString:@""])
//        {
//            
//        }
//        else if (![retThirdSubField.text isEqualToString:@""])
//        {
//            
//        }
        NSString * reteriveTutorName = [NSString stringWithFormat:@"%@ %@", [reteriveTutor objectForKey:account_first_name], [reteriveTutor objectForKey:account_last_name]];
        NSString * reteriveTutorLocation = [NSString stringWithFormat:@"%@ %@", [reteriveTutor objectForKey:account_city], [reteriveTutor objectForKey:account_country]];
        NSString * reteriveTutorSubject = [reteriveTutor objectForKey:account_subjects];
        
        if ([retTutorName.text isEqualToString:reteriveTutorName] || [retTutorName.text isEqualToString:reteriveTutorLocation] || [retFirstSubField.text isEqualToString:reteriveTutorSubject] || [retSecondSubField.text isEqualToString:reteriveTutorSubject] || [retThirdSubField.text isEqualToString:reteriveTutorSubject]) {
            
            [reteriveTutors addObject:reteriveTutor];
            
        }
        
    }
    
    if (reteriveTutors.count != 0) {
        
        [self gotoView:@"Student" :@"TutorListViewController" : reteriveTutors];
    }
    else
    {
        reteriveTutors = [availTutorArray copy];
        [self gotoView:@"Student" :@"TutorListViewController" : reteriveTutors];
    }
    
}

- (void)gotoView : (NSString *)strStoryboard : (NSString *) strIdentifier : (NSMutableArray *) reteriveTutors
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:strStoryboard bundle:nil];
    TutorListViewController* viewController = [storyBoard instantiateViewControllerWithIdentifier:strIdentifier];
    
    viewController.findTutorsArray = [[NSMutableArray alloc] init];
    viewController.findTutorsArray = reteriveTutors;
    
    [self.navigationController pushViewController:viewController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
