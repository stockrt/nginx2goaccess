#!/bin/bash
#
# Convert from this:
#   http://nginx.org/en/docs/http/ngx_http_log_module.html
# To this:
#   https://goaccess.io/man
#
# Conversion table:
#   $time_local         %d:%t %^
#   $host               %v
#   $http_host          %v
#   $remote_addr        %h
#   $request            %r
#   $status             %s
#   $body_bytes_sent    %b
#   $http_referer       %R
#   $http_user_agent    %u
#   $request_time       %T
#
# Samples:
#
# log_format main
# '${time_local}\t${remote_addr}\t${host}\t${request_method}\t${request_uri}\t${server_protocol}\t'
# '${http_referer}\t${http_x_mobile_group}\t'
# 'Local:\t${status}\t*${connection}\t${body_bytes_sent}\t${request_time}\t'
# 'Proxy:\t${upstream_status}\t${upstream_cache_status}\t'
# '${upstream_response_length}\t${upstream_response_time}\t${uri}${log_args}\t'
# 'Agent:\t${http_user_agent}\t'
# 'Fwd:\t${http_x_forwarded_for}';
#   ./nginx2goaccess.sh '${time_local}\t${remote_addr}\t${host}\t${request_method}\t${request_uri}\t${server_protocol}\t${http_referer}\t${http_x_mobile_group}\tLocal:\t${status}\t*${connection}\t${body_bytes_sent}\t${request_time}\tProxy:\t${upstream_status}\t${upstream_cache_status}\t${upstream_response_length}\t${upstream_response_time}\t${uri}${log_args}\tAgent:\t${http_user_agent}\tFwd:\t${http_x_forwarded_for}'
#
# log_format main
# '$remote_addr\t$time_local\t$host\t$request\t$http_referer\t$http_x_mobile_group\t'
# 'Local:\t$status\t$body_bytes_sent\t$request_time\t'
# 'Proxy:\t$upstream_cache_status\t$upstream_status\t$upstream_response_length\t$upstream_response_time\t'
# 'Agent:\t$http_user_agent\t'
# 'Fwd:\t$http_x_forwarded_for';
#   ./nginx2goaccess.sh '$remote_addr\t$time_local\t$host\t$request\t$http_referer\t$http_x_mobile_group\tLocal:\t$status\t$body_bytes_sent\t$request_time\tProxy:\t$upstream_cache_status\t$upstream_status\t$upstream_response_length\t$upstream_response_time\tAgent:\t$http_user_agent\tFwd:\t$http_x_forwarded_for'
#
# log_format combined '$remote_addr - $remote_user [$time_local] '
# '"$request" $status $body_bytes_sent '
# '"$http_referer" "$http_user_agent"';
#   ./nginx2goaccess.sh '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"'
#
# log_format compression '$remote_addr - $remote_user [$time_local] '
# '"$request" $status $bytes_sent '
# '"$http_referer" "$http_user_agent" "$gzip_ratio"';
#   ./nginx2goaccess.sh '$remote_addr - $remote_user [$time_local] "$request" $status $bytes_sent "$http_referer" "$http_user_agent" "$gzip_ratio"'
#
# Author: Rogério Carvalho Schneider <stockrt@gmail.com>

# Params
log_format="$1"

# Usage
if [[ -z "$log_format" ]]; then
    echo "Usage: $0 '<log_format>'"
    exit 1
fi

# Variables map
conversion_table="\$time_local,%d:%t_%^
\$host,%v
\$http_host,%v
\$remote_addr,%h
\$request,%r
\$status,%s
\$body_bytes_sent,%b
\$http_referer,%R
\$http_user_agent,%u
\$request_time,%T"

# Conversion
for item in $conversion_table; do
    nginx_var=${item%%,*}
    goaccess_var=${item##*,}
    goaccess_var=${goaccess_var//_/ }
    log_format=${log_format//$nginx_var/$goaccess_var}
done
log_format=$(echo "$log_format" | sed 's/$[a-z_]*/%^/g')

# Config output
echo "
- Generated goaccess config:

time-format %T
date-format %d/%b/%Y
log_format $log_format
"

# EOF
