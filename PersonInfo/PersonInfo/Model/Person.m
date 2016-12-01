//
//  Person.m
//  PersonInfo
//
//  Created by Xinyuan Wang on 11/23/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "Person.h"

@implementation Person

NSString *KeyForFirst = @"firstName";
NSString *KeyForLast = @"lastName";
NSString *KeyForAge = @"age";

@synthesize firstName, lastName, age;

-(instancetype)initWithFirstName: (NSString *)firstname LastName: (NSString *)lastname Age: (int) a{
    self = [super init];
    if(self) {
        self.firstName = firstname;
        self.lastName = lastname;
        self.age = a;
    }
    return self;
}
#pragma mark -NSCoding
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    NSString *first = [aDecoder decodeObjectForKey:KeyForFirst];
    NSString *last = [aDecoder decodeObjectForKey:KeyForLast];
    int a = [aDecoder decodeIntForKey:KeyForAge];
    return [self initWithFirstName:first LastName:last Age:a];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.firstName forKey:KeyForFirst];
    [aCoder encodeObject:self.lastName forKey:KeyForLast];
    [aCoder encodeInt:self.age forKey:KeyForAge];
}

@end
