require 'poise'
require 'chef/resource'
require 'chef/provider'

# Create a jboss environment such that it is sufficient to start loading jboss apps
# jboss apps should be found in #{jboss_destination}servers/#{appname}
module JbossEnv
  class Resource < Chef::Resource
    include Poise
    provides  :jboss_env
    actions   :create
    attribute :name, name_attribute: true, kind_of: String
    attribute :user, default: 'jboss', kind_of: String, required: true
    attribute :group, default: 'jboss', kind_of: String, required: true
    attribute :jboss_destination, default: '/opt/jboss/', kind_of: String, required: true
    attribute :jboss_source, default: 'jboss-4.2.3.GA', kind_of: String, required: true
  end
  class Provider < Chef::Provider
    include Poise
    provides :jboss_env
    def given_the_givens
      directory new_resource.jboss_destination do
        recursive true
      end
      yield
    end
    def given_the_givens
      nil
      yield
    end
    def action_create
      given_the_givens do
        remote_directory new_resource.jboss_destination do
          source new_resource.jboss_source
        end
      end
    end
  end
end
