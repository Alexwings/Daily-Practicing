//
//  ReminderManager.m
//  Reminder
//
//  Created by Xinyuan Wang on 12/5/16.
//  Copyright © 2016 Private. All rights reserved.
//

#import "ReminderManager.h"
#define pastFileName    @"past.plist"
#define upcomFileName   @"upcomming.plist"
@interface ReminderManager()

@property(strong, nonatomic)NSString *docDir;

@end

@implementation ReminderManager

NSMutableArray *past;
NSMutableArray *upcomming;

-(NSMutableArray *)pastReminders{
    return past;
}

-(NSMutableArray *)upcommingReminders{
    return upcomming;
}

+(instancetype)sharedManager{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ReminderManager alloc] init];
    });
    return instance;
}

-(NSString *)getDocDir{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Reminders"];
    BOOL isDir = false;
    [[NSFileManager defaultManager] fileExistsAtPath:docPath isDirectory:&isDir];
    if (!isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return docPath;
}

-(void)loadAllReminders{
    NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"past" ofType:@"plist"];
    NSString *plistPath2 = [[NSBundle mainBundle] pathForResource:@"upcomming" ofType:@"plist"];
    NSString *pastPath = [[self getDocDir] stringByAppendingPathComponent:@"past.plist"];
    NSString *upcomPath = [[self getDocDir] stringByAppendingPathComponent:@"upcomming.plist"];
    //load past reminders
    if(![[NSFileManager defaultManager] fileExistsAtPath:pastPath]){
        past = [NSMutableArray arrayWithContentsOfFile:plistPath1];
    }else{
        past = [NSMutableArray arrayWithContentsOfFile:pastPath];
    }
    //load upcomming reminders
    if(![[NSFileManager defaultManager] fileExistsAtPath:upcomPath]){
        upcomming = [NSMutableArray arrayWithContentsOfFile:plistPath2];
    }else{
        upcomming = [NSMutableArray arrayWithContentsOfFile:upcomPath];
    }
}

-(void)saveAllReminders{
    NSString *pastPath = [[self getDocDir] stringByAppendingPathComponent:pastFileName];
    NSString *upcomPath = [[self getDocDir] stringByAppendingPathComponent:upcomFileName];
    [past writeToFile:pastPath atomically:YES];
    [upcomming writeToFile:upcomPath atomically:YES];
}

-(NSDictionary *)getReminderForTitle:(NSString *)title isPast:(BOOL)isPast{
    if(isPast){
        for (NSDictionary *r in past) {
            if([r[@"title"] isEqualToString:title]){
                return r;
            }
        }
    }else{
        for(NSDictionary *r in upcomming){
            if([r[@"title"] isEqualToString:title]){
                return r;
            }
        }
    }
    return nil;
}

-(void)saveReminder:(NSDictionary *)reminder isPast:(BOOL)isPast{
    if(isPast){
        int count = 0;
        NSMutableDictionary *new = [reminder mutableCopy];
        for(NSDictionary *dic in past){
            if( [dic[@"title"] isEqualToString:new[@"title"]]){
                count++;
                new[@"title"] = count != 0 ? [NSString stringWithFormat:@"%@_%d", reminder[@"title"], count] : reminder[@"title"];
            }
        }
        [past addObject: new];
    }else{
        int count = 0;
        NSMutableDictionary *new = [reminder mutableCopy];
        for(NSDictionary *dic in past){
            if( [dic[@"title"] isEqualToString:new[@"title"]]){
                count++;
                new[@"title"] = count != 0 ? [NSString stringWithFormat:@"%@_%d", reminder[@"title"], count] : reminder[@"title"];
            }
        }
        [upcomming addObject: new];
    }
    if([self.delegate respondsToSelector:@selector(updateInfo)]){
        [self.delegate updateInfo];
    }
}

-(void)updateReminder:(NSDictionary *)reminder forTitle:(NSString *)title isPast:(BOOL)isPast{
    NSDictionary *old = [self getReminderForTitle:title isPast:isPast];
    if(isPast){
        [past removeObject:old];
        [upcomming addObject:reminder];
    }else{
        NSInteger index = [upcomming indexOfObject:old];
        [upcomming replaceObjectAtIndex:index withObject:reminder];
    }
    if([self.delegate respondsToSelector:@selector(updateInfo)]){
        [self.delegate updateInfo];
    }
}

-(void)removeAllForState:(BOOL)isPast{
    if(isPast){
        [past removeAllObjects];
    }else{
        [upcomming removeAllObjects];
    }
}

-(void)removeReminderAtIndex:(NSInteger)index isPast:(BOOL)isPast{
    if(isPast){
        [past removeObjectAtIndex:index];
    }else{
        [upcomming removeObjectAtIndex:index];
    }
}

-(void)refreshData{
    NSMutableArray *cache = [[NSMutableArray alloc] init];
    NSDate *now = [NSDate date];
    NSTimeZone *localTz = [NSTimeZone localTimeZone];
    NSTimeInterval diff = [localTz secondsFromGMTForDate: now];
    now = [now dateByAddingTimeInterval:diff];
    for(NSDictionary *dic in upcomming){
        NSDate * date = dic[@"time"];
        if([[now laterDate:date] isEqualToDate:now]){
            NSInteger index = [upcomming indexOfObject:dic];
            NSDictionary *newDic = [dic copy];
            [upcomming removeObjectAtIndex:index];
            [cache addObject:newDic];
        }
    }
    [past addObjectsFromArray:cache];
    if([self.delegate respondsToSelector:@selector(updateInfo)]){
        [self.delegate updateInfo];
    }
}

@end
