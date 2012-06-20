default[:kafka][:tarball_url] = "http://people.apache.org/~nehanarkhede/kafka-0.7.0-incubating/kafka-0.7.0-incubating-src.tar.gz"
default[:kafka][:tarball_checksum] = "08b6732080af7d063d2fde5358c5b02eaa5b3e9e376d71fb99de33d7cf5d5115"
default[:kafka][:extracted_dir] = "kafka-0.7.0-compiled"
default[:kafka][:brokerid] = fqdn.hash.abs % 2 ** 31
default[:kafka][:zk_cluster_name] = "default"
default[:kafka][:number_of_partitions_per_topic] = 1
