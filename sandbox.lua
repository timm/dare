-- /* vim: set filetype=lua ts=2 sw=2 sts=2 expandtab: */

local o= require "tests"
local function _one(     k) 
  k=1
  print(2)
  assert(1==2,"impossible")
end
b=2
o.k{_one}
