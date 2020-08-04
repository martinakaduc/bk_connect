import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TODO: Add your API key
    GMSServices.provideAPIKey("AIzaSyBjMCwGs5-kRyZ504Szs2Qv546Ud1Kwp4g")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
