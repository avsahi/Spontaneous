//
//  ViewController.h
//  ShakeFindr
//
//  Created by Avdeep Sahi on 2/24/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "BTGlassScrollView.h"
#import "FBShimmeringView.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewAccessibilityDelegate>

@property (strong, nonatomic) NSDictionary *restuarantDetail;
@property (strong, nonatomic) NSString *initialType;
@property CLLocationCoordinate2D center;
@property NSString *city;
@property NSString *backgroundURL;


@end
