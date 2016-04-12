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
    [super viewDidLoad];
    [self embedYouTube:self.videoURL];
    [self getLikeValue:self.videoId];
    self.videoURLLabel.text = [NSString stringWithFormat:@"%@",self.videoURL];
    
    self.userLocationLabel.text = [NSString stringWithFormat:@"%@",self.userLocation];
  
    if(_isVoted){
        self.update = @"update";
        if([_likeValue isEqualToString:@"disliked"]){
            self.likeButton.enabled = YES;
            self.dislikeButton.enabled = NO;
            
        }else if ([_likeValue isEqualToString:@"liked"]){
            self.likeButton.enabled = NO;
            self.dislikeButton.enabled = YES;
        }
    }
}

-(void)refreshView:(NSNotification *) notification {
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
    
    NSString *query = [vimeoURL componentsSeparatedByString:@"vimeo"][1];
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


-(void)getLikeValue: (NSString*)forVideo{
    NSString *URL = [NSString stringWithFormat:@"http://localhost/~admin/MejiaTestServer/profile.php?q=getlikefeature&username=%@",self.username];
    
    ProfileViewController *profileView = [[ProfileViewController alloc]init];
    
    NSDictionary *jsonObject = [profileView parseJsonResponse:URL];
    if ( jsonObject != nil ) {
//        NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)[jsonObject count]];
//        if(![count isEqualToString:@"0"] ){
        BOOL isEmpty = ([jsonObject count] == 0);
        if(!isEmpty){
            NSDictionary *data  = [jsonObject objectForKey:forVideo];
            NSString *Result = [data objectForKey:@"liked"];
            if(Result != nil){
                _isVoted = true;
                _likeValue = Result;
            }else{
                _isVoted = false;
                _likeValue = @"";
            }
        }
    
    }

}


- (IBAction)likeButton:(id)sender{
   
    [self sendValueToServer: @"liked" Update:self.update];
    [self viewDidLoad];
}

- (IBAction)dislikeButton:(id)sender{
    [self sendValueToServer: @"disliked" Update:self.update];
    [self viewDidLoad];
}

- (void)sendValueToServer:(NSString*)like Update:(NSString*)value
{
    
    NSString *sentence = [NSString stringWithFormat:@"You have %@ this video",like];
    UIAlertView *alertReport = [[UIAlertView alloc] initWithTitle:@"THANK YOU"
                                                          message:sentence
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [alertReport show];
    
    NSString *path ;
    if([value isEqualToString:@"update"]){
        path = @"updatevote";
    }else{
        path = @"likefeature";
    }
 ;
    // Sending image Id and app name to server
    NSString *urlString = [NSString stringWithFormat:@"http://localhost/~admin/MejiaTestServer/profile.php?q=%@&username=%@",path, self.username];
    
    NSLog(@"%@",urlString);
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //Create the body of the post
    NSMutableData *body = [NSMutableData data];
    
    
    // Text parameter1
    NSString *country = [NSString stringWithFormat:@"%@",self.userCountry ];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"country\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:country] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // Another text parameter
    
    NSString *videoId = [NSString stringWithFormat:@"%@",self.videoId];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"videoId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:videoId] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];


    // Another text parameter
    NSString *liked = [NSString stringWithFormat:@"%@",like ];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"liked\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:liked] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // make the connection to the web
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", returnString);
    
}



@end
