//
//  TimerAttributeCell.m
//  Timer
//
//  Created by Xinyuan Wang on 12/3/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "TimerAttributeCell.h"

@implementation TimerAttributeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
