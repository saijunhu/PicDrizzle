platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

target ’PicDrizzle’ do

	# NetWork
	pod 'Alamofire', '~> 4.0'
	pod 'Moya', '8.0.0-beta.2'

	#JSON
	pod 'SwiftyJSON'

	#Rx
	pod 'Moya/RxSwift'
	pod 'RxSwift',    '3.0.0-rc.1'
    pod 'RxCocoa',    '3.0.0-rc.1'

    #View
	pod 'SnapKit', '~> 3.0.2'
	pod 'PKHUD', '~> 4.0'
	pod	'Koloda'

	#Data persistence
	pod 'SwiftyUserDefaults'
	
	#Others
	pod 'R.swift'
	pod 'IQKeyboardManagerSwift', '4.0.6'	
	pod 'Kingfisher', '~> 3.0'


end


post_install do |installer|
`find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end