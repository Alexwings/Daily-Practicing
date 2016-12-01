//
//  Utils.h
//  PersonalDiary
//
//  Created by Xinyuan Wang on 11/29/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Diary.h"

@protocol ModelDelegate <NSObject>

-(void)informationUpdated;

@end

@interface Utils : NSObject
@property (strong, nonatomic)NSMutableArray *diaryBook;
@property (strong, nonatomic)NSMutableArray *classifiedDiaryBook;
@property (strong, nonatomic)id<ModelDelegate>delegate;

-(instancetype)init;

+(instancetype)defaultUtil;

-(void)saveDiaryAndUpdate:(Diary *)diary section: (NSInteger)section row: (NSInteger)row;

-(BOOL)saveDiaryToLocal:(Diary *)diary forKey: (NSString *)key;

-(void)loadDiaryBookForKey: (NSString *)key;

-(BOOL)removeDiaryFromLocal:(NSString *)path;

-(NSString *)getDocumentDir;

-(void)sortDiaryByDate:(NSMutableArray *)diaryBook;

-(NSString *)dateToString: (NSDate *)date;

-(NSDate *)stringToDate: (NSString *)date;

-(NSMutableArray *)classifyDiaryForSortedDiaryBookByYear;

-(NSString *)yearForDate: (NSDate *)date;

@end
