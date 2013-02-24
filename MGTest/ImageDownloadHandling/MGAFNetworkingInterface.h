//
//  MGImageDownloadHandler.h
//  MGTest
//
//  Created by Ben on 23/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import "AFImageRequestOperation.h"
#import "ParsingComplete.h"

@protocol ParsingComplete;
/** Created static instance so that this class can be statically called*/
static id<ParsingComplete>parsingDelegate;

@interface MGAFNetworkingInterface : AFImageRequestOperation

/** Sends off a request to Af networking to get and parse the JSON data
 */
+ (void)jsonRequestInitialiser;

/** Used to set the delegate for the ParsingComplete protocol, seeing as it is static so best way to set it
 @param id<ParsingComplete> The delegate class to call back
 */
+ (void)setImageManifestProtocol:(id<ParsingComplete>)delegate;
@end
