-- 🔥 OTIMIZAÇÃO MOBILE
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

settings().Rendering.QualityLevel = "Level01"

Lighting.GlobalShadows = false
Lighting.FogEnd = 1e10
Lighting.Brightness = 0

for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then v.Enabled = false end
end

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.Plastic
        v.CastShadow = false
    end
    if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
end

-- 🚀 RAYFIELD
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Mecânica BR - MOBILE MONEY",
   LoadingTitle = "Carregando...",
   LoadingSubtitle = "Full Mobile",

   KeySystem = true,
   KeySettings = {
      Title = "Key",
      Subtitle = "Digite",
      Key = {"deathpro.1"}
   }
})

local MainTab = Window:CreateTab("Caixas", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local TeleportTab = Window:CreateTab("Teleporte", 4483362458)

-- PLAYER
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- VAR
local caixas = {}
local autoFarm = false
local flySpeed = 800
local flying = false
local noclip = false

local pallet, entrega

-- DETECTAR
for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        local n = v.Name:lower()
        if not pallet and n:find("pallet") then pallet = v end
        if not entrega and (n:find("entrega") or n:find("delivery")) then entrega = v end
    end
end

-- PEGAR CAIXAS
local function pegarTudo()
    caixas = {}
    local count = 0

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("box") or v.Name:lower():find("caixa")) then
            if (v.Position - root.Position).Magnitude <= 20 then
                v.Anchored = true
                v.CanCollide = false
                table.insert(caixas, v)
                count += 1
                if count >= 20 then break end
            end
        end
    end
end

-- SEGURAR
game:GetService("RunService").RenderStepped:Connect(function()
    for i,v in ipairs(caixas) do
        v.CFrame = root.CFrame * CFrame.new((i%4)*2-3, math.floor(i/4)*2, -3)
    end
end)

-- SOLTAR
local function soltar()
    for _,v in ipairs(caixas) do
        v.Anchored = false
        v.CanCollide = true
    end
    caixas = {}
end

-- AUTO SOLTAR
game:GetService("RunService").Heartbeat:Connect(function()
    if entrega and #caixas > 0 then
        if (root.Position - entrega.Position).Magnitude <= 10 then
            soltar()
        end
    end
end)

-- NOCLIP
game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 🕊️ FLY MOBILE
local bv
local gui = Instance.new("ScreenGui", player.PlayerGui)

local upBtn = Instance.new("TextButton", gui)
upBtn.Size = UDim2.new(0,80,0,80)
upBtn.Position = UDim2.new(0.85,0,0.6,0)
upBtn.Text = "⬆️"

local downBtn = Instance.new("TextButton", gui)
downBtn.Size = UDim2.new(0,80,0,80)
downBtn.Position = UDim2.new(0.85,0,0.75,0)
downBtn.Text = "⬇️"

local up,down=false,false

upBtn.MouseButton1Down:Connect(function() up=true end)
upBtn.MouseButton1Up:Connect(function() up=false end)
downBtn.MouseButton1Down:Connect(function() down=true end)
downBtn.MouseButton1Up:Connect(function() down=false end)

game:GetService("RunService").RenderStepped:Connect(function()
    if flying then
        if not bv then
            bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        end

        local dir = humanoid.MoveDirection
        local y = 0
        if up then y = flySpeed end
        if down then y = -flySpeed end

        bv.Velocity = Vector3.new(dir.X*flySpeed, y, dir.Z*flySpeed)
    else
        if bv then bv:Destroy() bv=nil end
    end
end)

-- AUTO FARM
task.spawn(function()
    while true do
        if autoFarm and pallet and entrega then
            noclip = true

            root.CFrame = pallet.CFrame
            task.wait(0.5)
            pegarTudo()

            root.CFrame = entrega.CFrame
            task.wait(1)
            soltar()
        end
        task.wait(0.3)
    end
end)

-- 🚀 TELEPORTES
local function tp(cf) root.CFrame = cf end

TeleportTab:CreateButton({Name="Ferro Velho",Callback=function()tp(CFrame.new(-3126,65,-4255))end})
TeleportTab:CreateButton({Name="Auto Peças",Callback=function()tp(CFrame.new(-3330,65,-3409))end})
TeleportTab:CreateButton({Name="Drag Race",Callback=function()tp(CFrame.new(-3859,64,-4896))end})
TeleportTab:CreateButton({Name="Construção Metrópole",Callback=function()tp(CFrame.new(-3645,65,-2509))end})
TeleportTab:CreateButton({Name="Construção Cidade 2",Callback=function()tp(CFrame.new(-25216,65,-5291))end})
TeleportTab:CreateButton({Name="Posto",Callback=function()tp(CFrame.new(-3222,66,-3708))end})
TeleportTab:CreateButton({Name="Concessionária",Callback=function()tp(CFrame.new(-3040,65,-3697))end})
TeleportTab:CreateButton({Name="Secreto",Callback=function()tp(CFrame.new(-25678,32,-5880))end})

-- UI
MainTab:CreateButton({Name="Pegar Caixas",Callback=pegarTudo})
MainTab:CreateButton({Name="Soltar",Callback=soltar})

MainTab:CreateToggle({
   Name="Auto Farm",
   CurrentValue=false,
   Callback=function(v) autoFarm=v end
})

PlayerTab:CreateToggle({
   Name="Fly Mobile",
   CurrentValue=false,
   Callback=function(v) flying=v end
})

PlayerTab:CreateSlider({
   Name="Speed",
   Range={50,1000},
   Increment=50,
   CurrentValue=800,
   Callback=function(v) flySpeed=v end
})
