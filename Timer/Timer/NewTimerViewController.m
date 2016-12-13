//
//  NewTimerViewController.m
//  Timer
//
//  Created by Xinyuan Wang on 12/3/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "NewTimerViewController.h"
#import "TimerAttributeCell.h"
#import "TimerManager.h"
#import "CountViewController.h"

#define TableSectionNumber  1
#define RowNumberInSection  2
typedef NS_ENUM(NSInteger, TimerAttributes) {
    TimerAttributeTitle,
    TimerAttributeInterval
};

@interface NewTimerViewController ()
    @property (strong, nonatomic)UIBarButtonItem *confirmButton;
    @property (strong, nonatomic)TimerItem *timerItem;

@end

@implementation NewTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Timer";
    self.confirmButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirmButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.confirmButton;
    self.timerItem = [[TimerItem alloc] init];
}

-(void)confirmButtonClicked{
    //implement confirm Button, jump to countdown view
    NSArray *cells = [self.tableView visibleCells];
    for(int i = 0; i < cells.count; i++){
        TimerAttributeCell *cell = [cells objectAtIndex:i];
        switch (i){
            case TimerAttributeTitle:
            self.timerItem.title = cell.attriInput.text;
            break;
            case TimerAttributeInterval:
            self.timerItem.interval = [cell.attriInput.text integerValue];
        }
    }
    self.timerItem = [[TimerManager sharedManager] addTimer:self.timerItem];

    [self performSegueWithIdentifier:@"showCountSegue" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableSectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return RowNumberInSection;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimerAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newTimerCell" forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
        cell.attriTitle.text = @"Title: ";
        cell.attriInput.placeholder = @"name for your timer";
        cell.attriInput.keyboardType = UIKeyboardTypeDefault;
        break;
        case 1:
        cell.attriTitle.text = @"Time: ";
        cell.attriInput.keyboardType = UIKeyboardTypePhonePad;
        default:
        break;
    }
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showCountSegue"]){
        CountViewController *vc = segue.destinationViewController;
        vc.titleForTimer = self.timerItem.title;
        vc.intervalForTimer = self.timerItem.interval;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
