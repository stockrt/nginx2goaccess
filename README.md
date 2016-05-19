# Convert Nginx log_format to goaccess config

## Usage
```bash
./nginx2goaccess.sh '<log_format>'
./nginx2goaccess.sh '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"'
```
