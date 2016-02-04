//
//  BookmarkViewController.m
//  Spontaneous
//
//  Created by Avdeep Sahi on 4/1/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import "BookmarkViewController.h"
#import "MCSwipeTableViewCell.h"
#import "UIImage+BlurredFrame.h"
#import "View2Controller.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

@interface BookmarkViewController ()<MCSwipeTableViewCellDelegate>


@property (nonatomic, assign) NSUInteger nbItems;
@property (nonatomic, strong) MCSwipeTableViewCell *cellToDelete;

@end


@implementation BookmarkViewController {
    NSArray *keys;
    NSMutableDictionary *dict;
    NSString *toPass;
    NSString *backgroundURL;
    int bgIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];

    UIImage *img = [UIImage imageNamed:@"tableImage.png"];
    AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
//    [manager2 GET:@"http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US"
//       parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSDictionary *jsonArr = responseObject;
//              NSArray *newArr = [jsonArr objectForKey:@"images"];
//              NSDictionary *innerDict = [newArr objectAtIndex: 0];
//              backgroundURL = [innerDict objectForKey:@"url"];
//              backgroundURL = [@"http://www.bing.com" stringByAppendingString:backgroundURL];
//             
//              
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//          }];
    bgIndex = 1;
    NSLog(@"index is: %d", bgIndex);
    [manager2 GET:@"http://www.reddit.com/r/earthporn.json?"
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
                  
                  NSString *checker = [splitString objectAtIndex:[splitString count]-2];
                  if ([checker  containsString: @"X"]) {
                      NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"X"];
                      NSArray *str = [checker componentsSeparatedByCharactersInSet:delimiters];
                      NSInteger *int1 = [[[str objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];

                      NSInteger *int2 = [[[str objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      NSInteger * check = 4000;
                      if (int1 >= check || int2 >= check) {
                          backgroundURL = @"https://drscdn.500px.org/photo/52866292/m=2048_k=1_a=1/2683707825210f5bb6d26e7c32d14738";
                      }
                  } else if ([checker containsString:@"x"]) {
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
              } else if([title containsString:@"("]) {
                  NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"()"];
                  NSArray *splitString = [title componentsSeparatedByCharactersInSet:delimiters];
                  
                  NSString *checker = [splitString objectAtIndex:[splitString count]-2];
                  if ([checker  containsString: @"X"]) {
                      NSLog(@"first if");
                      NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"X"];
                      NSArray *str = [checker componentsSeparatedByCharactersInSet:delimiters];
                      NSInteger *int1 = [[[str objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      
                      NSInteger *int2 = [[[str objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      NSInteger * check = 4000;
                      if (int1 >= check || int2 >= check) {
                          NSLog(@"second if");
                          backgroundURL = @"https://drscdn.500px.org/photo/52866292/m=2048_k=1_a=1/2683707825210f5bb6d26e7c32d14738";
                      }
                  } else if ([checker containsString:@"x"]) {
                      NSLog(@"first else if");
                      NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"x"];
                      NSArray *str = [checker componentsSeparatedByCharactersInSet:delimiters];
                      NSInteger *int1 = [[[str objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      
                      NSInteger *int2 = [[[str objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                      NSInteger * check = 4000;
                      if (int1 >= check || int2 >= check) {
                          NSLog(@"third if");
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
                  
              }
              //              NSArray *newArr = [jsonArr objectForKey:@"images"];
              //              NSDictionary *innerDict = [newArr objectAtIndex: 0];
              //              backgroundURL = [innerDict objectForKey:@"url"];
              //              backgroundURL = [@"http://www.bing.com" stringByAppendingString:backgroundURL];
              
              
        NSLog(@"%@", backgroundURL);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          }];


//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    visualEffectView.frame = self.tableView.bounds;
   // [self.tableView addSubview:visualEffectView];
    CGRect frame = CGRectMake(0,0, 10000, 10000);
    img = [img applyLightEffectAtFrame:frame];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:img];
   NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.spontaneousWatch"];
    NSDictionary *adict = [defaults objectForKey:@"bookmark"];
    keys = [adict allKeys];
    keys = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    dict = [NSMutableDictionary new];
    for(NSString * key in [adict allKeys]) {
        //NSLog(@"key1: %@",key);
        NSString *value = [adict objectForKey:key];
       // NSLog(@"new dict has val of1:%@", [adict objectForKey:key]);
        [dict setValue:value forKey:key];
    }
    _nbItems = [keys count];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)showHowTo:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"How To"
                                                      message:@"Select a cell or swipe right to remove from bookmarks."
                                                     delegate:nil
                                            cancelButtonTitle:@"Okay"
                                            otherButtonTitles:nil];
    
    [message show];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _nbItems;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    NSString *CellIdentifier = @"Cell";
    MCSwipeTableViewCell *cell;

    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }

    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}
- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (void)configureCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor redColor];
    
   //  NSLog(@"index path: %@", [keys objectAtIndex:indexPath.row]);
    // Setting the default inactive state color to the tableView background color
    
    [cell setDelegate:self];
    cell.textLabel.font =[UIFont fontWithName:@"Avenir-Medium" size:21.f];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setText:[keys objectAtIndex:indexPath.row]];
    
    [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        [cell.textLabel setText:@""];
        [self deleteCell:cell];
    }];
}
- (void)deleteCell:(MCSwipeTableViewCell *)cell {
    _nbItems--;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [dict removeObjectForKey:[keys objectAtIndex:indexPath.row]];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.spontaneousWatch"];
    [defaults setObject:dict forKey:@"bookmark"];
    [defaults synchronize];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToBookmark"]) {
        
        View2Controller *detailViewController = (View2Controller *)segue.destinationViewController;
        //set NSDictionary Item restuarantDetail in detailViewController
        detailViewController.url = toPass;
        //backgroundURL = [@"https://" stringByAppendingString:backgroundURL];
        backgroundURL = @"https://drscdn.500px.org/photo/52866292/m=2048_k=1_a=1/2683707825210f5bb6d26e7c32d14738"; //comment this out after test
        detailViewController.backgroundURL = backgroundURL;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    toPass = [dict objectForKey:[keys objectAtIndex:indexPath.row]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading...";
    [self performSelector:@selector(segue) withObject:nil afterDelay:.1];
   
    
}
-(void) segue {
     [self performSegueWithIdentifier:@"segueToBookmark" sender:self];
}

- (IBAction)unwindToBookmark:(UIStoryboardSegue *)segue {
    // This segue is used for unwinding to this view controller. Notice
    // that the circle to the left is empty, meaning it is not connected.
    
}








@end
