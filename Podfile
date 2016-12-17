platform :ios, '9.0'
use_frameworks!

target 'ASDKSampleProject' do

    pod 'AsyncDisplayKit',
        git: 'https://github.com/leotumwattana/AsyncDisplayKit.git',
        branch: '2.0'

end

# Post pod install hook to set the Swift Version to use in build settings.
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
