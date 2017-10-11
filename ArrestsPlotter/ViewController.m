//
//  ViewController.m
//  ArrestsPlotter
//
//  Created by Z on 28.09.17.
//  Copyright © 2017 KonstantinBulavenko. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "MyLocation.h"

#define METERS_PER_MILE 1609.344

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.toolbar.hidden  = NO;
    [self.toolbar sizeToFit];
    NSLog(@"self.toolbar.items = %@",self.toolbar.items);
    
    
    self.mapView.delegate = (id<MKMapViewDelegate>)self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude   = 39.281516;
//    zoomLocation.longitude  = -76.6475852768532;
    zoomLocation.latitude   = 39.2843706746922;
    zoomLocation.longitude  = -76.6386039056014;
    
    //39.2843706746922°, -76.6386039056014°
    
    
    // 2
    MKCoordinateRegion viewRegion  =
    MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);
    
    // 3
    [_mapView  setRegion: viewRegion  animated: YES];
    
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    return;
//    NSLog(@"touchesBegan");
//    NSLog(@"self.toolbar = %@",self.toolbar);
//    self.toolbar.hidden   = ! self.toolbar.hidden;
//    
//    CGFloat    delta   =   self.toolbar.frame.size.height;
//    
//    if( !self.toolbar.hidden) {
//        
//        
//        [self addToolbarY: -delta];
//        [self addMapViewHeight: -delta];
//        
//        
//    } else {
//        [self addToolbarY: delta];
//        [self addMapViewHeight: delta];
//    }
//    
//   // self.toolbar.opaque   = ! self.toolbar.opaque;
//    
//}

- (IBAction)refreshTapped:(id)sender {
    // 0   Auth Operation
    //NSURL   *authUrl    = [NSURL URLWithString: @"https://data.baltimorecity.gov/api/views/3i3v-ibrt/rows.json?$$app_token=NqJsfTZ2QN3kOx3a2dz8kRtpu"];
    
    
    // 00  Auth Request
   // NSURLRequest   *authRequest         = [[NSURLRequest  alloc]   initWithURL: authUrl];
   // NSURLResponse  *authResponse        = nil;
   // NSError        *authRequestError    = nil;
  //  __block NSData         *authData              = nil;
   // [NSURLConnection sendSynchronousRequest: authRequest returningResponse:nil error:nil];
//    NSLog(@"Begin  dataTaskWithURL ");
//    NSURLSessionDataTask     *authSessionDataTask  =   [
//                    [NSURLSession   sharedSession] dataTaskWithURL: authUrl
//                                                completionHandler:^(NSData * _Nullable data,
//                                                                    NSURLResponse * _Nullable response,
//                                                                    NSError * _Nullable error) {
//         NSLog(@"NSURLResponse response = %@", response);
//    
//    }];
//    
//    NSLog(@"authSessionDataTask.response = %@", authSessionDataTask.response);
//
//    
    
    // 1
    //   Gets the lat/long for the center of the map.
    
    MKCoordinateRegion  mapRegion           = [_mapView region];
    CLLocationCoordinate2D  centerLocation  = mapRegion.center;
    
    // 2 Reads in the command file template that you downloaded from this site, which is the query string you need to send to the Socrata API to get the arrests within a radius of a particular location. It also has a hardcoded date restriction in there to keep the data set managable. The command file is set up to be a query string, so you can substitute the lat/long and radius in there as parameters. It has a hardcoded radius here (0.5 miles) to again keep the returned data managable.
    NSString   *jsonFile        = [[NSBundle mainBundle]  pathForResource:@"command" ofType:@"json"];
    NSString   *formatString    = [NSString   stringWithContentsOfFile: jsonFile encoding: NSUTF8StringEncoding error: nil];
    NSString   *json            = [NSString stringWithFormat: formatString,
                                   centerLocation.latitude, centerLocation.longitude, 0.5 * METERS_PER_MILE];
    
    // 3 Creates a URL for the web service endpoint to query.
 //  NSURL   *url    = [NSURL URLWithString: @"https://data.baltimorecity.gov/api/views/3i3v-ibrt/rows.json?accessType=DOWNLOAD"];
    
   // NSURL   *url    = [NSURL URLWithString: @"http://data.baltimorecity.gov/resource/icjs-e3jg.json?accessType=DOWNLOAD$$app_token=NqJsfTZ2QN3kOx3a2dz8kRtpu"];
    
    
//    NSURL   *url    = [NSURL URLWithString: @"https://data.baltimorecity.gov/api/views/3i3v-ibrt/rows.json?accessType=DOWNLOAD"];
    
    NSString      *centerLongtitude   =  [NSString   stringWithFormat: @"%0.13f",centerLocation.longitude];
    
    
    NSString   *latitudeMin   =   [NSString   stringWithFormat: @"%0.13f",mapRegion.center.latitude - mapRegion.span.latitudeDelta / 1.0];
    NSString   *latitudeMax   =   [NSString   stringWithFormat: @"%0.13f",mapRegion.center.latitude + mapRegion.span.latitudeDelta / 1.0];
    NSString   *longitudeMin  =   [NSString   stringWithFormat: @"%0.13f",mapRegion.center.longitude - mapRegion.span.longitudeDelta / 1.0];
    NSString   *longitudeMax  =   [NSString   stringWithFormat: @"%0.13f",mapRegion.center.longitude + mapRegion.span.longitudeDelta / 1.0];
    
    
    NSLog(@" longitudeMin = %@, longitudeMax  = %@, latitudeMin  = %@, latitudeMax  = %@  ", longitudeMin, longitudeMax, latitudeMin, latitudeMax);
    
    NSString      *urlString = [NSString   stringWithFormat:@"http://data.baltimorecity.gov/resource/icjs-e3jg.json?$where=latitude between %@ and %@ and longitude between %@ and %@" ,latitudeMin, latitudeMax , longitudeMin, longitudeMax ];
    NSLog(@"urlString = %@", urlString);
    NSURL   *url    = [NSURL URLWithString: [urlString stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet  URLQueryAllowedCharacterSet]]];
    NSLog(@"url1  = %@", url);

    
//url = [NSURL   URLWithString:   @"http://data.baltimorecity.gov/resource/icjs-e3jg.json?longitude=-76.6475852768532"];
    
  //  NSLog(@"url2  = %@", url);

    
   // https://data.baltimorecity.gov/resource/icjs-e3jg.json
    // https://data.baltimorecity.gov/resource/icjs-e3jg.json?arrest=17108516
    //  http://data.baltimorecity.gov/resource/icjs-e3jg.csv?$limit=5000&$$app_token=YOURAPPTOKENHERE
    
    //  https://data.baltimorecity.gov/api/views/3i3v-ibrt/rows.json?accessType=DOWNLOAD
    
//    // 4 Creates a ASIHTTPRequest request, and sets it up as a POST, passing in the JSON string as data.
//    ASIHTTPRequest   *_request = [ASIHTTPRequest requestWithURL:  url];
//    __weak  ASIHTTPRequest  *request    = _request;
//    
//    request.requestMethod  = @"POST";
//    [request  addRequestHeader:@"Content-Type" value: @"application/json"];
//   // NSLog(@"\n\n\njson = %@", json);
//    [request appendPostData: [json dataUsingEncoding: NSUTF8StringEncoding]];
//    
//    // 5  Sets up two blocks for the completion and failure. So far on this site we’ve been using callback methods (instead of blocks) with ASIHTTPRequest, but I wanted to show you the block method here because it’s kinda cool and convenient. Right now, these do nothing but log the results.
//    [request setDelegate: self];
//    [request setAuthenticationNeededBlock:^{
//        NSLog(@"Authentification block started");
//        
//    }];
//    [request setCompletionBlock:^{
//        NSString    *responseString  = [request responseString];
//        NSLog(@"\n\nResponse : %@", responseString);
//        // 7
//        [self plotCrimePosition: request.responseData];
//    }];
//    [request setFailedBlock:^{
//        NSError *error = [request error];
//        NSLog(@"Error: %@", error.localizedDescription);
//    }];

    //*****************   Begin GET session    *******************
    
    NSLog(@"*****************   Begin GET session    *******************");
    ASIHTTPRequest   *_request = [ASIHTTPRequest requestWithURL:  url];
    __weak  ASIHTTPRequest  *request    = _request;
    
    request.requestMethod  = @"GET";
  //  [request  addRequestHeader:@"Content-Type" value: @"application/json"];
    // NSLog(@"\n\n\njson = %@", json);
   // [request appendPostData: [json dataUsingEncoding: NSUTF8StringEncoding]];
    
    // 5  Sets up two blocks for the completion and failure. So far on this site we’ve been using callback methods (instead of blocks) with ASIHTTPRequest, but I wanted to show you the block method here because it’s kinda cool and convenient. Right now, these do nothing but log the results.
    [request setDelegate: self];
//    [request setAuthenticationNeededBlock:^{
//        NSLog(@"Authentification block started");
//        
//    }];
    [request setCompletionBlock:^{
        NSString    *responseString  = [request responseString];
        NSLog(@"\n\nResponse : \n\n%@\n\nRESPONSEEND \n\n\n", responseString);
        // 7
        [self plotCrimePosition: request.responseData];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    

    
    
    
    //***************
    
    
    
    
    // 6 Finally, starts the request going asynchronously. When it completes, either the completion or error block will be executed.
    [request startAsynchronous];
}

//-(void)addToolbarY:(CGFloat)   y
//{
//    CGRect   currentToolbarFrameForChange  = self.toolbar.frame;
//    NSLog(@"currentToolbarFrameForChange = %@",   NSStringFromCGRect( currentToolbarFrameForChange ));
//    currentToolbarFrameForChange.origin.y   += y;
//    self.toolbar.frame = currentToolbarFrameForChange  ;
//    [self.toolbar sizeToFit];
//
//}
//
//-(void)addMapViewHeight:(CGFloat)   y
//{
//    CGRect   currentMapViewFrameForChange  = self.mapView.frame;
//    NSLog(@"currentMapViewFrameForChange = %@",   NSStringFromCGRect( currentMapViewFrameForChange ));
//    currentMapViewFrameForChange.size.height   += y;
//    self.mapView.frame = currentMapViewFrameForChange  ;
//    [self.mapView sizeToFit];
//    
//}

- (void)plotCrimePosition: (NSData *)responseData {
    
    NSLog(@"plotCrimePosition");
    
    for(id<MKAnnotation> annotation in _mapView.annotations) {
        
        NSLog(@"Annotation = %@", annotation);
        [_mapView removeAnnotation: annotation];
    }
    
    if([NSJSONSerialization  isValidJSONObject: responseData])  {
        NSLog(@"responseData is valid");
        
    } else {
        NSLog(@"responseData is *NOT* valid");
        //return;
    }
    
    
    // NSDictionary    *root   = [NSJSONSerialization JSONObjectWithData: responseData
    //                                                           options: 0
    //                                                             error: nil];
    NSError     *errorSerialisation   = nil;
     NSArray    *root   = [NSJSONSerialization JSONObjectWithData: responseData
                                                               options: NSJSONReadingMutableContainers
                                                                 error: &errorSerialisation];
    
    
    NSLog(@"errorSerialisation = %@", errorSerialisation);
    
    
    
    
    NSLog(@" \n\n\nroot  = %@   \n\n\n ROOTEND", root);
    NSArray         *data   =  root; // [NSKeyedUnarchiver    unarchiveObjectWithData: root];
    
    //NSArray         *data   =(NSArray *)  root ;
    
    
  //  NSArray           *data   =  [NSJSONSerialization JSONObjectWithData: responseData
//                                                options: 0
//                                                error: nil];
    
//    NSArray         *data   = [root objectForKey: @"data"];
    
    NSLog(@"\n\n\nDATA\nDATA\nDATA = %@, \n DATA.count = %li   \n\n\n DATAEND \n\n", data, data.count);
    
    
    int  i= 0;
    for (NSDictionary *row in data) {
        NSLog(@"Iteration %i  : row =  %@, class  = %@", i++, row, [row class]);
        NSNumber  *latitude         =  row[@"latitude"];
        //[[row objectAtIndex:22] objectAtIndex: 1];
        NSLog(@"\n\n\nlatitude = %@", latitude);
        NSNumber  *longtitude       = row[@"longitude"];
        //[[row objectAtIndex: 22] objectAtIndex: 2];
        NSLog(@"longtitude = %@", longtitude);

        NSString  *crimeDescription =  row[@"chargedescription"];
        //[row objectAtIndex: 18];
        NSLog(@"crimeDescription = %@", crimeDescription);

        NSString  *address          =  row[@"arrestlocation"];
        //[row objectAtIndex: 14];
        NSLog(@"address = %@", address);

        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude     = latitude.doubleValue;
        coordinate.longitude    = longtitude.doubleValue;
        MyLocation  *annotation = [[MyLocation alloc] initWithName:crimeDescription
                                                           address: address
                                                        coordinate:coordinate];
        [_mapView addAnnotation: annotation];
    }
}

// MARK: Implementation MKMapViewDelegate
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static  NSString   *identifier      = @"MyLocation";
    if([annotation isKindOfClass: [MyLocation class]]) {
        MKAnnotationView *annotaionView = (MKAnnotationView *)
                                            [_mapView dequeueReusableAnnotationViewWithIdentifier: identifier];
        if(annotation == nil) {
            annotaionView = [[MKAnnotationView alloc]  initWithAnnotation: annotation
                                                          reuseIdentifier: identifier];
            annotaionView.enabled           = YES;
            annotaionView.canShowCallout    = YES;
            annotaionView.image             = [UIImage imageNamed:@"arrest.png"]; // here we used nice image instead of the default pins
        } else {
            annotaionView.annotation  = annotation;
        }
        return annotaionView;
    }
    
    // Not MyLocation class 
    return nil;
}


@end
