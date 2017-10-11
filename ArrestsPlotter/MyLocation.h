//
//  MyLocation.h
//  ArrestsPlotter
//
//  Created by Z on 09.10.17.
//  Copyright © 2017 KonstantinBulavenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface MyLocation : NSObject<MKAnnotation>

- (instancetype)initWithName: (NSString *) name address:(NSString *)adddress coordinate:(CLLocationCoordinate2D) coordinate;
- (MKMapItem *)mapItem;



- (NSString *) title;
- (NSString *)subtitle;
- (CLLocationCoordinate2D)coordinate;


@end
