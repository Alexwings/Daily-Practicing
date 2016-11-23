//
//  ViewController.m
//  ImageGellary
//
//  Created by Xinyuan Wang on 11/22/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "ViewController.h"

#define viewControllerEncoderKey @"imageName"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;



- (IBAction)SelectImageToSave:(UIButton *)sender;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageView.image = [UIImage imageNamed:@"image09.jpg"];
    NSURL *url = [self getDocumentsURL];
    if(self.filename){
        NSURL *fileUrl = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.filename]];
        NSData *data = [NSData dataWithContentsOfURL:fileUrl];
        if(data){
            self.imageView.image = [UIImage imageWithData:data];
        }
    }
}

-(NSURL *)getDocumentsURL{
    NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    url = [url URLByAppendingPathComponent:@"Images" isDirectory:YES];
    if(![url checkResourceIsReachableAndReturnError:nil]){
        [[NSFileManager defaultManager] createDirectoryAtURL:url withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return url;
}

-(void)saveImageName: (NSString *)filename withData: (NSData *)data{
    NSURL *url = [[self getDocumentsURL] URLByAppendingPathComponent:filename];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(data){
        [fm createFileAtPath:url.path contents:data attributes:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)SelectImageToSave:(UIButton *)sender {
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.allowsEditing = YES;
    self.picker.delegate = self;
    TextViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TextViewController"];
    tvc.delegate = self;
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"images"
                                                                        message:@"Camera or gellary"
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [alertSheet addAction:cameraAction];
    }
    [alertSheet addAction:galleryAction];
    [alertSheet addAction:cancelAction];
    [self presentViewController:alertSheet animated:YES completion:nil];
}

#pragma  mark - UIImageViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = (UIImage *)info[UIImagePickerControllerEditedImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerRestoration
-(void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.filename forKey:viewControllerEncoderKey];
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder{
    NSString *filename = [coder decodeObjectForKey:viewControllerEncoderKey];
    if(filename){
        self.filename = filename;
        self.displayLabel.text = filename;
    }
    [super decodeRestorableStateWithCoder:coder];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder{
    ViewController *viewController = nil;
    NSString *filename = [coder decodeObjectForKey:viewControllerEncoderKey];
    if(filename){
        viewController = [[self alloc] init];
        if([viewController respondsToSelector:@selector(setFilename:)]){
            [viewController setFilename: filename];
        }
    }
    return viewController;
}

#pragma mark - SaveImageNameDelegate

-(void)recevieImageName:(NSString *)name{
    self.filename = name;
    self.displayLabel.text = self.filename;
    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
    [self saveImageName: [NSString stringWithFormat:@"%@.png", self.filename] withData: imageData];
}

@end
