require 'fileutils'

task :default => [:install]

desc "install 3rd-party libs"
task :install do
  shared_lib = "SharedLib"
  FileUtils.mkdir_p(shared_lib)

  FileUtils.cd("#{shared_lib}");

  [
    ["https://github.com/kgn/DBPrefsWindowController.git", "master"],
    ["https://github.com/RestKit/RestKit.git", "development"],
    ["https://github.com/erndev/EDSidebar.git", "master"],
    ["https://github.com/irons/EMKeychain.git", "master"],
    ["https://github.com/enormego/EGOCache.git", "master"],
  ].each do |lib|
    `git clone #{lib[0]} -b #{lib[1]} --recursive`
  end
end
