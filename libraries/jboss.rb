require 'poise'
require 'chef/resource'
require 'chef/provider'

module Jboss
  class Resource < Chef::Resource
    include Poise
    provides :jboss
    actions :build
    attribute :version, name_attribute: true, kind_of: String
    attribute :user, default: 'root', kind_of: String
    attribute :group, default: 'root', kind_of: String
    attribute :path, default: '/opt/jboss/'
    attribute :package_name, default: 'jboss'
    attribute :jboss_url, default: 'http://jaist.dl.sourceforge.net/project/jboss/JBoss/JBoss-4.2.3.GA/jboss-4.2.3.GA-src.tar.gz'
    attribute :package_it, default: true
  end
  class Provider < Chef::Provider
    include Poise
    provides :jboss
    def jboss_home
      "#{new_resource.path}#{new_resource.version}"
    end
    def jboss_source_home
      ::File.join(new_resource.path, 'src')
    end
    def jboss_installation_path
      ::File.join(new_resource.path, new_resource.version)
    end
    def untar_name
      "jboss-#{new_resource.version}-src"
    end
    def source_build_origin_path
      ::File.join(self.jboss_source_home, self.untar_name, 'build', 'output', "jboss-#{new_resource.version}")
    end
    def tarball
      ::File.join(Chef::Config[:file_cache_path], "jboss-#{new_resource.version}.tar.gz")
    end
    def common
      [self.jboss_home, self.jboss_source_home, new_resource.path].each do |dir|
        directory dir do
          recursive true
        end
      end
    end
    def download
      remote_file self.tarball do
        user new_resource.user
        group new_resource.group
        source new_resource.jboss_url
      end
    end
    def setup
      bash "untar jboss #{new_resource.version}" do
        code <<-EOH
        tar zxf #{self.tarball} -C #{self.jboss_source_home}
        EOH
      end
      bash "build jboss #{new_resource.version}" do
        cwd ::File.join(self.jboss_source_home, self.untar_name)
        code <<-EOH
        /bin/bash build/build.sh
        mv #{self.source_build_origin_path}/* #{self.jboss_home}
        EOH
        # self.source_build_origin_path won't exist if the build.sh did not execute
        not_if do ::File.exists?(self.source_build_origin_path) end
      end
      if new_resource.package_it
        fpm new_resource.package_name do
          sources new_resource.path
        end
        #return "#{Chef::Config[:file_cache_path]}/#{new_resource.package_name}.rpm"
      end
    end
    def install
      download
      setup
    end
    def action_build
      common
      install
    end
  end
end
