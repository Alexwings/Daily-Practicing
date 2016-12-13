//
//  TimePicker.m
//  SimpleTimer
//
//  Created by Xinyuan Wang on 12/5/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "TimePicker.h"
@interface TimePicker()

@property (strong, nonatomic)UIDatePicker *datePicker;


@end

@implementation TimePicker

-(void)viewDidLoad{
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    [self.view addSubview:self.datePicker];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([self.delegate respondsToSelector:@selector(timerValueSet:)]){
            [self.delegate timerValueSet:self.datePicker.countDownDuration];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    self.message = @"\n\n\n\n\n\n\n\n";
    [self addAction:action];
}


@end
