//
//  ChatTableViewCell.m
//  FirstWebChat
//
//  Created by Xinyuan Wang on 12/11/16.
//  Copyright © 2016 AlexW. All rights reserved.
//

#import "ChatTableViewCell.h"
static CGFloat textMarginH = 12.0f;
static CGFloat textMarginV = 2.0f;

@implementation ChatTableViewCell

@synthesize isSender;

-(void)updateBubble{
    if(isSender){
        self.bubbleView.image = [[UIImage imageNamed:@"balloon_read_right"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 12.0f, 12.0f) resizingMode:UIImageResizingModeStretch];
    }else{
        self.bubbleView.image = [[UIImage imageNamed:@"balloon_read_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(12.0f, 12.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.messageLabel.numberOfLines = 0;
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.messageLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self updateBubble];
    [self updateBackgound];
}

-(void)updateBackgound{
    CGFloat contentWidth = self.contentView.frame.size.width;
    CGSize textSize = [self.messageLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.messageLabel.font} context:nil].size;
    if(!isSender){
        self.bubbleView.frame = CGRectMake(5.0f, 5.0f, textSize.width + 2*textMarginH, textSize.height + 4*textMarginV);
        self.messageLabel.frame = CGRectMake(5.0f +textMarginH, 5.0f+textMarginV, textSize.width, textSize.height);
    }else{
        self.bubbleView.frame = CGRectMake(contentWidth - (textSize.width + 2 * textMarginH)-5.0f, 5.0f, textSize.width + 2*textMarginH, textSize.height + 4*textMarginV);
        self.messageLabel.frame = CGRectMake(contentWidth - textMarginH-textSize.width, textMarginV+ 5.0f, textSize.width, textSize.height);
    }
}

@end
