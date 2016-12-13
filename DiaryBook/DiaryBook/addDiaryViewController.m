//
//  addDiaryViewController.m
//  DiaryBook
//
//  Created by Xinyuan Wang on 11/30/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "addDiaryViewController.h"

@interface addDiaryViewController ()

@property (strong, nonatomic)UIBarButtonItem *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic)DiaryItem *currentDiary;

@end

@implementation addDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Content";
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.contentTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.contentTextView.layer.borderWidth = 0.5;
    
    if(!self.isNew){
        self.currentDiary = [[DiaryManager sharedManager] getDiaryFromDisk:self.filename];
        self.saveButton.style = UIBarButtonItemStylePlain;
        [self.saveButton setTitle:@"update"];
        if(self.currentDiary){
            self.titleTextField.text = self.currentDiary.title;
            self.contentTextView.text = self.currentDiary.content;
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"File does not exists" message:@" " preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(void)saveButtonClicked{
    DiaryManager *dm = [DiaryManager sharedManager];
    if(self.titleTextField.text.length > 0 && self.contentTextView.text.length > 5){
        if(self.isNew){
            DiaryItem *diary = [[DiaryItem alloc] initWithTitle:self.titleTextField.text andContent:self.contentTextView.text];
            [dm saveDataOnDisk:diary];
        }else{
            self.currentDiary.title = self.titleTextField.text;
            self.currentDiary.content = self.contentTextView.text;
            [dm updateDataOnDisk:self.currentDiary forFile:self.filename];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Input!" message:@"title should not contain dot symbol!\n content should longer then 5 characters!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
