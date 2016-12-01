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
        DiaryItem *d = [[DiaryManager sharedManager] getDiaryFromDisk:self.filename];
        if(d){
            self.titleTextField.text = d.title;
            self.contentTextView.text = d.content;
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"File does not exists" message:@" " preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(void)saveButtonClicked{
    DiaryManager *dm = [DiaryManager sharedManager];
    if(![self.titleTextField.text containsString:@"."] && self.contentTextView.text.length > 5){
        DiaryItem *diary = [[DiaryItem alloc] initWithTitle:self.titleTextField.text andContent:self.contentTextView.text];
        if(self.isNew){
            [dm saveDataOnDisk:diary];
        }else{
            [dm updateDataOnDisk:diary forFile:self.filename];
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
