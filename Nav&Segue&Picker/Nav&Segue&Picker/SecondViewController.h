//
//  SecondViewController.h
//  Day7_Assignment
//
//  Created by Xinyuan Wang on 11/17/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong)NSString * userInputText;
@end
