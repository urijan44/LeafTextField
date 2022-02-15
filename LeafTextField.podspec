#
# Be sure to run `pod lib lint LeafTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LeafTextField'
  s.version          = '0.2.1'
  s.summary          = 'CustomTextField that contains Image and Animation.'

  s.description      = <<-DESC
  It is a simple TextField library with Image and Animation.
                      DESC

  s.homepage         = 'https://github.com/urijan44/LeafTextField'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HenryLee' => 'teamsva360@gmail.com' }
  s.source           = { :git => 'https://github.com/urijan44/LeafTextField.git', :tag => s.version.to_s }


  s.ios.deployment_target = '13.0'

  s.source_files = 'LeafTextField/Classes/**/*'
  s.frameworks = 'UIKit'
  s.swift_version = '5.0'
end
