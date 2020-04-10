//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <city_pickers/CityPickersPlugin.h>
#import <fake_alipay/FakeAlipayPlugin.h>
#import <fake_wechat/FakeWechatPlugin.h>
#import <flutter_image_compress/FlutterImageCompressPlugin.h>
#import <flutter_inappbrowser/InAppBrowserFlutterPlugin.h>
#import <image_picker/ImagePickerPlugin.h>
#import <jpush_flutter/JPushPlugin.h>
#import <multi_image_picker/MultiImagePickerPlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <permission_handler/PermissionHandlerPlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <sqflite/SqflitePlugin.h>
#import <webview_flutter/WebViewFlutterPlugin.h>
#import <xs_progress_hud/XsProgressHudPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [CityPickersPlugin registerWithRegistrar:[registry registrarForPlugin:@"CityPickersPlugin"]];
  [FakeAlipayPlugin registerWithRegistrar:[registry registrarForPlugin:@"FakeAlipayPlugin"]];
  [FakeWechatPlugin registerWithRegistrar:[registry registrarForPlugin:@"FakeWechatPlugin"]];
  [FlutterImageCompressPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterImageCompressPlugin"]];
  [InAppBrowserFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"InAppBrowserFlutterPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [JPushPlugin registerWithRegistrar:[registry registrarForPlugin:@"JPushPlugin"]];
  [MultiImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"MultiImagePickerPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
  [XsProgressHudPlugin registerWithRegistrar:[registry registrarForPlugin:@"XsProgressHudPlugin"]];
}

@end
