//
//  ProfileViewController.m
//  MejiaShortTest
//
//  Created by admin on 4/10/16.
//  Copyright © 2016 Kaho. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readUserDetail];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

//Make Keyboard dissapeared after textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTap:(id)sender{
    [self.view endEditing:YES];
}



- (void)readUserDetail{

    NSString *URL = [NSString stringWithFormat:@"http://localhost/~admin/MejiaTestServer/profile.php?q=profile&username=%@",self.username];
    NSDictionary *jsonObject = [self parseJsonResponse:URL];
    NSLog(@"reading json");
    if ( jsonObject != nil ) {
        BOOL isEmpty = ([jsonObject count] == 0);
        if(!isEmpty){
            if([jsonObject objectForKey:@"lastName" ] != nil ){
                self.userLastName.text  = [jsonObject objectForKey:@"lastName"];
            }
            if([jsonObject objectForKey:@"firstName" ] != nil){
                self.userFirstName.text  = [jsonObject objectForKey:@"firstName"];
            }
            if([jsonObject objectForKey:@"address" ] != nil){
                self.userAddress.text  = [jsonObject objectForKey:@"address"];
            }
            if([jsonObject objectForKey:@"phone" ] != nil){
                self.userPhone.text  = [jsonObject objectForKey:@"phone"];
            }
            if([jsonObject objectForKey:@"email" ] != nil){
                self.userEmail.text  = [jsonObject objectForKey:@"email"];
            }
        }
    }

}


- (NSDictionary *)parseJsonResponse:(NSString *)urlString
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error];
    if (!data)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        UIAlertView *alert =
        [[UIAlertView alloc]initWithTitle:@"Error"
                                  message:[NSString stringWithFormat:@"Error : %@",error.localizedDescription]
                                 delegate:self
                        cancelButtonTitle:@"Ok"
                        otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    
    // Parsing the JSON data received from web service into an NSDictionary object
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: data
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    return JSON;
}

- (IBAction)SaveProfile:(id)sender
{

            UIAlertView *alertReport = [[UIAlertView alloc] initWithTitle:@"THANK YOU"
                                                                  message:@"Your profile has been saved"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
            [alertReport show];
    
    
            // Sending image Id and app name to server
            NSString *urlString = [NSString stringWithFormat:@"http://localhost/~admin/MejiaTestServer/profile.php?q=update&username=%@", self.username];
    
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
            NSString *userLastName = [NSString stringWithFormat:@"%@",self.userLastName.text ];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userLastName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:userLastName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Another text parameter
            NSString *userFirstName = [NSString stringWithFormat:@"%@",self.userFirstName.text];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userFirstName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:userFirstName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Another text parameter
            NSString *userAddress = [NSString stringWithFormat:@"%@",self.userAddress.text ];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userAddress\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:userAddress] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
            // Another text parameter
            NSString *userPhone = [NSString stringWithFormat:@"%@", self.userPhone.text ];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userPhone\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:userPhone] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
            // Another text parameter
            NSString *userEmail = [NSString stringWithFormat:@"%@", self.userEmail.text ];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userEmail\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:userEmail] dataUsingEncoding:NSUTF8StringEncoding]];
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
