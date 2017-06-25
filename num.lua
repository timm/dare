local the=require "config"
------------------------------------------------------
local function new()
    return {n=0,mu=0,m2=0,sd=0,hi=-1e32,lo=1e32} end
------------------------------------------------------
local function fromString(str)
    return tonumber(str) end
------------------------------------------------------
local function add(i,x)
  if one ~= the.ignore then 
    i.n = i.n + 1
    if x < i.lo then i.lo = x end
    if x > i.hi then i.hi = x end
    local delta = x - i.mu
    i.mu = i.mu + delta / i.n
    i.m2 = i.m2 + delta * (x - i.mu) 
    if i.n > 1 then 
      i.sd = (i.m2 / (i.n - 1))^0.5 end end end
-----------------------------------------------------
local function spread(i) return i.sd end
-----------------------------------------------------
local function norm(i,x)
  if x==the.ignore then return x end
  return (x - i.lo) / (i.up - i.lo + 1e-32) end
-----------------------------------------------------
return {new=new,add=add,norm=norm,fromString=fromString,
        spread=function (i) return i.sd}
