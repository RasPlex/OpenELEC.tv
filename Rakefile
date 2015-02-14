require 'yaml'

config_path       = File.dirname(File.expand_path(__FILE__)) + '/config.yml'
build_config_path = File.dirname(File.expand_path(__FILE__)) + '/distributions/RasPlex/version'
root_dir          = File.dirname(File.expand_path(__FILE__))

Rake::TaskManager.record_task_metadata = true

# Main namespace for building
namespace :build do

  desc "Display info about the current build configuration and write rasplex config file"
  task :info do | t, args |

    puts $config.to_yaml

  end

  desc "Generate an image file from current or latest build output"
  task :image do | t, args |

    unless File.directory? 'tmp'
      Dir.mkdir('tmp')
    end

    freedev = `sudo losetup -f`.strip

    tarballs = Dir.glob('target/*.tar')
    latest = tarballs.sort_by {|filename| File.mtime(filename) }[-1]
    basename = File.basename(latest).gsub('.tar','')
    imgfile = "rasplex-#{$config['version']}.img"

    sh "tar -xpf #{latest} -C tmp"
    sh "dd if=/dev/zero of=tmp/#{imgfile} bs=1M count=910"
    Dir.chdir("tmp/#{basename}") do
      cmd = "sudo ./create_sdcard #{freedev} ../#{imgfile}"
      sh cmd
    end


  end

  desc "(re)build any new, incomplete, or modified OpenELEC packages."
  task :system => [:info] do

    cmd = "DISTRO=#{$config['distro']} PROJECT=#{$config['project']} ARCH=#{$config['arch']} make all -j `nproc`"
    sh cmd
  end

  desc "Force a (re)build full PHT package at [version], wip by default"
  task :plex => [:info] do | t, args |

    build_dir = "build.#{$config['distro']}-#{$config['project']}.#{$config['arch']}-#{$config['oeversion']}-release"
    sh "rm -rf #{build_dir}/.stamps/plexht"
    sh "mkdir -p #{build_dir}"

    if $config['version'] == 'wip'

      # Create the symlink to use for build
      work_dir = "#{build_dir}/plexht-wip"
      sh "ln -sf #{root_dir}/../plex-home-theater #{work_dir}"
    else
      work_dir = "#{root_dir}/#{build_dir}/plexht-#{$config['version']}"
      sh "rm -rf #{root_dir}/#{build_dir}/plexht-*"
      sh "mkdir -p #{work_dir}"
      sh "git --work-tree=#{work_dir}  --git-dir=#{root_dir}/plex-home-theater/.git checkout #{$config['version']} -- #{work_dir}"
    end

    File.open("#{work_dir}/GitRevision.txt", 'w') { |file| file.write($config['version']) }
    File.open("#{work_dir}/rasplex_version.txt", 'w') { |file| file.write($config['version'].gsub("RP-","")) }

    version_str = <<-eos
RASPLEX_VERSION=#{$config['version']}
RASPLEX_REF=#{$config['version']}
eos
    puts version_str
    File.open(build_config_path, 'a') { |file| file.write(version_str) }
  end

  desc "Force a rebuild of the kernel, initramfs, and firmware"
  task :kernel do

    kernel_pkgs = ["linux","linux-drivers","linux-initramfs","busybox","busybox-initramfs", "bcm2835-bootloader", "bcm2835-driver"]
    build_dir = "build.#{$config['distro']}-#{$config['project']}.#{$config['arch']}-#{$config['oeversion']}-release"
    kernel_pkgs.each do |pkg|
      sh "rm -rf #{build_dir}/.stamps/#{pkg}"
    end
  end

  desc "(re)build change or incomplete packages, kernel, bootloader, and, with PHT [version], wip by default"
  task :all, [:version] => [:plex, :system, :image]
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

if ENV.has_key? 'project'
  $config['project'] = ENV['project']
else
  $config['project'] = 'RPi'
end

if ENV.has_key? 'version'
  $config['version'] = ENV['version']
else
  $config['version'] = "wip"
end

rasplex_config = <<-eos
DISTRONAME=#{$config['distro']}
RASPLEX_BUILDTYPE=#{$config['type']}
RASPLEX_VERSION=#{$config['version']}
RASPLEX_REF=#{$config['version']}
eos

File.open(build_config_path, 'w') { |file| file.write(rasplex_config) }
