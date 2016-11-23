//
//  TextViewController.m
//  ImageGellary
//
//  Created by Xinyuan Wang on 11/23/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic)UIImagePickerController *picker;

- (IBAction)clickToSave:(UIButton *)sender;

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.saveButton.enabled = self.textField.text.length == 0 ? NO:YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickToSave:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(recevieImageName:)]){
        [self.delegate recevieImageName:self.textField.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
