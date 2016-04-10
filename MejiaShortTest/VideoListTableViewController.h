//
//  VideoListTableViewController.h
//  MejiaShortTest
//
//  Created by admin on 4/6/16.
//  Copyright © 2016 Kaho. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "ModelClass.h"
#import "TableCell.h"


@interface VideoListTableViewController : UITableViewController <UISearchDisplayDelegate,CLLocationManagerDelegate >

@property (strong, nonatomic) NSArray *videoList;
@property (strong, nonatomic) NSString *userLocation;
@property (strong, nonatomic) NSMutableArray *objectHolderArray;
@property (nonatomic, strong) NSMutableArray *searchResult;

@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLGeocoder *geocoder;
@property(nonatomic,strong) CLPlacemark *placemark;
@property(nonatomic) int locationFetchCounter;

- (IBAction)getCurrentLocation:(id)sender;

-(void)readJson;
@end
