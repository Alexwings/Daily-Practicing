//
//  ReminderManager.h
//  Reminder
//
//  Created by Xinyuan Wang on 12/5/16.
//  Copyright © 2016 Private. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UpdateInfoDelegate<NSObject>

-(void)updateInfo;

@end

@interface ReminderManager : NSObject

@property(nonatomic, readonly)NSMutableArray *pastReminders;
@property(nonatomic, readonly)NSMutableArray *upcommingReminders;
@property(weak, nonatomic)id<UpdateInfoDelegate> delegate;

+(instancetype)sharedManager;

//GET
-(void)loadAllReminders;

-(NSDictionary *)getReminderForTitle:(NSString *)title isPast: (BOOL)isPast;
//POST
-(void)saveAllReminders;

-(void)saveReminder: (NSDictionary *)reminder isPast: (BOOL) isPast;

//PUT
-(void)updateReminder: (NSDictionary *)reminder forTitle:(NSString *)title isPast: (BOOL)isPast;

//DELETE
-(void)removeAllForState:(BOOL)isPast;

-(void)removeReminderAtIndex:(NSInteger)index isPast:(BOOL)isPast;

-(void)refreshData;
@end
