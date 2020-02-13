#import "SendMmsPlugin.h"

@implementation SendMmsPlugin

 + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* shareChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"com.schemecreative.send_mms"
                                          binaryMessenger: [controller binaryMessenger]];

    [shareChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
        if ([@"share" isEqualToString:call.method]) {
            NSDictionary *arguments = [call arguments];
            NSString *message = arguments[@"message"];
            NSString *phone = arguments[@"phone"];
            NSString *imagePath = arguments[@"image"];
            NSURL *url = [NSURL fileURLWithPath:imagePath];
            [self share:message recipient:phone image:url];


        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
}

+ (void)share:(NSString *)message recipient:(NSString *)cell image:(NSURL *)imageUrl {

    UIViewController *controller =[UIApplication sharedApplication].keyWindow.rootViewController;

    MFMessageComposeViewController *msgController = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        msgController.recipients = [NSArray arrayWithObjects:cell, nil];
        NSError* error = nil;
        NSData *dataImg = [NSData dataWithContentsOfURL:imageUrl options:NSDataReadingUncached error:&error];

        [msgController addAttachmentData:dataImg typeIdentifier:@"public.data" filename:@"image.png"];
        
        msgController.body = message;
        msgController.messageComposeDelegate = self;
        [controller presentViewController:msgController animated:YES completion:nil];
    }
}


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

}



@end
