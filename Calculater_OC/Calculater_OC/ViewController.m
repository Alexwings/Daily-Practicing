//
//  ViewController.m
//  Calculater_OC
//
//  Created by Xinyuan Wang on 11/18/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *displayData;
@property (nonatomic)BOOL inTheMiddleOfType;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic)double displayDouble;
@end

@implementation ViewController

@synthesize displayDouble = _displayDouble;

-(double)displayDouble{
    return [self.displayData.text doubleValue];
}

-(void)setDisplayDouble:(double)displayDouble{
    self.displayData.text = [NSString stringWithFormat:@"%g", displayDouble];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.inTheMiddleOfType = NO;
    self.brain = [[CalculatorBrain alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action methods
- (IBAction)touchButton:(UIButton *)sender {
    NSString *value = sender.currentTitle;
    NSString *currentDisplay = self.displayData.text;
    BOOL canHaveDismal = ![currentDisplay containsString:@"."];
    BOOL isDismal = [value isEqualToString:@"."];
    if(self.inTheMiddleOfType){
        if(!isDismal || canHaveDismal){
            self.displayData.text = [currentDisplay stringByAppendingString:value];
        }
    }else if(isDismal){
        if(self.displayData != 0){
            self.displayData.text = [[[NSString alloc] initWithFormat:@"%d", 0] stringByAppendingString:value];
        }else {
            self.displayData.text = [currentDisplay stringByAppendingString:value];
        }
        self.inTheMiddleOfType = YES;
    }else {
        self.displayData.text = value;
        self.inTheMiddleOfType = [self.displayData.text doubleValue] != 0;
    }
}
- (IBAction)performOperation:(UIButton *)sender {
    NSString *operation = sender.currentTitle;
    double displayedValue = [self.displayData.text doubleValue];
    self.inTheMiddleOfType = NO;
    [self.brain setOprand: displayedValue];
    [self.brain performOperation:operation];
    self.displayDouble = [self.brain getResult];
    
}

@end
