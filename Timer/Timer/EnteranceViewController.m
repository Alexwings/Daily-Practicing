//
//  EnteranceViewController.m
//  Timer
//
//  Created by Xinyuan Wang on 12/3/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "EnteranceViewController.h"

#define isFirstUserKey

@interface EnteranceViewController ()
    @property (weak, nonatomic) IBOutlet UIButton *createNewButton;
    
    //testing
    @property (weak, nonatomic) IBOutlet UITextField *inputText;
    @property (weak, nonatomic) IBOutlet UILabel *label;
    @property (nonatomic)NSInteger count;
    
    @end

@implementation EnteranceViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Simple Timer";
    
}
- (IBAction)createButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"newTimerSegue" sender:sender];
}
    
#pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
    
    
    @end
