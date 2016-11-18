//
//  ViewController.m
//  Day7_Assignment
//
//  Created by Xinyuan Wang on 11/17/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userInput;


- (IBAction)clickToNextView:(UIBarButtonItem *)sender;
- (IBAction)changeTextViewState:(UISwitch *)sender;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI Controls
- (IBAction)clickToNextView:(UIBarButtonItem *)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *view = [main instantiateViewControllerWithIdentifier:@"vc_2"];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)changeTextViewState: (UISwitch *) sender {
    self.userInput.enabled = sender.on;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *userInputText = [NSString stringWithString:self.userInput.text];
    if([segue.identifier isEqualToString:@"sts_1"]){
        SecondViewController *controller = (SecondViewController *)segue.destinationViewController;
        controller.userInputText = userInputText;
    }
}

@end
