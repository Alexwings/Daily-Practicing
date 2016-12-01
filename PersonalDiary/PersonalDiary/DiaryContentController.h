//
//  DiaryContentControllerViewController.h
//  PersonalDiary
//
//  Created by Xinyuan Wang on 11/25/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"

@interface DiaryContentController : UIViewController<UITextViewDelegate, UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong)Diary *curDiary;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)UITapGestureRecognizer *gr;

@end
