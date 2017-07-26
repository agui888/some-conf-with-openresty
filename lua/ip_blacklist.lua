local _M = {
    _VERSION = '0.1'
}

local ngx_shared = ngx.shared
local restyLock = require "resty.lock"

local function error(msg)
  return 500, msg
end

function getFromCache(dict, prefix, key)
  local value = dict:get(prefix .. key)
  if not value then return nil end
  return value
end

function setToCache(dict, prefix, key)
  local value = getFromCache(dict, prefix, key)
  if not value then dict:set(prefix .. key, 1) return end
  dict:set(prefix .. key, value + 1)
end

function _M.checkIp(opt)
  opt.dict = opt.dict or ngx_shared[opt.dictName]
  opt.prefix = opt.prefix or "_default_prefix_"
  opt.limit = opt.limit or 5
  local request_client = ngx.var.remote_addr
  ngx.log(ngx.ERR, "The request_client is: ", request_client)

  local locker, err = restyLock:new(opt.dictLockName)
  if not locker then error("Get locker failed.") end
  local lock, err = locker:lock(opt.prefix .. request_client)
  if not lock then error("Retry lock the cache failed.") end

  local value = getFromCache(opt.dict, opt.prefix, request_client)
  ngx.log(ngx.ERR, "The value is: ", value)
  if value and value > opt.limit then
    locker:unlock()
    return error("500, the request over limit.")
  end
  setToCache(opt.dict, opt.prefix, request_client)
  locker:unlock()
  return nil, nil
end

return _M
