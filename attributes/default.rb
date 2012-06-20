default[:kafka][:tarball_url] = "http://fewbytes-clients.s3.amazonaws.com/conduit/kafka-0.7.0-compiled.tar.gz"
default[:kafka][:tarball_checksum] = "88b3b68f581d9c53c6ade52f70207114cceac368ff2200ac036a73d3efa0ef7f"
default[:kafka][:extracted_dir] = "kafka-0.7.0-compiled"
default[:kafka][:brokerid] = fqdn.hash.abs
default[:kafka][:zk_cluster_name] = "default"
default[:kafka][:number_of_partitions_per_topic] = 1
