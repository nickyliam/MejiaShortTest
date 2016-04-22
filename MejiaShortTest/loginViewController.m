//
//  loginViewController.m
//  MejiaShortTest
//
//  Created by admin on 4/12/16.
//  Copyright © 2016 Kaho. All rights reserved.
//

#import "loginViewController.h"

@interface loginViewController ()

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _isUserValid = true; //FOR TESTING
//    self.username.text = @"test"; //FOR TESTING
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (IBAction)loginButton:(id)sender {
    [self getLoginUsers];
    if(self.isUserValid){
        [self performSegueWithIdentifier:@"loginsuccess" sender:self];
    }else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"LOG IN"
                                      message:@"Invalid Username"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (IBAction)backgroundTap:(id)sender {
        [self.view endEditing:YES];
}

//Make Keyboard dissapeared after textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)getLoginUsers{
    NSString *URL = [NSString stringWithFormat:@"http://localhost/~admin/MejiaTestServer/profile.php?q=loginprofiles"];
    
    ProfileViewController *profileView = [[ProfileViewController alloc]init];
    
    NSDictionary *jsonObject = [profileView parseJsonResponse:URL];
    if ( jsonObject != nil ) {
        BOOL isEmpty = ([jsonObject count] == 0);
        if(!isEmpty){
            NSString *Result  = [jsonObject objectForKey:self.username.text];
            if(Result != nil){
                self.isUserValid = true;
            }else{
                self.isUserValid = false;
            }
        }
    }
    
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginsuccess"]) {
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        MainViewController *destViewController = (MainViewController *)[navController topViewController];

        destViewController.username = [NSString stringWithFormat:@"%@",self.username.text];
    }
}
@end
