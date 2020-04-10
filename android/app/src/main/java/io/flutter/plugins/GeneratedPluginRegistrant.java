package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.example.citypickers.CityPickersPlugin;
import io.github.v7lin.fakealipay.FakeAlipayPlugin;
import io.github.v7lin.fakewechat.FakeWechatPlugin;
import com.example.flutterimagecompress.FlutterImageCompressPlugin;
import com.pichillilorenzo.flutter_inappbrowser.InAppBrowserFlutterPlugin;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;
import com.jiguang.jpush.JPushPlugin;
import com.vitanov.multiimagepicker.MultiImagePickerPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.tekartik.sqflite.SqflitePlugin;
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin;
import will.com.xsprogresshud.XsProgressHudPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    CityPickersPlugin.registerWith(registry.registrarFor("com.example.citypickers.CityPickersPlugin"));
    FakeAlipayPlugin.registerWith(registry.registrarFor("io.github.v7lin.fakealipay.FakeAlipayPlugin"));
    FakeWechatPlugin.registerWith(registry.registrarFor("io.github.v7lin.fakewechat.FakeWechatPlugin"));
    FlutterImageCompressPlugin.registerWith(registry.registrarFor("com.example.flutterimagecompress.FlutterImageCompressPlugin"));
    InAppBrowserFlutterPlugin.registerWith(registry.registrarFor("com.pichillilorenzo.flutter_inappbrowser.InAppBrowserFlutterPlugin"));
    ImagePickerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"));
    JPushPlugin.registerWith(registry.registrarFor("com.jiguang.jpush.JPushPlugin"));
    MultiImagePickerPlugin.registerWith(registry.registrarFor("com.vitanov.multiimagepicker.MultiImagePickerPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    PermissionHandlerPlugin.registerWith(registry.registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    WebViewFlutterPlugin.registerWith(registry.registrarFor("io.flutter.plugins.webviewflutter.WebViewFlutterPlugin"));
    XsProgressHudPlugin.registerWith(registry.registrarFor("will.com.xsprogresshud.XsProgressHudPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
