#import "LoginViewController.h"
#import "AppDelegate.h"

CGFloat const keyBoardHeight = 216.0f;
CGFloat const minimumOffset = 30.0f;

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.nameTextField becomeFirstResponder];
    [self.nameTextField setDelegate:self];
    [self.loginButton setBackgroundColor:[UIColor purpleColor]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onLoginButtonPressed:(id)sender {

  if ([self.nameTextField.text length] == 0) {
    return;
  }

  [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLoginNotification"
                                                      object:nil
                                                    userInfo:@{@"userId" : self.nameTextField.text}];

  [self performSegueWithIdentifier:@"mainView" sender:nil];
}

@end
