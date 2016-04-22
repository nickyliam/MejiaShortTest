//
//  MainViewController.h
//  MejiaShortTest
//
//  Created by admin on 4/10/16.
//  Copyright © 2016 Kaho. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "ModelClass.h"
#import "TableCell.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"

@interface MainViewController : UIViewController<UISearchDisplayDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate >

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSArray *videoList;
@property (strong, nonatomic) NSString *userLocation;
@property (strong, nonatomic) NSMutableArray *objectHolderArray;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) IBOutlet UITableView  *tableView;

@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLGeocoder *geocoder;
@property(nonatomic,strong) CLPlacemark *placemark;
@property(nonatomic) int locationFetchCounter;
- (IBAction)logOut:(id)sender;
- (IBAction)getCurrentLocation:(id)sender;//testing..delete
- (IBAction)profileButton:(id)sender;
-(void)getCurrentLocation;


-(void)readJson;


@end
