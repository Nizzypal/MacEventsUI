//
//  CreateEventController.m
//  EventsAppUI2
//
//  Created by Jonathan Villegas on 26/10/2016.
//  Copyright © 2016 Jonathan Villegas. All rights reserved.
//

#import "CreateEventController.h"
#import "CreateEvent2Controller.h"
#import "Constants.h"
@import MapboxGeocoder;
@import AssetsLibrary;
@import AWSS3;

@interface CreateEventController ()

@property (strong, nonatomic) IBOutlet UIScrollView *_eventCreationScrollView;
@property (strong, nonatomic) IBOutlet UIView *_containerElement;
@property (strong, nonatomic) IBOutlet UIImageView *_testView;
@property (strong, nonatomic) NSString* imagePath;
@property (strong, nonatomic) NSURL* refURL;

@property (strong, nonatomic) IBOutlet UITextField *eventName;
@property (strong, nonatomic) IBOutlet UITextField *eventDesc;

@end

@implementation CreateEventController

- (IBAction)UploadPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.ImageUpload.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //Save image to file before uplaoding
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", NSURLCreationDateKey]];
    [UIImagePNGRepresentation(chosenImage) writeToFile:filePath atomically:YES];
    //[UIImageJPEGRepresentation(chosenImag, CGFL) writeToFile:filePath atomically:YES];
    
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    
    /*AWSS3TransferManagerUploadRequest* uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = fileURL;
    uploadRequest.bucket = @"devtestsg";
    //uploadRequest.bucket = @"eezy-s3";
    uploadRequest.key = @"NSURLCreationDateKey.png";*/
    
    //uploadRequest.key = @"testKey";
    //uploadRequest.contentType = @"img/png";
    //uploadRequest.contentLength = [NSNumber numberWithUnsignedLongLong:[filePath length]];
    
    AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityUploadTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do something e.g. Alert a user for transfer completion.
            // On failed uploads, `error` contains the error object.
            NSLog(@"Upload complete");
            NSLog(@"*****Error: %@", error);
        });
    };
    
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [[transferUtility uploadFile:fileURL
                          bucket:@"testbuckss"
                             key:@"test.png"
                     contentType:@"img/png"
                      expression:nil
                completionHander:completionHandler] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        if (task.result) {
            AWSS3TransferUtilityUploadTask *uploadTask = task.result;
            // Do something with uploadTask.
        }
        
        return nil;
    }];
    
    
    /*AWSS3TransferManager *tm = [AWSS3TransferManager defaultS3TransferManager];
    [[tm upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
                                          withBlock:^id(AWSTask *task){
                                              if (task.error != nil){
                                                  
                                                  if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                      switch (task.error.code) {
                                                          case AWSS3TransferManagerErrorCancelled:
                                                          case AWSS3TransferManagerErrorPaused:
                                                              break;
                                                              
                                                          default:
                                                              NSLog(@"Error: %@", task.error);
                                                              break;
                                                      }
                                                  } else {
                                                      // Unknown error.
                                                      NSLog(@"Error: %@", task.error);
                                                  }
                                                  
                                                  NSLog(@"%s %@", "Error uploading: ", uploadRequest.key);
                                              }
                                              
                                              if (task.result) {
                                                  AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
                                                  // The file uploaded successfully.
                                              }
                                              //else {NSLog(@"Upload complete");}
                                              return nil;
                                          }];*/
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self._testView.image = [UIImage imageNamed: @"custom-view-transition.jpg"];
    self._testView.clipsToBounds = YES;
    self._eventCreationScrollView.contentSize= CGSizeMake(300 + self._testView.image.size.width, 300 + self._testView.image.size.height);
    
    //Gesture
    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [self.view addGestureRecognizer:swipeLeftGesture];
    swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    
    //JSON
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:kLatestKivaLoansURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

//JSON
- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* latestLoans = [json objectForKey:@"loans"]; //2
    
    NSLog(@"loans: %@", latestLoans); //3
    
    // 1) Get the latest loan
    NSDictionary* loan = [latestLoans objectAtIndex:0];
    
    // 2) Get the funded amount and loan amount
    NSNumber* fundedAmount = [loan objectForKey:@"funded_amount"];
    NSNumber* loanAmount = [loan objectForKey:@"loan_amount"];
    float outstandingAmount = [loanAmount floatValue] -
    [fundedAmount floatValue];
    
    // 3) Set the label appropriately
    /*humanReadble.text = [NSString stringWithFormat:@"Latest loan: %@
                         from %@ needs another $%.2f to pursue their entrepreneural dream",
                         [loan objectForKey:@"name"],
                         [(NSDictionary*)[loan objectForKey:@"location"]
                          objectForKey:@"country"],
                         outstandingAmount];*/
    
    
    //-----Data to JSON-----//
    //build an info object and convert to json
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          [loan objectForKey:@"name"],
                          @"who",
                          [(NSDictionary*)[loan objectForKey:@"location"]
                           objectForKey:@"country"],
                          @"where",
                          [NSNumber numberWithFloat: outstandingAmount],
                          @"what",
                          nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info 
                                                       options:NSJSONWritingPrettyPrinted error:&error];
}

- (void) viewDidLayoutSubviews {
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.eventName.frame.size.height - borderWidth, self.eventName.frame.size.width, self.eventName.frame.size.height);
    border.borderWidth = borderWidth;
    [self.eventName.layer addSublayer:border];
    self.eventName.layer.masksToBounds = YES;
    
    border = [CALayer layer];
    borderWidth = 1;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.eventDesc.frame.size.height - borderWidth, self.eventDesc.frame.size.width, self.eventDesc .frame.size.height);
    border.borderWidth = borderWidth;
    [self.eventDesc.layer addSublayer:border];
    self.eventDesc.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeGesture:(UIGestureRecognizer *) sender {
    [self performSegueWithIdentifier:@"eventTwo" sender:self];
}

//Pass data to next VC
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"eventTwo"]){
        CreateEvent2Controller *controller = (CreateEvent2Controller *)segue.destinationViewController;
        controller.annotationImage = self.ImageUpload.image;
        controller.eventName = self.eventName;
        controller.eventDesc = self.eventDesc;
    }
}


- (IBAction)unwindToContainerVC:(UIStoryboardSegue *)segue {
    
}


@end
