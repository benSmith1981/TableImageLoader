//
//  ViewController.m
//  MGTest
//
//  Created by Esteban.
//  Copyright (c) 2012 Mobgen. All rights reserved.
//

#import "MGImageTableViewController.h"
#import "AFNetworking.h"
#import "MGAFNetworkingInterface.h"
#import "MGTableViewCell.h"
#import "MGDetailImageViewController.h"
#import "AFImageRequestOperation.h"
#import "Reachability.h"

@interface MGImageTableViewController ()
{
    int maxImages;
}
/** Local property array to store the image urls to display in the table*/
@property (nonatomic,retain) NSArray* imageURLs;
@property (nonatomic,retain) NSMutableArray* images;

/**Returns the cell ID depending on if it is ipad or iphone
 @return NSString The custom cell ID
 */
-(NSString*)getCustomCellID;

/**Returns the table custom cell dependent on the cell ID
 @return MGTableViewCell The Table cell
 */
-(MGTableViewCell*)getCustomTableCell;
@end

@implementation MGImageTableViewController
@synthesize imageListTable = _imageListTable;
@synthesize imageURLs = _imageURLs;
@synthesize images = _images;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self checkInternet]) {
        //set initial number of images show to 5
        maxImages = 5;
        //turn activity indicator on to show user images are loading
        AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
        //sets this class up to receive delegate call back when JSON is parsed
        [MGAFNetworkingInterface setImageManifestProtocol:self];
        //sets off AF networking to parse JSON
        [MGAFNetworkingInterface jsonRequestInitialiser];
        _imageURLs =  [[NSArray alloc]init];
        _images = [[NSMutableArray alloc]init];
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [_imageListTable reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [_imageListTable release];
    _imageListTable = nil;
    [_imageURLs release];
    _imageURLs = nil;
}

-(MGTableViewCell*)getCustomTableCell
{
    MGTableViewCell *cell = (MGTableViewCell*)[_imageListTable dequeueReusableCellWithIdentifier:[self getCustomCellID]];
    return cell;
}

-(NSString*)getCustomCellID
{
    static NSString *MGImageTableCellID;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        MGImageTableCellID = @"MGTableViewCell_iPhone";
    }
    else
    {
        MGImageTableCellID = @"MGTableViewCell_iPad";
    }
    return MGImageTableCellID;
}

#pragma mark - Table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 50;
    if ([[self getCustomCellID] isEqualToString:@"MGTableViewCell_iPhone"])
    {
        height = 84;
    }
    else if ([[self getCustomCellID] isEqualToString:@"MGTableViewCell_iPad"])
    {
        height = 199;
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_imageURLs count]) {
        return maxImages;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGTableViewCell *cell = [self getCustomTableCell];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:[self getCustomCellID] owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }

//    NSLog(@"%@",[[_imageURLs objectAtIndex:indexPath.row] lastPathComponent]);
//    UIImage *tempImage = [MGAFNetworkingInterface GetSavedImageWithName:[[_imageURLs objectAtIndex:indexPath.row] lastPathComponent]];
//    if (tempImage) {
//        cell.MGImage.image = tempImage;
//    }
//    else
//    {
//        cell.MGImage.image = [UIImage imageNamed:@"loading.png"];
//    }

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[_imageURLs objectAtIndex:indexPath.row]]];
    [cell.MGImage setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"loading.png"]
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                     cell.MGImage.image = image;
                                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                         [MGAFNetworkingInterface writeImages:[_imageURLs objectAtIndex:indexPath.row] DataToFile:image];
                                     });
                                     NSLog(@"%@",[[_imageURLs objectAtIndex:indexPath.row] lastPathComponent]);
                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                     NSLog(@"%@",error.description);
                                 }];
    //go get the images from the server, or load them if already downloaded
//    [cell.MGImage setImageWithURL:[NSURL URLWithString:[_imageURLs objectAtIndex:indexPath.row]]
//                 placeholderImage:[UIImage imageNamed:@"loading"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGDetailImageViewController *detailImageVC;

    //load detail view dependent on type of device
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        detailImageVC = [[MGDetailImageViewController alloc]initWithNibName:@"MGDetailImageViewController_iPhone" bundle:nil];
    }
    else
    {
        detailImageVC = [[MGDetailImageViewController alloc]initWithNibName:@"MGDetailImageViewController_iPad" bundle:nil];
    }
    //Get image stored in documents directory
    UIImage *tempImage = [MGAFNetworkingInterface GetSavedImageWithName:[[_imageURLs objectAtIndex:indexPath.row] lastPathComponent]];
//    UIImage *tempImage = [_images objectAtIndex:indexPath.row];
    //set image in detail view
    [detailImageVC setFullsizeImage:[[UIImageView alloc] initWithImage:tempImage]];
    //[detailImageVC.fullsizeImage setImageWithURL:[NSURL URLWithString:[_imageURLs objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"loading"]];
    //push detail view
    [self.navigationController pushViewController:detailImageVC animated:YES];
}

#pragma mark ImageParsingComplete Protocol method
- (void) sendBackArrayOfImageURLs:(NSArray*)imageURLs;
{
    _imageURLs = [[NSArray alloc]initWithArray:imageURLs];
    [_imageListTable reloadData];
}

- (void) reloadTable
{
    [_imageListTable reloadData];
}
#pragma mark Image Loading

- (IBAction)loadMoreImages:(id)sender {
    maxImages +=5;
    if (maxImages >= [_imageURLs count]) {
        maxImages = [_imageURLs count];
    }
    [_imageListTable reloadData];

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [MGAFNetworkingInterface loadImagesIntoDirectory:_imageURLs];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_imageListTable reloadData];
//        });
//    });
}

#pragma REACHIBILITY METHODS
- (BOOL) connectedToNetwork
{
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.co.uk"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

-(BOOL) checkInternet
{
	//Make sure we have internet connectivity
	if([self connectedToNetwork] != YES)
	{
        UIAlertView *alert = nil;

        alert = [[UIAlertView alloc] initWithTitle:@"No Network Connectivity!"
                                           message:@"No network connection found. An Internet connection is required for this application to work" delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil, nil];
        [alert show];
        
		return NO;
	}
	else {
		return YES;
	}
}
@end
