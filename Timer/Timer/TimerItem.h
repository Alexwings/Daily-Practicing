//
//  TimerItem.h
//  Timer
//
//  Created by Xinyuan Wang on 12/3/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerItem : NSObject
    @property (nonatomic, strong)NSString *title;
    @property (nonatomic)NSInteger interval;
    
    -(instancetype)initWithTitle:(NSString *)t andInterval: (NSInteger)i;
@end
