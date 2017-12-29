Pod::Spec.new do |s|
  s.name             = 'OBankingConnector'
  s.version          = '0.1.0'
  s.summary          = 'OBanking PSD2 Bank API Connector'
  s.description      = <<-DESC
    TODO
                       DESC

  s.homepage         = 'https://github.com/Ka0o0/obanking-psd2-connector-swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kai Takac' => 'kai.takac@gmail.com' }
  s.source           = { :git => 'git@github.com:Ka0o0/obanking-psd2-connector-swift.git', :tag => s.version.to_s }

  s.requires_arc = true

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.frameworks = 'Foundation'
  s.dependency 'RxSwift', '~> 4.1'


  s.default_subspec = 'Domain','Platform'

  s.subspec 'Domain' do |ps|
    ps.source_files = 'OBankingConnector/Domain/**/*.swift'
  end

  s.subspec 'Platform' do |ps|
    ps.source_files = 'OBankingConnector/Platform/**/*.swift'
    ps.resources = 'OBankingConnector/Platform/**/*.crt'
    ps.dependency 'RxAlamofire', '~> 4.0'
  end
end
