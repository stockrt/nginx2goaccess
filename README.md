# nginx2goaccess

Convert Nginx [log_format](http://nginx.org/en/docs/http/ngx_http_log_module.html)
to [goaccess config](https://goaccess.io/man).

## Usage

Command:

```bash
Usage: ./nginx2goaccess.sh '<log_format>'

./nginx2goaccess.sh '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"'
```

Result:

* Can be used with -p and read from a config file or placed into ~/.goaccessrc

```bash
- Generated goaccess config:

time-format %T
date-format %d/%b/%Y
log_format %h - %^ [%d:%t %^] "%r" %s %b "%R" "%u"
```
