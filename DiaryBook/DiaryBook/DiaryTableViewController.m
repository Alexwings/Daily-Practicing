//
//  DiaryTableViewController.m
//  DiaryBook
//
//  Created by Xinyuan Wang on 11/30/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "DiaryTableViewController.h"
#import "addDiaryViewController.h"

@interface DiaryTableViewController ()

@property (strong, nonatomic)UIBarButtonItem *addButton;

@end

@implementation DiaryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Diaries";
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewDiaryClicked)];
    self.navigationItem.rightBarButtonItem = self.addButton;
    [DiaryManager sharedManager].delegate = self;
    [[DiaryManager sharedManager] loadDataFromDisk];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)addNewDiaryClicked{
    [self performSegueWithIdentifier:@"addButton" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    addDiaryViewController *vc = segue.destinationViewController;
    if([segue.identifier isEqualToString:@"addButton"]){
        vc.isNew = YES;
    }
    if([segue.identifier isEqualToString:@"showDiary"]){
        vc.isNew = NO;
        UITableViewCell *cell = sender;
        vc.filename = cell.textLabel.text;
    }
}

#pragma mark - InformationUpdatedDelegate
-(void)infoUpdated{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DiaryManager sharedManager].diaryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text = [DiaryManager sharedManager].diaryList[indexPath.row];
    return cell;
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
