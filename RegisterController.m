//
//  RegisterController.m
//  EventsAppUI2
//
//  Created by Jonathan Villegas on 28/10/2016.
//  Copyright © 2016 Jonathan Villegas. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RegisterController.h"
#import "MapUIViewController.h"
#import "Constants.h"
#import "KeychainWrapper.h"

@interface RegisterController ()

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNoTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *RegisterButton;


@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidLayoutSubviews {
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.userNameTextField.frame.size.height - borderWidth, self.userNameTextField.frame.size.width, self.userNameTextField.frame.size.height);
    border.borderWidth = borderWidth;
    [self.userNameTextField.layer addSublayer:border];
    self.userNameTextField.layer.masksToBounds = YES;
    
    border = [CALayer layer];
    borderWidth = 1;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.phoneNoTextField.frame.size.height - borderWidth, self.phoneNoTextField.frame.size.width, self.phoneNoTextField .frame.size.height);
    border.borderWidth = borderWidth;
    [self.phoneNoTextField.layer addSublayer:border];
    self.phoneNoTextField.layer.masksToBounds = YES;
    
    border = [CALayer layer];
    borderWidth = 1;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.emailTextField.frame.size.height - borderWidth, self.emailTextField.frame.size.width, self.emailTextField .frame.size.height);
    border.borderWidth = borderWidth;
    [self.emailTextField.layer addSublayer:border];
    self.emailTextField.layer.masksToBounds = YES;
    
    border = [CALayer layer];
    borderWidth = 1;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.passwordTextField.frame.size.height - borderWidth, self.passwordTextField.frame.size.width, self.passwordTextField .frame.size.height);
    border.borderWidth = borderWidth;
    [self.passwordTextField.layer addSublayer:border];
    self.passwordTextField.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (IBAction)validateInfo:(UIButton *)sender {
    if (self.userNameTextField.text.length > 0 && self.phoneNoTextField.text.length > 0 && self.emailTextField.text.length && self.passwordTextField.text.length){
    
    }
}*/

- (IBAction)usernameEditEnd:(UITextField *)sender {
    if (self.userNameTextField.text.length > 0 && self.phoneNoTextField.text.length > 0 && self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0){
        [self.RegisterButton setEnabled:true];
    }
}

- (IBAction)phoneEditEnd:(UITextField *)sender {
    if (self.userNameTextField.text.length > 0 && self.phoneNoTextField.text.length > 0 && self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0){
        [self.RegisterButton setEnabled:true];
    }
}

- (IBAction)emailEditEnd:(UITextField *)sender {
    if (self.userNameTextField.text.length > 0 && self.phoneNoTextField.text.length > 0 && self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0){
        [self.RegisterButton setEnabled:true];
    }
}

- (IBAction)passwordEditEnd:(UITextField *)sender {
    if (self.userNameTextField.text.length > 0 && self.phoneNoTextField.text.length > 0 && self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0){
        [self.RegisterButton setEnabled:true];
    }
}

- (IBAction)Register:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue:self.userNameTextField.text forKey:USERNAME];
    [[NSUserDefaults standardUserDefaults] setValue:self.emailTextField.text forKey:EMAIL];
    [[NSUserDefaults standardUserDefaults] setValue:self.phoneNoTextField.text forKey:PHONE];
    
    NSUInteger fieldHash = [self.passwordTextField.text hash];
    // 4
    NSString *fieldString = [KeychainWrapper securedSHA256DigestHashForPIN:fieldHash];
    NSLog(@"** Password Hash - %@", fieldString);
    // Save PIN hash to the keychain (NEVER store the direct PIN)
    if ([KeychainWrapper createKeychainValue:fieldString forIdentifier:PIN_SAVED]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PIN_SAVED];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self performSegueWithIdentifier:@"registerToExplore" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *) segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"registerToExplore"]){
        RegisterController *destinationVC = [segue destinationViewController];
        //destinationVC.test = 20;
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
