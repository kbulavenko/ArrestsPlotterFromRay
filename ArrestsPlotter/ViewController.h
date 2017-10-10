//
//  ViewController.h
//  ArrestsPlotter
//
//  Created by Z on 28.09.17.
//  Copyright © 2017 KonstantinBulavenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarButtonRefresh;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


- (IBAction)refreshTapped:(id)sender;


-(void)addToolbarY:(CGFloat)   y;


@end

