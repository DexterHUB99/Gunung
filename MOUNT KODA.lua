-- ID Game Mount Koda: 92344507151834
local targetPlaceId = 92344507151834

if game.PlaceId ~= targetPlaceId then
    -- Jika ID tidak cocok, keluarkan pemain dengan pesan error
    game.Players.LocalPlayer:Kick("\n[Error 273]\nScript ini hanya diizinkan untuk game: Mount Koda.\nSilakan gunakan di map yang benar.")
    return -- Berhenti mengeksekusi sisa script di bawahnya
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MOUNT KODA by DexterHUB",
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
    Vector3.new(-463.55, 60.01, 19.65), Vector3.new(-493.18, 56.03, 11.47), Vector3.new(-1155.01, 42.60, -142.87), Vector3.new(-1918.96, 34.17, -161.20),
    Vector3.new(-2143.78, 193.04, -366.41), Vector3.new(-2192.70, 245.55, -732.45), Vector3.new(-2683.48, 248.33, -1151.61),
    Vector3.new(-3288.59, 297.57, -1374.67), Vector3.new(-3589.85, 454.61, -1804.41), Vector3.new(-3812.26, 461.00, -1838.68),
    Vector3.new(-4767.18, 665.31, -1794.46), Vector3.new(-5006.94, 683.72, -1796.89), Vector3.new(-5156.60, 686.92, -2475.07),
    Vector3.new(-5090.35, 812.74, -2844.36), Vector3.new(-5083.18, 879.91, -3706.46), Vector3.new(-5000.04, 910.51, -4431.26),
    Vector3.new(-4208.36, 1026.37, -4328.33), Vector3.new(-3115.39, 1027.39, -4365.67), Vector3.new(-3109.73, 1022.65, -3168.54),
    Vector3.new(-2318.61, 1165.58, -3279.66), Vector3.new(-2368.02, 1472.29, -4262.43), Vector3.new(-2328.94, 1582.55, -5103.90),
    Vector3.new(-2311.56, 1582.46, -6200.94), Vector3.new(-2274.73, 1910.17, -7229.98), Vector3.new(-845.24, 2137.64, -7470.83),
    Vector3.new(-870.75, 2138.04, -8567.81), Vector3.new(-854.85, 2170.36, -9890.96), Vector3.new(-1029.88, 2170.70, -11474.97),
    Vector3.new(-2160.57, 2461.71, -11480.30), Vector3.new(-4545.26, 2456.79, -11538.50), Vector3.new(-5918.95, 2458.20, -11479.23),
    Vector3.new(-6797.43, 2497.59, -11484.47), Vector3.new(-8410.03, 2495.17, -11462.05), Vector3.new(-10763.06, 2495.40, -11470.59),
    Vector3.new(-12135.77, 2493.20, -11570.41), Vector3.new(-12107.68, 2840.80, -12557.27), Vector3.new(-12091.14, 2840.88, -13708.17),
    Vector3.new(-12240.15, 2836.77, -15030.60), Vector3.new(-13619.46, 2839.26, -15037.02), Vector3.new(-14878.56, 2836.55, -15160.49),
    Vector3.new(-14745.22, 3128.61, -16248.99), Vector3.new(-14754.77, 3150.99, -16922.96), Vector3.new(-14620.84, 3149.42, -17438.66),
    Vector3.new(-13868.09, 3151.22, -17391.80), Vector3.new(-13202.08, 3147.15, -17577.28), Vector3.new(-13164.94, 3147.64, -18556.71),
    Vector3.new(-13190.35, 3150.38, -19695.40), Vector3.new(-13317.59, 3150.31, -21022.69), Vector3.new(-14862.55, 3153.75, -20963.25),
    Vector3.new(-16207.38, 3175.02, -20992.32), Vector3.new(-16689.62, 3288.69, -21187.31), Vector3.new(-17414.78, 3288.32, -21221.48),
    Vector3.new(-18694.15, 3308.26, -21129.66), Vector3.new(-19566.90, 3309.75, -21105.49), Vector3.new(-20549.48, 3307.46, -21088.46),
    Vector3.new(-21754.00, 3307.24, -21070.87), Vector3.new(-22652.97, 3307.81, -21092.31), Vector3.new(-23571.69, 3304.68, -21150.29),
    Vector3.new(-23550.86, 3300.19, -22178.58), Vector3.new(-23526.73, 3306.36, -23383.84), Vector3.new(-23530.94, 3303.37, -24527.55),
    Vector3.new(-23542.81, 3307.29, -25749.90), Vector3.new(-23565.40, 3350.41, -26625.71), Vector3.new(-23636.92, 3348.68, -28168.29),
    Vector3.new(-23541.89, 3347.96, -29331.72), Vector3.new(-23563.57, 3349.82, -30737.82), Vector3.new(-23449.42, 3344.38, -32162.97),
    Vector3.new(-21102.03, 3346.93, -32132.85), Vector3.new(-19228.99, 3349.78, -32155.88), Vector3.new(-18287.61, 3348.33, -32145.62),
    Vector3.new(-16918.51, 3347.89, -32143.56), Vector3.new(-15887.41, 3345.10, -32180.84), Vector3.new(-14882.14, 3344.97, -32145.28),
    Vector3.new(-13976.00, 3347.50, -32165.12), Vector3.new(-13013.63, 3346.29, -32145.62), Vector3.new(-11962.76, 3346.32, -32162.14),
    Vector3.new(-9725.80, 4345.84, -32109.54), Vector3.new(-8334.09, 4346.33, -32139.53), Vector3.new(-7048.10, 4346.88, -32141.90),
    Vector3.new(-5726.88, 4346.31, -32171.63), Vector3.new(-3352.05, 4347.85, -32151.19), Vector3.new(-2743.91, 4526.97, -32171.70),
    Vector3.new(-2255.24, 4528.93, -32161.71), Vector3.new(-1631.95, 4529.20, -32168.80), Vector3.new(-1004.92, 4527.23, -32164.62),
    Vector3.new(-459.04, 4528.14, -32172.38), Vector3.new(70.44, 4547.61, -32167.65), Vector3.new(583.09, 4545.47, -32167.04),
    Vector3.new(1148.95, 4546.58, -32174.77), Vector3.new(1747.29, 4547.07, -32177.75), Vector3.new(2492.48, 4545.30, -32169.29),
    Vector3.new(2756.43, 4994.16, -32200.87), Vector3.new(3016.57, 5440.64, -32182.73), Vector3.new(3289.68, 5880.03, -32186.98),
    Vector3.new(3558.62, 6325.59, -32181.01), Vector3.new(3864.76, 6768.28, -32190.47), Vector3.new(4190.80, 6768.08, -32182.49),
    Vector3.new(4586.57, 6765.40, -32182.17), Vector3.new(5040.12, 6767.08, -32189.49), Vector3.new(5524.22, 6770.18, -32185.15),
    Vector3.new(5996.69, 6764.27, -32188.57), Vector3.new(6331.17, 7220.56, -32180.04), Vector3.new(6635.69, 7665.25, -32175.75),
    Vector3.new(6935.22, 8107.01, -32180.95), Vector3.new(7250.60, 8554.80, -32178.64), Vector3.new(7554.54, 8991.00, -32173.34),
    Vector3.new(7876.60, 9880.67, -32185.10)
}
-- Tab Main (Teleport)
local TabMain = Window:CreateTab("Teleport", 4483362458)

TabMain:CreateSlider({
   Name = "Delay Teleport (ms)",
   Range = {100, 2000},
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