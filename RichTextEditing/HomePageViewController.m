//
//  HomePageViewController.m
//  RichTextEditing
//
//  Created by Bowen Zhang on 8/25/14.
//  Copyright (c) 2014 Bowen Zhang. All rights reserved.
//

#import "HomePageViewController.h"
#import "HelloWorldAppDelegate.h"

@interface HomePageViewController ()

@end


@implementation HomePageViewController
@synthesize signUpBtn;
@synthesize authButton;
@synthesize statusLabel;
@synthesize nameLabel;
@synthesize profilePictureView;

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
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 150);
    [self.view addSubview:loginView];
    // Do any additional setup after loading the view.
}

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.id;
    self.nameLabel.text = user.name;
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.statusLabel.text = @"You're logged in as";
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text = @"You're not logged in!";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alerttitle;
    
    if([FBErrorUtility shouldNotifyUserForError:error]){
        alerttitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    }else if([FBErrorUtility errorCategoryForError:error]==FBErrorCategoryAuthenticationReopenSession){
        alerttitle = @"Session error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    }else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        
    } else {
        alerttitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alerttitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

- (IBAction)authButtonAction:(id)sender {
    HelloWorldAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
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
