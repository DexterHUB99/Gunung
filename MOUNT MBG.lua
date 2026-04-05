
local targetPlaceId = 78514493666322

if game.PlaceId ~= targetPlaceId then
    -- Jika ID tidak cocok, keluarkan pemain dengan pesan error
    game.Players.LocalPlayer:Kick("\n[Error 273]\nScript ini hanya diizinkan untuk game: Mount Koda.\nSilakan gunakan di map yang benar.")
    return -- Berhenti mengeksekusi sisa script di bawahnya
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MOUNT MBG by DexterHUB",
   LoadingTitle = "DexterHUB",
   LoadingSubtitle = "Auto CP",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GeminiTeleport",
      FileName = "Config"
   }
})

-- Variabel Kontrol
local teleporting = false
local waitTime = 0.5
local antiAdminEnabled = false
local adminKeywords = {"admin", "owner", "staff", "mod", "developer", "dev"}

-- Fungsi Rejoin Server
local function rejoinServer()
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    if #Players:GetPlayers() <= 1 then
        Players.LocalPlayer:Kick("Mencoba Rejoin... (Hanya kamu sendiri di server)")
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end
end

-- Fungsi Cek Admin
local function checkAdmin(player)
    if not antiAdminEnabled then return end
    
    local name = player.Name:lower()
    local displayName = player.DisplayName:lower()
    
    for _, keyword in ipairs(adminKeywords) do
        if name:find(keyword) or displayName:find(keyword) then
            Rayfield:Notify({Title = "Bahaya!", Content = "Admin terdeteksi: " .. player.Name .. ". Rejoining...", Duration = 5})
            task.wait(1)
            rejoinServer()
            break
        end
    end
end

-- Daftar Koordinat (1 - 106)
local locations = {
    Vector3.new(-2183.84, 19.79, 27.03),
    Vector3.new(-2216.15, 19.91, 44.98),
    Vector3.new(-2974.75, 15.80, 57.88),
    Vector3.new(-4008.74, 12.79, 69.47),
    Vector3.new(-5055.75, 27.95, 88.68),
    Vector3.new(-5804.94, -51.80, 92.84),
    Vector3.new(-6133.05, 89.49, 175.51),
    Vector3.new(-6469.24, -98.36, 487.79),
    Vector3.new(-6691.01, -101.46, 1283.34),
    Vector3.new(-6479.05, -107.44, 2213.66),
    Vector3.new(-6523.71, 55.64, 2576.69),
    Vector3.new(-6913.59, 56.11, 3451.31),
    Vector3.new(-6736.61, 144.51, 3974.14),
    Vector3.new(-7267.17, 198.96, 3696.04),
    Vector3.new(-6881.69, 319.57, 3717.38),
    Vector3.new(-6916.73, 377.00, 4398.90),
    Vector3.new(-6489.78, 380.85, 5105.33),
    Vector3.new(-6972.61, 442.08, 5214.65),
    Vector3.new(-6944.18, 431.97, 6223.84),
    Vector3.new(-6875.83, 441.42, 6966.68),
    Vector3.new(-6959.25, 460.34, 8145.08),
    Vector3.new(-6868.78, 120.34, 8624.27),
    Vector3.new(-6820.75, 142.80, 9365.44),
    Vector3.new(-6305.36, 197.00, 9508.32),
    Vector3.new(-6639.56, 246.55, 10173.81),
    Vector3.new(-7373.58, 250.01, 10292.09),
    Vector3.new(-6865.67, 144.14, 11288.84),
    Vector3.new(-6883.12, 139.43, 12264.03),
    Vector3.new(-6752.57, 405.48, 12502.79),
    Vector3.new(-5926.40, 441.00, 12723.83),
    Vector3.new(-5655.11, 477.97, 13506.35),
    Vector3.new(-5686.04, 255.31, 13989.50),
    Vector3.new(-5823.26, 211.50, 15454.00),
    Vector3.new(-6643.15, 283.85, 15846.45),
    Vector3.new(-7725.14, 281.70, 15815.16),
    Vector3.new(-8587.53, 448.56, 15783.61),
    Vector3.new(-9872.65, 479.10, 15728.08),
    Vector3.new(-10342.31, 821.70, 15730.72),
}
-- Tab Main (Teleport)
local TabMain = Window:CreateTab("Teleport", 4483362458)

TabMain:CreateSlider({
   Name = "Delay Teleport (ms)",
   Range = {100, 5000},
   Increment = 50,
   Suffix = "ms",
   CurrentValue = 500,
   Callback = function(Value) waitTime = Value / 1000 end,
})

TabMain:CreateToggle({
   Name = "Mulai Auto Teleport",
   CurrentValue = false,
   Callback = function(Value)
      teleporting = Value
      if teleporting then
          task.spawn(function()
              for i, pos in ipairs(locations) do
                  if not teleporting then break end
                  local char = game.Players.LocalPlayer.Character
                  if char and char:FindFirstChild("HumanoidRootPart") then
                      char.HumanoidRootPart.CFrame = CFrame.new(pos)
                  end
                  task.wait(waitTime)
              end
          end)
      end
   end,
})

-- Auto-generate label dari jumlah locations
local locationLabels = {}
for i = 1, #locations do
    table.insert(locationLabels, "TP ke " .. i)
end

local selectedLocation = 1

TabMain:CreateDropdown({
   Name = "Pilih Teleport ke...",
   Options = locationLabels,
   CurrentOption = {"TP ke 1"},
   MultipleOptions = false,
   Callback = function(Value)
       -- Ambil angka dari string "CP X"
       selectedLocation = tonumber(Value[1]:match("%d+"))
   end,
})

TabMain:CreateButton({
   Name = "Teleport Sekarang",
   Callback = function()
       local pos = locations[selectedLocation]
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChild("HumanoidRootPart") then
           char.HumanoidRootPart.CFrame = CFrame.new(pos)
           Rayfield:Notify({
               Title = "Teleport",
               Content = "Berhasil teleport ke  " .. selectedLocation,
               Duration = 2
           })
       end
   end,
})

-- Tab Security (Anti-Admin)
local TabSec = Window:CreateTab("Security", 4483362458)

TabSec:CreateToggle({
   Name = "Anti-Admin (Auto Rejoin)",
   CurrentValue = false,
   Callback = function(Value)
      antiAdminEnabled = Value
      if antiAdminEnabled then
          -- Cek pemain yang sudah ada
          for _, p in ipairs(game.Players:GetPlayers()) do
              if p ~= game.Players.LocalPlayer then checkAdmin(p) end
          end
      end
   end,
})

-- Event saat pemain baru masuk
game.Players.PlayerAdded:Connect(checkAdmin)

Rayfield:Notify({Title = "Script Aktif", Content = "Siap digunakan!", Duration = 3})