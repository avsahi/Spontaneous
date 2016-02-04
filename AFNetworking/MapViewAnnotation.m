//
//  MapViewAnnotation.h
//  webTableView
//
//  Created by Avdeep Sahi on 3/15/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize coordinate=_coordinate;
@synthesize title=_title;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate
{
    self =  [super init];
    _title = title;
    _coordinate = coordinate;
    return self;
}

@end
