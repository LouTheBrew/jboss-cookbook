jboss_app 'core01' do
  installation_dir '/opt/jboss/4.2.3.GA/server/'
  owner 'jboss'
  group 'jboss'
  app_template 'core01.erb'
end
