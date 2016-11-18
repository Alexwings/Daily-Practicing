//
//  SecondViewController.m
//  Day7_Assignment
//
//  Created by Xinyuan Wang on 11/17/16.
//  Copyright © 2016 RJT. All rights reserved.
//
#define FONT_SIZE 20
#import "SecondViewController.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userInputDisplay;
@property (nonatomic)int16_t rowNum;
@property (weak, nonatomic) IBOutlet UIPickerView *fontPicker;

@end

@implementation SecondViewController
@synthesize userInputText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userInputDisplay.text = userInputText;
    self.rowNum = 0;
    self.fontPicker.dataSource = self;
    self.fontPicker.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger ret = 0;
    NSArray *fnames= [UIFont familyNames];
    if(component == 0){
        ret = (long)(fnames.count);
    }else if(component == 1){
        ret = [UIFont fontNamesForFamilyName:[fnames objectAtIndex: self.rowNum]].count;
    }
    return ret;
}
#pragma mark -UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *fname =[UIFont familyNames];
    if(component == 0){
        return [fname objectAtIndex:row];
    }else if (component == 1){
        NSString *familyName = [fname objectAtIndex:self.rowNum];
        NSArray *fonts = [UIFont fontNamesForFamilyName:familyName];
        return [fonts objectAtIndex:row];
    }
    return nil;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSArray *fNames = [UIFont familyNames];
    NSArray *fonts = [UIFont fontNamesForFamilyName:[fNames objectAtIndex:self.rowNum]];
    if(component == 0){
        self.rowNum = row;
        self.userInputDisplay.font = [UIFont fontWithName:[fNames objectAtIndex:self.rowNum] size:FONT_SIZE];
        [pickerView reloadComponent:1];
    }else if(component == 1){
        if(fonts.count != 0){
            self.userInputDisplay.font = [UIFont fontWithName:[fonts objectAtIndex:row] size:FONT_SIZE];
        }else {
            self.userInputDisplay.font = [UIFont fontWithName:[fNames objectAtIndex:self.rowNum] size: FONT_SIZE];
        }
    }
}

@end
