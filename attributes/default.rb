default[:kafka][:download_url] = "http://fewbytes-clients.s3.amazonaws.com/conduit/kafka-0.7.0-compiled.tar.gz"
default[:kafka][:extracted_dir] = "kafka-0.7.0-compiled"
default[:kafka][:brokerid] = fqdn.hash.abs
default[:kafka][:zk_cluster_name] = "default"
default[:kafka][:number_of_partitions_per_topic] = 1
