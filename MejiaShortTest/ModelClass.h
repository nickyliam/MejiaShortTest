//
//  ModelClass.h
//  MejiaShortTest
//
//  Created by admin on 4/5/16.
//  Copyright © 2016 Kaho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelClass : NSObject



@property (nonatomic,strong) NSString *videoId;
@property (nonatomic,strong) NSString *videoURL;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *city;

-(instancetype)initWithId:(NSString *)Id Name:(NSString *)video;
-(id)initWithLocation:(NSString *)currentCountry city:(NSString *)currentCity;


@end
