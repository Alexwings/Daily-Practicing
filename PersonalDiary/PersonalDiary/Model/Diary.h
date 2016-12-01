//
//  Diary.h
//  PersonalDiary
//
//  Created by Xinyuan Wang on 11/24/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Diary : NSObject<NSCoding>
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *content;
@property (strong, nonatomic)NSString *date;
@property (strong, nonatomic)NSString *path;

-(instancetype)initWithTile:(NSString *)title Content: (NSString *)content onDate: (NSString *)date inPath: (NSString *)p;
@end
