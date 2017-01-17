//
//  CreateEventController.h
//  EventsAppUI2
//
//  Created by Jonathan Villegas on 26/10/2016.
//  Copyright © 2016 Jonathan Villegas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEventController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *ImageUpload;

- (IBAction)UploadPhoto:(UIButton *)sender;


@end
