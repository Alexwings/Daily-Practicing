//
//  InfoViewController.m
//  PersonInfo
//
//  Created by Xinyuan Wang on 11/23/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@property (strong, nonatomic)UITapGestureRecognizer *gestureRec;
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.gestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.gestureRec.delegate = self;
    self.gestureRec.enabled = NO;
    [self.view addGestureRecognizer:self.gestureRec];
    self.title = @"Person";
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.age.delegate = self;
    if(self.person){
        self.firstName.text = self.person.firstName;
        self.lastName.text = self.person.lastName;
        self.age.text = [NSString stringWithFormat:@"%d", self.person.age];
    }
    if(self.firstName.text.length == 0 || self.lastName.text.length == 0 || self.age.text.length == 0){
        self.updateButton.enabled = NO;
    }
}


- (void)handleGesture:(UIGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateEnded){
        CGPoint p = [sender locationInView:self.view];
        if(p.y <= self.view.bounds.size.height){
            if([self.firstName isFirstResponder]){
                [self.firstName resignFirstResponder];
            }else if([self.lastName isFirstResponder]){
                [self.lastName resignFirstResponder];
            }else if([self.age isFirstResponder]){
                [self.age resignFirstResponder];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateInfo {
    if([self.delegate respondsToSelector:@selector(sendPersonInfo:atIndex:)]){
        [self.delegate sendPersonInfo: self.person atIndex:self.index];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyBoradView{
    [self.age resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField isEqual:self.age]){
        int value = [textField.text intValue];
        if(value < 150){
            self.person.age = value;
        }
    }else if([textField isEqual:self.firstName]){
        if(textField.text.length > 1){
            self.person.firstName = textField.text;
        }
    }else if([textField isEqual:self.lastName]){
        if(textField.text.length > 1){
            self.person.lastName = textField.text;
        }
    }
    self.updateButton.enabled =self.firstName.text.length != 0 && self.lastName.text.length != 0 && [self.age.text intValue] != 0;
    self.gestureRec.enabled = NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.gestureRec.enabled = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.gestureRec.enabled = NO;
    [textField resignFirstResponder];
    return YES;
}

@end
