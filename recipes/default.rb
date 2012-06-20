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

remote_file "/tmp/kafka.src.tgz" do
	source node[:kafka][:tarball_url]
	mode 0644
	owner "root"
	checksum node[:kafka][:tarball_checksum]
end

bash "untar kafka" do
	user "root"
	cwd "/tmp"
	code "tar zxf /tmp/kafka.src.tgz"
	not_if { File.exists? node[:kafka][:extracted_dir] }
end

bash "copy kafka" do
	user "root"
	cwd "/tmp"
	code "cp -a /tmp/#{node[:kafka][:extracted_dir]} /opt/kafka"
	not_if { File.exists? "/opt/kafka" }
end

directory "/etc/kafka" do
  mode "0755"
end

zk_servers = search(:node, "role:zookeeper or zookeeper_cluster_name:#{node[:kafka][:zk_cluster_name]}")
zk_servers.sort! { |a, b| a.name <=> b.name }

servers = search(:node, "role:kafka")

template "/etc/kafka/server.properties" do 
	mode 0644
	variables :brokerid => node[:kafka][:brokerid], :zk_servers => zk_servers, :hostname=>node[:cloud][:public_hostname], :num_partitions=> node[:kafka][:number_of_partitions_per_topic]
	notifies :restart, "service[kafka]"
end

runit_service "kafka" do
	cookbook "kafka"
end
