require 'yaml'
require 'securerandom'

config_path       = File.dirname(File.expand_path(__FILE__)) + '/config.yml'
build_config_path = File.dirname(File.expand_path(__FILE__)) + '/distributions/RasPlex/version'
root_dir          = File.dirname(File.expand_path(__FILE__))

Rake::TaskManager.record_task_metadata = true
GUID=SecureRandom.hex[0..7]

# Main namespace for building
namespace :build do

  desc "Display info about the current build configuration and write rasplex config file"
  task :info do | t, args |

    puts $config.to_yaml

  end

  desc "Force a rebuild of the kernel, initramfs, and firmware"
  task :kernel do

    kernel_pkgs = ["linux", "linux-drivers", "initramfs", "busybox", "bcm2835-bootloader", "bcm2835-driver"]
    build_dir = "build.#{$config['distro']}-#{$config['project']}.#{$config['arch']}-#{$config['oeversion']}"
    kernel_pkgs.each do |pkg|
      sh "rm -rf #{build_dir}/.stamps/#{pkg}"
    end
  end

  desc "Force a (re)build full PHT package"
  task :plex => [:info] do | t, args |

    build_dir = "build.#{$config['distro']}-#{$config['project']}.#{$config['arch']}-#{$config['oeversion']}"
    sh "rm -rf #{build_dir}/.stamps/plexht"
    sh "mkdir -p #{build_dir}"

    work_dir = "#{root_dir}/#{build_dir}/plexht-#{$config['version']}"
    sh "mkdir -p #{work_dir}"

    File.open("#{work_dir}/GitRevision.txt", 'w') { |file| file.write($config['version']) }
    version = $config['version']
    if $config['version'] == 'wip'

      version = "#{version}-#{GUID}"
      # Create the symlink to use for build
      sh "ln -sf #{root_dir}/../plex-home-theater #{work_dir}"
      sh "echo #{GUID} >> #{work_dir}/GitRevision.txt"
    else
      sh "rm -rf #{root_dir}/#{build_dir}/plexht-*"
      sh "mkdir -p #{work_dir}"
      cwd = Dir.pwd
      Dir.chdir(work_dir)
      sh "git --work-tree=#{work_dir}  --git-dir=#{root_dir}/plex-home-theater/.git checkout #{$config['version']} -- #{work_dir}"
      sh "git --work-tree=#{work_dir}  --git-dir=#{root_dir}/plex-home-theater/.git show-ref #{$config['version']} > #{work_dir}/GitRevision.txt"
      sh "touch #{work_dir}/.openelec-unpack"
      Dir.chdir(cwd)
    end

    File.open("#{work_dir}/rasplex_version.txt", 'w') { |file| file.write($config['version'].gsub("RP-","")) }

    version_str = <<-eos
RASPLEX_VERSION=#{version}
RASPLEX_REF=#{$config['version']}
eos
    puts version_str
    File.open(build_config_path, 'a') { |file| file.write(version_str) }
  end

  desc "Generate an image file from current or latest build output"
  task :image => [:info, :plex] do | t, args |

    cmd = "DISTRO=#{$config['distro']} PROJECT=#{$config['project']} ARCH=#{$config['arch']} make image -j `nproc`"
    sh cmd
  end

  desc "(re)build any new, incomplete, or modified OpenELEC packages."
  task :all => [:info, :plex] do

    cmd = "DISTRO=#{$config['distro']} PROJECT=#{$config['project']} ARCH=#{$config['arch']} make all -j `nproc`"
    sh cmd
  end

end

desc "Print a detailed help with usage examples"
task :help do

  help = <<-eos
This Rakefile replaces buildman. It requires ruby and the 'rake' gem be installed.

Environment variables accepted:

  project=[RPi,RPi2]
  version=[RP-0.5.X] # git tag, if not specified defaults to 'wip'

Common operations:

  Build the system

    rake build:image

  or, optionally pass the project to build

    rake build:image project=RPi2

  Rebuild the kernel / initramfs:

    rake build:kernel project=RPi2

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
