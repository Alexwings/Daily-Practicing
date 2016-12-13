//
//  TimePicker.h
//  SimpleTimer
//
//  Created by Xinyuan Wang on 12/5/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimerPickerDelegate <NSObject>

-(void)timerValueSet: (NSTimeInterval) interval;

@end

@interface TimePicker : UIAlertController
@property (weak, nonatomic)id<TimerPickerDelegate> delegate;

@end
