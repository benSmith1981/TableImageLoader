//
//  MGImageDownloadHandler.h
//  MGTest
//
//  Created by Ben on 23/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import "AFImageRequestOperation.h"
#import "ParsingCompleteProtocol.h"
#import "MGTableViewCell.h"

@protocol ParsingCompleteProtocol;
/** Created static instance so that this class can be statically called*/

@interface MGAFNetworkingInterface : AFImageRequestOperation

/** Sends off a request to Af networking to get and parse the JSON data from image manifest, which is sent back through a delegate call 
 */
+ (void)jsonRequestInitialiser;

/** Used to set the delegate for the ParsingComplete protocol, seeing as it is static so best way to set it
 @param id<ParsingComplete> The delegate class to call back
 */
+ (void)setImageManifestProtocol:(id<ParsingCompleteProtocol>)delegate;

/**Returns an image if it is already saved in the documents directory, or if no image exists returns a place holder "No Image" Image!
 @param NSString The name of the image with MIME extension
 @return UIImage The image returned from documents directory if it exists
 */
+ (UIImage*) getSavedImageWithName:(NSString*) imageName;

/**This method encapsulates a request by the table view for an image kicking off Afnetworking downloader and storing image for later retrieval in the documents directory
 @param MGTableViewCell Cell we want to populate an image
 @param int Row number of the cell, so we know what image to populate
 @param NSArray Array of image URLS paths on the remote server that we retrieved from the JSON image manifest
 */
+ (void)requestImageForCell:(MGTableViewCell*)cell atRow:(int)row withImageURLS:(NSArray*)imageURLs;
@end
