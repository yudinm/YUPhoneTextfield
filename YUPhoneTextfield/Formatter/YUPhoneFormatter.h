//
//  YUPhoneFormatter.h
//  YUPhoneTextfield
//
//  Created by michael on 01.07.14.
//  Copyright (c) 2014 ru.michael.yudin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YUPhoneFormatter : NSFormatter <UITextFieldDelegate>

- (NSString*)trimNonDigit:(NSString*)aString;

#pragma mark - Text Field Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
