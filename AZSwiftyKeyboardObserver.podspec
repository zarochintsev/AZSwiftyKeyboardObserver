Pod::Spec.new do |s|
  s.name = 'AZSwiftyKeyboardObserver'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Easy swifty keyboard observer'
  s.homepage = 'https://github.com/zarochintsev/AZSwiftyKeyboardObserver'
  s.social_media_url = 'http://twitter.com/zarochintsev'
  s.authors = { 'Alex Zarochintsev' => 'hello@zarochintsev.com' }
  s.source = { :git => 'https://github.com/zarochintsev/AZSwiftyKeyboardObserver.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.swift'
end
