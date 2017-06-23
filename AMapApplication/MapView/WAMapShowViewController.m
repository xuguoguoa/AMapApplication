//
//  WAMapShowViewController.m
//

#import "WAMapShowViewController.h"
#import "Masonry.h"

@interface WAMapShowViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *address;

@property(nonatomic, strong) UINavigationBar *navigationBar;

@end

@implementation WAMapShowViewController

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D) coordinate withAddress:(NSString *)address
{
  if(self = [super init])
  {
    self.coordinate = coordinate;
    self.address = address;
  }
  return self;
}
- (void)viewDidLoad
{
  
  [super viewDidLoad];
  [self.mapView removeAnnotations:self.mapView.annotations];
  self.view.backgroundColor = [UIColor whiteColor];
  //添加navigationbar
  [self addNavigationBar];
  [self.view addSubview:_mapView];
  
  MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
  [annotation setCoordinate:self.coordinate];
  [annotation setTitle:self.address];
  [self addAnnotationToMapView:annotation];
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
  [self.mapView addAnnotation:annotation];
  [self.mapView selectAnnotation:annotation animated:YES];
  [self.mapView setZoomLevel:15.1 animated:NO];
  [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
  
  [super viewWillAppear:animated];
  
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
  if ([annotation isKindOfClass:[MAPointAnnotation class]])
  {
    static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
    MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
    if (annotationView == nil)
    {
      annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
      
      annotationView.canShowCallout            = YES;
      annotationView.animatesDrop              = YES;
      annotationView.draggable                 = YES;
    }
    
    annotationView.pinColor = MAPinAnnotationColorRed;
    
    return annotationView;
  }
  
  return nil;
}

-(void)addNavigationBar
{
  self.navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44.0f)];
  [self.view addSubview:self.navigationBar];
  //设置导航栏背景色
  UIImage *image = [UIImage imageNamed:@"nav_bg.png"];
  [self.navigationBar setBackgroundImage:image
                           forBarMetrics:UIBarMetricsDefault];
  //设置导航栏返回按钮
  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  backButton.frame = CGRectMake(0, 0, 44, 44);
  [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
  [backButton setBackgroundImage:[UIImage imageNamed:@"nav_btn_b_back"] forState:UIControlStateNormal];
  
  //返回按钮
  UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  //间隙，调整返回按钮左边距
  UIBarButtonItem *navSpacer = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                target:nil action:nil];
  navSpacer.width = -16;
  UINavigationItem *navItem = [[UINavigationItem alloc] init] ;
  [navItem setLeftBarButtonItems:@[navSpacer,backBarButtonItem]];
  
  self.navigationBar.items = [NSArray arrayWithObject:navItem];
}

-(MAMapView *)mapView
{
  if(!_mapView)
  {
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64.0, self.view.frame.size.width, self.view.frame.size.height-64.0)];
    _mapView.delegate = self;
  }
  return _mapView;
}

-(void)backAction
{
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
