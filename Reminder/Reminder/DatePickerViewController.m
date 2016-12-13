//
//  DatePickerViewController.m
//  Reminder
//
//  Created by Xinyuan Wang on 12/6/16.
//  Copyright © 2016 Private. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.doneButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.doneButton.layer.borderWidth = 0.2;
    self.datePicker.minimumDate = [NSDate date];
    self.view.opaque = false;
    self.view.alpha = 0.5;
}
- (IBAction)doneButtonClicked:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(transferData:)]){
        [self.delegate transferData:self.datePicker.date];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
