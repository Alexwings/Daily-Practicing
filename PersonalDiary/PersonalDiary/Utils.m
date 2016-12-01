//
//  Utils.m
//  PersonalDiary
//
//  Created by Xinyuan Wang on 11/29/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "Utils.h"
#define keyForDiary @"Diary"

@implementation Utils

-(instancetype)init{
    if(self = [super init]){
        self.diaryBook = [[NSMutableArray alloc] init];
        self.classifiedDiaryBook = [[NSMutableArray alloc] init];
    }
    return self;
}

+(instancetype)defaultUtil{
    static id defaultUtilInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUtilInstance = [[self alloc] init];
    });
    return defaultUtilInstance;
}

-(void)saveDiaryAndUpdate:(Diary *)diary section:(NSInteger)section row:(NSInteger)row{
    if(section == -1 || row == -1){
        [self.diaryBook addObject:diary];
        self.classifiedDiaryBook = [self classifyDiaryForSortedDiaryBookByYear];
    }else{
        Diary *oldDiary = (Diary *)self.classifiedDiaryBook[section][row];
        if([self removeDiaryFromLocal:oldDiary.path]){
            NSInteger i = [self.diaryBook indexOfObject:oldDiary];
            [self.diaryBook replaceObjectAtIndex:i withObject:diary];
            [self.classifiedDiaryBook[section] replaceObjectAtIndex:row withObject:diary];
        }
    }
    if([self saveDiaryToLocal:diary forKey:keyForDiary]){;
        [self.delegate informationUpdated];
    }else{
        NSLog(@"diary failed to save!");
    }
}

-(NSMutableArray *)classifyDiaryForSortedDiaryBookByYear{
    NSMutableDictionary *YearToIndex = [[NSMutableDictionary alloc] init];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for(Diary *d in self.diaryBook){
        NSDate *date = [self stringToDate:d.date];
        NSString *year = [self yearForDate: date];
        if(!YearToIndex[year]){
            YearToIndex[year] = [NSNumber numberWithUnsignedInteger:ret.count];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [ret addObject:array];
        }
        int index = [YearToIndex[year] intValue];
        [ret[index] addObject:d];
    }
    return ret;
}

-(NSString *)yearForDate: (NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger year = [calendar component:NSCalendarUnitYear fromDate:date];
    return [NSString stringWithFormat:@"%lu", year];
}

-(BOOL)saveDiaryToLocal:(Diary *)diary forKey:(NSString *)key{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:diary forKey:key];
    [archiver finishEncoding];
    return [data writeToFile: diary.path atomically:YES];
}

-(void)loadDiaryBookForKey:(NSString *)key{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString * docPath = [self getDocumentDir];
    NSArray *paths = [fm contentsOfDirectoryAtPath:docPath error:nil];
    for(NSString *path in paths){
        NSString *fullPath = [docPath stringByAppendingPathComponent:path];
        Diary *diary = [self loadDiaryFromLocal:fullPath forKey:key];
        diary.path = fullPath;
        [self.diaryBook addObject:diary];
    }
    [self sortDiaryByDate:self.diaryBook];
}

-(Diary *)loadDiaryFromLocal:(NSString *)path forKey:(NSString *)key{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    Diary *d = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    return d;
}

-(BOOL)removeDiaryFromLocal:(NSString *)path{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

-(NSString *)getDocumentDir{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"diaries/"];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory;
    [fm fileExistsAtPath:path isDirectory:&isDirectory];
    if(isDirectory){
        [fm createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return path;
}

-(void)sortDiaryByDate:(NSMutableArray *)diaryBook{
    [diaryBook sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Diary *p1 = (Diary *)obj1;
        Diary *p2 = (Diary *)obj2;
        NSDate *d1 = [self stringToDate:p1.date];
        NSDate *d2 = [self stringToDate:p2.date];
        return [d1 compare:d2];
    }];
}

-(NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"MM-dd-yyyy";
    return [dateFormater stringFromDate:date];
}

-(NSDate *)stringToDate:(NSString *)date{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"MM-dd-yyyy";
    return [dateFormater dateFromString:date];
}
@end
