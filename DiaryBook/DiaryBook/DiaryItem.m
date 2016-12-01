//
//  DiaryItem.m
//  DiaryBook
//
//  Created by Xinyuan Wang on 11/30/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "DiaryItem.h"

@implementation DiaryItem

-(instancetype)initWithTitle:(NSString *)title andContent:(NSString *)content{
    if(self = [super init]){
        self.title = title;
        self.content = content;
    }
    return self;
}

@end
