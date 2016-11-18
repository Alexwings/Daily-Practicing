//
//  ViewController.m
//  Day_6_Assignment
//
//  Created by Xinyuan Wang on 11/16/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic)UILabel *stepperPresentLabel;
@property (nonatomic)UISwitch *switcher;
@property (nonatomic)UIStepper *myStepper;

-(void)enableStepper;
-(void)clickStepper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.stepperPresentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 50)];
    self.stepperPresentLabel.text = @"0.0";
    self.stepperPresentLabel.textColor = [UIColor blackColor];
    self.stepperPresentLabel.textAlignment = NSTextAlignmentCenter;
    self.stepperPresentLabel.backgroundColor = [UIColor redColor];
    self.stepperPresentLabel.userInteractionEnabled = true;
    self.switcher = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 80, 50, 50)];
    self.switcher.on = true;
    [self.switcher addTarget:self action:@selector(enableStepper) forControlEvents:UIControlEventValueChanged];
    self.myStepper = [[UIStepper alloc] initWithFrame:CGRectMake(0, 80, 80, 80)];
    self.myStepper.maximumValue = 10;
    self.myStepper.minimumValue = -10;
    self.myStepper.wraps = false;
    [self.myStepper addTarget:self action:@selector(clickStepper) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.stepperPresentLabel];
    [self.view addSubview:self.switcher];
    [self.view addSubview:self.myStepper];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)enableStepper{
    self.stepperPresentLabel.text = [NSString stringWithFormat:@"%.1f",self.myStepper.value];
    self.myStepper.enabled = self.switcher.on;
}

-(void)clickStepper{
    self.stepperPresentLabel.text = [NSString stringWithFormat:@"%.1f", self.myStepper.value];
    if (self.myStepper.value >= self.myStepper.maximumValue || self.myStepper.value <= self.myStepper.minimumValue){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Caution!!!" message: @"Current value is out of the allowed boundry"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            self.stepperPresentLabel.text = @"0.0";
            self.myStepper.value = 0.0;
            self.switcher.on = false;
            self.myStepper.enabled = false;
        }];
        UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:^(){}];
        }];
        [alert addAction:alertAction];
        [alert addAction: alertCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
