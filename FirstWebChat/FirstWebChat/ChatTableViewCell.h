//
//  ChatTableViewCell.h
//  FirstWebChat
//
//  Created by Xinyuan Wang on 12/11/16.
//  Copyright © 2016 AlexW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell

@property(nonatomic, strong)UILabel *messageLabel;

@property(nonatomic, strong)UIImageView *bubbleView;
@property(nonatomic)BOOL isSender;

@end
