//
//  MapUIViewController.m
//  EventsAppUI2
//
//  Created by Jonathan Villegas on 25/10/2016.
//  Copyright © 2016 Jonathan Villegas. All rights reserved.
//

#import "MapSettingsViewController.h"
//#import "CategoriesCollectionCollectionViewController.h"
@import Mapbox;

@interface MapSettingsViewController () <UITabBarDelegate, UICollectionViewDataSource, MGLMapViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *MapViewScrollView;

@property (strong, nonatomic) IBOutlet UITabBar *MenuTabs;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *CategoryControllerView;
@property (strong, nonatomic) IBOutlet MGLMapView *mapView;


@property NSArray *categoryPhotos;

@end

//@implementation MapSettingsViewController
@implementation MapSettingsViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.MenuTabs.delegate = self;
    self.CategoryControllerView.dataSource  = self;
    self.mapView.delegate = self;
    
    
    //CollectionView
    self.categoryPhotos = [NSArray arrayWithObjects:@"angry_birds_cake.jpg", @"creme_brelee.jpg", @"egg_benedict.jpg", @"full_breakfast.jpg", @"green_tea.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg", @"japanese_noodle_with_pork.jpg", @"mushroom_risotto.jpg", @"noodle_with_bbq_pork.jpg", @"starbucks_coffee.jpg", @"thai_shrimp_cake.jpg", @"vegetable_curry.jpg", @"white_chocolate_donut.jpg", nil];
    
    self.MapViewScrollView.contentSize= CGSizeMake(415, 300 + self.CategoryControllerView.frame.size.height);
    
    MGLPointAnnotation * annotation = [[MGLPointAnnotation alloc]init];
    
    //self.mapView.userTrackingMode= MGLUserTrackingMode.MGLUserTrackingMode;
    self.mapView.showsUserLocation = YES;
    annotation.coordinate = self.mapView.userLocation.location.coordinate;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)];
    
    //annotation.coordinate = CLLocationCoordinate2DMake(40.7326808, -73.984340);
    //[self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.7326808, -73.984340)];
    
    self.mapView.zoomLevel = 14;
    
    //[self.mapView addAnnotation:annotation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sliderChange:(UISlider *)sender {
    self.dayLabel.text = [NSString stringWithFormat:@"%i",
                          (NSInteger)sender.value];
    
}

/*wo
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

 -(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
 {
     if([item.title isEqual:@"Test2"])
     {
         /*ViewController *subClass = [[ViewController alloc] init];
         subClass.view.frame = self.view.frame;
         subClass.view.autoresizingMask = self.view.autoresizingMask;
         [self.view.superview addSubview:subClass.view];
         
         //ARC
         //instanceVarSubClass = subClass;
         
         //NO ARC
         //self.instanceVarSubClass = subClass;
         //[subClass release];*/
         
         /*
          -(void)perform {
          UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
          UIViewController *destinationController = (UIViewController*)[self destinationViewController];
          UINavigationController *navigationController = sourceViewController.navigationController;
          // Pop to root view controller (not animated) before pushing
          [navigationController popToRootViewControllerAnimated:NO];
          [navigationController pushViewController:destinationController animated:YES];
          }*/
     }
     else
     {
         //your code
     }
 }

//MapView Delegate

- (void)mapView:(nonnull MGLMapView *)mapView didUpdateUserLocation:(nullable MGLUserLocation *)userLocation{
    MGLPointAnnotation * annotation = [[MGLPointAnnotation alloc]init];
    
    annotation.coordinate = self.mapView.userLocation.location.coordinate;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)];
    
    [self.mapView addAnnotation:annotation];
}

//Collectionview Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *categoryImageView = (UIImageView *)[cell viewWithTag:100];
    categoryImageView.image = [UIImage imageNamed:[self.categoryPhotos objectAtIndex:indexPath.row]];
    
    return cell;
}
    

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.

@end
