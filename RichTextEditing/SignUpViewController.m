//
//  SignUpViewController.m
//  RichTextEditing
//
//  Created by Bowen Zhang on 8/25/14.
//  Copyright (c) 2014 Bowen Zhang. All rights reserved.
//

#import "SignUpViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize emailTF;
@synthesize passwordTF;
@synthesize usernameTF;
@synthesize signUpBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doSignup {
    NSString *email = emailTF.text;
    NSString *password = passwordTF.text;
    NSString *username = usernameTF.text;
    AFHTTPRequestOperationManager *manager =         [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://103.241.50.122:3000/api/user/signup.json" parameters:@{
                      @"email": email,
                      @"password": password,
                      @"name": username}       success:^(AFHTTPRequestOperation *operation, id responseObject) {//处理返Object
        NSLog(@"JSON: %@", responseObject);   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);  }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
