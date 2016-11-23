//
//  InfoViewController.h
//  SignUpPractice
//
//  Created by Xinyuan Wang on 11/21/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewControllerDelegate.h"

@interface InfoViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, weak) id <InfoViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *personalInfo;

@end
