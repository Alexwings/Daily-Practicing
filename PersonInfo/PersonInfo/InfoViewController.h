//
//  InfoViewController.h
//  PersonInfo
//
//  Created by Xinyuan Wang on 11/23/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@protocol SendPersonInfoDelegate <NSObject>

-(void)sendPersonInfo: (Person *)person atIndex: (int) index;

@end

@interface InfoViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic)id <SendPersonInfoDelegate> delegate;
@property (strong, nonatomic)Person *person;
@property (nonatomic)int index;

@end
