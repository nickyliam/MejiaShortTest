//
//  VideoDetailViewController.m
//  MejiaShortTest
//
//  Created by admin on 4/7/16.
//  Copyright © 2016 Kaho. All rights reserved.
//

#import "VideoDetailViewController.h"
@import AVFoundation;
@import AVKit;

@interface VideoDetailViewController ()

@end

@implementation VideoDetailViewController


- (void)viewDidLoad {
    
    
    [self embedYouTube:self.videoURL];
    NSLog(@"%@",self.videoURL);
    
    self.videoURLLabel.text = [NSString stringWithFormat:@"%@",self.videoURL];
    
    self.userLocationLabel.text = [NSString stringWithFormat:@"%@",self.userLocation];
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)playVimeo:(NSString *)URLID
{

    [self.webView setAllowsInlineMediaPlayback:YES];
    [self.webView setMediaPlaybackRequiresUserAction:NO];

    NSString* embedHTML = [NSString stringWithFormat:@"\
                           <html>\
                           <body style='margin:0px;padding:0px;'>\
                           <script type='text/javascript'>\
                            </script>\
                           <iframe src='https://player.vimeo.com/video/%@?title=0&byline=0&portrait=0&badge=0&playsinline=1&loop=1' width='%f' height='%f' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>\
                           </body>\
                           </html>", URLID, self.webView.frame.size.width, self.webView.frame.size.height];
    [self.webView loadHTMLString:embedHTML baseURL:[[NSBundle mainBundle] resourceURL]];

}

-(NSString *)extractVimeoID:(NSString *)vimeoURL
{
    NSString *vID = nil;
    NSString *url = @"https://vimeo.com/50713841";
    
    NSString *query = [url componentsSeparatedByString:@"vimeo"][1];
    NSArray *pairs = [query componentsSeparatedByString:@" "];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"/"];
        if ([kv[0] isEqualToString:@".com"]) {
            vID = kv[1];
            break;
        }
    }
    return vID;
}

-(NSString *)extractYoutubeID:(NSString *)youtubeURL
{
    NSString *regexString = @"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/vimeo)([-a-zA-Z0-9_]+)";

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:youtubeURL options:0 range:NSMakeRange(0, [youtubeURL length])];
    if(!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
    {
        NSString *substringForFirstMatch = [youtubeURL substringWithRange:rangeOfFirstMatch];
        
        return substringForFirstMatch;
    }
    return nil;
}


- (void)embedYouTube:(NSString *)URL
{

//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
//    
//    CGFloat point = (screenRect.size.width - self.webView.frame.size.width)/2 ;
//     NSLog(@"%f",screenRect.size.width);
//     self.webView.center = CGPointMake( self.webView.frame.size.width  / 2,
//                                      self.webView.frame.size.height / 2);
//

    if ([URL rangeOfString:@"vimeo" options:NSCaseInsensitiveSearch].location != NSNotFound){
        NSString *UrlID = [self extractVimeoID:URL];
        [self playVimeo:UrlID];
    }
    
    else
    {
    NSString *UrlID = [self extractYoutubeID:URL];
    
    [self.webView setAllowsInlineMediaPlayback:YES];
    [self.webView setMediaPlaybackRequiresUserAction:NO];

    NSString* embedHTML = [NSString stringWithFormat:@"\
                           <html>\
                           <body style='margin:0px;padding:0px;'>\
                           <script type='text/javascript' src='http://www.youtube.com/iframe_api'></script>\
                           <script type='text/javascript'>\
                           function onYouTubeIframeAPIReady()\
                           </script>\
                           <iframe id='playerId' type='text/html' width='%f' height='%f' src='http://www.youtube.com/embed/%@?enablejsapi=1&rel=0&playsinline=1&autoplay=0' frameborder='0'>\
                           </body>\
                           </html>", self.webView.frame.size.width, self.webView.frame.size.height, UrlID];
    [self.webView loadHTMLString:embedHTML baseURL:[[NSBundle mainBundle] resourceURL]];
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
