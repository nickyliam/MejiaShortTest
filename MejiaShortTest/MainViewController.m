//
//  MainViewController.m
//  MejiaShortTest
//
//  Created by admin on 4/10/16.
//  Copyright © 2016 Kaho. All rights reserved.
//

#import "MainViewController.h"
#import "VideoDetailViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self readJson];
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.objectHolderArray count]];
    NSLog(@"username:%@",self.username);
    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
//    [self getCurrentLocation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



// ========  READ JSON FILE ============
-(void)readJson{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"json"];
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:nil];
    
    NSError *error = nil;
    if (error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
    }
    
    if ( jsonObject != nil ) {
        BOOL isEmpty = ([jsonObject count] == 0);
            if(!isEmpty){
            NSArray *array = [jsonObject objectForKey:@"videos"];
            for(NSDictionary *dict in array) {
                NSString *videoURL = [dict objectForKey:@"video"];
                NSString *videoNo = [dict objectForKey:@"nombre"];
                ModelClass *currentVideo = [[ModelClass alloc]initWithId:videoNo Name:videoURL];
                [self.objectHolderArray addObject:currentVideo];
            }
        }
    }
}

// ========++++++++++++++++++============

// ========  SEARCH BAR  ============

- (void)filterContentForSearchText
:(NSString*)searchText scope:(NSString*)scope
{
    
    [self.searchResult removeAllObjects];
    
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.videoId contains[cd]  %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.objectHolderArray filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}



// ========  TABLE VIEW ============
#pragma mark - Table view data source

-(NSMutableArray *)objectHolderArray{
    if(!_objectHolderArray) _objectHolderArray = [[NSMutableArray alloc]init];
    return _objectHolderArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResult count];
    }
    else
    {
        return [self.objectHolderArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    TableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                       forIndexPath:indexPath];

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    ModelClass *currentVideo ;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
            
        currentVideo = [self.searchResult objectAtIndex:indexPath.row];
    }
    else
    {
        currentVideo = [self.objectHolderArray objectAtIndex:indexPath.row];
    }
    
    
    cell.videoID.text = [NSString stringWithFormat:@"%@",currentVideo.videoId];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

// ========+++++++++++++++++============


- (IBAction)logOut:(id)sender {

}


- (IBAction)getCurrentLocation:(id)sender{ //FOR TESTING _ create button at storyboard for testing
//-(void)getCurrentLocation{
    _locationFetchCounter = 0;
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // this delegate method is constantly invoked every some miliseconds.
    // we only need to receive the first response, so we skip the others.
    if (_locationFetchCounter > 0) return;
    _locationFetchCounter++;
    NSLog(@"location Fetch Counter: %d",_locationFetchCounter);
    
    
    // after we have current coordinates, we use this method to fetch the information data of fetched coordinate
    [self.geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        self.placemark = [placemarks lastObject];
        self.userLocation = [NSString stringWithFormat:@"%@,%@", self.placemark.locality,self.placemark.country];
        NSLog(@"we live in %@",self.userLocation);
        

        // stopping locationManager from fetching again
        [self.locationManager stopUpdatingLocation];

    }];
}


- (IBAction)profileButton:(id)sender;
{
    ProfileViewController *profileController;
    [self.navigationController pushViewController:profileController animated:YES];
}



// ========  SEGUE Passing Value ============

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"currentuser name%@",self.username);
    if ([segue.identifier isEqualToString:@"showVideoDetail"]) {
        //        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        VideoDetailViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = nil;
        ModelClass *currentVideo = nil;
        if ([self.searchDisplayController isActive])
        {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            currentVideo = [self.searchResult objectAtIndex:indexPath.row];
        }
        else
        {
            indexPath = [self.tableView indexPathForSelectedRow];
            currentVideo = [self.objectHolderArray objectAtIndex:indexPath.row];
        }
        
        destViewController.videoId = [NSString stringWithFormat:@"%@",currentVideo.videoId];
        destViewController.videoURL = [NSString stringWithFormat:@"%@",currentVideo.videoURL];
        destViewController.userLocation = [NSString stringWithFormat:@"%@",self.userLocation];
        destViewController.userCountry = [NSString stringWithFormat:@"%@",self.placemark.country];
        destViewController.username =[NSString stringWithFormat:@"%@",self.username];
    }
    else if ([segue.identifier isEqualToString:@"showProfileView"]) {
        ProfileViewController *destViewController = segue.destinationViewController;
        destViewController.username = [NSString stringWithFormat:@"%@",self.username];
    }
    
}


// ========++++++++++++++++++============



@end
