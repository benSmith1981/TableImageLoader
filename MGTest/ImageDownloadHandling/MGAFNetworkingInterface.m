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
@end
