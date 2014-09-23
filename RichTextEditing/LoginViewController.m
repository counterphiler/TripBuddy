//
//  LoginViewController.m
//  RichTextEditing
//
//  Created by Bowen Zhang on 8/25/14.
//  Copyright (c) 2014 Bowen Zhang. All rights reserved.
//

#import "LoginViewController.h"
#import "HelloWorldViewController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "AFHTTPRequestOperationManager.h"

@interface LoginViewController ()

@end


@implementation LoginViewController
@synthesize emailTF,passwordTF;

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

- (IBAction)jumpToEditorPage:(id)sender {
//    HelloWorldViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditorPage"];
//    [self.navigationController pushViewController:viewController animated:YES];
    NSString *email = emailTF.text;
    NSString *password = passwordTF.text;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://103.241.50.122:3000/api/user/signin.json" parameters:@{
                                                                                 @"email": email,
                                                                                 @"password": password}       success:^(AFHTTPRequestOperation *operation, id responseObject) {//处理返Object
                                                                                     NSDate *date = [NSDate date];
                                                                                     NSTimeZone* currentTimeZone = [NSTimeZone localTimeZone];
                                                                                     
                                                                                     NSTimeInterval gmtInterval = [currentTimeZone secondsFromGMTForDate:date];
                                                                                     
                                                                                     NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:-gmtInterval sinceDate:date];
                                                                                     NSDateFormatter *dateFormatter = [NSDateFormatter new];
                                                                                     dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm";
                                                                                     NSString *expireTime = [dateFormatter stringFromDate:destinationDate];
                                                                                     KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"keyChainTest" accessGroup:nil];
                                                                                     [keychain setObject:emailTF.text forKey:(__bridge id)(kSecAttrAccount)];
                                                                                     [keychain setObject:passwordTF.text forKey:(__bridge id)(kSecValueData)];
                                                                                     [keychain setObject:expireTime forKey:(__bridge id)kSecAttrService];
                                                                                 [self performSegueWithIdentifier:@"EditorPage" sender:self];} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                         NSLog(@"Error: %@", error);  }];
    
    
//    NSString *username = [keychain objectForKey:(__bridge id)kSecAttrAccount];
//    NSLog(@"User = %@",username);
    
}

//- (NSDate*) convertToGMT:(NSDate*)sourceDate
//{
//    NSTimeZone* currentTimeZone = [NSTimeZone localTimeZone];
//    
//    NSTimeInterval gmtInterval = [currentTimeZone secondsFromGMTForDate:sourceDate];
//    
//    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:sourceDate];
//    return destinationDate;
//}

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
