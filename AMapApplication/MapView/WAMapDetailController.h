//
//  WAMapDetailController.h
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
typedef void (^SelectMapLocation)(NSString *address, double latitude, double longitude);

@class WAMapDetailViewController;

@interface WAMapDetailController : NSObject<UISearchBarDelegate,MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, weak) WAMapDetailViewController *mapVC;

-(instancetype)initWithBlock:(SelectMapLocation)aBlock;

-(void)startLocation;

-(void)refreshMap;

-(void)sureButton;

@end
