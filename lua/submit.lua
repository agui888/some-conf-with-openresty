local _M = {
    _VERSION = '0.1'
}
local mysql = require "resty.mysql"
local ngx_re_match = ngx.re.match
local checkIp = require "ip_blacklist"

local function error(msg)
  ngx.status = 500
  ngx.say(msg)
  ngx.exit(500)
end

local function connectMysql(dataSourceName)
  local db, err = mysql:new()
  if not db then return nil, "initialize mysql failed!" end
  local regex = "(.+?):(.+?)@(.+?):(.+?)/(.+)"
  local m = ngx_re_match(dataSourceName, regex)
  if not m then return nil, "dataSourceName format is not recognized" end
  local ok, err, errno, sqlstate = db:connect {
        host = m[3],
        port = m[4],
        database = m[5],
        user = m[1],
        password = m[2],
        max_packet_size = 1024 * 1024
    }
    if ok then return db, nil end
end

local function closeDb(db)
  db:close()
end

function prepareInsertMysql(opt)
  local sqlStr = "insert into to_f_apply_user (user_name, mobile, merchant_name, merchant_area, create_time, update_time) values('" .. opt.userName .. "','" .. opt.mobile .. "','" .. opt.merchantName .. "','" .. opt.merchantArea .. "', now(), now())"
  return sqlStr
end

function _M.easyHiApply(opt)
  local errcode, errmsg = checkIp.checkIp({dictName = "check_ip", dictLockName = "check_ip_lock"})
  if errcode then error(errmsg) end
  opt.merchantName = ngx.var.arg_merchantName or ''
  opt.mobile = ngx.var.arg_mobile or ''
  opt.userName = ngx.var.arg_userName or ''
  opt.merchantArea = ngx.var.arg_merchantArea or ''
  local dataSourceName = opt.dataSourceName or "root:admin@127.0.0.1:3306/test"
  local sqlStr = prepareInsertMysql(opt)
  ngx.log(ngx.ERR, "the sqlStr is: ", sqlStr)
  local db, err = connectMysql(dataSourceName)
  if not db then error(err) end
  local res, err, errcode, sqlstate = db:query(sqlStr)
  if err then
    error("insert to mysql failed: " .. err)
    closeDb(db)
  end
  ngx.say("ok")
end

return _M
