//
//  TableViewController.m
//  webTableView
//
//  Created by Avdeep Sahi on 2/19/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import "TableViewController.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "ASStarRatingView.h"
#import "UIImage+BlurredFrame.h"
#import "MapViewAnnotation.h"
#import "POP.h"
#import "MBProgressHUD.h"

#define METPAHMILE 1609.344
#define IS_a_IPHONE5 ([[UIScreen mainScreen] bounds].size.width == 568 || [[UIScreen mainScreen] bounds].size.height == 568)



@interface TableViewController () <MKMapViewDelegate>

@end

@implementation TableViewController {
    NSString *backgroundURL;
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSString *latitude;
    NSString *longitude;
    NSNumber *priceLevel;
    int random; // index
    NSMutableArray *visited;
    int count;
    NSInteger *numRows;
    CLLocationCoordinate2D center;
    ASStarRatingView *staticStarRatingView;
    UILabel *ratingNum;
    UILabel *openLabel;
    UILabel *mainLabel;
    UILabel *priceLabel;
    UIActivityIndicatorView *indicator;
    NSString *checkString;
    
    NSNumber *lat;
    NSNumber *lng;
    MKMapView *mapview;
    MapViewAnnotation *annotation;
    CGRect bounds;
    NSMutableArray *indexArray;
    int bgIndex;
    NSString *urlBase;

}

@synthesize type, city, radius, countIndicator, emptyTable, name, back, sortBy;

- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{


    [super viewDidLoad];
    if ([type  isEqual: @"restaurant"]||[type  isEqual: @"food"]||[type  isEqual: @"grocery_or_supermarket"]||[type  isEqual: @"meal_delivery"]||[type  isEqual: @"meal_takeaway"]||[type  isEqual: @"bar"]) {
        urlBase = @"http://www.reddit.com/r/foodporn/.json?";
        
    } else if ([type  isEqual: @"subway_station"]||[type  isEqual: @"taxi_stand"]||[type  isEqual: @"lodging"]||[type  isEqual: @"shopping_mall"]||[type  isEqual: @"clothing_store"]||[type  isEqual: @"department_store"]||[type  isEqual: @"movie_theater"]||[type  isEqual: @"night_club"]||[type  isEqual: @"bowling_alley"]||[type  isEqual: @"atm"]||[type  isEqual: @"gas_station"]||[type  isEqual: @"liquor_store"]) {
        urlBase = @"http://www.reddit.com/r/cityporn/.json?";
        
    } else if ([type  isEqual: @"zoo"]) {
        urlBase = @"http://www.reddit.com/r/animalporn/.json?";
        
    } else if ([type  isEqual: @"amusement_park"]) {
        urlBase = @"http://www.reddit.com/r/ridesporn/.json?";
        
    } else if ([type  isEqual: @"aquarium"]) {
        urlBase = @"http://www.reddit.com/r/waterporn/.json?";
        
    } else if ([type  isEqual: @"bakery"]||[type  isEqual: @"cafe"]) {
        urlBase = @"http://www.reddit.com/r/dessertporn/.json?";
        
    } else if ([type  isEqual: @"stadium"]) {
         urlBase = @"http://www.reddit.com/r/sportsporn/.json?";
        
    } else {
        urlBase = @"http://www.reddit.com/r/earthporn/.json?";
    }
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    random = 0;

    UIImage *img = [UIImage imageNamed:@"tableImage.png"];
    CGRect frame = CGRectMake(0,0, 5000, 5000);
    img = [img applyLightEffectAtFrame:frame];
    

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:img];

    visited = [[NSMutableArray alloc] init];


    count = 1;
    self.googlePlacesArrayFromAFNetworking = [[NSArray alloc] init];
    indexArray = [[NSMutableArray alloc] init];
    self.tmp = [[NSArray alloc] init];
    // Configure the new event with information from the location
    //NSLog(@"%@", city);
    if (![city  isEqual: @""]) {
        CLLocationCoordinate2D acenter = [self getLocationFromAddressString:city];
        //NSLog(@"%f", acenter.longitude);
        longitude = [NSString stringWithFormat:@"%f", acenter.longitude];
        latitude = [NSString stringWithFormat:@"%f", acenter.latitude];
    } else {
        //todo: send an alert of no location
    }
    emptyTable.text = @"Looks like there's nothing here! Increase your search radius and try again.";
    countIndicator.text = @"";
    [self makeRestuarantsRequests];
    
    mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,
                                                          self.tableView.frame.size.height/17,
                                                          self.view.frame.size.width,
                                                          40)];
    [mainLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:27.f]];
    [mainLabel setBackgroundColor:[UIColor clearColor]];
    [mainLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [mainLabel setNumberOfLines:0];
    [mainLabel setTextColor:[UIColor whiteColor]];

    
    staticStarRatingView = [[ASStarRatingView alloc]initWithFrame:CGRectMake(10,
                                                                             10+mainLabel.frame.size.height+mainLabel.frame.origin.y,
                                                                             self.view.frame.size.width/2,
                                                                             17)];
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 50, 20, 20)];
    [indicator setAlpha:0];
    [indicator startAnimating];
    
    ratingNum = [[UILabel alloc] initWithFrame:CGRectMake(staticStarRatingView.frame.size.width+7,
                                                          staticStarRatingView.frame.origin.y+2,
                                                          self.view.frame.size.width/2,
                                                          17)];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(18,
                                                           ratingNum.frame.origin.y+ratingNum.frame.size.height+12,
                                                           self.view.frame.size.width/2,
                                                           17)];
    [priceLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.f]];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    [priceLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [priceLabel setNumberOfLines:0];
    [priceLabel setTextColor:[UIColor whiteColor]];
    
    openLabel = [[UILabel alloc] initWithFrame:CGRectMake(18,
                                                          priceLabel.frame.origin.y+priceLabel.frame.size.height+12,
                                                          self.view.frame.size.width/2,
                                                          17)];
    [openLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.f]];
    [openLabel setBackgroundColor:[UIColor clearColor]];
    [openLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [openLabel setNumberOfLines:0];
    [openLabel setTextColor:[UIColor whiteColor]];
    if (IS_a_IPHONE5) {
        mapview = [[MKMapView alloc] initWithFrame:CGRectMake(5, openLabel.frame.size.height + openLabel.frame.origin.y+ 50, screenWidth-10, screenWidth/1.5)];
    } else {
        mapview = [[MKMapView alloc] initWithFrame:CGRectMake(5, openLabel.frame.size.height + openLabel.frame.origin.y+ 50, screenWidth-10, screenWidth/1.25)];
    }
    mapview.delegate = self;
    [self.view addSubview:mapview];
    
    
    CGRect framePrev = CGRectMake(5, mapview.frame.origin.y+mapview.frame.size.height+15, (self.view.frame.size.width/2)-5, self.view.frame.size.height/14);
    prev = [[HTPressableButton alloc] initWithFrame:framePrev buttonStyle:HTPressableButtonStyleRounded];
    [prev setTitle:@"Back" forState:UIControlStateNormal];
    [prev addTarget:self action:@selector(searchPrev:) forControlEvents:UIControlEventTouchUpInside];
    prev.buttonColor = [UIColor ht_aquaColor];
    prev.shadowColor = [UIColor ht_aquaDarkColor];
    [self.view addSubview:prev];
    
    CGRect frameDirections = CGRectMake(prev.frame.origin.x+prev.frame.size.width+5, mapview.frame.origin.y+mapview.frame.size.height+15, (self.view.frame.size.width/2)-10, self.view.frame.size.height/14);
    next = [[HTPressableButton alloc] initWithFrame:frameDirections buttonStyle:HTPressableButtonStyleRounded];
    [next setTitle:@"Next" forState:UIControlStateNormal];
    [next addTarget:self action:@selector(searchNext:) forControlEvents:UIControlEventTouchUpInside];
    next.buttonColor = [UIColor ht_grapeFruitColor];
    next.shadowColor = [UIColor ht_grapeFruitDarkColor];
    [self.view addSubview:next];
    

    [countIndicator setFrame:CGRectMake(0, openLabel.frame.origin.y+openLabel.frame.size.height, self.view.frame.size.width, 60)];
    [countIndicator setNumberOfLines:0];
    [countIndicator setText:@"No places found :("];
    [countIndicator setAlpha:0];
    prev.enabled = NO;
    next.enabled = NO;
    [prev setTitle:@"Back" forState:UIControlStateDisabled];
    [next setTitle:@"Next" forState:UIControlStateDisabled];
    [countIndicator setFont:[UIFont fontWithName:@"Avenir-Medium" size:20.f]];
    [countIndicator setBackgroundColor:[UIColor clearColor]];
    [countIndicator setTextColor:[UIColor whiteColor]];
    [self performSelector:@selector(nofound) withObject:nil afterDelay:1.5];
    
}
-(void) nofound {
    [countIndicator setAlpha:1];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double alat = 0, lon = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&alat];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&lon];
            }
        }
    }
    center.latitude = alat;
    center.longitude = lon;
    return center;
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

#pragma mark - AFNetworking


-(void)makeRestuarantsRequests{
    NSString *strURL = @"";
    if ([radius  isEqual: @""]) {
        radius = @"4828.03";
    } else {
        int i = [radius intValue];
        i = i*1609.34; // miles to meters
        radius = [NSString stringWithFormat:@"%d", i];
    }
    

    name = [name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=%@&types=%@&name=%@&key=AIzaSyCWdd64ipGOgXNIZjPSJKK2xsGQUJigDgk", latitude, longitude, radius, type, name];
    

        
    
    
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSLog(@"request is: %@", strURL);
    

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:[url absoluteString]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             
             self.googlePlacesArrayFromAFNetworking = [responseObject objectForKey:@"results"];
             NSMutableArray*arr = [[NSMutableArray alloc] init];
             for (int i =0; i < self.googlePlacesArrayFromAFNetworking.count; i++) {
                 [arr addObject:[self.googlePlacesArrayFromAFNetworking objectAtIndex:i]];
             }
             
             if  ([sortBy  isEqual: @"Price"]) {
                 
                 long caount = arr.count;
                 int i;
                 bool swapped = TRUE;
                 while (swapped){
                     swapped = FALSE;
                     for (i=1; i<caount;i++)
                     {
                         NSDictionary*prev = [arr objectAtIndex:(i-1)];
                         NSDictionary*curr = [arr objectAtIndex:i];
                         NSNumber *currNum;
                         NSNumber *prevNum;
                         if([prev objectForKey:@"price_level"] == NULL) {
                             prevNum = [NSNumber numberWithInt: 10];
                         } else {
                             prevNum = [prev objectForKey:@"price_level"];
                         }
                         if([curr objectForKey:@"price_level"] == NULL) {
                             currNum = [NSNumber numberWithInt: 10];
                         } else {
                             currNum = [curr objectForKey:@"price_level"];
                         }
                         
                         
                         if ([prevNum doubleValue] > [currNum doubleValue])
                         {
                             [arr exchangeObjectAtIndex:(i-1) withObjectAtIndex:i];
                             swapped = TRUE;
                         }
                         
                     }
                 }
                 self.googlePlacesArrayFromAFNetworking = arr;
             }
             if  ([sortBy  isEqual: @"Rating"]) {
                 long caount = arr.count;
                 int i;
                 bool swapped = TRUE;
                 while (swapped){
                     swapped = FALSE;
                     for (i=1; i<caount;i++)
                     {
                         NSDictionary*prev = [arr objectAtIndex:(i-1)];
                         NSDictionary*curr = [arr objectAtIndex:i];
                         NSNumber *currNum;
                         NSNumber *prevNum;
                         if([prev objectForKey:@"rating"] == NULL) {
                             prevNum = [NSNumber numberWithInt: -1];
                         } else {
                             prevNum = [prev objectForKey:@"rating"];
                         }
                         if([curr objectForKey:@"rating"] == NULL) {
                             currNum = [NSNumber numberWithInt: -1];
                         } else {
                             currNum = [curr objectForKey:@"rating"];
                         }
                         
                         
                         if ([prevNum doubleValue] < [currNum doubleValue])
                         {
                             [arr exchangeObjectAtIndex:(i-1) withObjectAtIndex:i];
                             swapped = TRUE;
                         }
                         
                     }
                 }
                 self.googlePlacesArrayFromAFNetworking = arr;
             }
             
             [self.tableView reloadData];
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                               message:[NSString stringWithFormat:@"Request Failed with Error: %@, %@", error, error.userInfo]
                                                              delegate:nil
                                                     cancelButtonTitle:@"Okay"
                                                     otherButtonTitles:nil];
             
             [message show];
         }];
    
    AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
//    [manager2 GET:@"http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US"
//       parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSDictionary *jsonArr = responseObject;
//              NSArray *newArr = [jsonArr objectForKey:@"images"];
//              NSDictionary *innerDict = [newArr objectAtIndex: 0];
//              backgroundURL = [innerDict objectForKey:@"url"];
//              backgroundURL = [@"http://www.bing.com" stringByAppendingString:backgroundURL];
//              [self setURL];
//              
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//          }];
    //bgIndex = arc4random() % 5;
    bgIndex = 1;
    NSLog(@"base url is: %@", urlBase);
    [manager2 GET:urlBase
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary *jsonDict = [responseObject objectForKey:@"data"];
              NSArray *jsonArr = [jsonDict objectForKey:@"children"];
              NSDictionary *dictNeeded = [jsonArr objectAtIndex:bgIndex];
              NSDictionary *tmp = [dictNeeded objectForKey:@"data"];
              backgroundURL = [tmp objectForKey:@"url"];
              NSString *title = [tmp objectForKey:@"title"];
            if ([title containsString:@"["]) {
                  NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
                  NSArray *splitString = [title componentsSeparatedByCharactersInSet:delimiters];
                  NSLog(@"in here");
                  NSString *checker = [splitString objectAtIndex:[splitString count]-2];
                  if ([checker  containsString: @"X"]) {
                      NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"X"];
                      NSArray *str = [checker componentsSeparatedByCharactersInSet:delimiters];
                      NSInteger *int1 = [[[str objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      NSLog(@"in here 2");
                      
                      NSInteger *int2 = [[[str objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      NSInteger * check = 4000;
                      if (int1 >= check || int2 >= check) {
                          backgroundURL = @"https://drscdn.500px.org/photo/52866292/m=2048_k=1_a=1/2683707825210f5bb6d26e7c32d14738";
                      }
                  } else if ([checker containsString:@"x"]) {
                      NSLog(@"in here3");
                      NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"x"];
                      NSArray *str = [checker componentsSeparatedByCharactersInSet:delimiters];
                      for (NSString *string in str) {
                          NSLog(@"content: %@", string);
                      }
                      NSInteger *int1 = [[[str objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      
                      NSInteger *int2 = [[[str objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      NSInteger * check = 4000;
                      if (int1 >= check || int2 >= check) {
                          
                          backgroundURL = @"https://drscdn.500px.org/photo/52866292/m=2048_k=1_a=1/2683707825210f5bb6d26e7c32d14738";
                      }
                  } else {
                      backgroundURL = @"https://drscdn.500px.org/photo/52866292/m=2048_k=1_a=1/2683707825210f5bb6d26e7c32d14738";
                  }
              } else if ([title containsString:@"("]) {
                  NSLog(@"in here4");
                  NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"()"];
                  NSArray *splitString = [title componentsSeparatedByCharactersInSet:delimiters];
                  
                  NSString *checker = [splitString objectAtIndex:[splitString count]-2];
                  if ([checker  containsString: @"X"]) {
                      NSLog(@"in here5");
                      NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"X"];
                      NSArray *str = [checker componentsSeparatedByCharactersInSet:delimiters];
                      NSInteger *int1 = [[[str objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      
                      NSInteger *int2 = [[[str objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      NSInteger * check = 4000;
                      if (int1 >= check || int2 >= check) {
                          backgroundURL = @"https://drscdn.500px.org/photo/52866292/m=2048_k=1_a=1/2683707825210f5bb6d26e7c32d14738";
                      }
                  } else if ([checker containsString:@"x"]) {
                      NSLog(@"in here6");
                      NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"x"];
                      NSArray *str = [checker componentsSeparatedByCharactersInSet:delimiters];
                      NSInteger *int1 = [[[str objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      
                      NSInteger *int2 = [[[str objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      NSInteger * check = 4000;
                      if (int1 >= check || int2 >= check) {
                          backgroundURL = @"https://drscdn.500px.org/photo/52866292/m=2048_k=1_a=1/2683707825210f5bb6d26e7c32d14738";
                      }
                  } else {
                      backgroundURL = @"https://drscdn.500px.org/photo/52866292/m=2048_k=1_a=1/2683707825210f5bb6d26e7c32d14738";
                  }
              } else {
                  backgroundURL = @"https://drscdn.500px.org/photo/52866292/m=2048_k=1_a=1/2683707825210f5bb6d26e7c32d14738";
              }
              
              // NSLog(@"checker is: %@", checker);
              while ([backgroundURL containsString:@"www.flickr.com"]) {
                  bgIndex++;
                  dictNeeded = [jsonArr objectAtIndex:bgIndex];
                  tmp = [dictNeeded objectForKey:@"data"];
                  backgroundURL = [tmp objectForKey:@"url"];
                  
              }
              if ([backgroundURL containsString:@"http://imgur.com"]) {
                  backgroundURL= [backgroundURL substringFromIndex:17];
                  backgroundURL = [@"http://i.imgur.com/" stringByAppendingString:backgroundURL];
                  backgroundURL = [backgroundURL stringByAppendingString:@".jpg"];
                  NSLog(@"%@", backgroundURL);
              }
              //              NSArray *newArr = [jsonArr objectForKey:@"images"];
              //              NSDictionary *innerDict = [newArr objectAtIndex: 0];
              //              backgroundURL = [innerDict objectForKey:@"url"];
              //              backgroundURL = [@"http://www.bing.com" stringByAppendingString:backgroundURL];
              
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          }];

    [MBProgressHUD hideHUDForView:self.view animated:YES];

   
    

    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.googlePlacesArrayFromAFNetworking count] == 0) {
        numRows = 0;
        
    } else {
        numRows = 1;
        
    }
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    emptyTable.text = @"";
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if ([self.googlePlacesArrayFromAFNetworking count] == 0) { // if divide by 0 occurs
        random = arc4random() % 1;
    } else {
        if ([sortBy  isEqual: @"Random"]) {
            random = arc4random() % (int)[self.googlePlacesArrayFromAFNetworking count];
        } else if  ([sortBy  isEqual: @"Rating"]) {
            random = 0;
        } else if  ([sortBy  isEqual: @"Price"]) {
            random = 0;
        } else if  ([sortBy  isEqual: @"Popularity"]) {
            random = 0;
        }
        
    }
    
    
    NSDictionary *tempDictionary = [self.googlePlacesArrayFromAFNetworking objectAtIndex:random];
    while([visited containsObject: [self.googlePlacesArrayFromAFNetworking objectAtIndex:random]] ) {
        if ([sortBy  isEqual: @"Random"]) {
            random = arc4random() % (int)[self.googlePlacesArrayFromAFNetworking count];
        } else if  ([sortBy  isEqual: @"Rating"]) {
            random++;
        } else if  ([sortBy  isEqual: @"Price"]) {
            random++;
        } else if  ([sortBy  isEqual: @"Popularity"]) {
            random++;
        }
        
        
    }
    tempDictionary = [self.googlePlacesArrayFromAFNetworking objectAtIndex:random];
    if ((unsigned long)[visited count] >= (unsigned long)[self.googlePlacesArrayFromAFNetworking count]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                          message:@"This is the last result. Go back and expand your search criteria so we can find the right place for you."
                                                         delegate:nil
                                                cancelButtonTitle:@"Okay"
                                                otherButtonTitles:nil];
        
        [message show];
        return cell;
    }

    NSLog(@"%d", random);
    countIndicator.text = [NSString stringWithFormat:@"Result %d of %lu", count, (unsigned long)[self.googlePlacesArrayFromAFNetworking count]];
    if ([self.googlePlacesArrayFromAFNetworking count] == 0) {
         self.navigationController.navigationBar.topItem.title = @"No Places Found :(";
        next.enabled = NO;
        [next setTitle:@"Next" forState:UIControlStateDisabled];
        prev.enabled = NO;
        [prev setTitle:@"Back" forState:UIControlStateDisabled];

    } else {
         self.navigationController.navigationBar.topItem.title =  [NSString stringWithFormat:@"Result %d of %lu", count, (unsigned long)[self.googlePlacesArrayFromAFNetworking count]];
        next.enabled = YES;
        prev.enabled = YES;
        [next setTitle:@"Next" forState:UIControlStateDisabled];

        if (count == (unsigned long)[self.googlePlacesArrayFromAFNetworking count]) {
            next.enabled = NO;
            [next setTitle:@"Next" forState:UIControlStateDisabled];
        }
        if (count <= 1) {
            prev.enabled = NO;
            [prev setTitle:@"Back" forState:UIControlStateDisabled];
        }
    }
   
    
    lat = [[[tempDictionary objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
    lng = [[[tempDictionary objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
    mapview.scrollEnabled = YES;

    NSString *title = [tempDictionary objectForKey:@"vicinity"];
    
    //Create coordinates from the latitude and longitude values
    CLLocationCoordinate2D coord;
    coord.latitude = lat.doubleValue;
    coord.longitude = lng.doubleValue;
    
    annotation = [[MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coord];
    [mapview addAnnotation:annotation];
    [mapview selectAnnotation:[[mapview annotations] objectAtIndex:0] animated:YES];
    [self zoomToLocation];
    
    mainLabel.text = [tempDictionary objectForKey:@"name"];
    staticStarRatingView.canEdit = NO;
    staticStarRatingView.maxRating = 5;

    if ([tempDictionary objectForKey:@"price_level"]) {
        priceLevel = [tempDictionary objectForKey:@"price_level"];
    } else {
        priceLevel = [NSNumber numberWithInt:-1];
    }
    NSNumber *value = [tempDictionary objectForKey:@"rating"];
        if([tempDictionary objectForKey:@"rating"] != NULL)
        {
            //mainLabel.text = [NSString stringWithFormat:@"Rating: %@ of 5",value];
            staticStarRatingView.rating = [value doubleValue];
        }
        else
        {
            //mainLabel.text = [NSString stringWithFormat:@"Not Rated"];
            staticStarRatingView.rating = 0;
        }
    [self.view addSubview:mainLabel];
    [self.view addSubview:staticStarRatingView];
    
   

    [ratingNum setFont:[UIFont fontWithName:@"Avenir-Medium" size:18.f]];
    [ratingNum setBackgroundColor:[UIColor clearColor]];
    [ratingNum setTextColor:[UIColor whiteColor]];
    [ratingNum setLineBreakMode:NSLineBreakByWordWrapping];
    [ratingNum setNumberOfLines:0];
    [ratingNum setText:@""];
    if([tempDictionary objectForKey:@"rating"] != NULL) {
        [ratingNum setText: [NSString stringWithFormat:@"%@", [value stringValue]]];
        [ratingNum setTextColor:[UIColor colorWithRed:0.996 green:0.702 blue:0.02 alpha:1]];
        staticStarRatingView.rating = [value doubleValue];
    }
    [self.view addSubview:ratingNum];
    checkString = [[tempDictionary objectForKey:@"opening_hours"] objectForKey:@"open_now"];
    [self isItOpen];
    [self.view addSubview:openLabel];
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
    [self.view addSubview:priceLabel];

    return cell;
    
}
     
     
     - (void) isItOpen {
         NSInteger checkInt = [checkString integerValue];
         if (checkString == nil) {
             [openLabel setText:@""];
             [openLabel setTextColor:[UIColor redColor]];
        } else if (checkInt == 1) {
            // NSLog(@"yes");
             [openLabel setText:@"Open Now"];
             [openLabel setTextColor:[UIColor greenColor]];
         } else if (checkInt == 0){
             //NSLog(@"yes");
             [openLabel setText:@"Closed Now"];
             [openLabel setTextColor:[UIColor redColor]];
         } else {
             [openLabel setText:@""];
             [openLabel setTextColor:[UIColor redColor]];
         }
         
     }
#pragma mark - Prepare For Segue

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:@selector(segue) withObject:nil afterDelay:.1];
    
}
- (void) segue{
    [self performSegueWithIdentifier:@"viewController" sender:self];

    
}
- (IBAction)searchPrev:(id)sender {
    [visited removeLastObject];
    if ((unsigned long)[visited count] < (unsigned long)[self.googlePlacesArrayFromAFNetworking count])
    {
        [mapview removeAnnotation:annotation];
    }
    count--;
    NSLog(@"%lu", (unsigned long)[indexArray count]);
    random = [indexArray objectAtIndex:count-1];
    

    [self.tableView reloadData];
}

- (IBAction)searchNext:(id)sender {
    if ([self.googlePlacesArrayFromAFNetworking count] == 0) { // if divide by 0 occurs
        random = arc4random() % 1;
    } else {
        if ((unsigned long)[visited count] < (unsigned long)[self.googlePlacesArrayFromAFNetworking count]) {
            [mapview removeAnnotation:annotation];
        }
        NSDictionary *tempDictionary = [self.googlePlacesArrayFromAFNetworking objectAtIndex:random];
        while([visited containsObject: [self.googlePlacesArrayFromAFNetworking objectAtIndex:random]] ) {
            if ([sortBy  isEqual: @"Random"]) {
                random = arc4random() % (int)[self.googlePlacesArrayFromAFNetworking count];
            } else if  ([sortBy  isEqual: @"Rating"]) {
                random++;
            } else if  ([sortBy  isEqual: @"Price"]) {
                random++;
               
            } else if  ([sortBy  isEqual: @"Popularity"]) {
                random++;
                
            }
            
            tempDictionary = [self.googlePlacesArrayFromAFNetworking objectAtIndex:random];
            
            
        }
        
        
        
    }
    [visited addObject:[self.googlePlacesArrayFromAFNetworking objectAtIndex:random]]; // add to visited array
    [indexArray addObject:[NSNumber numberWithInt:random]];
    if (count <= 0) {
        count = 1;
    } else {
        count++;
    }

    [self.tableView reloadData];
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewController"]) {
       

        ViewController *detailViewController = (ViewController *)segue.destinationViewController;
        //set NSDictionary Item restuarantDetail in detailViewController
        detailViewController.restuarantDetail = [self.googlePlacesArrayFromAFNetworking objectAtIndex:random];
        detailViewController.initialType = type;
        detailViewController.center = center;
        detailViewController.city = city;
        //backgroundURL = [@"https://" stringByAppendingString:backgroundURL];
        //NSLog(@"print here: %@", backgroundURL);
        detailViewController.backgroundURL = backgroundURL;

    }
}

- (void)zoomToLocation
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = lat.doubleValue;
    zoomLocation.longitude= lng.doubleValue;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, .5*METPAHMILE,.5*METPAHMILE);
    [mapview setRegion:viewRegion animated:YES];
    
    //[mapview regionThatFits:viewRegion];
    
}









@end
