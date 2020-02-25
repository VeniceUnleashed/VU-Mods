Events:Subscribe('Partition:Loaded', function(partition)
	if partition == nil then
		return
	end

	local instances = partition.instances
	for _, instance in pairs(instances) do
		if instance ~= nil then
			if instance:Is("LevelData") then
				local instance = LevelData(instance)
				instance:MakeWritable()
				instance.maxVehicleHeight = 9999999
			end
		end
	end
end)

