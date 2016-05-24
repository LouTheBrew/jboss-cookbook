package 'xz'
package 'xz-devel'
include_recipe 'java'
jboss '4.2.3.GA' do
  action :build
end
#jboss_app 'core001'
