-- /* vim: set filetype=lua ts=2 sw=2 sts=2 expandtab: */
-- Test engine stuff -----------------------

local y,n = 0,0
local builtin = { "true","math","package","table","coroutine",
                   "os","io","bit32","string","arg","debug","_VERSION","_G"}

local function member(x,t)
  for _,y in pairs(t) do
    if x== y then return true end end
  return false end
-------------------------------------------------------
local function rogue()
  for k,v in pairs( _G ) do
    if type(v) ~= 'function' then  
       if not member(k, builtin) then 
         print("-- Global: " .. k) end end end end
------------------------------------------------------
local function report() 
  print(string.format(
        ":pass %s :fail %s :percentPass %.0f%%",
         y, n, 100*y/(0.001+y+n))) 
  rogue() end
------------------------------------------------------
local function tests(t)
  for s,x in pairs(t) do  
    print("# test:", s) 
    y = y + 1
    local passed,err = pcall(x) 
    if not passed then   
       n = n + 1
       print("Failure: ".. err) 
  end end end
------------------------------------------------------
local function main(t) 
    if next(t)==nil then report() else tests(t); report() end end
------------------------------------------------------
return {k=main}
