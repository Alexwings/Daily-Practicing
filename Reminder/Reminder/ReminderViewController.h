//
//  ReminderViewController.h
//  Reminder
//
//  Created by Xinyuan Wang on 12/5/16.
//  Copyright © 2016 Private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "ReminderManager.h"
#import "DatePickerViewController.h"

@interface ReminderViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, DatePickerDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)NSString *titleString;
@property(nonatomic)BOOL isNew;
@property(nonatomic)BOOL isPast;

@end
