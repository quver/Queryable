Pod::Spec.new do |s|
  s.name             = 'Queryable'
  s.version          = '1.0.0'
  s.summary          = 'Realm Query Extension'

  s.description      = <<-DESC
Extension for CRUD operation just on object
                       DESC

  s.homepage         = 'https://github.com/quver/Queryable'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paweł Bednorz' => 'pawel@quver.pl' }
  s.source           = { :git => 'https://github.com/quver/Queryable.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/plquver'
  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/**/*'
  s.dependency 'RealmSwift', '~> 2.0'
end
