//
//  MapUIViewController.m
//  EventsAppUI2
//
//  Created by Jonathan Villegas on 11/11/2016.
//  Copyright © 2016 Jonathan Villegas. All rights reserved.
//
#import "MapUIViewController.h"
#import "MapSettingsViewController.h"
@import Mapbox;

@interface MapUIViewController ()


@property (strong, nonatomic) IBOutlet UIScrollView *mapViewScrollView;
@property (strong, nonatomic) IBOutlet MGLMapView *mapView;
@property (strong, nonatomic) IBOutlet UITabBar *menuTabBar;

@end

@implementation MapUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.menuTabBar.delegate = self;
    self.mapView.delegate = self;
    
    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [self.view addGestureRecognizer:swipeLeftGesture];
    swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionRight;
    
    self.mapViewScrollView.contentSize= CGSizeMake(400, 600);
    
    MGLPointAnnotation * annotation = [[MGLPointAnnotation alloc]init];
    
    self.mapView.showsUserLocation = YES;
    annotation.coordinate = self.mapView.userLocation.location.coordinate;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)];
    
    self.mapView.zoomLevel = 14;
    //[self.mapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeGesture:(UIGestureRecognizer *) sender {
    [self performSegueWithIdentifier:@"toMapSettings" sender:self];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if([item.title isEqual:@"Settings"])
    {
        [self performSegueWithIdentifier:@"toMapSettings" sender:self];
    }
    else if ([item.title isEqual:@"Explore"])
    {

    }
    else{
    }
}

//MapView Delegate

- (void)mapView:(nonnull MGLMapView *)mapView didUpdateUserLocation:(nullable MGLUserLocation *)userLocation{
    MGLPointAnnotation * annotation = [[MGLPointAnnotation alloc]init];
    
    annotation.coordinate = self.mapView.userLocation.location.coordinate;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)];
    
    [self.mapView addAnnotation:annotation];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation {
    // Try to reuse the existing ‘pisa’ annotation image, if it exists.
    //MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"pisa"];
    MGLAnnotationImage *annotationImage;
    
    // If the ‘pisa’ annotation image hasn‘t been set yet, initialize it here.
    /*if (!annotationImage)
    {*/
        // Leaning Tower of Pisa by Stefan Spieler from the Noun Project.
        UIImage *image = [UIImage imageNamed:@"pisavector"];
        
        // The anchor point of an annotation is currently always the center. To
        // shift the anchor point to the bottom of the annotation, the image
        // asset includes transparent bottom padding equal to the original image
        // height.
        //
        // To make this padding non-interactive, we create another image object
        // with a custom alignment rect that excludes the padding.
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        
        // Initialize the ‘pisa’ annotation image with the UIImage we just loaded.
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"pisa"];
    //}
    
    return annotationImage;
}

//Unwind Delegate
- (IBAction)setMapDetails:(UIStoryboardSegue *)segue {
    
}


@end
