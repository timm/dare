--[[

# table : utilities

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

local the=require "config"
local num=require "num"
local sym=require "sym"
local row=require "row"
local csv=require "csv"
-------------------------------------------------------------
local function new(cells) return {
  cols={}, rows={}, less={}, ynums={}, xnums={},
  more={}, spec={}, ys={}, xs={}, syms={}, xsyms={}, nums={}} end
-------------------------------------------------------------
local function meta(i,txt)
  local spec =  {
    {what= "%$", who= num, wheres= {i.cols, i.xs, i.nums,         i.xnums}},
    {what= "<",  who= num, wheres= {i.cols, i.ys, i.nums, i.less, i.ynums}},
    {what= ">",  who= num, wheres= {i.cols, i.ys, i.nums, i.more, i.ynums}},
    {what= "!",  who= sym, wheres= {i.cols, i.ys, i.syms                 }},
    {what= "",   who= sym, wheres= {i.cols, i.xs, i.syms,         i.xsyms}}}
  for _,want in pairs(spec) do
    if string.find(txt,want.what) ~= nil then
      return want.who, want.wheres end end end
-------------------------------------------------------------
local function header(i,cells)
  i.spec = cells
  for col,cell in ipairs(cells) do
    local who, wheres = meta(i,cell)
    local one = who.new()
    one.col = col
    one.txt = cell
    one.who = who
    for _,where in ipairs(wheres) do
      where[ #where + 1 ] = one end end end
-------------------------------------------------------------
local function data(i,cells)
  i.rows[#i.rows+1] = row.add(row.new(), cells,t) end
-------------------------------------------------------------
local function add(i,cells) 
  local fn= #i.rows==0 and header or data
  fn(i,cells) end
-------------------------------------------------------------
local function csv2tbl(f,     t)
  out = new()
  csv.loop(f, function (cells) add(out,cells) end)
  return out end
-------------------------------------------------------------
return {csv2tbl=csv2tbl}
