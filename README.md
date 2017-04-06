# Some-conf-with-openresty
总结一些nginx配置
## OpenRest简介

OpenResty是一个基于 Nginx 与 Lua 的高性能 Web 平台，其内部集成了大量精良的 Lua 库、第三方模块以及大多数的依赖项。用于方便地搭建能够处理超高并发、扩展性极高的动态 Web 应用、Web 服务和动态网关. --[引自官网](https://openresty.org/cn)

## Nginx 启动方式
``` nginx启动方式
$ sbin/nginx -c conf/nginx.conf 直接指定配置文件启动
$ sbin/nignx -c conf/nginx.conf -s reload 重新启动Nginx
$ sbin/nginx -c conf/nginx.conf -s stop   停止Nginx服务
```
## Nginx 详细教程
中文教程详见春哥写的：http://openresty.org/download/agentzh-nginx-tutorials-zhcn.html

## hello-nginx.conf
``` demo1
启动好服务
$ sbin/nginx -c conf/hello-nginx.conf
$ curl http://localhost:9000/test
$ hello nginx!
```

## slb-for-nginx
通常我们生产环境中的应用是多台机器同时部署，美其名曰：集群。对于小规模的应用，使用nginx进行简单的集群还是很方便的，
通过upstream模块进行简单集群，方便、简单、高效。
当然，很多情况下用户在访问后台服务器时需要进行会话保持，我们可以简单地做一个会话保持服务器，比如通过redis保存sessionId,
后端很容易去实现，也可以通过nginx_lua模块进行会话保持，将同一个client的操作行为引入到同一个server中。
``` demo2
启动好服务
$ sbin/nginx -c conf/slb-for-nginx.conf
$ curl http://localhost:8000/a
$ I am from 127.0.0.1:9000
$ curl http://localhost:8000/a
$ I am from 127.0.0.1:9001
```
具体案例可以自己去试验
