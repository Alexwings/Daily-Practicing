//
//  DiaryContentControllerViewController.m
//  PersonalDiary
//
//  Created by Xinyuan Wang on 11/25/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "DiaryContentController.h"
#import "Utils.h"


@interface DiaryContentController ()
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (strong, nonatomic)Utils *util;


- (IBAction)saveCurrentDiary:(UIBarButtonItem *)sender;
- (IBAction)quitCurrentDiary:(UIBarButtonItem *)sender;

@end

@implementation DiaryContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.util = [Utils defaultUtil];
    self.gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.gr.delegate = self;
    self.gr.enabled = false;
    [self.view addGestureRecognizer:self.gr];
    NSString *today = [self.util dateToString:[NSDate date]];
    if(!self.curDiary){
        self.curDiary = [[Diary alloc] init];
        self.curDiary.date = today;
        NSString *docPath = [self.util getDocumentDir];
        NSString *docName = [self.curDiary.title stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-->%@", docName, self.curDiary.date]];
        self.curDiary.path = path;
    }
    self.title = self.curDiary.date;
    self.titleText.delegate = self;
    self.contentText.layer.borderColor = [UIColor blackColor].CGColor;
    self.contentText.layer.borderWidth = 0.2;
    //set current content of the diary
    self.titleText.text = self.curDiary.title;
    self.contentText.text = self.curDiary.content;
    
}
//Handle tap gesture;
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        if([gestureRecognizer locationInView:self.view].y < self.view.frame.size.height){
            if([self.titleText isFirstResponder]) [self.titleText resignFirstResponder];
            else if([self.contentText isFirstResponder]) [self.contentText resignFirstResponder];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exitKeyboardForTextView{
    [self.contentText resignFirstResponder];
}

- (IBAction)saveCurrentDiary:(UIBarButtonItem *)sender {
    if(self.titleText.text.length >=2 && self.contentText.text.length >=5){
        self.curDiary.title = self.titleText.text;
        self.curDiary.content = self.contentText.text;
        NSInteger sec = self.indexPath ? self.indexPath.section : -1;
        NSInteger r = self.indexPath ? self.indexPath.row: -1;
        [self.util saveDiaryAndUpdate:self.curDiary section:sec row:r];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter all the field!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)quitCurrentDiary:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.titleText){
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.gr.enabled = true;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.gr.enabled = true;
}


@end
