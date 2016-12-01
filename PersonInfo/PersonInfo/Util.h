//
//  Util.h
//  PersonInfo
//
//  Created by Xinyuan Wang on 11/29/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+(NSURL *)getDocumentsDirURL;
+(void)sortPeopleByAge:(NSMutableArray *)people;
+(BOOL)removeFileAtURL:(NSURL *) url;

@end
