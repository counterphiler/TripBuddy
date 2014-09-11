//
//  HelloWorldViewController.h
//  RichTextEditing
//
//  Created by Bowen Zhang on 8/16/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelloWorldViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, strong) NSString *imagePath;

@end
