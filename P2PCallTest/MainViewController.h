#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MainViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *destination;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

- (IBAction)call:(id)sender;

@end
