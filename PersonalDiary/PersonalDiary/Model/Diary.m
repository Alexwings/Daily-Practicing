//
//  Diary.m
//  PersonalDiary
//
//  Created by Xinyuan Wang on 11/24/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "Diary.h"
#define keyForTitle     @"diaryTitle"
#define keyForContent   @"diaryContent"
#define keyForDate      @"diaryDate"
#define keyForPath      @"diaryPath"

@implementation Diary
@synthesize title, content, date;
-(instancetype)initWithTile:(NSString *)t Content:(NSString *)c onDate:(NSString *)d inPath: p{
    if(self = [super init]){
        self.title =t;
        self.content = c;
        self.date = d;
        self.path = p;
    }
    return self;
}

#pragma mark - NSCoding
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    NSString *t =[aDecoder decodeObjectForKey:keyForTitle];
    NSString *c = [aDecoder decodeObjectForKey:keyForContent];
    NSString *d = [aDecoder decodeObjectForKey:keyForDate];
    NSString *p = [aDecoder decodeObjectForKey:keyForPath];
    return [self initWithTile:t Content:c onDate:d inPath: p];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:keyForTitle];
    [aCoder encodeObject:self.content forKey:keyForContent];
    [aCoder encodeObject:self.date forKey:keyForDate];
    [aCoder encodeObject:self.path forKey:keyForPath];
}
@end
