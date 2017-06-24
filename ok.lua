-- /* vim: set filetype=lua ts=2 sw=2 sts=2 expandtab: */
-- Test engine stuff -----------------------

local i={}
i.y,i.n = 0,0
i.builtin = { "true","math","package","table","coroutine",
              "os","io","bit32","string","arg","debug","_VERSION","_G"}

function i.member(x,t)
  for _,y in pairs(t) do
    if x== y then return true end end
  return false end
------------------------------------------------------
function i.report(y,n) 
  print(string.format(
        ":pass %s :fail %s :percentPass %.0f%%",
         y,n,100*y/(0.001+y+n))) end
------------------------------------------------------
function i.tests(t)
  for s,x in pairs(t) do  
    print("# test:", s) 
    i.y = i.y + 1
    local passed,err = pcall(x) 
    if not passed then   
       i.n = i.n + 1
       print("Failure: ".. err) 
  end end end
-------------------------------------------------------
function i.rogue()
  io.write "-- Globals: "
  for k,v in pairs( _G ) do
    if type(v) ~= 'function' then  
       if not i.member(k, i.builtin) then 
         io.write(" ",k) end end end
  print  "" end
------------------------------------------------------
function i.ok(t) 
    if next(t)==nil then i.report(i.y,i.n) else i.tests(t); i.report(i.y,i.n) end end
------------------------------------------------------
return i
