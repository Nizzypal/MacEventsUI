    //
//  CreateEvent2Controller.m
//  EventsAppUI2
//
//  Created by Jonathan Villegas on 04/11/2016.
//  Copyright © 2016 Jonathan Villegas. All rights reserved.
//

#import "CreateEvent2Controller.h"
#import "CreateEvent2ADateModalController.h"
#import "CreateEvent2ATimeModalController.h"
@import Mapbox;

@interface CreateEvent2Controller () <UITabBarDelegate, MGLMapViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *StartDate;
@property (strong, nonatomic) IBOutlet UITextField *StartTime;
@property (strong, nonatomic) IBOutlet UITextField *Location;
@property (strong, nonatomic) IBOutlet MGLMapView *mapView;
@property (strong, nonatomic) IBOutlet UIScrollView *eventScrollView;

@end

@implementation CreateEvent2Controller

static NSString * const reuseIdentifier = @"Cell";

CreateEvent2ADateModalController *event2A;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    
    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [self.view addGestureRecognizer:swipeLeftGesture];
    swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeftGesture];
    swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionRight;
    
    // --- MapBox init stuff
    self.eventScrollView.contentSize= CGSizeMake(400, 600);
    
    self.mapView.delegate = self;
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    MGLPointAnnotation * annotation = [[MGLPointAnnotation alloc]init];
    annotation.coordinate = self.mapView.userLocation.location.coordinate;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)
                             animated:NO];
    self.mapView.zoomLevel = 14;
    self.mapView.userTrackingMode   = MGLUserTrackingModeNone;
    
    self.mapView.showsUserLocation = YES;
    [self.mapView addAnnotation:annotation];
}

- (void) viewDidLayoutSubviews {
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.StartDate.frame.size.height - borderWidth, self.StartDate.frame.size.width, self.StartDate.frame.size.height);
    border.borderWidth = borderWidth;
    [self.StartDate.layer addSublayer:border];
    self.StartDate.layer.masksToBounds = YES;
    
    border = [CALayer layer];
    borderWidth = 1;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.StartTime.frame.size.height - borderWidth, self.StartTime.frame.size.width, self.StartTime .frame.size.height);
    border.borderWidth = borderWidth;
    [self.StartTime.layer addSublayer:border];
    self.StartTime.layer.masksToBounds = YES;
    
    border = [CALayer layer];
    borderWidth = 1;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.Location.frame.size.height - borderWidth, self.Location.frame.size.width, self.Location .frame.size.height);
    border.borderWidth = borderWidth;
    [self.Location.layer addSublayer:border];
    self.Location.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeGesture:(UIGestureRecognizer *) sender
{
    [self performSegueWithIdentifier:@"backToEvent1" sender:self];
    
}

- (IBAction)StartDateEdit:(UITextField *)sender {
    
    [self performSegueWithIdentifier:@"datePickerModal" sender:self];
}

- (IBAction)StartTImeEdit:(UITextField *)sender {
    [self performSegueWithIdentifier:@"timePickerModal" sender:self];
}

- (IBAction)StartDateSelected:(UIStoryboardSegue *)segue {
    
    if ([segue.sourceViewController isKindOfClass:[CreateEvent2ADateModalController class]]){
        CreateEvent2ADateModalController * event2A = (CreateEvent2ADateModalController *)segue.sourceViewController;
        self.StartDate.text = event2A.StartDate;
    }
    
    if ([segue.sourceViewController isKindOfClass:[CreateEvent2ATimeModalController class]]){
        CreateEvent2ATimeModalController * event2A = (CreateEvent2ATimeModalController *)segue.sourceViewController;
        self.StartTime.text = event2A.StartTime;
    }
}

//MapBox Delegates

//MapView Delegate

- (void)mapView:(nonnull MGLMapView *)mapView didUpdateUserLocation:(nullable MGLUserLocation *)userLocation{
    MGLPointAnnotation * annotation = [[MGLPointAnnotation alloc]init];
    
    annotation.coordinate = self.mapView.userLocation.location.coordinate;
    //[self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)
                             animated:NO];
    self.mapView.zoomLevel = 14;
    self.mapView.userTrackingMode   = MGLUserTrackingModeNone;
    
    self.mapView.showsUserLocation = YES;
    [self.mapView addAnnotation:annotation];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation {

    MGLAnnotationImage *annotationImage;
    //UIImage *image = [UIImage imageNamed:@"glyphicons-159-show-lines"];
    UIImage *image = [UIImage imageNamed:@"green_tea"];
    
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
    
    annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"gt"];

    return annotationImage;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
    return true;
}

- (UIView *)mapView:(MGLMapView *)mapView leftCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    if ([annotation.title isEqualToString:@"Kinkaku-ji"])
    {
        // Callout height is fixed; width expands to fit its content.
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.f, 50.f)];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor colorWithRed:0.81f green:0.71f blue:0.23f alpha:1.f];
        label.text = @"金閣寺";
        
        return label;
    }
    
    return nil;
}

- (UIView *)mapView:(MGLMapView *)mapView rightCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    return [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

- (void)mapView:(MGLMapView *)mapView annotation:(id<MGLAnnotation>)annotation calloutAccessoryControlTapped:(UIControl *)control
{
    // Hide the callout view.
    [self.mapView deselectAnnotation:annotation animated:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:annotation.title
                                                    message:@"A lovely (if touristy) place."
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
