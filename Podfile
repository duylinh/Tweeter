# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!
inhibit_all_warnings!

def rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxRealm'
  pod 'RxSwiftExt'
  pod 'RxOptional'
end

def database
  pod 'RealmSwift'
end

def ui
  pod 'KMPlaceholderTextView'
end

def tool
  pod 'SwiftDate'
  pod 'SwiftGen'
  pod 'SwiftLint'
end

def shared_pods

  #Database
  database
  
  #Reactive
  rx
  
  #UI
  ui
  
  # Tool
  tool
end

def testing
  pod 'Quick'
  pod 'Nimble'
  pod 'Nimble-Snapshots'
  pod 'RxBlocking'
  pod 'RxTest'
end


target 'Tweeter' do
  shared_pods
end

target 'TweeterTests' do
  inherit! :search_paths
  testing
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
  end
end


