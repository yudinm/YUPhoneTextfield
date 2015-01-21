//
//  ViewController.m
//  YUPhoneTextfield
//
//  Created by michael on 30.06.14.
//  Copyright (c) 2014 ru.michael.yudin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfMobileNum;
@property (nonatomic, strong) YUPhoneFormatter *formatter;
@property (nonatomic, strong) NSString *strPhoneNumber;

@end

@implementation ViewController

- (YUPhoneFormatter *)formatter
{
    _formatter = [[YUPhoneFormatter alloc] init];
    if (!_formatter) {

    }
    return _formatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tfMobileNum.delegate = self;
    _strPhoneNumber = @"";
    self.tfMobileNum.text = self.strPhoneNumber;
}

- (IBAction)btSendDidTapped:(id)sender {
    NSString *strMobile = [NSString stringWithFormat:@"\"%@\"",self.strPhoneNumber];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Phone number:" message:strMobile delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

#pragma mark - Text Field Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChange = [self.formatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
    _strPhoneNumber = self.tfMobileNum.text;
    return shouldChange;
}

@end
