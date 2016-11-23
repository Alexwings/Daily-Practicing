//
//  CalculatorBrain.m
//  Calculater_OC
//
//  Created by Xinyuan Wang on 11/18/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "CalculatorBrain.h"

typedef NS_ENUM(NSInteger, OperationType){
    UnaryOperation = 0,
    BinaryOperation,
    Equal,
    Clear
};

@interface CalculatorBrain ()


@property (nonatomic)double accumulator;
@property (nonatomic, strong)NSDictionary *operations;
@property (nonatomic, strong)NSDictionary *opTypes;
@property (nonatomic)double firstOprand;
@property (copy)double (^bAct)(double op1, double op2);

-(void)clear;
@end

@implementation CalculatorBrain

@synthesize result = _result;

-(double)getResult{
    return self.accumulator;
}
-(instancetype)init{
    if(self = [super init]){
        self.operations = @{
                            @"√": [^(double op){return sqrt(op);} copy],
                            @"+/-": [^(double op){return -(op);} copy],
                            @"+": [^(double op1, double op2){return op1+op2;} copy],
                            @"-": [^(double op1, double op2){return op1-op2;} copy],
                            @"×": [^(double op1, double op2){return op1*op2;} copy],
                            @"÷": [^(double op1, double op2){return op1/op2;} copy],
                            @"%": [^(double op1){return op1 / 100;}copy],
                            };
        self.opTypes = @{
                         @"√": [NSNumber numberWithInteger:UnaryOperation],
                         @"+/-": [NSNumber numberWithInteger:UnaryOperation],
                         @"+": [NSNumber numberWithInteger:BinaryOperation],
                         @"-": [NSNumber numberWithInteger:BinaryOperation],
                         @"×": [NSNumber numberWithInteger:BinaryOperation],
                         @"÷": [NSNumber numberWithInteger:BinaryOperation],
                         @"%": [NSNumber numberWithInteger:UnaryOperation],
                         @"=" : [NSNumber numberWithInteger:Equal],
                         @"AC" : [NSNumber numberWithInteger:Clear]
                         };
        self.bAct = nil;
    }
    return self;
}
-(void)setOprand:(double)oprand{
    self.accumulator = oprand;
}

-(void)performOperation:(NSString *)symbol{
    NSNumber *type = (NSNumber *)self.opTypes[symbol];
    double (^uAction)(double op);
    double (^bAction)(double op1, double po2);
    switch (type.longValue){
        case UnaryOperation:
            uAction = self.operations[symbol];
            self.accumulator = uAction(self.accumulator);
            break;
        case BinaryOperation:
            bAction = self.operations[symbol];
            if(self.bAct != nil){
                self.accumulator = self.bAct(self.firstOprand, self.accumulator);
            }
            self.bAct = bAction;
            self.firstOprand = self.accumulator;
            break;
        case Equal:
            if(self.bAct != nil){
                self.accumulator = self.bAct(self.firstOprand, self.accumulator);
                self.bAct = 0;
                self.firstOprand = 0;
            }
            break;
        case Clear:
            [self clear];
            break;
    }
}

-(void)clear{
    self.accumulator = 0;
    self.firstOprand = 0;
    self.bAct = nil;
}
@end

