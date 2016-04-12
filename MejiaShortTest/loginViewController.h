//
//  loginViewController.h
//  MejiaShortTest
//
//  Created by admin on 4/12/16.
//  Copyright © 2016 Kaho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"


@interface loginViewController : UIViewController<UITextFieldDelegate >
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property(nonatomic) bool isUserValid;
- (IBAction)loginButton:(id)sender;
- (IBAction)backgroundTap:(id)sender;


@end
