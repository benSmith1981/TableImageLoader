//
//  MGDetailImageVCViewController.h
//  MGTest
//
//  Created by Ben on 24/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGDetailImageViewController : UIViewController
/** This is the scroll that image is displayed in if it is too big for view so we can see all of it*/
@property (nonatomic,retain) IBOutlet UIScrollView *imageScrollView;
/** This is the full size image that is displayed on the detail view*/
@property (nonatomic,retain) UIImageView *fullsizeImage;
@end
