//
//  WAMapShowViewController.h
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface WAMapShowViewController : UIViewController

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D) coordinate withAddress:(NSString *)address;

@end
