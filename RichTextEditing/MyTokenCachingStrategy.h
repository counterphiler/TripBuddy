//
//  MyTokenCachingStrategy.h
//  RichTextEditing
//
//  Created by Bowen Zhang on 9/6/14.
//  Copyright (c) 2014 Bowen Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

static NSString *kFilename = @"TokenInfo.plist";

@interface MyTokenCachingStrategy : NSObject

@property (nonatomic, strong) NSString *tokenFilePath;
@property (nonatomic, strong) NSString *thirdPartySessionId;

-(NSString *) filePath;
@end
