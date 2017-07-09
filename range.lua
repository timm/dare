--[[

# range : unsupervised discretiation

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
local some=require "sample"
----------------------------------
local function create() return {
  _all= some.create(),
  n  = 0,
  hi = -2^63,
  lo =  2^63,
  span = 2^64} end
----------------------------------
local function update(i,one, x)
  if x ~= the.ignore then
    some.update(i._all, one)
    i.n = i.n + 1
    if x > i.hi then i.hi = x  end
    if x < i.lo then i.lo = x  end
    i.span = i.hi - i.lo
    return x end  end
----------------------------------
local function nextRange(i) 
  i.now  = create()
  i.ranges[#i.ranges+1] = i.now end
----------------------------------
local function rangeManager(lst, x)  
  local _ = { 
    x     = x,
    cohen = the.chop.cohen,
    m     = the.chop.m,
    size  = #lst,
    ranges= {} 
  }
  _.enough = _.size^_.m
  nextRange(_)
  _.num = num.updates(lst, _.x)
  _.hi     = _.num.hi
  _.epsilon= _.num.sd * _.cohen
  return _ end
----------------------------------
return function (lst, x,       last)
  x= x or function (z) return z end
  table.sort(lst, function (z1,z2) return x(z1) < x(z2) end)
  local i= rangeManager(lst, x)
  for j,one in pairs(lst) do
    local x1 = update(i.now, one, x(one))
    if j > 1 and
       x1 > last and
       i.now.n       > i.enough  and
       i.now.span    > i.epsilon and
       i.num.n - j   > i.enough  and
       i.num.hi - x1 > i.epsilon 
    then nextRange(i) end 
    last = x1 
  end 
  return i.ranges end
