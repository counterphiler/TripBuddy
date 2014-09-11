//
//  MyTokenCachingStrategy.m
//  RichTextEditing
//
//  Created by Bowen Zhang on 9/6/14.
//  Copyright (c) 2014 Bowen Zhang. All rights reserved.
//

#import "MyTokenCachingStrategy.h"

static BOOL kLocalCache = YES;

// Local cache - unique file info
//static NSString* kFilename = @"TokenInfo.plist";

static NSString* kBackendURL = @"<YOUR_BACKEND_SERVER>/token.php";

// Remote cache - date format
static NSString* kDateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ";
@implementation MyTokenCachingStrategy

-(id) init {
    self = [super init];
    if(self) {
        _tokenFilePath = [self filePath];
        _thirdPartySessionId = @"";
    }
    return self;
}

-(NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void) writeData:(NSDictionary *) data {
    NSLog(@"WriteFile = %@ and Data = %@", self.tokenFilePath, data);
    BOOL success = [data writeToFile:self.tokenFilePath atomically:YES];
    if (!success) {
        NSLog(@"Error writing to file");
    }
}

-(NSDictionary *) readData {
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:self.tokenFilePath];
    NSLog(@"ReadFile = %@ and data = %@", self.tokenFilePath, data);
    return data;
}

-(void)cacheFBAccessTokenData: (FBAccessTokenData *) accessToken {
    NSDictionary *tokenInfomation = [accessToken dictionary];
    [self writeData:tokenInfomation];
}

-(FBAccessTokenData *) fetchFBAccessTokenData {
    NSDictionary *tokenInformation = [self readData];
    if(nil == tokenInformation) {
        return nil;
    }else {
        return [FBAccessTokenData createTokenFromDictionary:tokenInformation];
    }
}

-(void)clearToken {
    [self writeData:[NSDictionary dictionaryWithObjectsAndKeys:nil]];
}
@end
