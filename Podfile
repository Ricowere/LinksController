
workspace 'LinksControllerExample.xcworkspace'
project 'LinksControllerExample.xcodeproj'

# ignore all warnings from all pods
inhibit_all_warnings!

use_frameworks!

##### Cocoapods Repository #####
pod 'JLRoutes', '~> 1.6'
#########################

target 'LinksControllerExample'
target 'LinksControllerPlaygrounds'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end
