//
//  Person.h
//  PersonInfo
//
//  Created by Xinyuan Wang on 11/23/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject <NSCoding>

extern NSString *KeyForFirst;
extern NSString *KeyForLast;
extern NSString *KeyForAge;

@property (strong, nonatomic)NSString *firstName;
@property (strong, nonatomic)NSString *lastName;
@property (nonatomic)int age;
@property (nonatomic,strong)NSURL *path;

-(instancetype)initWithFirstName: (NSString *)firstname LastName: (NSString *)lastname Age: (int) a;

@end
