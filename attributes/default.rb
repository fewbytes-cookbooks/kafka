#
# Cookbook Name:: kafka
# Attributes:: default
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

# Install
default[:kafka][:version] = "0.8.0"
default[:kafka][:download_url] = "https://dist.apache.org/repos/dist/release/kafka/kafka_2.8.0-0.8.0-beta1.tgz"

default[:kafka][:checksum] = "750046ab729d2dbc1d5756794ebf8fcb640879b23a64749164c43063286316b8"

default[:kafka][:install_dir] = "/usr/local/kafka"
default[:kafka][:data_dir] = "/var/kafka"
default[:kafka][:log_dir] = "/var/log/kafka"
default[:kafka][:chroot_suffix] = "brokers"

default[:kafka][:num_partitions] = 1
default[:kafka][:broker_id] = nil
default[:kafka][:broker_host_name] = fqdn
default[:kafka][:port] = 9092
default[:kafka][:network_threads] = cpu[:total]
default[:kafka][:io_threads] = cpu[:total]
default[:kafka][:log_flush_interval] = 10000
default[:kafka][:log_flush_time_interval] = 1000
default[:kafka][:log_flush_scheduler_time_interval] = 1000
default[:kafka][:log_retention_hours] = 168
default[:kafka][:zk_connectiontimeout] = 10000
default[:kafka][:java][:xmx] = "512M"
default[:kafka][:user] = "kafka"
default[:kafka][:group] = "kafka"

default[:kafka][:log4j_logging_level] = "INFO"
default[:kafka][:jmx_port] = 9999
