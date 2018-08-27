Pod::Spec.new do |s|

# 1
s.platform = :ios
s.swift_version = '4.0'
s.ios.deployment_target = '10.0'
s.name = "SKNetworkingLib"
s.summary = "Library helps to create and execute requests"
s.requires_arc = true

# 2
s.version = "0.0.3"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Serhii Kostian" => "skostyan666@gmail.com" }

# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/sjsoad/Networking"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/sjsoad/Networking.git", :tag => "#{s.version}"}

# 7
s.framework = "Foundation"

# 8
s.source_files = "Networking/**/*.{swift}"

#10
s.dependency 'SKActivityViewable'
s.dependency 'SKAlertViewable'
s.dependency 'NVActivityIndicatorView'
s.dependency 'SwiftyDrop'
s.dependency 'Alamofire'

end
