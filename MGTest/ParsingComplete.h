//
//  ImageParsingComplete.h
//  MGTest
//
//  Created by Ben on 23/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Implement this to get JSON data back in form of and array*/
@protocol ParsingComplete <NSObject>
/**Protocol method used to send back JSON data to class that requested it
 @param NSArray of image urls to be downloaded to display in table
 */
- (void) sendBackArrayOfImageURLs:(NSArray*)imageURLs;

- (void) reloadTable;
@end
