-- 🔥 OTIMIZAÇÃO MOBILE EXTREMA
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

settings().Rendering.QualityLevel = "Level01"

Lighting.GlobalShadows = false
Lighting.FogEnd = 1e10
Lighting.Brightness = 0

for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        v.Enabled = false
    end
end

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.Plastic
        v.Reflectance = 0
        v.CastShadow = false
    end
    
    if v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy()
    end
    
    if v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v:Destroy()
    end
end

workspace.DescendantAdded:Connect(function(v)
    if v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v:Destroy()
    end
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player and plr.Character then
        plr.Character:Destroy()
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        plr.CharacterAdded:Connect(function(char)
            char:Destroy()
        end)
    end
end)

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("Sound") then
        v.Volume = 0
    end
end

-- 🚀 RAYFIELD + KEY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Mecânica BR - MOBILE GOD",
   LoadingTitle = "Carregando...",
   LoadingSubtitle = "Full Script",

   ConfigurationSaving = {Enabled = false},

   KeySystem = true,
   KeySettings = {
      Title = "Sistema de Key",
      Subtitle = "Digite a key",
      Note = "Key necessária",
      FileName = "MecanicaBR_Key",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"usuario.2026"}
   }
})

local MainTab = Window:CreateTab("Caixas", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local TeleportTab = Window:CreateTab("Teleporte", 4483362458)

-- PLAYER
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- VARIÁVEIS
local caixas = {}
local autoFarm = false
local flySpeed = 800
local noclip = false
local flying = false

local pallet = nil
local entrega = nil

-- DETECTAR LOCAIS
for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        local n = v.Name:lower()

        if not pallet and n:find("pallet") then
            pallet = v
        end

        if not entrega and (n:find("delivery") or n:find("entrega") or n:find("sell") or n:find("drop")) then
            entrega = v
        end
    end
end

-- 📦 PEGAR ATÉ 20 CAIXAS
local function pegarTudo()
    caixas = {}
    local count = 0

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local nome = v.Name:lower()

            if nome:find("box") or nome:find("caixa") then
                local dist = (v.Position - root.Position).Magnitude

                if dist <= 20 and v.Size.Magnitude < 15 then
                    v.Anchored = true
                    v.CanCollide = false

                    table.insert(caixas, v)
                    count += 1

                    if count >= 20 then break end
                end
            end
        end
    end
end

-- SEGURAR CAIXAS
game:GetService("RunService").RenderStepped:Connect(function()
    for i, v in ipairs(caixas) do
        local x = (i % 4) * 2 - 3
        local y = math.floor(i / 4) * 2
        v.CFrame = root.CFrame * CFrame.new(x, y, -3)
    end
end)

-- SOLTAR
local function soltar()
    for _, v in ipairs(caixas) do
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
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- 🕊️ FLY MOBILE TOTAL
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

local up = false
local down = false

upBtn.MouseButton1Down:Connect(function() up = true end)
upBtn.MouseButton1Up:Connect(function() up = false end)

downBtn.MouseButton1Down:Connect(function() down = true end)
downBtn.MouseButton1Up:Connect(function() down = false end)

game:GetService("RunService").RenderStepped:Connect(function()
    if flying then
        
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(9e9,9e9,9e9)
            bv.Parent = root
        end

        local moveDir = humanoid.MoveDirection
        local y = 0

        if up then y = flySpeed end
        if down then y = -flySpeed end

        bv.Velocity = Vector3.new(
            moveDir.X * flySpeed,
            y,
            moveDir.Z * flySpeed
        )

    else
        if bv then
            bv:Destroy()
            bv = nil
        end
    end
end)

-- 🚀 TELEPORT
TeleportTab:CreateButton({
   Name = "📍 Ir para ponto secreto",
   Callback = function()
       root.CFrame = CFrame.new(-25678.73, 32.98, -5880.50)
   end
})

-- UI

MainTab:CreateButton({
   Name = "📦 Pegar até 20 Caixas",
   Callback = pegarTudo
})

MainTab:CreateButton({
   Name = "🗑️ Soltar Caixas",
   Callback = soltar
})

MainTab:CreateToggle({
   Name = "🤖 Auto Farm",
   CurrentValue = false,
   Callback = function(v)
       autoFarm = v
   end
})

PlayerTab:CreateToggle({
   Name = "🕊️ Fly Mobile TOTAL",
   CurrentValue = false,
   Callback = function(v)
       flying = v
   end
})

PlayerTab:CreateSlider({
   Name = "🚀 Speed",
   Range = {50, 1000},
   Increment = 50,
   CurrentValue = 800,
   Callback = function(v)
       flySpeed = v
   end
})
