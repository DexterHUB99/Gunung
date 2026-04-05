
local targetPlaceId = 95146909368889

if game.PlaceId ~= targetPlaceId then
    -- Jika ID tidak cocok, keluarkan pemain dengan pesan error
    game.Players.LocalPlayer:Kick("\n[Error 273]\nScript ini hanya diizinkan untuk game: Mount Koda.\nSilakan gunakan di map yang benar.")
    return -- Berhenti mengeksekusi sisa script di bawahnya
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MOUNT CIDRO by DexterHUB",
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
    Vector3.new(-6.99, 157.27, -70.40),
    Vector3.new(-15.84, 157.27, -147.81),
    Vector3.new(-57.92, 271.11, -711.67),
    Vector3.new(-12.38, 275.37, -1453.31),
    Vector3.new(672.19, 278.49, -1443.04),
    Vector3.new(1504.43, 300.72, -1434.11),
    Vector3.new(2675.31, 365.28, -1532.69),
    Vector3.new(2934.44, 586.68, -1494.17),
    Vector3.new(3524.17, 505.50, -1429.98),
    Vector3.new(4137.62, 501.72, -1234.79),
    Vector3.new(5259.46, 497.74, -991.48),
    Vector3.new(6064.69, 610.30, -1486.24),
    Vector3.new(6083.80, 782.92, -2473.42),
    Vector3.new(6085.13, 838.44, -4029.37),
    Vector3.new(6065.14, 836.65, -4678.96),
    Vector3.new(6078.99, 906.89, -5146.05),
    Vector3.new(6158.28, 907.90, -6198.28),
    Vector3.new(6231.19, 770.29, -7024.32),
    Vector3.new(7088.00, 700.36, -7197.69),
    Vector3.new(7083.38, 673.44, -8094.06),
    Vector3.new(8028.99, 675.80, -8066.43),
    Vector3.new(8105.44, 781.19, -7231.55),
    Vector3.new(9084.44, 787.57, -7205.96),
    Vector3.new(9938.30, 784.00, -7159.77),
    Vector3.new(9834.18, 866.25, -6357.36),
    Vector3.new(9940.35, 1033.51, -6235.38),
    Vector3.new(9982.94, 899.64, -5446.82),
    Vector3.new(9985.27, 1204.84, -5267.32),
    Vector3.new(10433.53, 1194.54, -4413.33),
    Vector3.new(10452.10, 1186.39, -3202.97),
    Vector3.new(10504.72, 1162.60, -2583.80),
    Vector3.new(10518.64, 1170.57, -1740.13),
    Vector3.new(10667.44, 1170.45, -1185.01),
    Vector3.new(10716.01, 1178.03, -291.97),
    Vector3.new(10999.18, 1574.90, 785.17),
    Vector3.new(11034.39, 2444.97, 1071.65)
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
                  
                  -- Cek apakah ini lokasi terakhir (Checkpoint terakhir)
                  if i == #locations then
                      Rayfield:Notify({
                          Title = "Checkpoint Selesai!",
                          Content = "Silahkan Maju Kedepan",
                          Duration = 5
                      })
                  end
                  
                  task.wait(waitTime)
              end
          end)
      end
   end,
})

-- Auto-generate label dengan kondisi khusus untuk index pertama
local locationLabels = {}
for i = 1, #locations do
    if i == 1 then
        table.insert(locationLabels, "TP ke Speedrun")
    else
        -- i - 1 supaya index ke-2 jadi tulisan "TP ke 1"
        table.insert(locationLabels, "TP ke " .. (i - 1))
    end
end

local selectedLocation = 1

TabMain:CreateDropdown({
   Name = "Pilih Teleport ke...",
   Options = locationLabels,
   CurrentOption = {"TP ke Speedrun"},
   MultipleOptions = false,
   Callback = function(Value)
       local selectedText = Value[1]
       
       if selectedText == "TP ke Speedrun" then
           selectedLocation = 1
       else
           -- Ambil angka (misal "1") lalu tambah 1 supaya jadi index 2
           local numberPart = tonumber(selectedText:match("%d+"))
           selectedLocation = numberPart + 1
       end
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