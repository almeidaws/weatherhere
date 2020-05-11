source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

workspace 'WeatherHere'

target 'UserInterface' do
    project 'UserInterface/UserInterface.xcodeproj'
    pod 'SnapKit', '~> 5.0.0'
    pod 'SQLite.swift', '~> 0.12.0'
end

target 'Storage' do
    project 'Storage/Storage.xcodeproj'
    pod 'SQLite.swift', '~> 0.12.0'
end

target 'StorageTests' do
    project 'Storage/Storage.xcodeproj'
    pod 'SQLite.swift', '~> 0.12.0'
end
