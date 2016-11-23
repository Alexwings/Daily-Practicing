//
//  ViewController.h
//  ImageGellary
//
//  Created by Xinyuan Wang on 11/22/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextViewController.h"

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerRestoration, SaveImageNameDelegate>

@property (strong, nonatomic)NSString *filename;


@end

