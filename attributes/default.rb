require 'zlib'

default["kafka"]["archive_url"] = "http://public.fewbytes.com/kafka-0.7.1.zip"
default["kafka"]["archive_checksum"] = "e71386369d5960bd62da7b88b393b5f8b98838ee33b4683175b40f062cfe3aee"
default["kafka"]["brokerid"] = (Zlib.crc32(fqdn) % 2**31) #this needs to enter a Java int
default["kafka"]["zk_cluster_name"] = "default"
default["kafka"]["number_of_partitions_per_topic"] = 1
default["kafka"]["config_dir"] = "/etc/kafka"
default["kafka"]["base_dir"] = "/opt/kafka"
default["kafka"]["jmx_port"] = 9999
default["kafka"]["java_max_memory"] = "768m"

default["kafka"]["data_dir"] = "/mnt/kafka-logs"
