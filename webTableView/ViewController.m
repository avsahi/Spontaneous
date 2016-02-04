//
//  ViewController.m
//  ShakeFindr
//
//  Created by Avdeep Sahi on 2/24/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MapViewAnnotation.h"
#import "ASStarRatingView.h"

#import <GPUberViewController.h>
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"
#import "OpenInChromeController.h"
#import "MBProgressHUD.h"




#define METERS_PER_MILE 1609.344
CGFloat const margin = 5.f;
@interface ViewController () <MKMapViewDelegate, UIActionSheetDelegate>

@end

@implementation ViewController
{
    BTGlassScrollView *_glassScrollView;
    NSDictionary *inventory;
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    NSNumber *lat;
    NSNumber *lng;
    NSString *placesID;
    NSString *strURL;
    NSDictionary *dict;
    NSArray *hoursArray;
    UILabel *titleLabel;
    UILabel *reviewLabel;
    NSArray *tableArray;
    NSString *addressString;
    UILabel *infoLabel;
    UILabel *typeOfPlace;
    UILabel *ratingNum;
    UILabel *hours;
    UILabel *mon;
    UILabel *tues;
    UILabel *wed;
    UILabel *thurs;
    UILabel *fri;
    UILabel *sat;
    UILabel *sun;
    UILabel *openLabel;
    NSString *checkString;
    MKMapView *mapview;
    UITableView *aTableView;
    ASStarRatingView *staticStarRatingView;
    NSURL *googleURL;
    UIView *myView;
    NSNumber *priceLevel;
    UILabel *priceLabel;
    NSString *tel;
    UILabel *distanceText;
    CLLocation *locA;
    CLLocation *locB;
    NSMutableDictionary *savedObjects;
    HTPressableButton *bookmark;
    
    double lat1;
    double lng1;
    NSNumber *lat2;
    CLLocationManager *locationManager;
    NSNumber *lng2;
    
    
}

@synthesize initialType, restuarantDetail, center, city, backgroundURL;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    lat1 = (double)locationManager.location.coordinate.latitude;
    lng1 = (double)locationManager.location.coordinate.longitude;
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    //self.navigationController.hidesBarsOnSwipe = YES;
    // Capture frame
   
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(saveButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    if ([self.restuarantDetail objectForKey:@"price_level"]) {
        priceLevel = [self.restuarantDetail objectForKey:@"price_level"];
    } else {
        priceLevel = [NSNumber numberWithInt:-1];
    }
    placesID = [self.restuarantDetail objectForKey:@"reference"];
    lat = [[[self.restuarantDetail objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
    lng = [[[self.restuarantDetail objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
    checkString = [[self.restuarantDetail objectForKey:@"opening_hours"] objectForKey:@"open_now"];
    strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&key=AIzaSyCWdd64ipGOgXNIZjPSJKK2xsGQUJigDgk", placesID];
    NSLog(@"placesID is: %@", strURL);
    NSURL *url = [NSURL URLWithString:strURL];
    
    

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:[url absoluteString]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             tableArray = [[responseObject objectForKey:@"result"]objectForKey:@"reviews"];
             hoursArray = [[[responseObject objectForKey:@"result"]objectForKey:@"opening_hours"]objectForKey:@"weekday_text"];
             addressString = [[responseObject objectForKey:@"result"] objectForKey:@"formatted_address"];
             tel = [[responseObject objectForKey:@"result"]objectForKey:@"formatted_phone_number"];
             [aTableView reloadData];

         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                               message:[NSString stringWithFormat:@"Request Failed with Error: %@, %@", error, error.userInfo]
                                                              delegate:nil
                                                     cancelButtonTitle:@"Okay"
                                                     otherButtonTitles:nil];
             
             [message show];;
         }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    inventory = [NSDictionary dictionaryWithObjects:@[@"Accounting", @"Airport", @"Amusement Park", @"Aquarium", @"Art Gallery", @"ATM", @"Bakery", @"Bank", @"Bar", @"Beauty Salon", @"Bicycle Store", @"Book Store", @"Bowling Alley", @"Bus Station", @"Cafe", @"Campground",  @"Car Dealer", @"Car Rental", @"Car Repair", @"Car Wash", @"Casino", @"Cemetery", @"Church", @"City Hall", @"Clothing Store" ,@"Convenience Store", @"Courthouse", @"Dentist", @"Department Store", @"Doctor", @"Electrician", @"Electronics Store", @"Embassy", @"Establishment", @"Finance", @"Fire Station", @"Florist", @"Food", @"Funeral Home", @"Furniture Store", @"Gas Station", @"General Contractor", @"Grocery or Supermarket", @"Gym", @"Hair Care", @"Hardware Store", @"Health", @"Hindu Temple", @"Home Goods Store", @"Hospital", @"Insurance Agency", @"Jewelry Store", @"Laundry", @"Lawyer", @"Library", @"Liquor Store", @"Local Government Office", @"Locksmith", @"Lodging", @"Meal Delivery", @"Meal Takeaway", @"Mosque", @"Movie Rental", @"Movie Theater", @"Moving Company", @"Museum", @"Night Club", @"Painter", @"Park", @"Parking", @"Pet Store", @"Pharmacy", @"Physiotherapist", @"Place of Worship", @"Plumber" ,@"Police", @"Post Office", @"Real Estate Agency", @"Restaurant", @"Roofing Contractor", @"RV Park", @"School", @"Shoe Store", @"Shopping Mall", @"Spa", @"Stadium", @"Storage", @"Store", @"Subway Station", @"Synagogue", @"Taxi Stand", @"Train Station", @"Travel Agency", @"University", @"Veterinary Care", @"Zoo"] forKeys:@[@"accounting", @"airport", @"amusement_park", @"aquarium", @"art_gallery", @"atm", @"bakery", @"bank", @"bar", @"beauty_salon", @"bicycle_store", @"book_store", @"bowling_alley", @"bus_station", @"cafe", @"campground",  @"car_dealer", @"car_rental", @"car_repair", @"car_wash", @"casino", @"cemetery", @"church", @"city_hall", @"clothing_store" ,@"convenience_store", @"courthouse", @"dentist", @"department_store", @"doctor", @"electrician", @"electronics_store", @"embassy", @"establishment", @"finance", @"fire_station", @"florist", @"food", @"funeral_home", @"furniture_store", @"gas_station", @"general_contractor", @"grocery_or_supermarket", @"gym", @"hair_care", @"hardware_store", @"health", @"hindu_temple", @"home_goods_store", @"hospital", @"insurance_agency", @"jewelry_store", @"laundry", @"lawyer", @"library", @"liquor_store", @"local_government_office", @"locksmith", @"lodging", @"meal_delivery", @"meal_takeaway", @"mosque", @"movie_rental", @"movie_theater", @"moving_company", @"museum", @"night_club", @"painter", @"park", @"parking", @"pet_store", @"pharmacy", @"physiotherapist", @"place_of_worship", @"plumber" ,@"police", @"post_office", @"real_estate_agency", @"restaurant", @"roofing_contractor", @"rv_park", @"school", @"shoe_store", @"shopping_mall", @"spa", @"stadium", @"storage", @"store", @"subway_station", @"synagogue", @"taxi_stand", @"train_station", @"travel_agency", @"university", @"veterinary_care", @"zoo"]];

    //showing white status
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //preventing weird inset
    [self setAutomaticallyAdjustsScrollViewInsets: NO];
    //background
    self.view.backgroundColor = [UIColor blackColor];
    
    savedObjects = [NSMutableDictionary new];
   NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.spontaneousWatch"];
    NSDictionary *adict = [defaults objectForKey:@"bookmark"];
    for(NSString * key in [adict allKeys]) {
        NSString *value = [adict objectForKey:key];
        [savedObjects setObject:value forKey:key];
    }

    // important for some reason
    aTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1, 1) style:UITableViewStylePlain];
    aTableView.delegate = self;
    aTableView.dataSource = self;
    [self.view addSubview:aTableView];
    NSLog(@"url: %@", backgroundURL);
    myView = [self customView];

    
    _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:backgroundURL]]] blurredImage:nil viewDistanceFromBottom:margin*28 foregroundView:myView];
    [self.view addSubview:_glassScrollView];
    
}


- (UIView *)customView
{
    myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*2)];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth-margin, 150)];
    [titleLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:32.f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setShadowColor:[UIColor colorWithWhite:0.f alpha:0.3f]];
    [titleLabel setShadowOffset:(CGSize){1,1}];
    [titleLabel setNumberOfLines:0];
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:titleLabel.bounds];
    [myView addSubview:shimmeringView];
    
    shimmeringView.contentView = titleLabel;
    
    // Start shimmering.
    shimmeringView.shimmering = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;

    
    [titleLabel setText:[NSString stringWithFormat:@"↑\n%@",[self.restuarantDetail objectForKey:@"name"]]];
    UIView *box1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, titleLabel.frame.size.height )];
    box1.layer.cornerRadius = 3;
    box1.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [box1 addSubview:titleLabel];
    [myView addSubview:box1];
    
    //type of place
    
    typeOfPlace = [[UILabel alloc] initWithFrame:CGRectMake(2*margin,
                                                            titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                                            screenWidth-margin*2,
                                                            70)];
    [typeOfPlace setFont:[UIFont fontWithName:@"Avenir-Medium" size:18.f]];
    [typeOfPlace setBackgroundColor:[UIColor clearColor]];
    [typeOfPlace setTextColor:[UIColor whiteColor]];
    [typeOfPlace setLineBreakMode:NSLineBreakByWordWrapping];
    [typeOfPlace setNumberOfLines:0];
    [self setTypeOfPlace];
    [myView addSubview:typeOfPlace];
    
    staticStarRatingView = [[ASStarRatingView alloc]initWithFrame:CGRectMake(margin,
                                                                             typeOfPlace.frame.size.height + typeOfPlace.frame.origin.y,
                                                                             screenWidth/2,
                                                                             30)];
    ratingNum = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+margin*2,
                                                          typeOfPlace.frame.size.height + typeOfPlace.frame.origin.y,
                                                          screenWidth/2,
                                                          30)];
    staticStarRatingView.canEdit = NO;
    staticStarRatingView.maxRating = 5;
    [ratingNum setFont:[UIFont fontWithName:@"Avenir-Medium" size:22.f]];
    [ratingNum setBackgroundColor:[UIColor clearColor]];
    [ratingNum setTextColor:[UIColor whiteColor]];
    [ratingNum setLineBreakMode:NSLineBreakByWordWrapping];
    [ratingNum setNumberOfLines:0];
    if([self.restuarantDetail objectForKey:@"rating"] != NULL) {
        NSNumber *value = [self.restuarantDetail objectForKey:@"rating"];
        [ratingNum setText: [NSString stringWithFormat:@"%@", [value stringValue]]];
        [ratingNum setTextColor:[UIColor colorWithRed:0.996 green:0.702 blue:0.02 alpha:1]];
        staticStarRatingView.rating = [value doubleValue];
    } else {
        [ratingNum setText: @"Not Rated"];
        [UIColor colorWithRed:0.827 green:0.827 blue:0.827 alpha:1];
        staticStarRatingView.rating = 0;
        
    }
    [myView addSubview:staticStarRatingView];
    [myView addSubview:ratingNum];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin*2, staticStarRatingView.frame.size.height+ staticStarRatingView.frame.origin.y, screenWidth-margin, 60)];
    [priceLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:18.f]];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    [priceLabel setTextColor:[UIColor whiteColor]];
    [priceLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [priceLabel setNumberOfLines:0];
    NSString *text;
   // NSLog(@"price level: %@", priceLevel);
    if (priceLevel <= 0) {
        text = @"N/A";
    } else if ([priceLevel intValue] == 1) {
        text = @"Price Level: $";
    } else if ([priceLevel intValue] == 2) {
        text = @"Price Level: $$";
    } else if ([priceLevel intValue] == 3) {
        text = @"Price Level: $$$";
    } else if ([priceLevel intValue] == 4) {
        text = @"Price Level: $$$$";
    } else if ([priceLevel intValue] >= 5) {
        text = @"Price Level: $$$$$";
    }
    [priceLabel setText:text];
    [myView addSubview:priceLabel];

        hours = [[UILabel alloc] initWithFrame:CGRectMake(margin*2,
                                                          priceLabel.frame.size.height+ priceLabel.frame.origin.y + margin,
                                                          screenWidth/2,
                                                          30)];
        [hours setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.f]];
        [hours setBackgroundColor:[UIColor clearColor]];
        [hours setTextColor:[UIColor whiteColor]];
        [hours setLineBreakMode:NSLineBreakByWordWrapping];
        [hours setNumberOfLines:0];
        [hours setText:@"Hours of Operation:"];
        [myView addSubview:hours];
    
        openLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2 + margin*2,
                                                              priceLabel.frame.size.height + priceLabel.frame.origin.y + margin,
                                                              screenWidth/2,
                                                              30)];
        [openLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.f]];
        [openLabel setBackgroundColor:[UIColor clearColor]];
        [openLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [openLabel setNumberOfLines:0];
    
        [myView addSubview:openLabel];
    [self isItOpen];
    
        mon = [[UILabel alloc] initWithFrame:CGRectMake(margin*2,
                                                        hours.frame.size.height+ hours.frame.origin.y,
                                                        screenWidth-margin,
                                                        30)];
        [mon setFont:[UIFont fontWithName:@"Avenir-Medium" size:15.f]];
        [mon setBackgroundColor:[UIColor clearColor]];
        [mon setTextColor:[UIColor whiteColor]];
        [mon setLineBreakMode:NSLineBreakByWordWrapping];
        [mon setNumberOfLines:0];
        [myView addSubview:mon];
    
        tues = [[UILabel alloc] initWithFrame:CGRectMake(margin*2,
                                                         mon.frame.size.height + mon.frame.origin.y,
                                                         screenWidth-margin,
                                                         30)];
        [tues setFont:[UIFont fontWithName:@"Avenir-Medium" size:15.f]];
        [tues setBackgroundColor:[UIColor clearColor]];
        [tues setTextColor:[UIColor whiteColor]];
        [tues setLineBreakMode:NSLineBreakByWordWrapping];
        [tues setNumberOfLines:0];
        [myView addSubview:tues];
    
        wed = [[UILabel alloc] initWithFrame:CGRectMake(margin*2,
                                                        tues.frame.size.height + tues.frame.origin.y,
                                                        screenWidth-margin,
                                                        30)];
        [wed setFont:[UIFont fontWithName:@"Avenir-Medium" size:15.f]];
        [wed setBackgroundColor:[UIColor clearColor]];
        [wed setTextColor:[UIColor whiteColor]];
        [wed setLineBreakMode:NSLineBreakByWordWrapping];
        [wed setNumberOfLines:0];
        [myView addSubview:wed];
    
        thurs = [[UILabel alloc] initWithFrame:CGRectMake(margin*2,
                                                          wed.frame.size.height + wed.frame.origin.y,
                                                          screenWidth-margin,
                                                          30)];
        [thurs setFont:[UIFont fontWithName:@"Avenir-Medium" size:15.f]];
        [thurs setBackgroundColor:[UIColor clearColor]];
        [thurs setTextColor:[UIColor whiteColor]];
        [thurs setLineBreakMode:NSLineBreakByWordWrapping];
        [thurs setNumberOfLines:0];
        [myView addSubview:thurs];
    
        fri = [[UILabel alloc] initWithFrame:CGRectMake(margin*2,
                                                        thurs.frame.size.height + thurs.frame.origin.y,
                                                        screenWidth-margin,
                                                        30)];
        [fri setFont:[UIFont fontWithName:@"Avenir-Medium" size:15.f]];
        [fri setBackgroundColor:[UIColor clearColor]];
        [fri setTextColor:[UIColor whiteColor]];
        [fri setLineBreakMode:NSLineBreakByWordWrapping];
        [fri setNumberOfLines:0];
        [myView addSubview:fri];
    
        sat = [[UILabel alloc] initWithFrame:CGRectMake(margin*2,
                                                        fri.frame.size.height + fri.frame.origin.y,
                                                        screenWidth-margin,
                                                        30)];
        [sat setFont:[UIFont fontWithName:@"Avenir-Medium" size:15.f]];
        [sat setBackgroundColor:[UIColor clearColor]];
        [sat setTextColor:[UIColor whiteColor]];
        [sat setLineBreakMode:NSLineBreakByWordWrapping];
        [sat setNumberOfLines:0];
        [myView addSubview:sat];
    
        sun = [[UILabel alloc] initWithFrame:CGRectMake(margin*2,
                                                        sat.frame.size.height + sat.frame.origin.y,
                                                        screenWidth-margin,
                                                        30)];
        [sun setFont:[UIFont fontWithName:@"Avenir-Medium" size:15.f]];
        [sun setBackgroundColor:[UIColor clearColor]];
        [sun setTextColor:[UIColor whiteColor]];
        [sun setLineBreakMode:NSLineBreakByWordWrapping];
        [sun setNumberOfLines:0];
        [myView addSubview:sun];
    

//    // map
    mapview = [[MKMapView alloc] initWithFrame:CGRectMake(5, sun.frame.size.height + sun.frame.origin.y + margin*4, screenWidth-10, screenWidth-margin*8)];
    mapview.delegate = self;
    [mapview addAnnotation:[self createAnnotation]];
    [mapview selectAnnotation:[[mapview annotations] objectAtIndex:0] animated:YES];
    [self zoomToLocation];
    [myView addSubview:mapview];
    

    CGRect frameDirections = CGRectMake(margin, mapview.frame.size.height + mapview.frame.origin.y+margin*3, screenWidth-margin*2, screenHeight/14);
    HTPressableButton *directions = [[HTPressableButton alloc] initWithFrame:frameDirections buttonStyle:HTPressableButtonStyleRounded];
    [directions setTitle:@"Get Directions" forState:UIControlStateNormal];
    [directions addTarget:self action:@selector(mapsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    directions.buttonColor = [UIColor ht_alizarinColor];
    directions.shadowColor = [UIColor ht_pomegranateColor];
    [myView addSubview:directions];
    
    CGRect frameUber = CGRectMake(margin, directions.frame.size.height+directions.frame.origin.y + margin*2, screenWidth-margin*2, screenHeight/14);
    HTPressableButton *uber = [[HTPressableButton alloc] initWithFrame:frameUber buttonStyle:HTPressableButtonStyleRounded];
    [uber setTitle:@"Uber To Here" forState:UIControlStateNormal];
    [uber addTarget:self action:@selector(uberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    uber.buttonColor = [UIColor ht_peterRiverColor];
    uber.shadowColor = [UIColor ht_belizeHoleColor];
    [myView addSubview:uber];
    

    CGRect frameCall = CGRectMake(margin, uber.frame.size.height+margin*2+uber.frame.origin.y, screenWidth-margin*2, screenHeight/14);
    HTPressableButton *call = [[HTPressableButton alloc] initWithFrame:frameCall buttonStyle:HTPressableButtonStyleRounded];
    [call setTitle:@"Call" forState:UIControlStateNormal];
    [call addTarget:self action:@selector(phoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    call.buttonColor = [UIColor ht_turquoiseColor];
    call.shadowColor = [UIColor ht_greenSeaColor];
    [myView addSubview:call];

    
    
    locA = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1]; // curr loc

    
    locB = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lng.doubleValue]; // dest
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    double val = distance*0.000621371;
    distanceText = [[UILabel alloc] initWithFrame:CGRectMake(margin*2,
                                                             call.frame.size.height + call.frame.origin.y+margin*3,
                                                             screenWidth-(margin*2),
                                                             60)];
    [distanceText setFont:[UIFont fontWithName:@"Avenir-Medium" size:18.f]];
    [distanceText setBackgroundColor:[UIColor clearColor]];
    [distanceText setTextColor:[UIColor whiteColor]];
    [distanceText setLineBreakMode:NSLineBreakByWordWrapping];
    [distanceText setNumberOfLines:0];
    NSString *str = [NSString stringWithFormat:@"You are %.2f miles away", val];
    [distanceText setText:str];
    [myView addSubview:distanceText];
    //    // Add info label
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin*2,
                                                                (distanceText.frame.size.height+ distanceText.frame.origin.y)+margin*2,
                                                                  screenWidth-(margin*2),
                                                                  60)];
        [infoLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:18.f]];
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        [infoLabel setTextColor:[UIColor whiteColor]];
        [infoLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [infoLabel setNumberOfLines:0];
        [myView addSubview:infoLabel];
    
    reviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin*2,
                                                            infoLabel.frame.size.height + infoLabel.frame.origin.y + margin*2,
                                                            screenWidth-margin*2,
                                                            screenWidth+margin*5)];
    [reviewLabel setBackgroundColor:[UIColor clearColor]];
    [reviewLabel setTextColor:[UIColor whiteColor]];
    [reviewLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [reviewLabel setNumberOfLines:0];
    [reviewLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:14.f]];
    [myView addSubview:reviewLabel];
    CGRect frameMore = CGRectMake(margin, reviewLabel.frame.size.height + reviewLabel.frame.origin.y+margin*2, screenWidth-margin*2, screenHeight/14);
    HTPressableButton *moreInfo = [[HTPressableButton alloc] initWithFrame:frameMore buttonStyle:HTPressableButtonStyleRounded];
    [moreInfo setTitle:@"More Info" forState:UIControlStateNormal];
    [moreInfo addTarget:self action:@selector(moreInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
    moreInfo.buttonColor = [UIColor ht_aquaColor];
    moreInfo.shadowColor = [UIColor ht_aquaDarkColor];
    [myView addSubview:moreInfo];
    
    CGRect frameBookmark = CGRectMake(margin, moreInfo.frame.size.height + moreInfo.frame.origin.y+margin*2, screenWidth-margin*2, screenHeight/14);
    bookmark = [[HTPressableButton alloc] initWithFrame:frameBookmark buttonStyle:HTPressableButtonStyleRounded];
    [bookmark setTitle:@"Bookmark" forState:UIControlStateNormal];
    [bookmark addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    bookmark.buttonColor = [UIColor ht_grapeFruitColor];
    bookmark.shadowColor = [UIColor ht_grapeFruitDarkColor];

    if ([[savedObjects allKeys] containsObject:[self.restuarantDetail objectForKey:@"name"]]) {
        bookmark.enabled = NO;
        [bookmark setTitle:@"Bookmarked" forState:UIControlStateDisabled];
        bookmark.disabledButtonColor = [UIColor ht_emeraldColor];
        bookmark.disabledShadowColor = [UIColor ht_nephritisColor];
        bookmark.alpha = 0.9;

    }

    [myView addSubview:bookmark];

    
   
    CGRect newFrame = myView.frame;
    
    newFrame.size.width = screenWidth;
    newFrame.size.height = bookmark.frame.origin.y + margin*8 +bookmark.frame.size.height;
    [myView setFrame:newFrame];
   
    return myView;
}

- (IBAction)moreInfoClicked:(id)sender {

    NSString *link = [self.restuarantDetail objectForKey:@"name"];
    link = [link stringByReplacingOccurrencesOfString:@" " withString:@""];
    link = [link stringByReplacingOccurrencesOfString:@"&" withString:@""];
    link = [link stringByReplacingOccurrencesOfString:@":" withString:@""];
    link = [NSString stringWithFormat:@"http://www.google.com/webhp?#q=%@&btnI=I", link];
    NSURL *inputURL = [[NSURL alloc] initWithString:link];
    NSString *scheme = inputURL.scheme;
    
    // Replace the URL Scheme with the Chrome equivalent.
    NSString *chromeScheme = nil;
    if ([scheme isEqualToString:@"http"]) {
        chromeScheme = @"googlechrome";
    } else if ([scheme isEqualToString:@"https"]) {
        chromeScheme = @"googlechromes";
    }
    
    // Proceed only if a valid Google Chrome URI Scheme is available.
    if (chromeScheme) {
        NSString *absoluteString = [inputURL absoluteString];
        NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
        NSString *urlNoScheme =
        [absoluteString substringFromIndex:rangeForScheme.location];
        NSString *chromeURLString =
        [chromeScheme stringByAppendingString:urlNoScheme];
        NSURL *chromeURL = [NSURL URLWithString:chromeURLString];
        
        // Open the URL with Chrome.
        [[UIApplication sharedApplication] openURL:chromeURL];
    }

    
}

- (void) isItOpen {
    NSInteger checkInt = [checkString integerValue];
    if (checkString == nil) {
        [openLabel setText:@"No hours found"];
        [openLabel setTextColor:[UIColor redColor]];
        [mon setText:@"Hours Not Available"];
    } else if (checkInt == 1) {
       // NSLog(@"yes");
        [openLabel setText:@"(Open Now)"];
        [openLabel setTextColor:[UIColor greenColor]];
    } else if (checkInt == 0){
      //  NSLog(@"yes");
        [openLabel setText:@"(Closed Now)"];
        [openLabel setTextColor:[UIColor redColor]];
    } else {
        [openLabel setText:@"No hours found"];
        [openLabel setTextColor:[UIColor redColor]];
    }
    
}

- (void) setTypeOfPlace {
    NSArray *types =[self.restuarantDetail objectForKey:@"types"];
    if ([types count] == 0) {
        [typeOfPlace setText:@"Unknown"];
    } else if ([types count] == 1) {
        [typeOfPlace setText:[NSString stringWithFormat:@"%@.", [inventory objectForKey:types[0]]]];
    } else if ([types count] == 2) {
        [typeOfPlace setText:[NSString stringWithFormat:@"%@, %@.", [inventory objectForKey:types[0]],
                              [inventory objectForKey:types[1]]]];
    } else if ([types count] >= 3) {
        [typeOfPlace setText:[NSString stringWithFormat:@"%@, %@, %@.", [inventory objectForKey:types[0]],
                              [inventory objectForKey:types[1]], [inventory objectForKey:types[2]]]];
    }
}


- (IBAction) mapsButtonClicked: (id)sender {
    //give the user a choice of Apple or Google Maps
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select your favorite Maps service" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Apple Maps",@"Google Maps", nil];
    [sheet showInView:self.view];
}

- (IBAction) backButtonClicked: (id)sender {
    [self performSegueWithIdentifier:@"returnToTable" sender:self];
}

- (IBAction) saveButtonClicked: (id)sender {
    if ([[savedObjects allKeys] containsObject:[self.restuarantDetail objectForKey:@"name"]]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                          message:[NSString stringWithFormat:@"You have already bookmarked %@.", [self.restuarantDetail objectForKey:@"name"]]
                                                         delegate:nil
                                                cancelButtonTitle:@"Okay"
                                                otherButtonTitles:nil];
        
        [message show];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Yay!"
                                                          message:[NSString stringWithFormat:@"%@ has been bookmarked.", [self.restuarantDetail objectForKey:@"name"]]
                                                         delegate:nil
                                                cancelButtonTitle:@"Okay"
                                                otherButtonTitles:nil];
        
        [message show];

        bookmark.enabled = NO;
        [bookmark setTitle:@"Bookmarked" forState:UIControlStateDisabled];
        bookmark.disabledButtonColor = [UIColor ht_aquaColor];
        bookmark.disabledShadowColor = [UIColor ht_aquaDarkColor];
        bookmark.alpha = 0.9;
    }

    [savedObjects setObject:strURL forKey:[self.restuarantDetail objectForKey:@"name"]];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.spontaneousWatch"];
    [defaults setObject:savedObjects forKey:@"bookmark"];
    [defaults synchronize];
    NSLog(@"Count : %lu", (unsigned long)savedObjects.count);
    
    
}

- (IBAction) backPull: (id)sender {
    NSLog(@"back pressed");
}

- (IBAction) phoneButtonClicked: (id)sender {
    tel = [tel stringByReplacingOccurrencesOfString:@"(" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@")" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
    tel = [tel stringByReplacingOccurrencesOfString:@"+" withString:@""];
     NSString *url = [NSString stringWithFormat:@"telprompt://%@", tel];
    //NSLog(@"%@", url);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
- (IBAction) uberButtonClicked: (id)sender {
    GPUberViewController *uber = [[GPUberViewController alloc] initWithServerToken:@"2DzGkraeNFHszDNHVs4-PlgHxbaZ3HpsezJwHiLm"];
    uber.startLocation = CLLocationCoordinate2DMake(locA.coordinate.latitude,locA.coordinate.longitude);
    uber.endLocation = CLLocationCoordinate2DMake(locB.coordinate.latitude,locB.coordinate.longitude);
    uber.startName = @"Current Location";
    uber.endName = [self.restuarantDetail objectForKey:@"name"];
    uber.clientId = @"3P9XPbKc3Xc5ovEL5gHIR7Ne7z196Hvo";
    [uber showInViewController:self];

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    CLLocationCoordinate2D rdOfficeLocation = CLLocationCoordinate2DMake([lat doubleValue],[lng doubleValue]);
    if (buttonIndex == 0) {
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:rdOfficeLocation addressDictionary:nil];
        MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
        item.name = [self.restuarantDetail objectForKey:@"name"];
        [item openInMapsWithLaunchOptions:nil];
    } else if (buttonIndex == 1) {
        googleURL = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%@,%@&directionsmode=driving", lat,lng]];
        //NSLog(@"%@", googleURL);
        if (![[UIApplication sharedApplication] canOpenURL:googleURL]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                              message:@"Google Maps not found on your device."
                                                             delegate:nil
                                                    cancelButtonTitle:@"Okay"
                                                    otherButtonTitles:nil];
            
            [message show];
        } else {
            [[UIApplication sharedApplication] openURL:googleURL];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSDictionary *tempDictionary = [tableArray objectAtIndex:0];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myCell"];
        //cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        
        
    }
    [reviewLabel setText: @""];
    reviewLabel.clearsContextBeforeDrawing = YES;
    NSString *text = [tempDictionary objectForKey:@"text"];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [reviewLabel setText:[NSString stringWithFormat:@"Most helpful review: \n%@\n- Review By %@", text,[tempDictionary objectForKey:@"author_name"]]];
    
    
    reviewLabel.clearsContextBeforeDrawing = YES;
    [mon setText:hoursArray[0]];
    [tues setText:hoursArray[1]];
    [wed setText:hoursArray[2]];
    [thurs setText:hoursArray[3]];
    [fri setText:hoursArray[4]];
    [sat setText:hoursArray[5]];
    [sun setText:hoursArray[6]];
    [infoLabel setText: addressString];
    return cell;
    
}

- (void)zoomToLocation
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = lat.doubleValue;
    zoomLocation.longitude= lng.doubleValue;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, .5*METERS_PER_MILE,.5*METERS_PER_MILE);
    [mapview setRegion:viewRegion animated:YES];
    
    [mapview regionThatFits:viewRegion];
}

- (MapViewAnnotation *)createAnnotation
{
    NSNumber *latitude = lat;
    NSNumber *longitude = lng;
    NSString *title = [self.restuarantDetail objectForKey:@"name"];
    
    //Create coordinates from the latitude and longitude values
    CLLocationCoordinate2D coord;
    coord.latitude = latitude.doubleValue;
    coord.longitude = longitude.doubleValue;
    
    MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coord];
    return annotation;
}



- (void)viewWillLayoutSubviews
{
    // if the view has navigation bar, this is a great place to realign the top part to allow navigation controller
    // or even the status bar
    [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
    
}

@end
