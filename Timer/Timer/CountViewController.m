//
//  CountViewController.m
//  Timer
//
//  Created by Xinyuan Wang on 12/3/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "CountViewController.h"

@interface CountViewController ()
@property(strong, nonatomic)NSTimer *timer;
@property(nonatomic)long count;
@property(strong, nonatomic)UNNotificationRequest *request;

@property (weak, nonatomic) IBOutlet UILabel *timerInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;


@end

@implementation CountViewController
@synthesize count;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleForTimer;
    UIBarButtonItem *goBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleDone target:self action:@selector(goBackButtonClicked)];
    self.navigationItem.leftBarButtonItem = goBackButton;
    count = self.intervalForTimer;
    self.timerInfoLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.timerInfoLabel.layer.borderWidth = 0.3;
    [self updateTimerInfo];
    //create Timer
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(fireUpTimer:) userInfo:nil repeats:YES];

}

//behavior when timer is fired
-(void)fireUpTimer: (NSTimer *)timer{
    if(self.count <= 0){
        [timer invalidate];
        self.playButton.enabled = false;
        self.timer = nil;

    }else{
        count--;
        [self updateTimerInfo];
    }
}

//helper function for update label
-(void)updateTimerInfo{
    NSInteger hour = count / 3600;
    NSInteger min = count % 3600 / 60;
    NSInteger sec = count % 3600 % 60;
    NSString *hourInString = hour < 10 ? [NSString stringWithFormat:@"0%lu", hour] : [NSString stringWithFormat:@"%lu", hour];
    NSString *minInString = min < 10 ? [NSString stringWithFormat:@"0%lu", min] : [NSString stringWithFormat:@"%lu", min];
    NSString *secInString = sec < 10 ? [NSString stringWithFormat:@"0%lu", sec] : [NSString stringWithFormat:@"%lu", sec];
    self.timerInfoLabel.text = [NSString stringWithFormat:@"%@:%@:%@", hourInString,minInString,secInString];
}

-(void)goBackButtonClicked{
    UINavigationController *navCon = self.navigationController;
    NSMutableArray *controllers = [navCon.viewControllers mutableCopy];
    [controllers removeLastObject];
    navCon.viewControllers = controllers;
    [navCon popViewControllerAnimated:YES];
}


- (IBAction)playButtonClicked:(id)sender {
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    self.pauseButton.enabled = true;
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Times up";
    content.body = [NSString stringWithFormat:@"timer set: %lu is done", self.intervalForTimer];
    content.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:self.count repeats:NO];
    self.request = [UNNotificationRequest requestWithIdentifier:@"TimesUp" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:self.request withCompletionHandler:nil];
}

- (IBAction)restartButtonClicked {
    count = self.intervalForTimer;
    [self updateTimerInfo];
    self.playButton.enabled = true;
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(fireUpTimer:) userInfo:nil repeats:YES];
    self.request = nil;
}

- (IBAction)pauseButtonClicked:(UIButton *)sender {
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval: 1 target:self selector:@selector(fireUpTimer:) userInfo:nil repeats:YES];
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[@"TimesUp"]];
}
- (IBAction)stopButtonClicked:(UIButton *)sender {
    self.count = self.intervalForTimer;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval: 1 target:self selector:@selector(fireUpTimer:) userInfo:nil repeats:YES];
    self.timerInfoLabel.text = @"00:00:00";
    self.pauseButton.enabled = false;
    self.playButton.enabled = false;
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[@"TimesUp"]];
}

@end
