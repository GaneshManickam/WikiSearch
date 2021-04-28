# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!

def core_pods
    #Keyboard Management
    pod 'IQKeyboardManagerSwift'

    #Realm
    pod 'RealmSwift'
end

def ui_pods
    #Toast alert
    pod 'Toast-Swift'
    
    #Toaster
    pod 'Toaster', :git => 'https://github.com/devxoul/Toaster'

    #Asynchronous image download and cache
    pod 'Kingfisher'
end

def rx_pods
    # Networking
    pod 'Moya/RxSwift'
  
    # Model
    pod 'ModelMapper'
    
    # Rx
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxGesture'
end
 

target 'Demo' do
    core_pods
    ui_pods
    rx_pods
end
