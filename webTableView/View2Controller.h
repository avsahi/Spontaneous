//
//  View2Controller.h
//  Spontaneous
//
//  Created by Avdeep Sahi on 4/1/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "BTGlassScrollView.h"
#import "FBShimmeringView.h"

@interface View2Controller : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewAccessibilityDelegate>


@property (strong, nonatomic) NSString *url;
@property CLLocationCoordinate2D center;
@property NSString *backgroundURL;
@end
