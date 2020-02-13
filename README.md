# send_mms

A Plugin that allows you to attach an image as MMS with the user's default messaging app.

[![pub package](https://img.shields.io/pub/v/share_extend.svg)](https://pub.dartlang.org/packages/share_extend)

A Flutter plugin for iOS and Android for sharing text, image, video and file with system ui. 

## Installation

First, add `send_mms` as a dependency in your pubspec.yaml file.

```
dependencies:
  send_mms: "^0.0.1"
```

### iOS

Add the following key to your info.plist file, located in `<project root>/ios/Runner/Info.plist` for saving shared images to photo library.

```
<key>NSPhotoLibraryAddUsageDescription</key>
<string>describe why your app needs access to write photo library</string>
```

### Android

If your project needs read and write permissions for sharing external storage file, please add the following permissions to your AndroidManifest.xml, located in `<project root>/android/app/src/main/AndroidManifest.xml`

```
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

## Import

```
import 'package:send_mms/send_mms.dart';
```


## Example

```

//share text
SendMMS.share(message: "Hello!",
                      phone: "1234451231");

//share image
File f = await ImagePicker.pickImage(source: ImageSource.gallery);
SendMMS.share(imagePath:f.path,message: "Hello!",phone: "1234451231");



```



## License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details