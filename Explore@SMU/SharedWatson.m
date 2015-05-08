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

+(NSString*) askWatsonQuestion:(NSString*)question {
    WPWatson* watson = [WPWatson sharedManager];
    
    [watson askQuestion:question completionHandler:^(NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
    
    WPWatsonQuestionResponse* response = watson.responses[watson.currentQuestion];
    
    return response.answers[0][KEY_TEXT];
}

@end
