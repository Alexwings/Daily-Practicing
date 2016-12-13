//
//  ViewController.m
//  SimpleTimer
//
//  Created by Xinyuan Wang on 12/5/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "ViewController.h"

#define timerLabelZero  @"00:00:00"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *timerControl;
@property (weak, nonatomic) IBOutlet UIButton *selectTimeButton;

@property (nonatomic)long interval;
@property (nonatomic)long count;
@property (strong, nonatomic)NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"SimpleTimer";
    self.timerLabel.layer.borderColor = [UIColor blueColor].CGColor;
    self.timerLabel.layer.borderWidth = 0.2;
    self.timerLabel.text = timerLabelZero;
    [self.timerControl setTitle:@"Start" forState:UIControlStateNormal];
    self.timerControl.enabled = false;
    self.timer = nil;
    UNNotificationAction *snoozeAction = [UNNotificationAction actionWithIdentifier:@"SNOOZE_ACTION" title:@"snooze" options:UNNotificationActionOptionNone];
    UNNotificationCategory *expiredCategory = [UNNotificationCategory categoryWithIdentifier:@"TIMER_EXPIRED" actions:@[snoozeAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:expiredCategory]];

}

- (IBAction)controlButtonClicked:(UIButton *)sender {
    NSString *title = sender.currentTitle;
    if([title isEqualToString:@"Start"]){
        //disable the textfiled
        self.count = self.interval;
        [self updateLabel];
        //set up timer
        self.timer = [NSTimer timerWithTimeInterval: 1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        //add notification
        
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.categoryIdentifier = @"TIMER_EXPIRED";
        content.title = [NSString localizedStringWithFormat:@"Times Up"];
        content.body = [NSString localizedStringWithFormat:@"Time is up"];
        content.badge = 0;
        content.sound = [UNNotificationSound defaultSound];
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:self.count repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"TimerNotification" content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"%@", error.description);
        }];
        //change title
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
    }else if([title isEqualToString:@"Stop"]){
        [self.timer invalidate];
        self.timer = nil;
        self.count = 0;
        self.timerControl.enabled = self.interval != 0;
        [self updateLabel];
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers: @[@"TimerNotification"]];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
    }
}

-(void)timerFireMethod:(NSTimer *)timer{
    if(self.count <= 0){
        [timer invalidate];
        self.count = self.interval;
        self.timerControl.enabled = self.interval != 0;
        timer = nil;
        [self.timerControl setTitle:@"Start" forState:UIControlStateNormal];
    }else {
        self.count--;
        [self updateLabel];
    }
}

-(void)updateLabel{
    NSInteger h = self.count / 3600;
    NSInteger m = self.count % 3600 / 60;
    NSInteger s = self.count % 3600 % 60;
    NSString *hour = h > 9 ? [NSString stringWithFormat:@"%lu", h] : [NSString stringWithFormat:@"0%lu", h];
    NSString *min = m > 9 ? [NSString stringWithFormat:@"%lu", m] : [NSString stringWithFormat:@"0%lu", m];
    NSString *sec = s > 9 ? [NSString stringWithFormat:@"%lu", s] : [NSString stringWithFormat:@"0%lu", s];
    self.timerLabel.text = [NSString stringWithFormat:@"%@:%@:%@", hour, min, sec];
}
- (IBAction)selectTimeButtonClicked:(UIButton *)sender {
    TimePicker *picker = [TimePicker alertControllerWithTitle:@"TimerPicker" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}



#pragma mark -TimePickerDelegate

-(void)timerValueSet:(NSTimeInterval)interval{
    self.interval = (NSInteger)interval;
    self.count = self.interval;
    self.timerControl.enabled = true;
    [self updateLabel];
}

@end
