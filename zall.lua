if game.PlaceId == 914010731 then
    local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Sirius-Dev/Rayfield/main/source.lua'))()

    local Window = Rayfield:CreateWindow({
        Name = "Blox Fruits Hub",
        LoadingTitle = "Rayfield Interface Suite",
        LoadingSubtitle = "by Sirius",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil,
            FileName = "Big Hub"
        },
        Discord = {
            Enabled = false,
            Invite = "noinvitelink",
            RememberJoins = true
        },
        KeySystem = false,
        KeySettings = {
            Title = "Untitled",
            Subtitle = "Key System",
            Note = "No method of obtaining the key is provided",
            FileName = "Key",
            SaveKey = true,
            GrabKeyFromSite = false,
            Key = {"Hello"}
        }
    })

    -- Variables for features
    local autoFarmEnabled = false
    local godModeEnabled = false
    local selectedItem = "Sword"
    local auraColor = Color3.fromRGB(255, 0, 0)
    local targetKillCount = 0

    local MainTab = Window:CreateTab("Main") -- Tab utama

    -- 1. Button untuk Auto Farm
    MainTab:CreateButton({
        Name = "Auto Farm",
        Callback = function()
            autoFarmEnabled = not autoFarmEnabled
            print("Auto Farming toggled. Status:", autoFarmEnabled and "Enabled" or "Disabled")
            
            while autoFarmEnabled do
                wait(0.1) -- Kecepatan auto farm
                -- Logika dasar untuk mencari musuh dan menyerang
                for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        game.Players.LocalPlayer.Character:MoveTo(enemy.HumanoidRootPart.Position)
                        enemy.Humanoid:TakeDamage(10) -- Mengurangi HP musuh (contoh)
                        wait(1)
                    end
                end
            end
        end,
    })

    -- 2. Button untuk Teleportasi ke Pulau
    MainTab:CreateButton({
        Name = "Teleport to Island",
        Callback = function()
            local islandPosition = Vector3.new(1000, 100, 1000) -- Koordinat tujuan
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(islandPosition)
            print("Teleported to Island at position:", islandPosition)
        end,
    })

    -- 3. Toggle untuk God Mode
    MainTab:CreateToggle({
        Name = "Enable God Mode",
        Default = false,
        Callback = function(value)
            godModeEnabled = value
            print("God Mode", godModeEnabled and "Activated" or "Deactivated")
            
            if godModeEnabled then
                local player = game.Players.LocalPlayer
                player.Character.Humanoid.Health = math.huge -- Set HP to infinite
                player.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if godModeEnabled then
                        player.Character.Humanoid.Health = math.huge
                    end
                end)
            end
        end,
    })

    -- 4. Slider untuk Walk Speed
    MainTab:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 100},
        Increment = 1,
        Suffix = "Speed",
        CurrentValue = 16,
        Callback = function(value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
            print("Walk Speed set to:", value)
        end,
    })

    -- 5. Label dengan nama pembuat
    MainTab:CreateLabel("Made by [YourName]")

    -- 6. Dropdown untuk memilih item
    MainTab:CreateDropdown({
        Name = "Select Item",
        Options = {"Sword", "Gun", "Fruit"},
        CurrentOption = "Sword",
        Callback = function(selected)
            selectedItem = selected
            print("Selected item:", selectedItem)
            -- Logika untuk mengubah senjata aktif pemain bisa ditambahkan di sini
        end,
    })

    -- 7. Color Picker untuk Aura Color
    MainTab:CreateColorPicker({
        Name = "Aura Color",
        DefaultColor = Color3.fromRGB(255, 0, 0),
        Callback = function(color)
            auraColor = color
            print("Selected aura color:", auraColor)
            -- Logika untuk menerapkan warna aura pada karakter pemain
            game.Players.LocalPlayer.Character.HumanoidRootPart.BrickColor = BrickColor.new(auraColor)
        end,
    })

    -- 8. Keybind untuk Toggle Auto Farm
    MainTab:CreateKeybind({
        Name = "Toggle Auto Farm",
        Default = Enum.KeyCode.F,
        Callback = function()
            autoFarmEnabled = not autoFarmEnabled
            print("Auto Farm toggled by keybind. Status:", autoFarmEnabled and "Enabled" or "Disabled")
            -- Logika auto farm mirip seperti di button Auto Farm
        end,
    })

    -- 9. Input Field untuk jumlah kill
    MainTab:CreateInput({
        Name = "Kill Count",
        PlaceholderText = "Enter kill count",
        Callback = function(text)
            targetKillCount = tonumber(text) or 0
            print("Set kill count to:", targetKillCount)
            
            -- Menjalankan Auto Farm hingga target kill tercapai
            local currentKills = 0
            while autoFarmEnabled and currentKills < targetKillCount do
                wait(0.1)
                for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        game.Players.LocalPlayer.Character:MoveTo(enemy.HumanoidRootPart.Position)
                        enemy.Humanoid:TakeDamage(10)
                        currentKills = currentKills + 1
                        print("Current Kills:", currentKills)
                        if currentKills >= targetKillCount then
                            autoFarmEnabled = false
                            break
                        end
                        wait(1)
                    end
                end
            end
            print("Target kill count reached:", targetKillCount)
        end,
    })
else
    print("Script ini hanya dapat dijalankan di Blox Fruits.")
end
