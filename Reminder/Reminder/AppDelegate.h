//
//  AppDelegate.h
//  Reminder
//
//  Created by Xinyuan Wang on 12/5/16.
//  Copyright © 2016 Private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "ReminderManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

