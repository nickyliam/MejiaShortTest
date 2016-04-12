//
//  VideoDetailViewController.h
//  MejiaShortTest
//
//  Created by admin on 4/7/16.
//  Copyright © 2016 Kaho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ProfileViewController.h"



@interface VideoDetailViewController : UIViewController 

@property(nonatomic,weak) IBOutlet UILabel *userLocationLabel;
@property(nonatomic,weak) IBOutlet UILabel *videoURLLabel;
@property(nonatomic,strong) NSString *userLocation;
@property(nonatomic,strong) NSString *userCountry;
@property(nonatomic,strong) NSString *videoURL;
@property(nonatomic,strong) NSString *videoId;
@property(nonatomic,strong) NSString *username;
@property(nonatomic) bool isVoted;
@property(nonatomic,strong) NSString* likeValue;
@property(nonatomic,strong) NSString* update;
@property(nonatomic,weak) IBOutlet UIWebView * webView;
@property(nonatomic,weak) IBOutlet UIButton *likeButton;
@property(nonatomic,weak) IBOutlet UIButton *dislikeButton;

- (IBAction)likeButton:(id)sender;
- (IBAction)dislikeButton:(id)sender;

@end
