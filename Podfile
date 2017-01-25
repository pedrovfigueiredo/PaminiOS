# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Pamin' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Pamin
  pod 'Alamofire', '~> 4.0.1’
  pod 'AlamofireImage', '~> 3.1'
  pod 'SwiftyJSON'
  pod 'Eureka', '~> 2.0.0-beta.1'
  pod ‘IQKeyboardManagerSwift’
  pod 'Cloudinary', '~> 2.0'
  pod 'SwiftOverlays', '~> 3.0.0'

end

#Para o Cloudinary funcionar:

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # remove this when https://github.com/cloudinary/cloudinary_ios/issues/57 is resolved
      if target.name == 'Cloudinary'
        config.build_settings['FRAMEWORK_SEARCH_PATHS'] = [
          '$(inherited)',
          './Cloudinary/Cloudinary/Frameworks/CLDCrypto/$(PLATFORM_NAME)',
          '$PODS_CONFIGURATION_BUILD_DIR/Alamofire'
        ]
      end
    end
  end
end
