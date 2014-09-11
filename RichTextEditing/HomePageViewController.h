//
//  HomePageViewController.h
//  RichTextEditing
//
//  Created by Bowen Zhang on 8/25/14.
//  Copyright (c) 2014 Bowen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface HomePageViewController : UIViewController <FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *signUpBtn;
@property (strong, nonatomic) IBOutlet UIButton *authButton;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@end
