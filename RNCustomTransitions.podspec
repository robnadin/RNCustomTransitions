Pod::Spec.new do |s|
  s.name         = "RNCustomTransitions"
  s.version      = "1.0.2"
  s.summary      = "Block-based custom animations API for iOS."
  s.description  = <<-DESC
                   A longer description of RNCustomTransitions in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  s.homepage     = "https://bitbucket.org/tmti/"
  s.license      = 'MIT'
  s.author       = { "Rob Nadin" => "rnadin@tmti.net" }
  s.platform     = :ios
  s.source       = { :git => "http://bitbucket.org/robnadin/RNCustomTransitions.git", :tag => s.version.to_s }
  s.source_files = 'RNCustomTransitions/*.{h,m}'
  s.requires_arc = true
end
