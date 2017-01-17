//
//  ViewController.m
//  EventsAppUI2
//
//  Created by Jonathan Villegas on 21/10/2016.
//  Copyright © 2016 Jonathan Villegas. All rights reserved.
//

/*#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end*/

#import "ViewController.h"
#import "MapUIViewController.h"
#import "RegisterController.h"
#import "KeychainWrapper.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *EmailUsernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *EmailUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@end

@implementation ViewController

- (void) viewDidLayoutSubviews {
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.EmailUsernameTextField.frame.size.height - borderWidth, self.EmailUsernameTextField.frame.size.width, self.EmailUsernameTextField.frame.size.height);
    border.borderWidth = borderWidth;
    [self.EmailUsernameTextField.layer addSublayer:border];
    self.EmailUsernameTextField.layer.masksToBounds = YES;
    
    border = [CALayer layer];
    borderWidth = 1;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.PasswordTextField.frame.size.height - borderWidth, self.PasswordTextField.frame.size.width, self.PasswordTextField .frame.size.height);
    border.borderWidth = borderWidth;
    [self.PasswordTextField.layer addSublayer:border];
    self.PasswordTextField.layer.masksToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)EmailUsernameText:(id)sender {
    
    if ([sender hasText]){
        self.EmailUsernameLabel.hidden = true;
    }
}
- (IBAction)EmailUsernameTextEdited:(id)sender {
    if ([sender hasText]){
        self.EmailUsernameLabel.hidden = true;
    }
}

- (IBAction)LoginButtonClick:(UIButton *)sender {
    
    NSUInteger fieldHash = [self.PasswordTextField.text hash]; // Get the hash of the entered PIN, minimize contact with the real password
    // 3
    if ([KeychainWrapper compareKeychainValueForMatchingPIN:fieldHash]) { // Compare them
        NSLog(@"** User Authenticated!!");
        
        MapUIViewController * mapUIVC = [[MapUIViewController alloc] init];
        //TODO -  Setup
        [self presentViewController:mapUIVC animated:YES completion:nil];
        
        //self.pinValidated = YES;
    } else {
        NSLog(@"** NOT  Authenticated!!");
      
      [self performSegueWithIdentifier:@"register" sender:self];
      
      //RegisterController * regVC = [[RegisterController alloc] init];
      //[self presentViewController:regVC animated:YES completion:nil];
    }
}

- (IBAction)RegisterButtonClick:(UIButton *)sender {
    [self performSegueWithIdentifier:@"register" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *) segue sender:(id)sender{
  if ([[segue identifier] isEqualToString:@"register"]){
    RegisterController *destinationVC = [segue destinationViewController];
    //destinationVC.test = 20;
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

