//
//  TimerManager.h
//  Timer
//
//  Created by Xinyuan Wang on 12/3/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerItem.h"

@interface TimerManager : NSObject
    @property (strong, nonatomic)NSMutableArray *timers;
    @property (strong, nonatomic, readonly)NSString *docDir;
    
    //custom initializer
    -(instancetype)init;
    //create singlton for TimerManager
    +(instancetype)sharedManager;
    //GET
    //loads all the timer from disk
    -(void)loadTimers;
    
    //POST
    -(TimerItem *)addTimer:(TimerItem *) t;

@end
