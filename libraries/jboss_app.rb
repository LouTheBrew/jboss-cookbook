require 'poise'
require 'chef/resource'
require 'chef/provider'

module JbossApp
  class Resource < Chef::Resource
    include Poise
    provides :jboss_app
    actions :create
    attribute :name, name_attribute: true, kind_of: String
    attribute :jboss_version, default: '4.2.3.GA'
    attribute :installation_dir, default: '/opt/jboss/', kind_of: String
    attribute :owner, default: 'jboss', kind_of: String
    attribute :group, default: 'jboss', kind_of: String
    attribute :app_template, required: true, kind_of: String
    attribute :custom_config, kind_of: Hash
  end
  class Provider < Chef::Provider
    include Poise
    provides :jboss_app
    def destroy(appdir)
      directory "#{new_resource.installation_dir}server/#{new_resource.name}" do
        recursive true
        action :delete
      end
    end
    def create(appdir)
      directory "#{new_resource.installation_dir}server/#{new_resource.name}" do
        recursive true
      end
    end
    def env
      #jboss_env new_resource.name do
      #  jboss_destination new_resource.installation_dir
      #  user new_resource.owner
      #  group new_resource.group
      #  not_if do ::File.exists?(new_resource.installation_dir) end
      #end
    end
    def action_create
      create "#{new_resource.installation_dir}server/#{new_resource.name}"
    end
    def action_destroy
      destroy "#{new_resource.installation_dir}server/#{new_resource.name}"
    end
  end
end
