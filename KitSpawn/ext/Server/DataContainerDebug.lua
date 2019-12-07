class "DataContainerDebug"

-- Prints all members and child members of a given instance. Useful for debugging.
function DataContainerDebug:PrintFields( instance, typeInfo, padding, currentDepth, maxDepth, fieldName)
	if(fieldName == nil) then
		fieldName = ""
	else
		fieldName = fieldName .. " "
	end

	typeInfo = typeInfo or instance.typeInfo

	if(currentDepth == nil) then
		currentDepth = 0
	end

	if(maxDepth == nil) then
		maxDepth = -1
	else
		if(maxDepth ~= -1 and currentDepth > maxDepth) then
			return
		end
	end

	currentDepth = currentDepth + 1

	if(padding == nil) then
		padding = ""
	end

	print(padding ..fieldName..'(Object - '..typeInfo.name..')')
	-- print(padding .. typeInfo.name .. ' {')
	padding = padding .. "  "

	-- print(type(typeInfo.fields))
	-- print(#typeInfo.fields)

	local super = typeInfo.super

	if super ~= nil then
		if super.name ~= "DataContainer" then
			self:PrintFields(instance, super)
		end
	end

	for _, field in pairs(typeInfo.fields) do
		-- print("Found field: " .. field.name)

		if field.typeInfo ~= nil then

			local s_Name = field.name:firstToLower()

			--Value that can be printed
			--NOTE: these arent all possible types
			if field.typeInfo.name == 'CString' or

				 field.typeInfo.name == 'Float8' or
				 field.typeInfo.name == 'Float16' or
				 field.typeInfo.name == 'Float32' or
				 field.typeInfo.name == 'Float64' or

				 field.typeInfo.name == 'Int8' or
				 field.typeInfo.name == 'Int16' or
				 field.typeInfo.name == 'Int32' or
				 field.typeInfo.name == 'Int64' or

				 field.typeInfo.name == 'Uint8' or
				 field.typeInfo.name == 'Uint16' or
				 field.typeInfo.name == 'Uint32' or
				 field.typeInfo.name == 'Uint64' or

				 field.typeInfo.name == 'Boolean' then

				local s_Value = instance[s_Name]

				print(padding ..field.name..' ('..field.typeInfo.name..') : '.. tostring(s_Value))

			--Array
			elseif field.typeInfo.array then
				-- So UIBundlesAsset[uIBundleAssetStateList] returns nil even though it's not??
				if(instance[field.name:firstToLower()] ~= nil) then
					local s_Count = #instance[field.name:firstToLower()]
					print(padding ..field.name..' (Array), '..tostring(s_Count)..' Members {')

					if s_Count ~= 0 then
						s_Count = s_Count

						for i=1,s_Count,1 do
							local instanceType = type(instance[field.name:firstToLower()]:get(i))
							if(instanceType == "number" or instanceType == "string" ) then
								print(padding .. "[" .. i .. "] " ..instance[field.name:firstToLower()]:get(i))
							else
								local s_MemberInstance = instance[field.name:firstToLower()]:get(i)
								local s_Member = _G[s_MemberInstance.typeInfo.name](s_MemberInstance)

								if s_Member ~= nil then
									self:PrintFields(s_Member, s_Member.typeInfo, padding .. "  ", currentDepth, maxDepth)
								end
							end
						end
					end
					print(padding .. "}")
				end
			--Enum
			elseif field.typeInfo.enum then
				local s_Value = instance[s_Name]
				print(padding..field.name..' (Enum) : ' .. tostring(s_Value))
			elseif field.typeInfo.name == "Guid" then
				local s_Value = instance[s_Name]
				print(padding..field.name..' (Guid) : ' .. tostring(s_Value))
			--Object
			else
				if instance[s_Name] ~= nil then
					-- local s_Value = instance[s_Name]
					local i = _G[field.typeInfo.name](instance[s_Name])
					if i ~= nil then
						-- padding = padding .. "	"
						self:PrintFields( i, i.typeInfo, padding, currentDepth, maxDepth, field.name) 
					end
				else
					print(padding ..field.name..' (Object - '..field.typeInfo.name..') ' .."nil")
				end
			end
		end
	end
	print (padding:sub(1, -3) .. "}")
end

return DataContainerDebug