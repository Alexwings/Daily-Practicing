//
//  DatePickerViewController.h
//  Reminder
//
//  Created by Xinyuan Wang on 12/6/16.
//  Copyright © 2016 Private. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerDelegate <NSObject>

-(void)transferData: (NSDate *)date;

@end

@interface DatePickerViewController : UIViewController

@property (weak, nonatomic)id<DatePickerDelegate>delegate;

@end
