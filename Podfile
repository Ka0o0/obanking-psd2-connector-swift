def global_deps
	pod 'RxSwift',    	 :git => "https://github.com/Ka0o0/RxSwift.git", :branch => "feature/first-operator" # '~> 4.0'
	pod 'RxAlamofire',   '~> 4.0'
end

def testing_deps
	pod 'RxBlocking', :git => "https://github.com/Ka0o0/RxSwift.git", :branch => "feature/first-operator" # RxSwift Tests
	pod 'RxTest',     :git => "https://github.com/Ka0o0/RxSwift.git", :branch => "feature/first-operator" #'~> 4.0' # RxSwift Tests
end

target 'OBankingConnector-iOS' do
  platform :ios, '8.0'

  use_frameworks!

  global_deps

  target 'OBankingConnectorTests-iOS' do
    inherit! :search_paths
    
    testing_deps
  end
end

target 'OBankingConnector-macOS' do
  platform :osx, '10.10'
  
  use_frameworks!

  global_deps

  target 'OBankingConnectorTests-macOS' do
    inherit! :search_paths
    
    testing_deps
  end
end