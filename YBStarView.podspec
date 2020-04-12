#
# Be sure to run `pod lib lint YBStarView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YBStarView'
  s.version          = '1.0.0'
  s.summary          = '星星评分视图'
  s.description  = <<-DESC
         星星评分视图
  DESC
  s.homepage         = 'https://github.com/YangYiBo23/YBStarView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangyibo23' => 'yangyibo93@gmail.com' }
  s.source           = { :git => 'https://github.com/YangYiBo23/YBStarView.git' }
  
  s.ios.deployment_target = '8.0'

  s.source_files = 'YBStarView/Classes/**/*'
  
  s.resource_bundles = {
    'YBStarView' => ['YBStarView/Assets/*.png']
  }

end
