Pod::Spec.new do |s|
  s.name             = 'Sr25519'
  s.version          = '0.0.1'
  s.summary          = 'Swift wrapper for Rust sr25519 library'

  s.homepage         = 'https://github.com/tesseract-one/sr25519.swift'

  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Tesseract Systems, Inc.' => 'info@tesseract.one' }
  s.source           = { :git => 'https://github.com/tesseract-one/sr25519.swift.git', :tag => s.version.to_s, :submodules => true }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '12.0'
  
  s.swift_versions = ['5.3']
  
  s.module_name = 'Sr25519'
  
  s.subspec 'Binary' do |ss|
    ss.source_files = 'Sources/Sr25519/*.swift'

    ss.dependency 'Sr25519-Binaries', '~> 0.0.1'
    
    ss.test_spec 'Sr25519Tests' do |test_spec|
      test_spec.source_files = 'Tests/Sr25519Tests/**/*.swift'
    end
  end

  s.subspec 'Build' do |ss|
    ss.source_files = 'Sources/Sr25519/*.swift'
    ss.preserve_paths = "rust/**/*", "scripts/*"
    
    ss.script_phase = {
      :name => "Build Rust Binary",
      :script => 'bash "${PODS_TARGET_SRCROOT}/scripts/xcode_build_step.sh"',
      :execution_position => :before_compile
    }
    
    ss.test_spec 'Sr25519Tests' do |test_spec|
      test_spec.source_files = 'Tests/Sr25519Tests/**/*.swift'
    end
  end

  s.default_subspecs = 'Binary'
end
