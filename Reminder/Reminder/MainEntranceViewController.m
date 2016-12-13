//
//  MainEntranceViewController.m
//  Reminder
//
//  Created by Xinyuan Wang on 12/5/16.
//  Copyright © 2016 Private. All rights reserved.
//

#import "MainEntranceViewController.h"
#import "ReminderViewController.h"

#define newReminderFlag -1

@interface MainEntranceViewController ()

@property (strong, nonatomic)ReminderManager *datasource;

@end

@implementation MainEntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.datasource = [ReminderManager sharedManager];
    [self.datasource loadAllReminders];
    [self.datasource refreshData];
    self.datasource.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked)];
    self.title = @"Reminders";
    
    
}

-(void)addButtonClicked{
    [self performSegueWithIdentifier:@"addReminderSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"addReminderSegue"]){
        ReminderViewController *vc = segue.destinationViewController;
        vc.isNew = true;
        vc.isPast = false;
    }
    if([segue.identifier isEqualToString:@"showReminderSegue"]){
        ReminderViewController *vc = segue.destinationViewController;
        vc.isNew = false;
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        vc.isPast = index.section == 0;
        vc.titleString = [[[self.tableView cellForRowAtIndexPath:index].textLabel.text componentsSeparatedByString:@"--"] firstObject];
    }
}

#pragma mark -UpdateInfoDelegate

-(void)updateInfo{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.datasource.pastReminders.count;
    }
    return self.datasource.upcommingReminders.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reminderCell" forIndexPath:indexPath];
    NSDictionary *reminder;
    switch (indexPath.section) {
        case 0:
            reminder = self.datasource.pastReminders[indexPath.row];
            break;
        case 1:
            reminder = self.datasource.upcommingReminders[indexPath.row];
            break;
        default: break;
    }
    if(reminder){
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"MM-dd-yyyy";
        NSString *date = [formater stringFromDate:reminder[@"time"]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@--%@",reminder[@"title"], date];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete ){
        [self.datasource removeReminderAtIndex:indexPath.row isPast:(indexPath.section == 0)];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
#pragma mark -UITableViewDelegate
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Past Reminders";
            break;
        case 1:
            return @"Upcomming Reminders";
    }
    return @"";
}

@end
