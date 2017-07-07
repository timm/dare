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
  local function xpect(lo,hi)
    out= num.create()
    for j=lo,hi do
      num.updates(ranges[j]._all._all, y) end
    return out end
  --------------------------------------------
  local function combine(lo,hi,all,bin,lvl)
    local lbest,rbest,cut
    local best= all.sd
    for j=lo,hi-1 do
      local l  = xpect(lo,  j, y,ranges)
      local r  = xpect(j+1,hi, y,ranges)
      local tmp= l.n/all.n*l.sd + r.n/all.n*r.sd
      if (tmp*1.01 < best) then
        cut  = j
        best = tmp
        lbest = copy(l)
        rbest = copy(r)
    end end
    if cut then
      bin= combine(lo,  cut,lbest,bin,lvl+1)
      bin= combine(cut+1,hi,rbest,bin,lvl+1)
    else
      for j in lo,hi do
        ranges[j].bin = bin end end 
    return bin end 
  --------------------------------------------
  local ranges = range(lst,x)
  return combine(1,#ranges, 
                 xpect(1,#ranges),
                 1,0) end
