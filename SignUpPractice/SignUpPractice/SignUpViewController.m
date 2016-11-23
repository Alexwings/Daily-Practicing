//
//  ViewController.m
//  SignUpPractice
//
//  Created by Xinyuan Wang on 11/21/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "SignUpViewController.h"
#import "InfoViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameDisplay;
@property (weak, nonatomic) IBOutlet UILabel *userIDDisplay;
@property (weak, nonatomic) IBOutlet UILabel *userEmailDisplay;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Sign Up";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ClicktoSignUP {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoViewController *view = [main instantiateViewControllerWithIdentifier:@"InfoViewController"];
    view.delegate = self;
    [self.navigationController pushViewController:view animated:YES];
    
}

#pragma mark - InfoViewControllerDelegate

- (void)didVarifyInfoAndSend:(id)sender{
    NSMutableDictionary * dic = (NSMutableDictionary *)sender;
    if (dic.count != 0){
        self.usernameDisplay.text = dic[@"username"];
        self.userIDDisplay.text = dic[@"userID"];
        self.userEmailDisplay.text = dic[@"email"];
        self.signUpButton.hidden = true;
    }
}

@end
