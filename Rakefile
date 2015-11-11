require 'yaml'
require "rspec/core/rake_task"

desc "Update release versions"
task :update_releases, [:docker_version, :offline_version] do |_, args|
  Dir['./deployments/*.yml'].each do |file|
    deployemnt = YAML.load_file(file)
    size = deployemnt['releases'].size
    deployemnt['releases'] = []
    deployemnt['releases'] << {
      'name' => 'docker',
      'version' => args[:docker_version].to_s,
      'git' => 'https://github.com/cf-platform-eng/docker-boshrelease.git'
    }
    deployemnt['releases'] << {
      'name' => 'docker-broker-images',
      'version' => args[:offline_version].to_s,
      'git' => 'https://github.com/cloudfoundry-community/docker-broker-images-boshrelease.git'
    } if size == 2
    IO.write(file, deployemnt.to_yaml.gsub('IPMASK', '"IPMASK"'))
  end
end

task :default => :spec
RSpec::Core::RakeTask.new
