//
//  Util.m
//  PersonInfo
//
//  Created by Xinyuan Wang on 11/29/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "Util.h"
#import "Person.h"

@implementation Util

+(NSURL *)getDocumentsDirURL{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *docUrl = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *url = [docUrl URLByAppendingPathComponent:@"people" isDirectory:YES];
    if (![url checkResourceIsReachableAndReturnError:nil]){
        [fm createDirectoryAtURL:url withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return url;
}

+(void)sortPeopleByAge:(NSMutableArray *)people{
    [people sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Person *p1 = (Person *)obj1;
        Person *p2 = (Person *)obj2;
        if(p1.age > p2.age){
            return NSOrderedDescending;
        }else if(p1.age < p2.age){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

+(BOOL)removeFileAtURL:(NSURL *)url{
    return [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
}

@end
