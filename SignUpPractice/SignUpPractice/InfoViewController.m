//
//  InfoViewController.m
//  SignUpPractice
//
//  Created by Xinyuan Wang on 11/21/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "InfoViewController.h"
#import "SignUpViewController.h"

#define USERNAME @"username";
#define USERID @"userID";
#define PWD @"password";
#define EMAIL @"email";
#define CPWD @"conPassword";

@interface InfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *userIDText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmText;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic)BOOL isVarified;

@end

@implementation InfoViewController

BOOL nameVerify = false, idVerify = false, emailVerify = false, passwordVerify = false, confirmVerify = false;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.personalInfo = [[NSMutableDictionary alloc] init];
    self.isVarified = false;
    self.title = @"Self Information";
    self.usernameText.placeholder = @"username";
    self.usernameText.clearButtonMode = YES;
    self.usernameText.delegate = self;
    self.userIDText.placeholder = @"User ID";
    self.userIDText.clearButtonMode = YES;
    self.userIDText.delegate = self;
    self.emailText.placeholder = @"email@email";
    self.emailText.clearButtonMode = YES;
    self.emailText.delegate = self;
    self.emailText.keyboardType = UIKeyboardTypeEmailAddress;
    self.passwordText.secureTextEntry = YES;
    self.passwordText.clearButtonMode = YES;
    self.passwordText.delegate = self;
    self.confirmText.secureTextEntry = YES;
    self.confirmText.clearButtonMode = YES;
    self.confirmText.delegate = self;
    self.submitButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitToView {
    if([self.delegate respondsToSelector:@selector(didVarifyInfoAndSend:)]){
        [self.delegate didVarifyInfoAndSend:self.personalInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.submitButton.enabled = false;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString * str = textField.restorationIdentifier;
    if ([str isEqualToString:@"username"]) {
        
        nameVerify = [self usernameCheck: textField.text];
        if(nameVerify){
            self.personalInfo[@"username"] = self.usernameText.text;
        }
    } else if([str isEqualToString:@"userID"]){
        idVerify = [self userIdCheck: textField.text ];
         if(idVerify){
            self.personalInfo[@"userID"] = self.userIDText.text;
        }
    }else if([str isEqualToString:@"email"]){
        emailVerify = [self userEmailCheck: textField.text ];
         if(emailVerify){
            self.personalInfo[@"email"] = self.emailText.text;
        }
    }else if([str isEqualToString:@"password"]){
        passwordVerify = [self userPWDCheck: textField.text];
         if(passwordVerify){
            self.personalInfo[@"password"] = self.passwordText.text;
        }
    }else if([str isEqualToString:@"conPassword"]){
        confirmVerify = [self confirmCheck:textField.text];
    }
    self.isVarified = nameVerify && idVerify && emailVerify && passwordVerify && confirmVerify;
    return YES;
}

-(BOOL)usernameCheck: (NSString *)str{
    return (str.length > 5 && str.length <20);
}

-(BOOL)userIdCheck: (NSString *)str{
    return (str.length > 5 && str.length < 20);
}

-(BOOL)userEmailCheck: (NSString *)str{
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z_\\.0-9]+@[a-zA-Z0-9]+\\.[a-zA-Z]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger match = [regex numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    return match == 0 ? NO : (match == 1) ? true : false;
}

-(BOOL)userPWDCheck: (NSString *)str{
    return (str.length > 6 && str.length < 13);
}

-(BOOL)confirmCheck: (NSString *)str{
    return [(NSString *)self.personalInfo[@"password"] isEqualToString:str];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.isVarified){
        self.submitButton.enabled = YES;
    }else {
        self.submitButton.enabled = NO;
    }
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"%d", self.isVarified);
    if(self.isVarified){
        self.submitButton.enabled = YES;
    }else {
        self.submitButton.enabled = NO;
    }
    [textField resignFirstResponder];
    return YES;
}
@end
