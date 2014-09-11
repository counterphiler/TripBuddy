//
//  HelloWorldAppDelegate.h
//  RichTextEditing
//
//  Created by Bowen Zhang on 8/16/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MyTokenCachingStrategy.h"

@interface HelloWorldAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MyTokenCachingStrategy *tokenCaching;

-(BOOL)openSessionWithAllowLoginUI:(BOOL) allowLoginUI;
-(void) closeSession;
@end
