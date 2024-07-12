--"[King's Game Group] you have been blacklisted, any issues please contact us via our communcation server."
--"[King's Game Group] The group 'GroupName has been blacklisted, please leave to join the game."

local m = {}

local httpService = game:GetService("HttpService")

function getBlacklistedGroup(plr : Player)
	local response = httpService:GetAsync("https://raw.githubusercontent.com/kingcharlesspaniel13/KGBlacklist/main/group.json")
	local decoded = httpService:JSONDecode(response)
	for _, group in decoded do
		if plr:GetRankInGroup(group["GroupId"]) then
			if plr:GetRankInGroup(group["GroupId"]) >= tonumber(group["Minimum"]) then
				return true,game:GetService("GroupService"):GetGroupInfoAsync(group["GroupId"]).Name
			else

				for _, roleset in game:GetService("GroupService"):GetGroupInfoAsync(group["GroupId"]).Roles do
					for _, data in roleset do
						if data["Rank"] >= tonumber(group["Minimum"]) then
							return true,game:GetService("GroupService"):GetGroupInfoAsync(group["GroupId"]).Name
						end
					end
				end

			end
		end
	end
end

function isWhitelisted(plr : Player)
	do
		local response = httpService:GetAsync("https://raw.githubusercontent.com/kingcharlesspaniel13/KGBlacklist/main/groupwhitelist.json")
		print(response)
		local decoded = httpService:JSONDecode(response)
		for _, group in decoded do
			if plr:IsInGroup(group["GroupId"]) then
				return true
			end
		end
	end
	do
		local response = httpService:GetAsync("https://raw.githubusercontent.com/kingcharlesspaniel13/KGBlacklist/main/userwhitelist.json")
		print(response)
		local decoded = httpService:JSONDecode(response)
		for _, group in decoded do
			if plr.UserId == tonumber(group["UserId"]) then
				script["Approved UI"]:Clone().Parent = plr.PlayerGui
				return true
			end
		end
	end
end

function getBlacklistedUser(plr : Player)
	local response = httpService:GetAsync("https://raw.githubusercontent.com/kingcharlesspaniel13/KGBlacklist/main/user.json")
	local decoded = httpService:JSONDecode(response)
	for _, id in decoded do
		if id["UserId"] == plr.UserId then
			return true
		end
	end
end


function m.init()
	game.Players.PlayerAdded:Connect(function(plr)
		if not isWhitelisted(plr) then
			do
				local isblacklisted = getBlacklistedGroup(plr)
				print(isblacklisted)
				if isblacklisted then
					if isblacklisted[1] then
						plr:Kick("[King's Game Group] The group " .. isblacklisted[2] .. " has been blacklisted, please leave to join the game.")
					end	
				end
			end
			do
				local isblacklisted = getBlacklistedUser(plr)
				print(isblacklisted)
				if isblacklisted then
					plr:Kick("[King's Game Group] you have been blacklisted, any issues please contact us via our communcation server.")
				end
			end
		else
			
		end
	end)
end

return m