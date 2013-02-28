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
#import "MGReachabilityCheck.h"
#import "MGConstants.h"

@interface MGImageTableViewController ()
{
    int maxImages;
}
/** Local property array to store the image urls to display in the table*/
@property (nonatomic,retain) NSArray* imageURLs;

/**Returns the cell ID depending on if it is ipad or iphone
 @return NSString The custom cell ID
 */
-(NSString*)getCustomCellID;

/**Returns the table custom cell dependent on the cell ID
 @return MGTableViewCell The Table cell
 */
-(MGTableViewCell*)getCustomTableCell;

/**Loads 5 extra images onto the table view
 @param id Button that called this
 @return IBAction Action returned upon this call
 */
- (IBAction)loadMoreImages:(id)sender;
@end

@implementation MGImageTableViewController
@synthesize imageListTable = _imageListTable;
@synthesize imageURLs = _imageURLs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([MGReachabilityCheck checkInternet]) {
        //set initial number of images show to 5
        maxImages = extraImagesToLoad;
        //turn activity indicator on to show user images are loading
        AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
        //sets this class up to receive delegate call back when JSON is parsed
        [MGAFNetworkingInterface setImageManifestProtocol:self];
        //intialise array to hold image URLS returned from JSON request
        _imageURLs =  [[NSArray alloc]init];
        //sets off AF networking to parse JSON
        [MGAFNetworkingInterface jsonRequestInitialiser];
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
    return [MGImageTableCellID autorelease];
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
    //Request MGAFNetworkingInterface to get the images to populate cells
    [MGAFNetworkingInterface requestImageForCell:cell
                                           atRow:(int)indexPath.row
                                   withImageURLS:_imageURLs];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGDetailImageViewController *detailImageVC = nil;
/* Retain count 0 */

    //load detail view dependent on type of device
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        detailImageVC = [[MGDetailImageViewController alloc]initWithNibName:@"MGDetailImageViewController_iPhone" bundle:nil];
        /* Retain count 1 */

    }
    else
    {
        detailImageVC = [[MGDetailImageViewController alloc]initWithNibName:@"MGDetailImageViewController_iPad" bundle:nil];
        /* Retain count 1 */

    }
    //Get image stored in documents directory
    UIImage *tempImage = [MGAFNetworkingInterface getSavedImageWithName:[[_imageURLs objectAtIndex:indexPath.row] lastPathComponent]];

    UIImageView* imageView = [[UIImageView alloc] initWithImage:tempImage];
    
    //set image in detail view
    [detailImageVC setFullsizeImage:imageView];
    
    [imageView release];

    //push detail view
    [self.navigationController pushViewController:detailImageVC animated:YES];
    /* Retain count 2 */

    
    [detailImageVC release];
    /* Retain count 1 */
}
//
//NSArray array = [NSArray array]; // Autorelease
//
//NSArray array =

#pragma mark ImageParsingComplete Protocol method
- (void) sendBackArrayOfImageURLs:(NSArray*)imageURLs;
{
    //initialise imageURLS array with list of URLS returned from JSON parser
    _imageURLs = [[NSArray alloc]initWithArray:imageURLs];
    [_imageListTable reloadData];
}

#pragma mark Extra Image Loading

- (IBAction)loadMoreImages:(id)sender {
    //increase number of images displayed
    maxImages +=extraImagesToLoad;
    
    //if max images is now greater than number of actual images there are then set size to array size (max size)
    if (maxImages >= [_imageURLs count]) {
        maxImages = [_imageURLs count];
    }
    //reload table with new data
    [_imageListTable reloadData];
}


@end
