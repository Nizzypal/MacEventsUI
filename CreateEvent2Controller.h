//
//  CreateEvent2Controller.h
//  EventsAppUI2
//
//  Created by Jonathan Villegas on 04/11/2016.
//  Copyright © 2016 Jonathan Villegas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEvent2Controller : UIViewController
    @property(strong, nonatomic) UIImage * annotationImage;
    @property (strong, nonatomic) IBOutlet UITextField *eventName;
    @property (strong, nonatomic) IBOutlet UITextField *eventDesc;
@end
