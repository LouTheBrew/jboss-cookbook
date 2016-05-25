package 'xz'
package 'xz-devel'
include_recipe 'java'
jboss '4.2.3.GA' do
  action :build
end
#jboss_app 'core001'
s3 'upload jboss' do
  bucket 'anaplan-devops'
  path "#{Chef::Config[:file_cache_path]}/jboss.rpm"
  key 'jboss.rpm'
end
s3 'get example core' do
  bucket 'anaplan-devops'
  path "#{Chef::Config[:file_cache_path]}/beta-core1.tar.gz"
  key 'beta-core1.tar.gz'
  action :download
end
