//
//  MainViewController.m
//  webTableView
//
//  Created by Avdeep Sahi on 2/18/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import "MainViewController.h"
#import "TableViewController.h"
#import "BookmarkViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImage+BlurredFrame.h"
#import "POP.h"
#import "MBProgressHUD.h"
#import "ASValueTrackingSlider.h"
#import "SWRevealViewController.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.width == 568 || [[UIScreen mainScreen] bounds].size.height == 568)
#define STEP_DURATION 0.01



@interface MainViewController () <ASValueTrackingSliderDataSource>
{
    NSArray *keys;
    NSInteger selected;
    NSString *currVal;
    UIGestureRecognizer *tapper;
    NSString *currAddress;
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSString *sliderVal;
}
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider1;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation MainViewController 

@synthesize inventory, noConnection;


- (void)viewDidLoad {
    [super viewDidLoad];
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {
//        [self.sidebarButton setTarget: self.revealViewController];
//        [self.sidebarButton setAction: @selector( openFavorites: )];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }
    // customize slider 3
    NSNumberFormatter *tempFormatter = [[NSNumberFormatter alloc] init];
    [tempFormatter setPositiveSuffix:@""];
    
    self.slider1.dataSource = self;
    [self.slider1 setNumberFormatter:tempFormatter];
    self.slider1.minimumValue = 1;
    self.slider1.maximumValue = 35;
    //self.slider1.popUpViewCornerRadius = 3;
    self.slider1.value = 3;
    
    self.slider1.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:26];
    self.slider1.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    UIColor *coldBlue = [UIColor colorWithRed:0.00 green:1.00 blue:1.00 alpha:1.0];
    UIColor *blue = [UIColor colorWithRed:0.64 green:0.76 blue:0.96 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:0.71 green:0.84 blue:0.66 alpha:1.0];
    UIColor *yellow = [UIColor colorWithRed:0.93 green:0.93 blue:0.04 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:0.98 green:0.38 blue:0.38 alpha:1.0];
    
    [self.slider1 setPopUpViewAnimatedColors:@[blue, coldBlue, green, yellow, red]
                               withPositions:@[@0, @8, @16, @23, @35]];
    
    currVal = @"oops";
     self.navigationController.navigationBar.topItem.title = @"Spontaneous";
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        noConnection = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                          message:@"Spontaneous needs location services enabled to work correctly."
                                                         delegate:self
                                                cancelButtonTitle:@"Settings"
                                                otherButtonTitles:nil];
        
        [noConnection show];
    }

    //self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    //navigation bar work
   // [self addBlurEffect];

    self.navigationController.navigationBar.tintColor =UIColorFromRGB(0x067AB5);
   
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    

    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    geocoder = [[CLGeocoder alloc] init];

    inventory = [NSDictionary dictionaryWithObjects:@[ @"amusement_park", @"aquarium", @"art_gallery", @"atm", @"bakery",  @"bar",  @"bowling_alley", @"cafe",  @"car_rental", @"casino",  @"clothing_store" , @"department_store",  @"florist", @"food",  @"gas_station", @"grocery_or_supermarket", @"gym", @"hair_care", @"library", @"liquor_store", @"lodging", @"meal_delivery", @"meal_takeaway",  @"movie_rental", @"movie_theater", @"museum", @"night_club", @"park", @"restaurant",   @"shopping_mall", @"spa", @"stadium", @"subway_station",    @"zoo", @"taxi_stand", @"store"] forKeys:@[ @"Amusement Park", @"Aquarium", @"Art Gallery", @"ATM", @"Bakery", @"Bar",   @"Bowling Alley",  @"Cafe",    @"Car Rental", @"Casino",  @"Clothing Store" ,  @"Department Store",  @"Florist", @"Food",  @"Gas Station", @"Supermarket", @"Gym", @"Hair Care", @"Library", @"Liquor Store", @"Hotel", @"Meal Delivery", @"Meal Takeaway", @"Movie Rental", @"Movie Theater",  @"Museum", @"Night Club",  @"Park",  @"Restaurant", @"Shopping Mall", @"Spa", @"Stadium", @"Subway Station", @"Zoo", @"Taxi", @"Store"]];
    keys = [inventory allKeys];
   
    keys = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    [tmp insertObject:@"Select a type of place below" atIndex:0];
    for (NSString *string in keys) {
        [tmp addObject:string];

    }
    keys = tmp;

    [city setTextColor:[UIColor colorWithRed:84.0f/255.0f green:140.0f/255.0f blue:226.0f/255.0f alpha:1.0]];
    // Do any additional setup after loading the view
    [picker setAlpha:0];
    picker.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y ,self.view.frame.size.width, 162);
    
    
    [name setAlpha:0];
    name.frame = CGRectMake(self.view.frame.origin.x, picker.frame.origin.y + picker.frame.size.height+5, self.view.frame.size.width, 44);
    [bottom1 setAlpha:0];
    bottom1.frame = CGRectMake(self.view.frame.origin.x, picker.frame.origin.y + picker.frame.size.height+5 ,self.view.frame.size.width, 44);
    
    [location setAlpha:0];
    location.frame = CGRectMake(self.view.frame.size.width-41, name.frame.origin.y + name.frame.size.height+2 ,38, 40);
    [city setAlpha:0];
    city.frame = CGRectMake(self.view.frame.origin.x, name.frame.origin.y + name.frame.size.height ,self.view.frame.size.width-42, 44);
    [top2 setAlpha:0];
    top2.frame = CGRectMake(self.view.frame.origin.x, name.frame.origin.y + name.frame.size.height,self.view.frame.size.width, 44);
    
    
    [bottom2 setAlpha:0];
    bottom2.frame = CGRectMake(self.view.frame.origin.x, city.frame.origin.y + city.frame.size.height ,self.view.frame.size.width, 44);
    [label setAlpha:0];
    label.frame = CGRectMake(self.view.frame.origin.x+10, city.frame.origin.y + city.frame.size.height ,65, 44);
    [_slider1 setAlpha:0];
    _slider1.frame = CGRectMake(self.view.frame.origin.x+label.frame.size.width+5, city.frame.origin.y + city.frame.size.height ,self.view.frame.size.width-80, 44);
    
    [control setAlpha:0];
    control.frame = CGRectMake(self.view.frame.origin.x, _slider1.frame.origin.y+10 + _slider1.frame.size.height ,self.view.frame.size.width, 40);
    

    
    [vistaLogo setAlpha:0];
    [Loadimageview setAlpha:0];
    [Loadimageview setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [AnitmationimageView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    if (IS_IPHONE5) {
        [vistaLogo setFrame:CGRectMake(self.view.frame.size.width/2-screenWidth/6, self.view.frame.size.height/3, screenWidth/3, screenWidth/3)];
    } else {
        [vistaLogo setFrame:CGRectMake(self.view.frame.size.width/2-screenWidth/4, self.view.frame.size.height/3, screenWidth/2, screenWidth/2)];
    }
    
    [vistaLogo setAlpha:1];
    vistaLogo.userInteractionEnabled = YES;
    [vistaLogo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fun:)]];
    [AnitmationimageView setAlpha:1];
    [top1 setAlpha:0];
    [self performSelector:@selector(logoYcampos) withObject:nil afterDelay:1.5];

    [city setDelegate:self];
    [name setDelegate:self];
    

}
-(IBAction)openFavorites:(id)sender {
    [self performSegueWithIdentifier:@"bookmarks" sender:self];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Settings"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    selected = row;
    NSString *currKey = [keys objectAtIndex:selected];
    NSLog(@"%@", currKey);
    if ([currKey  isEqual: @"Select a type of place below"]) {
        currVal = @"oops";
    } else {
        currVal = [inventory objectForKey:currKey];
    }
   

}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [keys count];
}


// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [keys objectAtIndex:row];
}

//// tell the picker the width of each row for a given component
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    int sectionWidth = 300;
//    
//    return sectionWidth;
//}


- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
    
    
}
-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}



-(IBAction)fun:(id)sender {
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(5, 5)];
    sprintAnimation.springBounciness = 25.f;
    [vistaLogo pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
//    if ([searchBar.text  isEqual: @""]) {
//        [self performSelector:@selector(searchDB) withObject:nil afterDelay:.85];
//    } else
    if ([city.text  isEqual: @""]) {
        [self performSelector:@selector(cityDB) withObject:nil afterDelay:.85];
    } else if ([currVal isEqual:@"oops"]) {
        [self performSelector:@selector(pickerDB) withObject:nil afterDelay:.85];
    } else {
        [self performSelector:@selector(indicatorDB) withObject:nil afterDelay:.2];
        [self performSelector:@selector(elseDB) withObject:nil afterDelay:.85];
    }
}
-(void) indicatorDB{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading...";
}
-(void)pickerDB {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                      message:@"Select a type of place before searching!"
                                                     delegate:nil
                                            cancelButtonTitle:@"Okay"
                                            otherButtonTitles:nil];
    
    [message show];
}

-(void) searchDB{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                      message:@"Enter a type of place before searching!"
                                                     delegate:nil
                                            cancelButtonTitle:@"Okay"
                                            otherButtonTitles:nil];
    
    [message show];

}

-(void) cityDB{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                      message:@"Enter a city or select your current location before searching!"
                                                     delegate:nil
                                            cancelButtonTitle:@"Okay"
                                            otherButtonTitles:nil];
    
    [message show];

}

-(void) elseDB{
    
    [self performSegueWithIdentifier:@"segueToTable" sender:self];

}


-(void)logoYcampos{
    
    city.autocorrectionType = UITextAutocorrectionTypeYes;
    name.autocorrectionType = UITextAutocorrectionTypeYes;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    if (IS_IPHONE5) {
        [vistaLogo setFrame:CGRectMake(self.view.frame.size.width/2-screenWidth/6,self.view.frame.size.height-vistaLogo.frame.size.height-20,screenWidth/3,screenWidth/3)];
    } else {
        [vistaLogo setFrame:CGRectMake(self.view.frame.size.width/2-screenWidth/4,self.view.frame.size.height-vistaLogo.frame.size.height-20,screenWidth/2,screenWidth/2)];
    }
    [UIView commitAnimations];
    [self performSelector:@selector(finalAnimate) withObject:nil afterDelay:1.5];

    
}

//- (IBAction)onBurger:(id)sender {
//    NSArray *images = @[
//                        [UIImage imageNamed:@"star"],
//                        [UIImage imageNamed:@"globe"],
//                        [UIImage imageNamed:@"profile"],
//                        [UIImage imageNamed:@"gear"],
//                  
//                        
//                        ];
//    NSArray *colors = @[
//                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
//                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
//                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
//                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
//
//                        ];
//    
//    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
//    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
//    callout.delegate = self;
//    //    callout.showFromRight = YES;
//    [callout show];
//}







-(void) finalAnimate {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:3];
    [picker setAlpha:1];
    [label setAlpha:1];
    //[searchBar setAlpha:1];
    [name setAlpha:1];
    [location setAlpha:1];
    [top2 setAlpha:1];
    [bottom1 setAlpha:1];
    [_slider1 setAlpha:1];
    [city setAlpha:1];
    [control setAlpha:1];
    [bottom2 setAlpha:1];
    UIImage *img = [UIImage imageNamed:@"1.png"];
    CGRect frame = CGRectMake(0,0, 5000, 5000);
//    [city addTarget:self
//                  action:@selector(displayText:)
//        forControlEvents:UIControlEventEditingDidEnd];
    

    
    img = [img applyLightEffectAtFrame:frame];
  
    
    Loadimageview.image = img;
   
    
    [AnitmationimageView setAlpha:0];
    [Loadimageview setAlpha:1];
    [UIView commitAnimations];

}





//- (IBAction)displayText:(id)sender {
//    
//
//}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [city resignFirstResponder];
    [name resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.28];
    [UIView commitAnimations];
    
    
//    UITouch *myTouch = [touches anyObject];
//    
//    CGPoint aPoint = [myTouch locationInView:self.view];
//    
//    if(aPoint.y > control.frame.size.height + control.frame.origin.y) {
//        if (![searchBar.text  isEqual: @""] && ![currAddress  isEqual: @""]) {
//            //[HUD showUIBlockingIndicatorWithText:@"Shake to search!" withTimeout:2];
//            [HUD showTimedAlertWithTitle:@"Shake to Search" text:nil withTimeout:2];
//        }
//    }
}

- (IBAction)getCurrentLocation:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
    
    
}




//mover los campos y logo al mismo tiempo que el  teclado aparece
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.28];
        [UIView commitAnimations];

    return YES;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField) {
        [textField resignFirstResponder];
    }
    return NO;
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    // Reverse Geocoding
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
             NSLog(@"no error");
            placemark = [placemarks lastObject];
            currAddress = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
            if (![currAddress  isEqual: @""]) {
                city.text = @"Current Location";
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
            }
        } else {
            NSLog(@"error");
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                              message:error.description
                                                             delegate:nil
                                                    cancelButtonTitle:@"Okay"
                                                    otherButtonTitles:nil];
            
            [message show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } ];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    if (motion == UIEventSubtypeMotionShake)
//    {
//        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
//
//        if ([city.text  isEqual: @""]) {
//                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops"
//                                                                  message:@"Enter a city or select your current location before shaking!"
//                                                                 delegate:nil
//                                                        cancelButtonTitle:@"Okay"
//                                                        otherButtonTitles:nil];
//                
//                [message show];
//        } else if ([currVal isEqual:@"oops"]) {
//            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops"
//                                                              message:@"Select a type of place before shaking!"
//                                                             delegate:nil
//                                                    cancelButtonTitle:@"Okay"
//                                                    otherButtonTitles:nil];
//            
//            [message show];
//        } else {
//                [self performSegueWithIdentifier:@"segueToTable" sender:self];
//        }
//    }
//    
//}

#pragma mark - ASValueTrackingSliderDataSource

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    value = roundf(value);
    NSString *s;
    if (value == 1.0) {
        s = [NSString stringWithFormat:@"%@ Mile", [slider.numberFormatter stringFromNumber:@(value)]];
    } else {
        s = [NSString stringWithFormat:@"%@ Miles", [slider.numberFormatter stringFromNumber:@(value)]];
    }
    sliderVal = s;
    return s;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"segueToTable"]) {
        ((TableViewController*)segue.destinationViewController).type = currVal;
        if ([city.text  isEqual: @"Current Location"]) {
        
            ((TableViewController*)segue.destinationViewController).city = currAddress;
        } else {
            ((TableViewController*)segue.destinationViewController).city = city.text;

        }
        sliderVal = [sliderVal stringByReplacingOccurrencesOfString:@" Mile" withString:@""];
        ((TableViewController*)segue.destinationViewController).radius = [sliderVal stringByReplacingOccurrencesOfString:@"s" withString:@""];

        ((TableViewController*)segue.destinationViewController).name = [name.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        ((TableViewController*)segue.destinationViewController).sortBy = [control titleForSegmentAtIndex:control.selectedSegmentIndex];

    }
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue {
    // This segue is used for unwinding to this view controller. Notice
    // that the circle to the left is empty, meaning it is not connected.
}





@end
