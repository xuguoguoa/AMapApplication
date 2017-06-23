//
//  WAMapDetailViewController.h
//

#import <UIKit/UIKit.h>
#import "WAMapDetailController.h"
#import "Masonry.h"

#define TableViewHeight 300.0

@interface WAMapDetailViewController : UIViewController

@property (nonatomic, strong) WAMapDetailController *mapController;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UINavigationBar *navigationBar;

@property (nonatomic, strong) MASConstraint *searchBarTopHeight;

@property (nonatomic, strong) MASConstraint *tableHeight;

-(instancetype)initWithBlock:(SelectMapLocation)aBlock;

@end
