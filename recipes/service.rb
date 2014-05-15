
include_recipe "kafka::install"

# create the runit service
runit_service "kafka" do
  options({
    :log_dir => node[:kafka][:log_dir],
    :install_dir => install_dir,
    :java_home => java_home,
    :log_dir => node[:kafka][:log_dir],
    :java_jmx_port => node[:kafka][:jmx_port],
    :java_class => "kafka.Kafka",
    :user => user
  })
end