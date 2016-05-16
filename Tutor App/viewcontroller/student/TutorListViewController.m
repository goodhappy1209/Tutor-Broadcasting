//
//  TutorListViewController.m
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "TutorListViewController.h"
#import "findTutorCell.h"
#import "InitateSessionViewController.h"

@interface TutorListViewController ()

@end

@implementation TutorListViewController
@synthesize findTutorsArray, tblTutorListView;

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

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma inite sesstion action.
- (void) didIniteSession : (NSDictionary * ) initSessionTutor
{
 
    [self gotoView:@"Student" : @"InitateSessionViewController" : initSessionTutor];
    
}

- (void)gotoView : (NSString *)strStoryboard : (NSString *) strIdentifier : (NSDictionary *) initSessionTutor
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:strStoryboard bundle:nil];
    InitateSessionViewController* viewController = [storyBoard instantiateViewControllerWithIdentifier:strIdentifier];
    
    viewController.selectedTutor = initSessionTutor;
    
    [self.navigationController pushViewController:viewController animated:YES];
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
    return findTutorsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    findTutorCell* cell = (findTutorCell*) [tableView dequeueReusableCellWithIdentifier:@"findTutorCell"];
    cell.delegate = self;
    [cell initAvailableTutorCell:[findTutorsArray objectAtIndex:indexPath.row]];

    return cell;
}

@end
