--[[

# superranges : utilities

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
local range=require "range"
-----------------------------------------------
return function (lst,x,y)
  local ranges = range(lst,x)
  --------------------------------------------
  local function data(j) return ranges[j]._all._all end
  --------------------------------------------
  local function memo(here,stop,inc,_memo,    b4)
    if not _memo[here] then 
      if here ~= stop then 
        b4= memo(here+inc, stop, inc, _memo) end
      _memo[here] = num.updates(data(here), y, b4) 
    end
    return copy(_memo[here]) end
  --------------------------------------------
  local function combine(lo,hi,all,bin,lvl)
    local best= all.sd
    local lmemo, rmemo= {},{}
    local l,r,cut
    for j=lo,hi-1 do
      local l0 = memo(j,   lo, -1, lmemo)
      local r0 = memo(j+1, hi,  1, rmemo)
      local tmp= l0.n/all.n*l0.sd + r0.n/all.n*r0.sd
      if (tmp*1.01 < best) then
        cut  = j
        best = tmp
        l = copy(l0)
        r = copy(r0)
    end end
    if cut then
      bin = combine(lo,  cut,lbest,bin,lvl+1)
      bin = combine(cut+1,hi,rbest,bin,lvl+1)
    else
      for j in lo,hi do
        ranges[j].bin = bin end end 
    return bin end 
  --------------------------------------------
  combine(1,#ranges, 
           xpect(1,#ranges),
           1,0) 
  return ranges end
