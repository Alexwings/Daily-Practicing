//
//  AppDelegate.m
//  SimpleTimer
//
//  Created by Xinyuan Wang on 12/5/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "AppDelegate.h"

#define keyForAuthorization @"allowUseNotifications"
@interface AppDelegate ()

@end

@implementation AppDelegate

-(BOOL) application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionBadge+UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(granted){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:keyForAuthorization];
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:keyForAuthorization];
        }
        if(error){
            NSLog(@"%@", error.description);
        }
    }];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma  mark - UNUserNotificationCenterDelegate
//handle notification behavior when the screen is locked and define the action button behavior there
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    if([response.notification.request.content.categoryIdentifier isEqualToString:@"TIMER_EXPIRED"]){
        if([response.actionIdentifier isEqualToString:@"SNOOZE_ACTION"]){
            NSInteger cont = [response.notification.request.content.badge integerValue];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = [NSString localizedStringWithFormat:@"Times Up"];
            content.body = [NSString localizedStringWithFormat:@"10 more seconds past"];
            content.badge = [NSNumber numberWithInteger:cont+1];
            content.categoryIdentifier = @"TIMER_EXPIRED";
            content.sound = [UNNotificationSound defaultSound];
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"RepeatTen" content:content trigger:trigger];
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
        }
    }else{
        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[response.notification.request.identifier]];
    }
}

@end
