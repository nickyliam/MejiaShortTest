//
//  VideoDetailViewController.h
//  MejiaShortTest
//
//  Created by admin on 4/7/16.
//  Copyright © 2016 Kaho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListTableViewController.h"


@interface VideoDetailViewController : UIViewController 

@property(nonatomic,weak) IBOutlet UILabel *userLocationLabel;
@property(nonatomic,weak) IBOutlet UILabel *videoURLLabel;
@property(nonatomic,strong) NSString *userLocation;
@property(nonatomic,strong) NSString *videoURL;
@property(nonatomic,weak) IBOutlet UIWebView * webView;

@end
