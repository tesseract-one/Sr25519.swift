Pod::Spec.new do |s|
  s.name             = 'Sr25519-Binaries'
  s.version          = '0.0.1'
  s.summary          = 'Compiled Rust files for sr25519.'

  s.homepage         = 'https://github.com/tesseract-one/sr25519.swift'

  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Tesseract Systems, Inc.' => 'info@tesseract.one' }
  s.source           = { :http => "https://github.com/tesseract-one/sr25519.swift/releases/download/#{s.version.to_s}/CSr25519.Pods-Binary.zip", :sha256 => 'ba0ae8d395fd559845df77f1e055545501c5ef43afaf37f2172367dcdd0ae473' }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '12.0'
  
  s.swift_versions = ['5']
  
  s.vendored_frameworks = "CSr25519.xcframework"
end
