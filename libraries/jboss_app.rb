require 'poise'
require 'chef/resource'
require 'chef/provider'

module JbossApp
  class Resource < Chef::Resource
    include Poise
    provides :jboss_app
    actions :create
    attribute :name, name_attribute: true, kind_of: String
    attribute :jboss_dir, default: '/opt/jboss/', kind_of: String
    attribute :owner, default: 'root', kind_of: String
    attribute :group, default: 'root', kind_of: String
  end
  class Provider < Chef::Provider
    include Poise
    provides :jboss_app
    def app_dir
      ::File.join new_resource.jboss_dir, 'server', new_resource.name
    end
    def destroy(appdir)
      directory app_dir do
        recursive true
        action :delete
      end
    end
    def create(appdir)
      directory app_dir do
        recursive true
      end
    end
    def action_create
      create self.app_dir
    end
    def action_destroy
      destroy self.app_dir
    end
  end
end
