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
static id<ParsingComplete>parsingDelegate;

@interface MGAFNetworkingInterface ()
+ (NSString*)getOurImageDirectory;

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
                                                                    NSDictionary *temp = [JSON objectForKey:@"image-manifest"];
                                                                    NSArray *images = [temp objectForKey:@"images"];
                                                                        [parsingDelegate sendBackArrayOfImageURLs:images];
                                                                    }
                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                    NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                                                }];
    [operation start];

}

+ (void)setImageManifestProtocol:(id<ParsingComplete>)delegate
{
    parsingDelegate = delegate;
}

+ (void)loadImagesIntoDirectory:(NSArray*)imageURLs
{
    for (NSString *imageStringURL in imageURLs) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageStringURL]];
        
        AFImageRequestOperation *operation;
        operation = [AFImageRequestOperation
                     imageRequestOperationWithRequest:request
                                 imageProcessingBlock:nil
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  // Save Image
                                                  NSData *imageData = UIImageJPEGRepresentation(image, 90);
                                                  //write to documents directory
                                                  [imageData writeToFile:[NSString stringWithFormat:@"%@%@",[self getOurImageDirectory],[imageStringURL lastPathComponent]] atomically:YES];
                                              }
                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  NSLog(@"%@", [error localizedDescription]);
                                                  UIAlertView *alert = [[UIAlertView alloc]
                                                                        initWithTitle: @"Error Downloading Image"
                                                                        message: [NSString stringWithFormat:@"%@",error.description]
                                                                        delegate: nil
                                                                        cancelButtonTitle:@"OK"
                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                                  [alert release];
                                              }];
        [operation start];
    }
}

+ (NSString*)getOurImageDirectory
{
    // Get dir
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    NSString *pathString = [NSString stringWithFormat:@"%@/MGImages/",documentsDirectory];
    return pathString;
}

+ (UIImage*) GetSavedImageWithName:(NSString*) aFileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *str = [NSString stringWithFormat:@"%@%@",[self getOurImageDirectory],aFileName];
    BOOL success = [fileManager fileExistsAtPath:str];
    
    UIImage* image = nil;
    image = [[UIImage alloc] initWithContentsOfFile:str];
    
    if(!success)
    {
        return nil;
    }
    else
    {
        image = [[UIImage alloc] initWithContentsOfFile:str];
    }
    
    return [image autorelease];
}
@end
