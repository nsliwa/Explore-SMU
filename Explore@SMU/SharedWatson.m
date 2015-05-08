//
//  SharedWatson.m
//  Explore@SMU
//
//  Created by ch484-mac4 on 5/7/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

#import "SharedWatson.h"
#import "WPWatson.h"
#import "WPUtils.h"

@implementation SharedWatson

+(void) askWatsonQuestion:(NSString*)question {
    
    [[WPWatson sharedManager] askQuestion:question completionHandler:^(NSError* connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self responseFound];

        });
    }];
}

+(void) responseFound {
    
    WPWatson* watson = [WPWatson sharedManager];
    WPWatsonQuestionResponse* response = watson.responses[watson.currentQuestion];
    
    NSString* responseStr = response.evidence[0][KEY_TEXT];
    
    NSDictionary* result = @{@"response": responseStr};
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"QuestionGotResponseNotification"
     object:nil
     userInfo:result];
}

@end
