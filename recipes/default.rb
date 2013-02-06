#
# Cookbook Name:: statsd
# Recipe:: default
#
# Copyright 2011, Blank Pad Development
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"
include_recipe "git"

include_recipe "nodejs"
include_recipe "npm"

statsd_version = node[:statsd][:sha]

git "#{node[:statsd][:tmp_dir]}/statsd" do
  repository node[:statsd][:repo]
  reference statsd_version
  action :sync
  notifies :run, "execute[build debian package]"
end

package "debhelper"

# Fix the debian changelog file of the repo
template "#{node[:statsd][:tmp_dir]}/statsd/debian/changelog" do
  source "changelog.erb"
end

execute "build debian package" do
  command "dpkg-buildpackage -us -uc"
  cwd "#{node[:statsd][:tmp_dir]}/statsd"
  creates "#{node[:statsd][:tmp_dir]}/statsd_#{node[:statsd][:package_version]}_all.deb"
end

dpkg_package "statsd" do
  action :install
  source "#{node[:statsd][:tmp_dir]}/statsd_#{node[:statsd][:package_version]}_all.deb"
end

service "statsd" do
  action [ :enable, :start ]
end

# Install backends
backends = []

if node[:statsd][:graphite_enabled]
  backends << "./backends/graphite"
end

node[:statsd][:backends].each do |k, v|
  if v
    name = "#{k}@#{v}"
  else
    name= k
  end

  # Requires sudo to make it use the correct user
  npm_package "#{name}" do
    version "#{v}" if v
    action :install_local
    path "/usr/share/statsd"
  end

  backends << k
end

directory "/usr/share/statsd" do
    owner 'statsd'
    action :create
end

template "/etc/statsd/config.js" do
  source "config.js.erb"
  mode 0644

  config_hash = {
    :port           => node[:statsd][:port],
    :flushInterval  => node[:statsd][:flush_interval_msecs]
  }.merge(node[:statsd][:extra_config])

  if node[:statsd][:graphite_enabled]
    config_hash[:graphitePort] = node[:statsd][:graphite_port]
    config_hash[:graphiteHost] = node[:statsd][:graphite_host]
  end

  variables(:config_hash => config_hash)

  notifies :restart, resources(:service => 'statsd')
end

cookbook_file "/usr/share/statsd/scripts/start" do
  source "upstart.start"
  mode 0755
end


case node["platform_family"]
when "debian"
  template "/etc/init/statsd.conf" do
    mode "0644"
    source "upstart.conf.erb"
    variables(
      :log_file         => node[:statsd][:log_file],
      :platform_version => node["platform_version"].to_f
    )
  end
when "rhel","fedora"
  template "/etc/init.d/statsd" do
    mode "0755"
    source "initd.erb"
    variables(
      :log_file         => node[:statsd][:log_file]
    )
  end
end

file node[:statsd][:log_file] do
  owner "statsd"
  action :create
end

user node[:statsd][:user] do
  comment "statsd"
  system true
  shell "/bin/false"
end

