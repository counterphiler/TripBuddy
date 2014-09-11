//
//  SignUpViewController.h
//  RichTextEditing
//
//  Created by Bowen Zhang on 8/25/14.
//  Copyright (c) 2014 Bowen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UITextField *usernameTF;

@property (strong, nonatomic) IBOutlet UIButton *signUpBtn;
-(IBAction)doSignup;
@end
