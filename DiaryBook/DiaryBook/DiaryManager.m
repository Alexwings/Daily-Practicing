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
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/diaries"];
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
    NSInteger index = [self.diaryList indexOfObject:diary];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docPath =[DiaryManager getDocumentDir];
    NSLog(@"%@", docPath);
    [fm removeItemAtPath:[docPath stringByAppendingPathComponent:filename] error:nil];
    diary.filename = newFilename;
    [diary.content writeToFile:[[DiaryManager getDocumentDir] stringByAppendingPathComponent:diary.filename] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self.diaryList replaceObjectAtIndex:index withObject:diary];
    if([self.delegate respondsToSelector:@selector(infoUpdated)]){
        [self.delegate infoUpdated];
    }
}

-(void)loadDataFromDisk{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = [fm contentsOfDirectoryAtPath:[DiaryManager getDocumentDir] error:nil];
    for(NSString *p in paths){
        NSString *docPath = [[DiaryManager getDocumentDir] stringByAppendingPathComponent:p];
        NSString *title = [[p componentsSeparatedByString:@"-->"] firstObject];
        NSString *content = [NSString stringWithContentsOfFile:docPath encoding:NSUTF8StringEncoding error:nil];
        DiaryItem *item = [[DiaryItem alloc] initWithTitle:title andContent:content];
        item.filename = p;
        [self.diaryList addObject:item];
    }
}

-(DiaryItem *)getDiaryFromDisk:(NSString *)filename{
    for(DiaryItem *item in self.diaryList){
        if([item.filename isEqualToString: filename]){
            return item;
        }
    }
    return nil;
}

-(void)saveDataOnDisk:(DiaryItem *)diary{
    NSDateFormatter *dm = [[NSDateFormatter alloc] init];
    dm.dateFormat = @"MM-dd-yyyy";
    NSString *date = [dm stringFromDate:[NSDate date]];
    NSString *filename = [NSString stringWithFormat:@"%@-->%@.txt", diary.title, date];
    diary.filename = filename;
    [diary.content writeToFile:[[DiaryManager getDocumentDir] stringByAppendingPathComponent:filename] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self.diaryList addObject:diary];
    if([self.delegate respondsToSelector:@selector(infoUpdated)]){
        [self.delegate infoUpdated];
    }
}

@end
