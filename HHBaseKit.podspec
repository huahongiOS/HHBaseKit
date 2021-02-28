#
# Be sure to run `pod lib lint HHBaseKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HHBaseKit'
  s.version          = '0.1.0'
  s.summary          = 'HHBaseKit.'

  s.description      = <<-DESC
            基础组件库.
                       DESC

  s.homepage         = 'https://github.com/huahong1124/HHBaseKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huahong1124' => '2330669775@qq.com' }
  s.source           = { :git => 'https://github.com/huahong1124/HHBaseKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'HHBaseKit/Classes/*.{h,m,swift}'
  s.public_header_files = 'HHBaseKit/Classes/*.{h,m,swift}'

  
  #--------------------subspec-----------------------------------------------#
   
    s.subspec 'Catagory' do |ss|
    ss.source_files = 'HHBaseKit/Classes/Catagory/*.{h,m,swift}'
    end
       
     s.subspec 'Common' do |ss|
     ss.source_files = 'HHBaseKit/Classes/Common/*.{h,m,swift}'
     end
      
     s.subspec 'Safe' do |ss|
     ss.source_files = 'HHBaseKit/Classes/Safe/*.{h,m,swift}'
     end
    
#     s.subspec 'ProgressHud' do |ss|
#     ss.source_files = 'HHBaseKit/Classes/ProgressHud/*.{h,m,swift}'
#     ss.resources = 'HHBaseKit/Classes/ProgressHud/*.bundle'
#     ss.dependency 'MBProgressHUD'
#     ss.dependency 'SVProgressHUD'
#     end
#
#      s.subspec 'Cookie' do |ss|
#      ss.source_files = 'HHBaseKit/Classes/Cookie/*.{h,m,swift}'
#      end
#
#       s.subspec 'CleanCache' do |ss|
#       ss.source_files = 'HHBaseKit/Classes/CleanCache/*.{h,m,swift}'
#       end
#
#       s.subspec 'Media' do |ss|
#        ss.source_files = 'HHBaseKit/Classes/Media/*.{h,m,swift}'
#        end
     
  #--------------------subspec-----------------------------------------------#
  
  
  # s.resource_bundles = {
  #   'HHBaseKit' => ['HHBaseKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'YYCategories'
    s.dependency 'MJExtension'
    s.dependency 'NSDictionary-NilSafe'
end
