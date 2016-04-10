//
//  ProfileViewController.h
//  MejiaShortTest
//
//  Created by admin on 4/10/16.
//  Copyright © 2016 Kaho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userLastName;
@property (weak, nonatomic) IBOutlet UITextField *userFirstName;
@property (weak, nonatomic) IBOutlet UITextField *userAddress;
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
- (IBAction)SaveProfile:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@end
