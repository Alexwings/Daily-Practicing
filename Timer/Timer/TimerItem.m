//
//  TimerItem.m
//  Timer
//
//  Created by Xinyuan Wang on 12/3/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "TimerItem.h"

@implementation TimerItem

    @synthesize title, interval;
    
    -(instancetype)initWithTitle:(NSString *)t andInterval:(NSInteger)i{
        if(self = [super init]){
            self.title = t;
            self.interval = i;
        }
        return self;
    }
    
@end
