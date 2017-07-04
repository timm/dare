--[[

# chop : unsupervised discretiation

DARE, Copyright (c) 2017, Tim Menzies
All rights reserved, BSD 3-Clause License

Redistribution and use in source and binary forms, with
or without modification, are permitted provided that
the following conditions are met:

* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the 
  following disclaimer.

* Redistributions in binary form must reproduce the
  above copyright notice, this list of conditions and the 
  following disclaimer in the documentation and/or other 
  materials provided with the distribution.

* Neither the name of the copyright holder nor the names 
  of its contributors may be used to endorse or promote 
  products derived from this software without specific 
  prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

------------------------------------------------------

--]]

require "show"
local the=require "config"
local num=require "num"
----------------------------------
local function create(lst, x)  
  local _= { 
    x     = x or function (z) return z  end,
    cohen = the.chop.cohen,
    m     = the.chop.m,
    size  = #lst,
    ranges= {} }
  table.sort(lst,_.x)
  local n = num.updates(lst, _.x)
  _.enough = _.size^_.m
  _.hi     = n.hi
  _.epsilon= n.sd * _.cohen
  return _ end
----------------------------------
local function range() return {
  all= {},
  hi = -2^63,
  lo =  2^63,
  span = 2^64,
  n  =  0 }  end
----------------------------------
local function update(i,one,x) 
  if x > i.hi then i.hi= x end 
  if x < i.lo then i.lo= x end 
  i.all[#i.all+1] = one
  i.n = i.n + 1
  i.span = i.hi - i.lo
end  
----------------------------------
local function nextRange(i) 
  local _ = range()
  i.ranges[#i.ranges+1] = _
  return _ end
----------------------------------
return function (lst, x,       last)
  local i= create(lst, x)
  local r= nextRange(i)
  for j,one in pairs(lst) do
    local x1 = x(one)
    update(r, one, x1)
    if j > 1 and
       r.n        > i.enough  and
       r.span     > i.epsilon and
       i.size - j > i.enough  and
       i.hi  - x1 > i.epsilon and
       x1  - last > i.epsilon 
    then r = nextRange(i) end 
    last = x1 
  end 
  return i end
