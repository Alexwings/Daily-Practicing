//
//  ReminderViewController.m
//  Reminder
//
//  Created by Xinyuan Wang on 12/5/16.
//  Copyright © 2016 Private. All rights reserved.
//

#import "ReminderViewController.h"
#define newReminderFlag -1

@interface ReminderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *datePickerButton;
@property (weak, nonatomic) IBOutlet UILabel *datePickerLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property(strong, nonatomic)ReminderManager *datasource;
@property(strong, nonatomic)NSDictionary *curReminder;
@property(strong, nonatomic)NSDate *selectedDate;
@property(strong, nonatomic)UITapGestureRecognizer *gtr;

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.datasource = [ReminderManager sharedManager];
    self.contentTextView.text = @"";
    if(!self.isNew){
        self.title = self.titleString;
        self.curReminder = [self.datasource getReminderForTitle:self.titleString isPast:self.isPast];
        self.titleTextField.text = self.curReminder[@"title"];
        self.titleTextField.enabled = false;
        self.contentTextView.text = self.curReminder[@"content"];
        self.selectedDate = self.curReminder[@"time"];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        formater.dateFormat = @"MM-dd-yyyy/hh:mm:ss";
        self.datePickerLabel.text = [formater stringFromDate:self.curReminder[@"time"]];
    }
    self.contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentTextView.layer.borderWidth = 0.5;
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClicked)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.gtr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.gtr.delegate = self;
    self.gtr.enabled = false;
    [self.view addGestureRecognizer:self.gtr];
}

-(void)handleGesture:(UIGestureRecognizer *)sender{
    if([sender locationInView:self.view].y < self.view.frame.size.height){
        if([self.titleTextField isFirstResponder]){
            [self.titleTextField resignFirstResponder];
        }
        if([self.contentTextView isFirstResponder]){
            [self.contentTextView resignFirstResponder];
        }
    }
}
- (IBAction)datePickerButtonClicked:(UIButton *)sender {
    DatePickerViewController *picker = [self.storyboard instantiateViewControllerWithIdentifier:@"DatePicker"];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)transferData:(NSDate *)date{
//    assert(NO);
    NSTimeZone *timezone = [NSTimeZone localTimeZone];
    NSTimeInterval diff = [timezone secondsFromGMTForDate:date];
    self.selectedDate = [date dateByAddingTimeInterval:diff];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    formater.dateFormat = @"MM-dd-yyyy/hh:mm:ss";
    self.datePickerLabel.text= [formater stringFromDate:self.selectedDate];
}

-(void)saveButtonClicked{
    NSDictionary *re = @{@"title":self.titleTextField.text,
                         @"time" : self.selectedDate,
                         @"content" : self.contentTextView.text};
    if(self.isNew){
        [self.datasource saveReminder:re isPast:self.isPast];
    }else{
        [self.datasource updateReminder:re forTitle:self.titleString isPast:self.isPast];
    }
    [self removeNotification:re[@"title"]];
    [self addNotification:re[@"title"]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)removeNotification:(NSString *)identifier{
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifier]];
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[identifier]];
}

-(void)addNotification:(NSString *)identifier{
    //add notification to current notification center
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"You have a reminder";
    content.body = identifier;
    content.sound = [UNNotificationSound defaultSound];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDateComponents* date = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute  | NSCalendarUnitSecond fromDate:self.selectedDate];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:date repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}

#pragma  mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextView *)textView{
    self.gtr.enabled = true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.gtr.enabled = false;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.gtr.enabled = false;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.gtr.enabled = true;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    self.gtr.enabled = false;
}



@end
