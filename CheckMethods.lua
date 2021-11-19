--Kat Method
function nearestPlayerToRay()
    local dist = math.huge
    local ray
    
    for i,v in pairs(game.Players:GetChildren()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Head") and not v.Character:FindFirstChild("ForceField") then
            if v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("Head") then -- needed..
                local newVec = (v.Character.Head.Position - game.Players.LocalPlayer.Character.Head.Position)
                if newVec.magnitude < dist then
                    local toRay = Ray.new(game.Players.LocalPlayer.Character.Head.Position, newVec)
                    if not workspace:FindPartOnRayWithIgnoreList(toRay, {game.Players.LocalPlayer.Character, v.Character, workspace.WorldIgnore, workspace.CurrentCamera}) then
                        dist = newVec.magnitude
                        ray = toRay
                    end
                end
            end
        end
    end
    return ray
end

-- score method ( not tested)
local function closestTarget()
	local clos = {
		ThreatDist = nil,
		PixelDist = nil,
		score = 0, -- 1 pixel 2 threat 3 both
		person = nil,
	}
	for _,player in pairs(Players:GetPlayers()) do
		if player.Team ~= Player.Team then
			if player.Character then
				if not player.Character.Humanoid.Health <= 0 then return end
				
				local threatLevel = scanPlayer(player.Character)
				
				local threaten = false
				local score = 0
				local PixelDist,ThreatDist = nil,nil
				if string.find(threatLevel,"|shoot") then
					threaten = true
				else
					threaten = false
				end
				
				local ors,si = player.Character:GetBoundingBox()
				local ors1,si1 = Player.Character:GetBoundingBox()
				if not threaten then						
					local point,onscreen = camera:WorldToViewportPoint(ors.p)
					if onscreen then
						PixelDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(point.X, point.Y)).magnitude
						score = 1
					end
				else
					local dist = (ors.p-ors1.p).magnitude
					local point,onscreen = camera:WorldToViewportPoint(ors.p)
					if onscreen then
						ThreatDist = dist
						PixelDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(point.X, point.Y)).magnitude
						score = 3
					else
						ThreatDist = dist
						score = 2
					end
				end
				
				if clos.person then
					if clos.PixelDist then
						if PixelDist then
							if clos.PixelDist>PixelDist then
								clos.person = player
								clos.ThreatDist = ThreatDist
								clos.PixelDist = PixelDist
								clos.score = score
							end
						else
							if clos.ThreatDist and ThreatDist then
								if ThreatDist<clos.ThreatDist then
									clos.person = player
									clos.ThreatDist = ThreatDist
									clos.PixelDist = PixelDist
									clos.score = score
								end
							end
						end
					else
						if ThreatDist and clos.ThreatDist then
							if ThreatDist<clos.ThreatDist then
								clos.person = player
								clos.ThreatDist = ThreatDist
								clos.PixelDist = PixelDist
								clos.score = score
							end
						end
					end
				else
					clos.person = player
					clos.PixelDist  = PixelDist
					clos.ThreatDist = ThreatDist
				end
				
			end
		end
	end
	return clos.person
end

-- phantom method ( needs to be edited)
local function phMethod()
	local nearestDist = math.huge
    local nearest
                      
    for o,p in pairs(game:GetService("Players"):GetPlayers()) do
        if pf.hud:isplayeralive(p) and p.TeamColor ~= lp.TeamColor then
            local _, headPos = pf.replication.getupdater(p).getpos()
                                
            local viewportHead = pf.camera.currentcamera:WorldToViewportPoint(headPos)
                                
            local distFromCursor = (Vector2.new(viewportHead.x, viewportHead.y) - (pf.camera.currentcamera.ViewportSize / 2)).magnitude
                                
            if distFromCursor < nearestDist then
                nearestDist = distFromCursor
                nearest = p
            end
        end
    end
end
