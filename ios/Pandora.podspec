Pod::Spec.new do |s|
  s.name             = 'Pandora'
  s.version          = '0.1.0'
  s.summary          = 'Pandora'

  s.description      = <<-DESC
Pandora
                       DESC

  s.homepage         = 'https://github.com/chanjh/Pandora'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'UgCode' => 'jiahao0408@gmail.com' }
  s.source           = { :git => 'https://github.com/chanjh/Pandora.git', :tag => s.version.to_s }

  s.ios.deployment_target = '14.0'
  s.swift_versions = '5.0'

  s.source_files = 'Pandora/**/*{swift,h,m}'
  s.resource_bundles = { 'Pandora' => ['Pandora/Resources/*'] }

  s.dependency 'Zip', '~> 2.1'
  s.dependency 'SnapKit', '~> 5.0.0'
  s.dependency 'GCWebContainer', '~> 0.1.0'
  
end