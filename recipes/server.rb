#
# Cookbook Name:: solr_simple
# Recipe:: server
#
# Copyright (c) 2015 Michael Haas, Apache License 2.0.

package %w(tar gzip)

solr_tmpfile = '/tmp/solr.tgz'
solr_home = node['solr']['home']
solr_dir = node['solr']['dir']

remote_file solr_tmpfile do
  source node['solr']['url']
  owner 'root'
  group 'root'
  mode '0644'
end

include_recipe 'libarchive'
libarchive_file solr_tmpfile do
  extract_to solr_dir
  owner 'root'
  group 'root'
  action :extract
end

template '/etc/init.d/solr' do
  source 'solr.init.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

template "#{solr_home}/solr.in.sh" do
  source 'solr.in.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

include_recipe 'java'
include_recipe 'java::default_java_symlink'
if node['platform_family'] == 'debian'
  link '/usr/lib/jvm/default-java' do
    to '/usr/lib/jvm/java-8-oracle-amd64'
  end
end

service 'solr' do
  supports :restart => true, :status => true
  action [ :restart, :enable ]
end

include_recipe 'logrotate'
logrotate_app 'solr_simple' do
  path "#{node['solr']['home']}/server/logs/"
  enable true
  frequency 'daily'
  maxsize 51_200
  create '644 root adm'
end
