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

package "unzip"

kafka_archive = ::File.basename(node[:kafka][:archive_url])
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

zk_servers = search_within_environment(:node,
    "role:zookeeper or zookeeper_cluster_name:#{node[:kafka][:zk_cluster_name]}")

template ::File.join(node["kafka"]["config_dir"], "server.properties") do
	mode 0644
	variables(
        :brokerid        => node[:kafka][:brokerid],
        :zk_servers      => zk_servers.sort_by{|server| server.name},
        :hostname        => node[:cloud][:public_hostname],
        :num_partitions  => node[:kafka][:number_of_partitions_per_topic],
    )
	notifies :restart, "service[kafka]"
end

template ::File.join(node["kafka"]["config_dir"], "log4j.properties") do
	mode 0644
	notifies :restart, "service[kafka]"
end

properties_file = ::File.join(node["kafka"]["config_dir"], "server.properties")
runit_service "kafka" do
	cookbook "kafka"
    options :kafka_server_properties => properties_file, :user => "kafka"
end
