class 'IngameRconServer'


function IngameRconServer:__init()
	print("Initializing IngameRconServer")
	self:RegisterEvents()
end


function IngameRconServer:RegisterEvents()
	self.m_ChatEvent = Events:Subscribe("Player:Chat", self, self.OnChat)
end

function string:split(sep)
   local sep, fields = sep or " ", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function IngameRconServer:OnChat(p_Player, p_RecipientMask, p_Message)
	if p_Message == '' or p_Player == nil then
		return
	end

	print("[Chat] " .. p_Player.name .. ": " .. p_Message)
	local parts = p_Message:split(' ')

	if parts[1] == 'rcon' then
		local result = RCON:SendCommand(parts[2], {parts[3]})
		print("Rcon: " .. dump(result))
	end

	if parts[1] == 'reload' then
		print("Reloading mods")
		RCON:SendCommand('vu.modlist.reloadextensions')
	end
end


g_IngameRconServer = IngameRconServer()

