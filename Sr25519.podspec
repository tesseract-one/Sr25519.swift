Pod::Spec.new do |s|
  s.name             = 'Sr25519'
  s.version          = '999.99.9'
  s.summary          = 'Swift wrapper for sr25519-donna C library'
  
  s.description      = <<-DESC
Swift wrapper for sr25519-donna C library. Provides Sr25519 and Ed25519 wrappers.
                       DESC

  s.homepage         = 'https://github.com/tesseract-one/Sr25519.swift'

  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Tesseract Systems, Inc.' => 'info@tesseract.one' }
  s.source           = { :git => 'https://github.com/tesseract-one/Sr25519.swift.git', :tag => s.version.to_s }

  s.swift_version    = '5.4'

  base_platforms     = { :ios => '11.0', :osx => '10.13', :tvos => '11.0' }
  s.platforms        = base_platforms.merge({ :watchos => '6.0' })
  
  s.module_name = 'Sr25519'
  
  s.subspec 'CSr25519' do |ss|
    ss.source_files = 'Sources/CSr25519/src/**/*.{h,c}'
    ss.public_header_files = 'Sources/CSr25519/src/sr25519.h', 'Sources/CSr25519/src/sr25519-random*.h', 'Sources/CSr25519/src/ed25519-donna/ed25519.h'
    
    ss.pod_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) ED25519_CUSTOMRANDOM ED25519_CUSTOMHASH ED25519_NO_INLINE_ASM SR25519_CUSTOMHASH',
      'GCC_WARN_UNUSED_FUNCTION' => 'NO',
      'GCC_WARN_UNUSED_VARIABLE' => 'NO'
    }
    
    ss.dependency 'UncommonCrypto', '~> 0.2.1'
  end
  
  s.subspec 'Helpers' do |ss|
    ss.source_files = 'Sources/Sr25519Helpers/*.swift'
    
    ss.dependency 'Sr25519/CSr25519'
  end
  
  s.subspec 'Ed25519' do |ss|
    ss.source_files = 'Sources/Ed25519/*.swift'
    
    ss.dependency 'Sr25519/Helpers'
    ss.dependency 'Sr25519/CSr25519'
    
    ss.test_spec 'Ed25519Tests' do |ts|
      ts.platforms = base_platforms
      ts.source_files = 'Tests/Ed25519Tests/**/*.swift'
    end
  end

  s.subspec 'Sr25519' do |ss|
    ss.source_files = 'Sources/Sr25519/*.swift'
    
    ss.dependency 'Sr25519/Helpers'
    ss.dependency 'Sr25519/CSr25519'
    
    ss.test_spec 'Sr25519Tests' do |ts|
      ts.platforms = base_platforms
      ts.source_files = 'Tests/Sr25519Tests/**/*.swift'
    end
  end

  s.default_subspecs = 'Sr25519'
end
