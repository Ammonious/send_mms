#import "SendMmsPlugin.h"


@interface SendMmsPlugin () <MFMessageComposeViewControllerDelegate>
@property(copy, nonatomic) FlutterResult result;

@end


@implementation SendMmsPlugin {
    MFMessageComposeViewController *msgController;
    UIViewController *_viewController;
}

 + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* shareChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"com.schemecreative.send_mms/send"
                                          binaryMessenger: [registrar messenger]];
     UIViewController *viewController =
     [UIApplication sharedApplication].delegate.window.rootViewController;
     SendMmsPlugin *instance = [[SendMmsPlugin alloc] initWithViewController:viewController];
     [registrar addMethodCallDelegate:instance channel:shareChannel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
  self = [super init];
  if (self) {
    _viewController = viewController;
     
  }
  return self;
}
#pragma mark MethodCallDelegate

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
if (self.result) {
  self.result([FlutterError errorWithCode:@"multiple_request"
                                  message:@"Cancelled by a second request"
                                  details:nil]);
  self.result = nil;
}
    if ([@"share" isEqualToString:call.method]) {
               NSDictionary *arguments = [call arguments];
               NSString *message = arguments[@"message"];
               NSString *phone = arguments[@"phone"];
               NSString *imagePath = arguments[@"image"];
               NSURL *url = [NSURL fileURLWithPath:imagePath];
               [self share:message recipient:phone image:url];

           } else {
               self.result(FlutterMethodNotImplemented);
           }
}



- (void)share:(NSString *)message recipient:(NSString *)cell image:(NSURL *)imageUrl  {

     msgController = [[MFMessageComposeViewController alloc] initWithRootViewController:_viewController];
        msgController.messageComposeDelegate = self;
   
    if([MFMessageComposeViewController canSendText]){
        msgController.recipients = [NSArray arrayWithObjects:cell, nil];
        
        if(imageUrl != nil){
            NSError* error = nil;
            NSData *dataImg = [NSData dataWithContentsOfURL:imageUrl options:NSDataReadingUncached error:&error];
             [msgController addAttachmentData:dataImg typeIdentifier:@"public.data" filename:@"image.png"];
        }
        msgController.body = message;
        [_viewController presentViewController:msgController animated:YES completion:nil];
    }
}

#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {

    
    switch (result) {
        case MessageComposeResultCancelled:
                [controller dismissViewControllerAnimated:YES completion:nil];

            break;
        case MessageComposeResultFailed:

            break;
        case MessageComposeResultSent:
             [controller dismissViewControllerAnimated:YES completion:nil];

            break;
        default:
            break;
        }
        self.result(nil);
}



@end
