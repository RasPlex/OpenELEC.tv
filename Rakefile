require 'yaml'

config_path       = File.dirname(File.expand_path(__FILE__)) + '/config.yml'
build_config_path = File.dirname(File.expand_path(__FILE__)) + '/config/rasplex'

Rake::TaskManager.record_task_metadata = true

# Main namespace for building
namespace :build do

  desc "Display info about the current build configuration and write rasplex config file"
  task :info, [:version] do | t, args |

    if args[:version].nil?
      version = "wip"
    else
      version = args[:version]
    end

    puts $config.to_yaml

    rasplex_config = <<-eos
DISTRONAME=#{$config['distro']}
RASPLEX_BUILDTYPE=#{$config['type']}
OE_PROJECT=#{$config['project']}
RASPLEX_REF=#{version}
eos

    if $config['linkfast']
      rasplex_config += "RASPLEX_SPEEDYLINK=yes\n"
    end
     File.open(build_config_path, 'w') { |file| file.write(rasplex_config) }
  end

  desc "Generate an image file from current or latest build output"
  task :image, [:version] do | t, args |
    if args[:version].nil?
      version = "wip"
    else
      version = args[:version]
    end

    unless File.directory? 'tmp'
      Dir.mkdir('tmp')
    end

    freedev = `sudo losetup -f`.strip

    tarballs = Dir.glob('target/*.tar')
    latest = tarballs.sort_by {|filename| File.mtime(filename) }[-1]
    basename = File.basename(latest).gsub('.tar','')
    imgfile = "rasplex-#{version}.img"

    sh "tar -xpf #{latest} -C tmp"
    sh "dd if=/dev/zero of=tmp/#{imgfile} bs=1M count=910"
    Dir.chdir("tmp/#{basename}") do 
      cmd = "sudo ./create_sdcard #{freedev} ../#{imgfile}"
      sh cmd
    end

    
  end

  desc "(re)build any new, incomplete, or modified OpenELEC packages."
  task :system => [:info] do

    if $config['type'] == "release"
      buildstr = 'LIVEDEBUG="yes"'
    else
      buildstr = 'DEVTOOLS="yes" DEBUG="yes"'
    end

    cmd = "#{buildstr} PROJECT=#{$config['project']} ARCH=#{$config['arch']} make release -j `nproc`"
    sh cmd
  end

  desc "Force a (re)build full PHT package at [version], wip by default"
  task :plex, [:version] => [:info] do | t, args |
    if args[:version].nil?
      version = "wip"

      build_dir = "build.#{$config['distro']}-#{$config['project']}.#{$config['arch']}-#{$config['oeversion']}-release"
      sh "rm -rf #{build_dir}/.stamps/plexht"
      sh "mkdir -p #{build_dir}"
      # Create the symlink to use for build
      sh "ln -sf ../plex-home-theater #{build_dir}/plexht-wip"
    else
      version = args[:version]
    end
    
    version_str = <<-eos
RASPLEX_VERSION=#{version}
RASPLEX_REF=#{version}
eos
    puts version_str
    File.open(build_config_path, 'a') { |file| file.write(version_str) }
  end

  desc "Force a rebuild of the kernel, initramfs, and firmware"
  task :kernel do
    sh "echo kernel"
  end

  desc "Force a clean rebuild (this will take a long time)"
  task :clean do
    sh "echo clean"
  end


  desc "Incremental rebuild of PHT binary only <WILL FAIL IF YOU CHANGED CMAKE>"
  task :binary do 
    sh "echo binary"
  end

  desc "Generates minidump symbols and strips PHT binary <WILL FAIL IF YOU CHANGED CMAKE>"
  task :symbols do 
    sh "echo symbols"
  end

  desc "Incremental rebuild of PHT and symbols <WILL FAIL IF YOU CHANGED CMAKE>"
  task :debug => [:binary, :symbols]


  desc "(re)build change or incomplete packages, kernel, bootloader, and, with PHT [version], wip by default"
  task :all, [:version] => [:kernel, :plex, :system, :image]
end

desc "Print a detailed help with usage examples"
task :help do

  help = <<-eos
This Rakefile replaces buildman. It requires ruby and the 'rake' gem be installed.

Common operations:

** Full rebuild / initial build **

  This will build all missing openelec packages (all packages on first build), and anything modified. It will force a rebuild of PHT.

  The output of a successful buil will be a .img file, suitable for flashing to an SD card.

    rake all

  or, optionally pass a git tagged version of PHT

    rake all[RP-0.4.0]

** Incremental rebuild **

  This will only work if you already have a working toolchain / build system.
  If you have changed any CMake files, this will fail. 

  This is very useful to save time when developing, as it will only build those files that changed.

  To do an incremental build of just the PHT binary

    rake build:binary

  To generate the symbols from said binary (note - this will also strip the symbols)

    rake build:symbols

  To do both of the above

    rake build:debug
  eos
  puts help

end

# Print the help if no arguments are given
task :default do
  Rake::application.options.show_tasks = :tasks  
  Rake::application.options.show_task_pattern = //
  Rake::application.display_tasks_and_comments
end

# Load the config file if exists, or print help
if File.exists? config_path
  $config = YAML::load(File.open(config_path))
else
  puts "A config file is required. See config.yml.example for details"
  Rake::Task["default"].invoke
  exit 1
end

