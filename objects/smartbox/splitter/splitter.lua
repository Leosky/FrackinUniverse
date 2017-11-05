require "/scripts/kheAA/transferUtil.lua"
local deltaTime = 0

function init()
	transferUtil.init()
	object.setInteractive(true)
end

function update(dt)
	deltaTime = deltaTime + dt
	if deltaTime > 1 then
		deltaTime = 0
		transferUtil.loadSelfContainer()
	end

	 --test on output slots to avoid filling more than once
	local id = entity.id()
	if not world.containerItemAt(id, 1) then refresh(100, 1) end
	if not world.containerItemAt(id, 2) then refresh(10, 2) end
	if not world.containerItemAt(id, 3) then refresh(1, 3) end
end

function refresh(size, slot)
	local id = entity.id()
	local input = world.containerItemAt(id, 0)
	if input then
		local stack = world.containerTakeNumItemsAt(id, 0, math.min(1, (input.count // size)) * size) -- only one stack
		if stack then 
			stack = world.containerPutItemsAt(id, stack, slot)
			if stack then
				world.containerPutItemsAt(id, stack, 0)
				if ((stack.count or 0) % size) ~= 0 then
					stack = world.containerTakeNumItemsAt(id, slot, size - (stack.count % size))
					world.containerPutItemsAt(id, stack, 0)
				end
			end
		end
	end
end

--Note : shift-clicking will fill already filled slots before slot 1. Idk if its possible to fix this inadabted behaviore for this block.