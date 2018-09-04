# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Afaps'

abstract_target 'defaults' do
    #Alamofire && Network
    pod 'Alamofire', '~> 4.6.0'
    pod 'EVReflection/Alamofire', '~> 5.4.0'

    #Firebase
    pod 'Firebase/Core', '~> 4.7.0'
    pod 'Firebase/Messaging', '~> 4.7.0'
    pod 'Crashlytics', '~> 3.10.1'

    #UI
    pod 'NVActivityIndicatorView', '~> 4.1.0'
    pod 'SSPullToRefresh', :git => 'https://repo.eoffice1.com/cocoa/sspulltorefresh.git', :tag => 'v1.2.4-r1'
    pod 'SKPhotoBrowser', '~> 5.0.3'

    #Utilities
    pod 'OCThumbor', '~> 0.3'
    pod 'SDWebImage', '~> 4.2.2'
    pod 'IQKeyboardManagerSwift', '~> 5.0.0'
    pod 'SwiftLint', '~> 0.27.0'
    pod 'R.swift', '~> 4.0.0'
    
    target 'Afaps-enterprise'

end
