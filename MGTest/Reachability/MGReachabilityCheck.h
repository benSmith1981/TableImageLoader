//
//  MGReachabilityCheck.h
//  MGTest
//
//  Created by Ben on 24/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGReachabilityCheck : NSObject

+ (BOOL) connectedToNetwork;
+ (BOOL) checkInternet;
@end
