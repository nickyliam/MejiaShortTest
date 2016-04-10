//
//  ModelClass.m
//  MejiaShortTest
//
//  Created by admin on 4/5/16.
//  Copyright © 2016 Kaho. All rights reserved.
//

#import "ModelClass.h"
#import "VideoListTableViewController.h"

@implementation ModelClass

-(instancetype)initWithId:(NSString *)Id Name:(NSString *)givenVideo{
    self = [super init];
    if(self){
        self.videoId = Id;
        self.videoURL = givenVideo;
    }
    return self;
}

-(id)initWithLocation:(NSString *)currentCountry city:(NSString *)currentCity
{
    if (self = [super init]) {
        self.country = currentCountry;
        self.city = currentCity;
    }
    return self;
}



@end
