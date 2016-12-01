//
//  DiaryManager.h
//  DiaryBook
//
//  Created by Xinyuan Wang on 11/30/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiaryItem.h"

@protocol InformationUpdatedDelegate <NSObject>

-(void)infoUpdated;

@end

@interface DiaryManager : NSObject

@property (strong, nonatomic)NSMutableArray * diaryList;
@property (weak, nonatomic)id<InformationUpdatedDelegate> delegate;

-(instancetype)init;

+(instancetype)sharedManager;

+(NSString *)getDocumentDir;

-(void)updateDataOnDisk:(DiaryItem *)diary forFile:(NSString *)filename;

-(void)loadDataFromDisk;

-(DiaryItem *)getDiaryFromDisk:(NSString *) filename;

-(void)saveDataOnDisk: (DiaryItem *)diary;

@end
