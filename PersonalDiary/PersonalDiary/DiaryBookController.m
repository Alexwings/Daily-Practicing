//
//  ViewController.m
//  PersonalDiary
//
//  Created by Xinyuan Wang on 11/24/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "DiaryBookController.h"
#import "Diary.h"

#define keyForDiary @"Diary"

@interface DiaryBookController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)Utils *util;

//show the Content view
- (IBAction)CreateNew:(UIBarButtonItem *)sender;

@end

@implementation DiaryBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Diary Book";
    self.util = [Utils defaultUtil];
    self.util.delegate = self;
    [self.util loadDiaryBookForKey:keyForDiary];
    self.util.classifiedDiaryBook = [self.util classifyDiaryForSortedDiaryBookByYear];
//    Diary *d = [[Diary alloc] initWithTile:@"Section test" Content:@"test diary used to test auto generated sections" onDate:@"Nov 30, 2015" inPath:@"no path"];
//    [self.diaryBook addObject:d];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//show the Content View
- (IBAction)CreateNew:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addButtonSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier  isEqualToString: @"addButtonSegue"]){
        DiaryContentController *vc = segue.destinationViewController;
        vc.indexPath = nil;
    }
}

#pragma mark - ModelDelegate

-(void)informationUpdated{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.util.classifiedDiaryBook.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSMutableArray *)self.util.classifiedDiaryBook[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diary"];
    NSString *title = [(Diary *)self.util.classifiedDiaryBook[indexPath.section][indexPath.row] title];
    NSString *date = [(Diary *)self.util.classifiedDiaryBook[indexPath.section][indexPath.row] date];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-->%@", title, date];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        Diary *d = (Diary *)self.util.classifiedDiaryBook[indexPath.section][indexPath.row];
        if([self.util removeDiaryFromLocal:d.path]){
            [self.util.diaryBook removeObject:d];
            [self.util.classifiedDiaryBook[indexPath.section] removeObject:d];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:true];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    NSDate *d = [self.util stringToDate:[(Diary *)[(NSMutableArray *)self.util.classifiedDiaryBook[section] firstObject] date]];
    label.text = [[Utils defaultUtil] yearForDate:d];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showContent:indexPath];
}
//helper fuction for showing content of diary in tableView
-(void)showContent: (NSIndexPath *)indexPath{
    DiaryContentController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DiaryContentController"];
    vc.curDiary = (Diary *)self.util.classifiedDiaryBook[indexPath.section][indexPath.row];
    vc.indexPath = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
