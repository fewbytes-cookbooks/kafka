#
# Cookbook Name:: kafka
# Recipe:: default
#
# Copyright 2012, Fewbytes
#
# All rights reserved - Do Not Redistribute
#
include_recipe "runit"
include_recipe "java"

user "kafka" do
  system true
end

kafka_archive = node[:kafka][:archive_url][/.*\/([^\/]+)$/,1] # => Retrieve last part of the URL
remote_file ::File.join("/tmp/", kafka_archive) do
	source node[:kafka][:archive_url]
	mode 0644
	owner "root"
	checksum node[:kafka][:archive_checksum]
end

bash "extract kafka" do
	user "root"
	cwd "/tmp"
	code "unzip #{kafka_archive} -d #{node[:kafka][:base_dir]}"
	not_if { File.directory? ::File.join(node[:kafka][:base_dir], "libs") }
end

directory node["kafka"]["config_dir"] do
  mode "0755"
end

directory node["kafka"]["base_dir"] do
  mode "0755"
end

directory node["kafka"]["data_dir"] do
  mode "0755"
  owner "kafka"
end

zk_servers = search(:node, "role:zookeeper or zookeeper_cluster_name:#{node[:kafka][:zk_cluster_name]}")
zk_servers.sort! { |a, b| a.name <=> b.name }

servers = search(:node, "role:kafka")

template ::File.join(node["kafka"]["config_dir"], "server.properties") do 
	mode 0644
	variables :brokerid => node[:kafka][:brokerid], :zk_servers => zk_servers, :hostname=>node[:cloud][:public_hostname], :num_partitions=> node[:kafka][:number_of_partitions_per_topic]
	notifies :restart, "service[kafka]"
end

template ::File.join(node["kafka"]["config_dir"], "log4j.properties") do 
	mode 0644
	notifies :restart, "service[kafka]"
end

runit_service "kafka" do
	cookbook "kafka"
  options :kafka_server_properties => ::File.join(node["kafka"]["config_dir"], "server.properties"), :user => "kafka"
end
