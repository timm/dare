local id=  require "id"
local lst= require "lists"
local num= require "num"
-----------------------------------------------------------

local function new()
  return {id=id.new(),   cells={},   cooked={}} end
-----------------------------------------------------------
local function add(i,cells,t)
  i.cells=lst.copy(cells)
  i.cooked=lst.copy(cells)
  for _,head in pairs(t.all.cols) do
    head.what.add(head, cells[head.pos]) end
  return i end
-----------------------------------------------------------
local function dominates1(i,j,t)
  local e,n = 2.71828,#t.goals
  local sum1,sum2=0,0
  for _,col in pairs(t.goals)  do
    local w= col.weight
    local x= num.norm(col, i.cells[col.pos])
    local y= num.norm(col, j.cells[col.pos])
    sum1 = sum1 - e^(w * (x-y)/n)
    sum2 = sum2 - e^(w * (y-x)/n) 
  end 
  return sum1/n < sum2/n 
end
-----------------------------------------------------------
local function dominates(i,t) 
  if not i.dom then
    for _,j in pairs(t.rows) do
      if i.id ~= j.id then 
        if dominates1(i,j,t) then
          i.dom = i.dom + 1  end end end end 
  return i.dom end
-----------------------------------------------------------
return {new=new, add=add,dominates=dominates}
