//
//  ViewController.m
//  PersonInfo
//
//  Created by Xinyuan Wang on 11/23/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "ButtonViewController.h"
#import "Person.h"
#import "InfoViewController.h"
#import "Util.h"
#define keyPersonData @"Person"

@interface ButtonViewController ()
@property (weak, nonatomic) IBOutlet UITableView *peopleTable;
@property (strong, nonatomic)NSURL *dirUrl;
@property (strong, nonatomic)NSMutableArray *people;

@end

@implementation ButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"People";
    NSArray *urls = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[Util getDocumentsDirURL] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    self.people = [[NSMutableArray alloc] init];
    self.peopleTable.allowsMultipleSelectionDuringEditing = false;
    if(urls.count > 0){
        for(NSURL *url in urls){
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            Person *p = [unarchiver decodeObjectForKey:keyPersonData];
            [unarchiver finishDecoding];
            if(p){
                p.path = url;
                [self.people addObject:p];
            }
        }
    }
    self.dirUrl = [Util getDocumentsDirURL];
    [Util sortPeopleByAge:self.people];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.peopleTable reloadData];
}
- (IBAction)addNewPerson:(UIBarButtonItem *)sender {
    [self showPersonInfo:self.people.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -sendPersonInfoDelegate
-(void)sendPersonInfo:(Person *)person atIndex:(int)index{
    if(index != -1){
        person.path = [self.dirUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"person_%d.plist", index+1]];
        [self.people replaceObjectAtIndex:(NSUInteger)index withObject:person];
    }else{
        person.path = [self.dirUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"person_%d.plist", (int)self.people.count]];
        [self.people addObject:person];
    }
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:person forKey:keyPersonData];
    [archiver finishEncoding];
    [data writeToFile:person.path.path atomically:YES];
    [Util sortPeopleByAge:self.people];
    [self.peopleTable reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"person"];
    Person *p = (Person *)self.people[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", p.firstName, p.lastName];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,25)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Current People in record";
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row <= self.people.count){
        [self showPersonInfo:indexPath.row];
    }
}
- (void)showPersonInfo: (NSInteger)row{
    InfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
    vc.delegate = self;
    if(self.people.count > row){
        vc.person = self.people[row];
        vc.index = (int)row;
    }else{
        vc.person = [[Person alloc] init];
        vc.index = -1;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        Person *p = self.people[indexPath.row];
        if([Util removeFileAtURL: p.path]){
        [self.people removeObjectAtIndex: indexPath.row];
        [self.peopleTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
@end
