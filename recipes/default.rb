#
# Cookbook Name:: jboss-cookbook
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe 'java'
poise_service_user 'jboss'
jboss_app 'core01' do
  installation_dir '/opt/jboss/4.2.3.GA/server/'
  owner 'jboss'
  group 'jboss'
  app_template 'core01.erb'
end
