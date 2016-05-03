#
# Cookbook Name:: jboss-cookbook
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe 'java'
poise_service_user 'luis'
jboss_app 'core01' do
  installation_dir '/opt/jboss/4.2.3.GA/server/'
  owner 'luis'
  group 'luis'
  app_template 'core01.erb'
end
#poise_service 'core01' do
#  provider :runit
#  command '/opt/jboss/4.2.3.GA/bin/run.sh'
#end
