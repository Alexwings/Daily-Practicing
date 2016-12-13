//
//  TimerManager.m
//  Timer
//
//  Created by Xinyuan Wang on 12/3/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "TimerManager.h"

@implementation TimerManager
    @synthesize timers, docDir;
    //custom initializer
    -(instancetype)init{
        if(self = [super init]){
            timers = [[NSMutableArray alloc] init];
            docDir = [self documentsDir];
        }
        return self;
    }
    //helper function to get current
    -(NSString *)documentsDir{
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/timers"];
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:docPath isDirectory:&isDir];
        if(!isDir){
            [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:false attributes:nil error:nil];
        }
        return docPath;
    }
    //create singlton for TimerManager
    +(instancetype)sharedManager{
        static id instance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[TimerManager alloc] init];
        });
        return instance;
    }
    
    -(void)loadTimers{
        
    }
    
    -(TimerItem *)addTimer:(TimerItem *)t{
        int c = 0;
        for(TimerItem *timer in timers){
            if([timer.title isEqualToString:t.title]){
                c++;
            }
        }
        if(c > 0){
            t.title = [t.title stringByAppendingString:[NSString stringWithFormat:@"_%d", c]];
        }
        [timers addObject:t];
        return t;
    }

@end
