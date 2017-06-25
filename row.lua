local id= require "id"
-----------------------------------------------------------
local function new()
  return {id=id.new(),   cells={},   cooked={}} end
-----------------------------------------------------------
local function add(i,cells,t)
  i.cells=copy(cells)
  i.cooked=copy(cells)
  for _,head in pairs(t.cols) do
    head.who.add(head, cells[head.pos])
  end
end
return {new=new}
