# Some-conf-with-openresty
总结一些nginx配置
## OpenRest简介

OpenResty是一个基于 Nginx 与 Lua 的高性能 Web 平台，其内部集成了大量精良的 Lua 库、第三方模块以及大多数的依赖项。用于方便地搭建能够处理超高并发、扩展性极高的动态 Web 应用、Web 服务和动态网关. --[引自官网](https://openresty.org/cn)

## Nginx 启动方式
``` nginx启动方式
$ sbin/nginx -c conf/nginx.conf 直接指定配置文件启动
$ sbin/nignx -c conf/nginx.conf -s reload 重新启动Nginx
$ sbin/nginx -s stop   停止Nginx服务
```

## hello-nginx.conf
``` demo1
启动好服务
$ sbin/nginx -c conf/hello-nginx.conf
$ curl http://localhost:9000/test
$ hello nginx!
```

## slb-for-nginx
