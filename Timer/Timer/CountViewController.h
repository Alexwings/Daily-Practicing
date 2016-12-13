//
//  CountViewController.h
//  Timer
//
//  Created by Xinyuan Wang on 12/3/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "TimerManager.h"

@interface CountViewController : UIViewController
    @property (strong, nonatomic)NSString *titleForTimer;
    @property (nonatomic)NSInteger intervalForTimer;

@end
