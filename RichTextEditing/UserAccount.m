//
//  UserAccount.m
//  RichTextEditing
//
//  Created by Bowen Zhang on 8/25/14.
//  Copyright (c) 2014 Bowen Zhang. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount

- (void) setUserName: (NSString *) name {
    username = name;
}

- (void) setPassWord: (NSString *) pwd {
    password = pwd;
}

- (void) setEmail: (NSString *) emailStr {
    email = emailStr;
}



@end
