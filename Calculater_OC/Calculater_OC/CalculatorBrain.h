//
//  CalculatorBrain.h
//  Calculater_OC
//
//  Created by Xinyuan Wang on 11/18/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#ifndef CalculatorBrain_h
#define CalculatorBrain_h


#endif /* CalculatorBrain_h */
#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (nonatomic, readonly, getter=getResult)double result;
- (instancetype)init;

-(void)setOprand:(double)oprand;
-(void)performOperation: (NSString *)symbol;


@end
