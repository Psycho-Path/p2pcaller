#import "AppDelegate.h"
#import "AppDelegate+UI.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self addSplashView];
  [self handleLocalNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]];
  [self requestUserNotificationPermission];
  [[NSNotificationCenter defaultCenter]
      addObserverForName:@"UserDidLoginNotification"
                  object:nil
                   queue:nil
              usingBlock:^(NSNotification *note) { [self initSinchClientWithUserId:note.userInfo[@"userId"]]; }];
  return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  [self handleLocalNotification:notification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [self dismissSplashViewIfNecessary];
}

- (void)requestUserNotificationPermission {
  if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
  }
}

#pragma mark -

- (id<SINClient>)client {
  return _client;
}

- (void)initSinchClientWithUserId:(NSString *)userId {
  if (!_client) {
    _client = [Sinch clientWithApplicationKey:@"76a605bc-6b31-4bd9-a4c7-68cc039a1e10"
                            applicationSecret:@"K2c8ypUofU6XWuG4LoMQEw=="
                              environmentHost:@"sandbox.sinch.com"
                                       userId:userId];

    _client.delegate = self;

    [_client setSupportCalling:YES];
    [_client setSupportActiveConnectionInBackground:YES];

    [_client start];
    [_client startListeningOnActiveConnection];
  }
}

- (void)handleLocalNotification:(UILocalNotification *)notification {
  if (notification) {
    id<SINNotificationResult> result = [self.client relayLocalNotification:notification];
    if ([result isCall] && [[result callResult] isTimedOut]) {
      UIAlertView *alert = [[UIAlertView alloc]
              initWithTitle:@"Missed call"
                    message:[NSString stringWithFormat:@"Missed call from %@", [[result callResult] remoteUserId]]
                   delegate:nil
          cancelButtonTitle:nil
          otherButtonTitles:@"OK", nil];
      [alert show];
    }
  }
}

#pragma mark - SINClientDelegate

- (void)clientDidStart:(id<SINClient>)client {
  NSLog(@"Sinch client started successfully (version: %@)", [Sinch version]);
}

- (void)clientDidStop:(id<SINClient>)client {
  NSLog(@"Sinch client stopped");
}

- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error {
  NSLog(@"Error: %@", error);
}

- (void)client:(id<SINClient>)client
    logMessage:(NSString *)message
          area:(NSString *)area
      severity:(SINLogSeverity)severity
     timestamp:(NSDate *)timestamp {
  if (severity == SINLogSeverityCritical) {
    NSLog(@"%@", message);
  }
}

@end