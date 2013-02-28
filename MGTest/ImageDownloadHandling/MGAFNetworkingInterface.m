//
//  MGImageDownloadHandler.m
//  MGTest
//
//  Created by Ben on 23/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import "MGAFNetworkingInterface.h"
#import "AFJSONRequestOperation.h"
#import "MGConstants.h"
#import "AFNetworking.h"
#import "MGAFNetworkingInterface.h"

static id<ParsingCompleteProtocol>parsingDelegate;

@interface MGAFNetworkingInterface ()

/**Returns the image directory path that we store our images in
 @return NSString The image directory path for images
 */
+ (NSString*)getOurImageDirectory;

/**Writes the image data to a specific file location in our documents directory for later retrieval
 @param NSString This is the image path in documents directory
 @param UIImage This is the image we want to save there
 */
+ (void)writeImages:(NSString*)imageStringURL DataToFile:(UIImage*)image;
@end

@implementation MGAFNetworkingInterface

+ (void)jsonRequestInitialiser
{
    NSURL *url = [[NSURL alloc] initWithString:imageManifestJSON];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                        JSONRequestOperationWithRequest:request
                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                                                        NSLog(@"%@", JSON);
                                                                        //Get the image manifest dictionary
                                                                        NSDictionary *temp = [JSON objectForKey:@"image-manifest"];
                                                                        //Get the images array from dictionary
                                                                        NSArray *images = [temp objectForKey:@"images"];
                                                                        //Call to send back Image URLS array to delegate
                                                                        [parsingDelegate sendBackArrayOfImageURLs:images];
                                                                    }
                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                                                }];
    [operation start];
    [request release];
    [url release];

}

+ (void)requestImageForCell:(MGTableViewCell*)cell atRow:(int)row withImageURLS:(NSArray*)imageURLs
{
    NSURL *url = [[NSURL alloc]initWithString:[imageURLs objectAtIndex:row]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [cell.MGImage setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"loading.png"]
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                                     {
                                         cell.MGImage.image = image;
                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                             [self writeImages:[imageURLs objectAtIndex:row] DataToFile:image];
                                         });
                                         NSLog(@"%@",[[imageURLs objectAtIndex:row] lastPathComponent]);
                                     }
                                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                     {
                                         NSLog(@"%@",error.description);
                                     }];
    [request release];
    [url release];
}

+ (void)setImageManifestProtocol:(id<ParsingCompleteProtocol>)delegate
{
    parsingDelegate = delegate;
}

+ (void)writeImages:(NSString*)imageStringURL DataToFile:(UIImage*)image
{
    //if image doesn't exist then save it in documents directory
    if (![self doesImageExist:imageStringURL])
    {
        // Save Image
        NSData *imageData = UIImageJPEGRepresentation(image, 90);
        //write to documents directory
        [imageData writeToFile:[NSString stringWithFormat:@"%@%@",[self getOurImageDirectory],[imageStringURL lastPathComponent]] atomically:YES];
    }
}

+ (NSString*)getOurImageDirectory
{
    // Get dir
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    NSString *pathString = [NSString stringWithFormat:@"%@/",documentsDirectory];
    return pathString;
}

+ (BOOL)doesImageExist:(NSString*)imageName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *str = [NSString stringWithFormat:@"%@%@",[self getOurImageDirectory],imageName];
    return [fileManager fileExistsAtPath:str];
}

+ (UIImage*) getSavedImageWithName:(NSString*) imageName
{
    UIImage* image = nil;
    if([self doesImageExist:imageName])
    {
        NSString *fullImagePath = [NSString stringWithFormat:@"%@%@",[self getOurImageDirectory],imageName];
        image = [[[UIImage alloc] initWithContentsOfFile:fullImagePath] autorelease];
    }
    else {
        image = [UIImage imageNamed:@"no_image.jpg"];
    }
    
    return image;
}


@end
