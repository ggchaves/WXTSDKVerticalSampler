# Uncomment the next line to define a global platform for your project
 platform :ios, '10.1'

target 'WXTSDKSampler' do
  # Comment the next line if you're not using Swift and don't want to use dynam$
  use_frameworks!

  # Pods for CiscoSparkVideo
  pod 'WebexSDK', :git => 'https://github.com/webex/webex-ios-sdk.git', :branch => 'EFT/2.0.0'
  pod 'SwiftMessages', '~> 3.3'
  pod 'SwiftySettings', '~> 1.0'
  pod 'SwiftyUserDefaults'
  pod 'PopupDialog'
  pod 'ActionButton'
  pod 'SwiftForms'
  pod 'MIAlertController', '~> 1.1'
  pod 'MIFab', '~> 1.0'
  pod 'Mixpanel-swift'
  pod 'Device.swift'
  pod 'EPSignature', '~> 1.0'
  pod 'ResearchKit', '~> 1.4'
  pod 'CareKit'
  pod 'APFeedBack'
  pod 'RVCalendarWeekView', '~> 0.5'
  pod 'ASBottomSheet'
  pod 'AABlurAlertController'
  pod 'DateToolsSwift', '~> 4.0'
  pod 'Bohr', '~> 3.0'
  pod 'CollectionViewSlantedLayout', '~> 3.0'
  pod 'JSQMessagesViewController'
  pod 'CircularSpinner'
end

target 'WXTSamplerBroadcast' do
    use_frameworks!
    platform :ios, '11.2'
    pod 'SparkBroadcastExtensionKit'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'MAS_SHORTHAND=1'
    end
  end
end
