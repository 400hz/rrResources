local ContextActionService = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer 

local Camera = workspace.CurrentCamera
local mouse  = Player:GetMouse()
----
local Target;
local Enabled = false
local aimAt;

local RayOriginOffset = CFrame.new(0,-0.75,0)
----
local Line = nil
local FOV;
----
local function raytoTarget(target)
    if not target.Character then return end 
    local os,s  = target.Character:GetBoundingBox()

    local Origin = (Player.Character.Head.CFrame * RayOriginOffset).p
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {target.Character}--part}
    params.FilterType = Enum.RaycastFilterType.Whitelist
    local Direction = (pos-Origin).unit*(pos-Origin).magnitude
    local Result = workspace:Raycast(Origin, Direction, params)
    if Result then 
        return Result.Position
    end 
end 
local function loadFOV()
    FOV = Drawing.new("Circle")
    FOV.Visible = true
    FOV.Color = Color3.fromRGB(0, 255, 0)
    FOV.Transparency = 1
    FOV.NumSides = 25
    FOV.Radius = 100
    FOV.Filled = false
    FOV.Thickness = 1
end
local function loadLine()
    Line = Drawing.new("Line")
    Line.Visible = true
    Line.From = Vector2.new(0, 0)
    Line.To = Vector2.new(200, 200)
    Line.Color = Color3.fromRGB(0, 255, 0)
    Line.Thickness = 2
    Line.Transparency = 1
    Line.ZIndex = 1
end
local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for i,v in pairs(Players:GetPlayers()) do 
        if v~= Player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health >=0 then 
            local os,s = v.Character:GetBoundingBox()
            if v.Team ~= Player.Team then 
                local pos = Camera.WorldToViewportPoint(Camera, os.p)
                local mag = (Vector2.new(pos.x, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude

                if mag <= FOV.Radius then 
                    if magnitude < shortestDistance then 
                        closestPlayer = v 
                        shortestDistance = magnitude
                    end 
                end 
            end 
        end 
    end 
    return closestPlayer
end  
----
ContextActionService:BindAction("RELLLLD1",function()
    Enabled = not Enabled
end,false,Enum.KeyCode.E)
ContextActionService:BindAction("RELLLLD",function()
    Target = getClosestPlayerToCursor()
end,false,Enum.KeyCode.Q)
ContextActionService:BindAction("RELLLLDzz",function()
    Target = nil
end,false,Enum.KeyCode.Z)
---
local gui_inset = game:GetService("GuiService"):GetGuiInset()
loadLine()
loadFOV()
---
local oldRaynew
oldRaynew = hookfunction(Ray.new, newcclosure(function(...)
    if not checkcaller() then
        local args = {...}
        local p = getcallingscript()
        if not string.find(tostring(p)or p.Name,"ControlModule") then 
            pcall(function()
                if p.Parent and Target and Enabled then 
                    local Origin = (player.Character.Head.CFrame * RayOriginOffset).p
                    local Hit = raytoTarget(Target)
                    return oldRaynew(Origin, Hit)
                end 
            end)
        end
    end
    return oldRaynew(...)
end)
)
---
RunService.RenderStepped:Connect(function()
    if FOV then 
        FOV.Position    = Vector2.new(mouse.X+gui_inset.X,mouse.Y+gui_inset.Y)
    end

    if Target then 
        local hit       = raytoTarget(Target)
        local Origin    = (player.Character.Head.CFrame * RayOriginOffset).p
        local s1        = Camera.WorldToViewportPoint(Camera, Origin)
        local s         = Camera.WorldToViewportPoint(Camera, hit)

        Line.To         = Vector2.new(s.X,s.Y)
        Line.From       = Vector2.new(s1.X,s1.Y)
    else 
        Line.To         = Vector2.new(0,0)
        Line.From       = Vector2.new(0,0)
    end 
end)
