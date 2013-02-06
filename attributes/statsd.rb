default[:statsd][:port] = 8125
default[:statsd][:graphite_port] = 2003
default[:statsd][:graphite_host] = "localhost"
default[:statsd][:package_version] = "0.5.0"
default[:statsd][:sha] = "96c488dc52a4f50fdf73343b8275e914be722655"
default[:statsd][:user] = "statsd"
default[:statsd][:repo] = "git://github.com/etsy/statsd.git"
default[:statsd][:tmp_dir] = "/tmp"

# https://github.com/hectcastro/chef-statsd
#default["statsd"]["dir"]            = "/usr/share/statsd"
#default["statsd"]["conf_dir"]       = "/etc/statsd"
#default["statsd"]["repository"]     = "git://github.com/etsy/statsd.git"
#default["statsd"]["log_file"]       = "/var/log/statsd.log"
#default["statsd"]["flush_interval"] = 10000
#default["statsd"]["address"]        = "0.0.0.0"
#default["statsd"]["port"]           = 8125
#default["statsd"]["graphite_host"]  = "localhost"
#default["statsd"]["graphite_port"]  = 2003

#
# https://github.com/petey5king/statsd
# default[:statsd][:home_dir]          = "/usr/local/share/statsd"
# default[:statsd][:conf_dir]          = "/etc/statsd"
# default[:statsd][:log_dir]           = "/var/log/statsd"
# default[:statsd][:pid_dir]           = "/var/run/statsd"
# default[:statsd][:user]            = "statsd"
# default[:users ]['statsd' ][:uid]  = 310
# default[:groups]['statsd' ][:gid]  = 310
# default[:statsd][:run_state]   = :start
# default[:statsd][:graphite][:port] = 2003
# default[:statsd][:graphite][:addr] = "localhost"
# default[:statsd][:port]            = 8125
# default[:statsd][:git_repo]         = "https://github.com/etsy/statsd.git"
# default[:statsd][:flush_interval]   = 10000 #milliseconds between flushes
#
#https://github.com/cramerdev/statsd-cookbook
# https://github.com/librato/statsd-cookbook
