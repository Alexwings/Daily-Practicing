//
//  DiaryManager.m
//  DiaryBook
//
//  Created by Xinyuan Wang on 11/30/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "DiaryManager.h"

@implementation DiaryManager

-(instancetype)init{
    if(self = [super init]){
        self.diaryList = [[NSMutableArray alloc] init];
    }
    return self;
}

+(instancetype)sharedManager{
    static id diaryManagerInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        diaryManagerInstance = [[DiaryManager alloc] init];
    });
    return diaryManagerInstance;
}

+(NSString *)getDocumentDir{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"diaries"];
    NSLog(@"%@", docPath);
    BOOL isDir;
    [fm fileExistsAtPath:docPath isDirectory:&isDir];
    if(!isDir){
        [fm createDirectoryAtPath:docPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return docPath;
}

-(void)updateDataOnDisk:(DiaryItem *)diary forFile:(NSString *)filename{
    NSString *suffixDate = [[filename componentsSeparatedByString:@"-->"] lastObject];
    NSString *newFilename = [NSString stringWithFormat:@"%@-->%@", diary.title, suffixDate];
    NSInteger index = [self.diaryList indexOfObject:filename];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docPath =[DiaryManager getDocumentDir];
    [fm removeItemAtPath:[docPath stringByAppendingPathComponent:filename] error:nil];
    [self.diaryList replaceObjectAtIndex:index withObject:newFilename];
    [diary.content writeToFile:[docPath stringByAppendingPathComponent:newFilename] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if([self.delegate respondsToSelector:@selector(infoUpdated)]){
        [self.delegate infoUpdated];
    }
}

-(void)loadDataFromDisk{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = [fm contentsOfDirectoryAtPath:[DiaryManager getDocumentDir] error:nil];
    self.diaryList = [paths mutableCopy];
    [self.diaryList removeObjectAtIndex:0];
    [self.diaryList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *f1 = obj1;
        NSString *f2 = obj2;
        NSString *ds1 = [[[[f1 componentsSeparatedByString:@"-->"] lastObject] componentsSeparatedByString:@"."] firstObject];
        NSString *ds2 = [[[[f2 componentsSeparatedByString:@"-->"] lastObject] componentsSeparatedByString:@"."] firstObject];
        NSDateFormatter *dm = [[NSDateFormatter alloc]init];
        dm.dateFormat = @"MM-dd-yyyy";
        NSDate *d1 = [dm dateFromString:ds1];
        NSDate *d2 = [dm dateFromString:ds2];
        return [d1 compare:d2];
    }];
}

-(DiaryItem *)getDiaryFromDisk:(NSString *)filename{
    NSString *filepath = [[DiaryManager getDocumentDir] stringByAppendingPathComponent:filename];
    if([[NSFileManager defaultManager] fileExistsAtPath:filepath]){
        DiaryItem *d = [[DiaryItem alloc] initWithTitle:[[filename componentsSeparatedByString:@"-->"] firstObject] andContent:[NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil]];
        return d;
    }
    return nil;
}

-(void)saveDataOnDisk:(DiaryItem *)diary{
    NSDateFormatter *dm = [[NSDateFormatter alloc] init];
    dm.dateFormat = @"MM-dd-yyyy";
    NSString *date = [dm stringFromDate:[NSDate date]];
    NSString *filename = [NSString stringWithFormat:@"%@-->%@.txt", diary.title, date];
    NSString *path = [[DiaryManager getDocumentDir] stringByAppendingPathComponent:filename];
    [diary.content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self.diaryList addObject:filename];
    if([self.delegate respondsToSelector:@selector(infoUpdated)]){
        [self.delegate infoUpdated];
    }
}

@end
