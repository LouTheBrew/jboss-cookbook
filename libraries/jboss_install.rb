require 'poise'
require 'chef/resource'
require 'chef/provider'

module JbossInstall
  class Resource < Chef::Resource
    include Poise
    provides :jboss_install
    actions :install
    attribute :name, name_attribute: true, kind_of: String
    attribute :user, default: 'root', kind_of: String
    attribute :group, default: 'root', kind_of: String
    attribute :path, default: '/opt/jboss/4.2.3.GA/'
    attribute :jboss_url, default: 'http://jaist.dl.sourceforge.net/project/jboss/JBoss/JBoss-4.2.3.GA/jboss-4.2.3.GA-src.tar.gz'
  end
  class Provider < Chef::Provider
    include Poise
    provides :jboss_install
    def common
      directory new_resource.path do
        recursive true
      end
    end
    def download
      remote_file "#{new_resource.path}jboss.tar.gz" do
        user new_resource.user
        group new_resource.group
        source new_resource.jboss_url
      end
    end
    def install
      download
    end
    def action_install
      common
      install
    end
  end
end
