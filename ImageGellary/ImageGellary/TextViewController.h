//
//  TextViewController.h
//  ImageGellary
//
//  Created by Xinyuan Wang on 11/23/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SaveImageNameDelegate <NSObject>

-(void)recevieImageName:(NSString *)name;


@end
@interface TextViewController : UIViewController

@property (weak, nonatomic)id<SaveImageNameDelegate> delegate;

@end
