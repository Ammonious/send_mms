package com.schemecreative.send_mms;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;

import java.io.File;
import java.util.Map;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** SendMmsPlugin */
public class SendMmsPlugin implements MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

  /// the authorities for FileProvider
  private static final int CODE_ASK_PERMISSION = 100;
  private static final String CHANNEL = "com.schemecreative.send_mms/send";

  private final Registrar mRegistrar;
  private String message;
  private String phone;
  private String imagePath;

  public static void registerWith(Registrar registrar) {
    MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);

    final SendMmsPlugin instance = new SendMmsPlugin(registrar);
    registrar.addRequestPermissionsResultListener(instance);
    channel.setMethodCallHandler(instance);
  }

  SendMmsPlugin(Registrar registrar) {
    this.mRegistrar = registrar;
  }


  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
    if (call.method.equals("share")) {
      if (!(call.arguments instanceof Map)) {
        throw new IllegalArgumentException("Map argument expected");
      }
      // Android does not support showing the share sheet at a particular point on screen.
      String message = call.argument("message");
      String phone = call.argument("phone");
      String imagePath = call.argument("image");

      if(imagePath != null && !imagePath.isEmpty()){
        shareImage(message, phone, imagePath);
      } else {
        shareText(message, phone);
      }

      result.success(null);
    } else {
      result.notImplemented();
    }
  }

  private void shareImage(String message, String phone, String imagePath) {
    this.message = message;
    this.phone = phone;
    this.imagePath = imagePath;
    if (ShareUtils.shouldRequestPermission(imagePath)) {
      if (!checkPermission()) {
        requestPermission();
        return;
      }
    }
    Intent shareIntent = new Intent();
    shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

    File f = new File(imagePath);
    Uri uri = ShareUtils.getUriForFile(mRegistrar.activity(), f, "image");
    shareIntent.setAction(Intent.ACTION_SEND);
    shareIntent.putExtra(Intent.EXTRA_TEXT, message);
    shareIntent.putExtra("address", phone);
    shareIntent.setType("text/plain");
    shareIntent.setType("image/*");
    shareIntent.setAction(Intent.ACTION_SEND);
    shareIntent.putExtra(Intent.EXTRA_STREAM, uri);
    mRegistrar.activity().startActivity(shareIntent);

  }

  private void shareText(String message, String phone) {
    this.message = message;
    this.phone = phone;
    if (ShareUtils.shouldRequestPermission(imagePath)) {
      if (!checkPermission()) {
        requestPermission();
        return;
      }
    }
    Intent shareIntent = new Intent();
    shareIntent.setAction(Intent.ACTION_SEND);
    shareIntent.putExtra(Intent.EXTRA_TEXT, message);
    shareIntent.putExtra("address", phone);
    shareIntent.setType("text/plain");
    shareIntent.setAction(Intent.ACTION_SEND);
    mRegistrar.activity().startActivity(shareIntent);

  }
  private boolean checkPermission() {
    return ContextCompat.checkSelfPermission(mRegistrar.activity(), Manifest.permission.WRITE_EXTERNAL_STORAGE)
            == PackageManager.PERMISSION_GRANTED;
  }

  private void requestPermission() {
    ActivityCompat.requestPermissions(mRegistrar.activity(), new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, CODE_ASK_PERMISSION);
  }

  @Override
  public boolean onRequestPermissionsResult(int requestCode, String[] perms, int[] grantResults) {
    if (requestCode == CODE_ASK_PERMISSION && grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
      if(imagePath != null && !imagePath.isEmpty()){
        shareImage(message, phone, imagePath);
      } else {
        shareText(message, phone);
      }
    }
    return false;


  }
}
