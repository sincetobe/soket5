set +o posix
#!/bin/bash
function install_http() {
# We strongly recommend the following be uncommented to protect innocent
# web applications running on the proxy server who think the only
# one who can access services on "localhost" is a local user
#http_access deny to_localhost

#
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#

# Example rule allowing access from your local networks.
# Adapt localnet in the ACL section to list your (internal) IP networks
# from where browsing should be allowed
http_access allow localnet
#http_access allow localhost

# And finally deny all other access to this proxy
#http_access deny all
http_access allow all

# Squid normally listens to port 3128
#http_port 3128
http_port 59394
via off
forwarded_for delete

# We recommend you to use at least the following line.
hierarchy_stoplist cgi-bin ?

# Uncomment and adjust the following to add a disk cache directory.
#cache_dir ufs /var/spool/squid 100 16 256

# Leave coredumps in the first cache dir
coredump_dir /var/spool/squid

# Add any of your own refresh_pattern entries above these.
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320
EOF
  systemctl start squid          #开启squid
  systemctl restart squid          #开启squid
  systemctl enable squid.service #设置开机自动启动
}
function install_socks5() {
  wget --no-check-certificate https://raw.github.com/Lozy/danted/master/install.sh -O install_proxy.sh
  bash install_proxy.sh --port=5788 --user=lin --passwd=duo111
}
install_http
install_socks5
