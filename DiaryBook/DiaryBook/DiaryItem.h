//
//  DiaryItem.h
//  DiaryBook
//
//  Created by Xinyuan Wang on 11/30/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiaryItem : NSObject

@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *content;

-(instancetype)initWithTitle:(NSString *)title andContent: (NSString *)content;

@end
