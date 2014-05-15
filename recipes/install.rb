#
# Cookbook Name::	kafka
# Description:: Base configuration for Kafka
# Recipe:: default
#
# Copyright 2012, Webtrends, Inc.
# Copyright 2013, Fewbytes, Inc.
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

# == Recipes
include_recipe "java"
include_recipe "runit"
include_recipe "ark"

java_home   = node['java']['java_home']

user = node[:kafka][:user]
group = node[:kafka][:group]

if node[:kafka][:broker_id].nil?
   node.set[:kafka][:broker_id] = Zlib.crc32(node.name + rand().to_s) >> 1
end

if node[:kafka][:broker_host_name].nil? || node[:kafka][:broker_host_name].empty?
   node.set[:kafka][:broker_host_name] = node[:fqdn]
end

log "Broker id: #{node[:kafka][:broker_id]}"
log "Broker name: #{node[:kafka][:broker_host_name]}"

# == Users

# setup kafka group
group group do
  system true
end

# setup kafka user
user user do
  system true
  comment "Kafka user"
  gid group
  home "/home/kafka"
  shell "/bin/noshell"
  supports :manage_home => false
end

install_dir = node[:kafka][:install_dir]

ark "kafka" do
  url node[:kafka][:download_url]
  checksum node[:kafka][:checksum]
  version node[:kafka][:version]
  mode 00644
  action :install
  home_dir install_dir
end

directory "#{install_dir}/bin" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

directory "#{install_dir}/config" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

# create the log directory
directory node[:kafka][:log_dir] do
  owner   user
  group   group
  mode    00755
  recursive true
  action :create
end

# create the data directory
directory node[:kafka][:data_dir] do
  owner   user
  group   group
  mode    00755
  recursive true
  action :create
end

# grab the zookeeper nodes that are currently available
zookeeper_nodes = if node["kafka"]["zookeeper"]["nodes"].is_a? Array
  node["kafka"]["zookeeper"]["nodes"]
elsif node["kafka"]["zookeeper"]["search_query"] and not Chef::Config.solo
  name_attr = node["zookeeper"]["search_name_attribute"]
  port_attr = node["zookeeper"]["search_port_attribute"]
  search(:node, node["kafka"]["zookeeper"]["search_query"])
    .map {|n| "#{name_attr.reduce(n) {|n, attr| n[attr]}}:#{port_attr.reduce(n){|n, attr| n[attr]}}"}.sort
elsif Chef::Config.solo
  ["localhost:2181"]
else
  Chef::Application.fatal! "No zookeeper nodes found"
end

%w[server.properties log4j.properties].each do |template_file|
  template "#{install_dir}/config/#{template_file}" do
    source	"#{template_file}.erb"
    owner user
    group group
    mode  00644
    variables({
      :kafka => node[:kafka],
      :zookeeper_nodes => zookeeper_nodes,
      :client_port => node[:zookeeper][:client_port]
    })
    notifies :restart, "runit_service[kafka]"
  end
end


# create collectd plugin for kafka JMX objects if collectd has been applied.
if node.attribute?("collectd")
  template "#{node[:collectd][:plugin_conf_dir]}/collectd_kafka-broker.conf" do
    source "collectd_kafka-broker.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, "service[collectd]"
  end
end

