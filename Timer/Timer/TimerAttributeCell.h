//
//  TimerAttributeCell.h
//  Timer
//
//  Created by Xinyuan Wang on 12/3/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerAttributeCell : UITableViewCell<UITextFieldDelegate>
    @property (weak, nonatomic) IBOutlet UITextField *attriInput;
    @property (weak, nonatomic) IBOutlet UILabel *attriTitle;

@end
