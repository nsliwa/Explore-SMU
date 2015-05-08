//
//  SharedWatson.h
//  Explore@SMU
//
//  Created by ch484-mac4 on 5/7/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharedWatson : NSObject

+(void) askWatsonQuestion:(NSString*)question;
+(void) responseFound;

@end
