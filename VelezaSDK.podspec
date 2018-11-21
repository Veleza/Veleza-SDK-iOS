Pod::Spec.new do |s|

    # 1
    s.platform = :ios
    s.ios.deployment_target = '10.0'
    s.name = "VelezaSDK"
    s.summary = "Veleza SDK"
    s.requires_arc = true

    # 2
    s.version = "0.2.0"

    # 3
    s.license = { :type => "BSD", :file => "LICENSE" }

    # 4 - Replace with your name and e-mail address
    s.author = { "Vytautas Povilaitis" => "vytautas@veleza.com" }

    # 5 - Replace this URL with your own GitHub page's URL (from the address bar)
    s.homepage = "https://github.com/Veleza/Veleza-SDK-iOS"

    # 6 - Replace this URL with your own Git URL from "Quick Setup"
    s.source = { :git => "https://github.com/Veleza/Veleza-SDK-iOS.git", 
                 :tag => "#{s.version}" }

    # 7
    s.framework = "UIKit"
    s.dependency 'PINRemoteImage', '3.0.0-beta.13'
    s.dependency 'DTPhotoViewerController', '~> 1.2'
    s.dependency 'Amplitude-iOS', '~> 4.0.4'

    # 8
    s.source_files = "VelezaSDK/**/*.{swift}"

    # 9
    s.resources = "VelezaSDK/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,ttf}"

    # 10
    s.swift_version = "3.2"

end
