-- ═══════════════════════════════════════════════════════
--  CELZZ | Auto Steal + Anti-Detect
--  Powered by EGX AI | ENDXZ
--  Dedicated to ENDXZ | JAILBREAK HAS DONE
--  Monochrome Minimalist Edition
-- ═══════════════════════════════════════════════════════

local CONFIG = {
    AutoSteal = false,
    AntiDetect = true,

    -- Speed
    MinDelay = 1.5,
    MaxDelay = 4.0,
    EggCooldown = 3.5,

    -- Anti-Detect
    RandomBreak = true,
    BreakInterval = 480,
    BreakDuration = 45,
    SessionLimit = 5400,
    SessionRest = 600,
    AntiReportRange = 60,
    RandomMovement = true,

    -- Scan
    ScanRange = 3000,
    MaxDistance = 500,
}

local RUNNING = true

-- Rarity prioritas (index kecil = prioritas tinggi)
local RARITY_ORDER = {
    "divine", "secret", "eternal", "lunar",
    "mythic", "legendary", "epic", "rare", "uncommon", "common", "normal"
}

local HIGH_PRIORITY_EGGS = {
    ["unicorn"]="divine", ["kitsune"]="divine",
    ["eternal lunar dragon"]="eternal", ["gorilla king"]="eternal",
    ["oni tiger"]="eternal", ["mosasaurus"]="eternal",
    ["el maja"]="eternal", ["ice dragon"]="eternal", ["lava dragon"]="eternal",
    ["mutant shark"]="secret", ["stag"]="secret", ["t-rex"]="secret",
    ["tralaledon"]="secret", ["cosmic skeleton boss"]="secret",
    ["cosmic dragon"]="secret", ["king snake"]="secret",
    ["cerberus"]="secret", ["kraken"]="secret", ["phoenix"]="secret",
}

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local VirtualUser       = game:GetService("VirtualUser")
local LocalPlayer       = Players.LocalPlayer
local PlayerGui         = LocalPlayer:WaitForChild("PlayerGui")

-- ═══ THEME MONOCHROME ═══
local THEME = {
    Bg        = Color3.fromRGB(0, 0, 0),
    Panel     = Color3.fromRGB(12, 12, 12),
    Card      = Color3.fromRGB(22, 22, 22),
    Border    = Color3.fromRGB(50, 50, 50),
    Text      = Color3.fromRGB(255, 255, 255),
    TextDim   = Color3.fromRGB(150, 150, 150),
    TextMuted = Color3.fromRGB(90, 90, 90),
    Accent    = Color3.fromRGB(255, 255, 255),
}

local old = PlayerGui:FindFirstChild("CELZZ_UI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "CELZZ_UI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = PlayerGui

-- CIRCLE
local circle = Instance.new("TextButton")
circle.Size = UDim2.new(0, 58, 0, 58)
circle.Position = UDim2.new(0.5, -29, 0.5, -29)
circle.BackgroundColor3 = THEME.Bg
circle.BorderSizePixel = 0
circle.Text = "CELZZ"
circle.TextColor3 = THEME.Text
circle.TextSize = 10
circle.Font = Enum.Font.GothamBlack
circle.AutoButtonColor = false
circle.Active = true
circle.Parent = gui
Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

local cStroke = Instance.new("UIStroke")
cStroke.Color = THEME.Border
cStroke.Thickness = 1.5
cStroke.Parent = circle

-- PANEL
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 250, 0, 260)
panel.Position = UDim2.new(0.5, -125, 0.5, -130)
panel.BackgroundColor3 = THEME.Panel
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 1000
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

local pStroke = Instance.new("UIStroke")
pStroke.Color = THEME.Border
pStroke.Thickness = 1
pStroke.Parent = panel

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
header.BorderSizePixel = 0
header.Parent = panel
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local hFix = Instance.new("Frame")
hFix.Size = UDim2.new(1, 0, 0, 12)
hFix.Position = UDim2.new(0, 0, 1, -12)
hFix.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
hFix.BorderSizePixel = 0
hFix.Parent = header

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, -40, 1, 0)
logo.Position = UDim2.new(0, 14, 0, 0)
logo.BackgroundTransparency = 1
logo.Text = "CELZZ"
logo.TextColor3 = THEME.Text
logo.TextSize = 14
logo.Font = Enum.Font.GothamBlack
logo.TextXAlignment = Enum.TextXAlignment.Left
logo.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -32, 0.5, -12)
minBtn.BackgroundColor3 = THEME.Card
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = THEME.Text
minBtn.TextSize = 16
minBtn.Font = Enum.Font.GothamBold
minBtn.AutoButtonColor = false
minBtn.Parent = header
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

-- CONTENT
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -16, 1, -48)
content.Position = UDim2.new(0, 8, 0, 42)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 0
content.CanvasSize = UDim2.new(0, 0, 0, 400)
content.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

-- STATUS
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, -4, 0, 36)
statusFrame.BackgroundColor3 = THEME.Card
statusFrame.BorderSizePixel = 0
statusFrame.Parent = content
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 6)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -12, 1, 0)
statusLbl.Position = UDim2.new(0, 8, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "● Idle"
statusLbl.TextColor3 = THEME.TextDim
statusLbl.TextSize = 10
statusLbl.Font = Enum.Font.GothamMedium
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.TextWrapped = true
statusLbl.Parent = statusFrame

local function updateStatus(txt, color)
    statusLbl.Text = "● " .. txt
    statusLbl.TextColor3 = color or THEME.TextDim
end

-- TOGGLE BUILDER
local function makeToggle(name, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 40)
    row.BackgroundColor3 = THEME.Card
    row.BorderSizePixel = 0
    row.Parent = content
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local rStroke = Instance.new("UIStroke")
    rStroke.Color = THEME.Border
    rStroke.Thickness = 1
    rStroke.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -90, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = THEME.Text
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local stateLbl = Instance.new("TextLabel")
    stateLbl.Size = UDim2.new(0, 26, 1, 0)
    stateLbl.Position = UDim2.new(1, -78, 0, 0)
    stateLbl.BackgroundTransparency = 1
    stateLbl.Text = default and "ON" or "OFF"
    stateLbl.TextColor3 = default and THEME.Accent or THEME.TextMuted
    stateLbl.TextSize = 9
    stateLbl.Font = Enum.Font.GothamBold
    stateLbl.Parent = row

    local tgBg = Instance.new("Frame")
    tgBg.Size = UDim2.new(0, 34, 0, 18)
    tgBg.Position = UDim2.new(1, -46, 0.5, -9)
    tgBg.BackgroundColor3 = default and THEME.Accent or Color3.fromRGB(40, 40, 40)
    tgBg.BorderSizePixel = 0
    tgBg.Parent = row
    Instance.new("UICorner", tgBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    knob.BackgroundColor3 = default and THEME.Bg or THEME.TextDim
    knob.BorderSizePixel = 0
    knob.Parent = tgBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local click = Instance.new("TextButton")
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.Parent = row

    local state = default
    click.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(tgBg, TweenInfo.new(0.2), {
            BackgroundColor3 = state and THEME.Accent or Color3.fromRGB(40, 40, 40)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
            BackgroundColor3 = state and THEME.Bg or THEME.TextDim
        }):Play()
        stateLbl.Text = state and "ON" or "OFF"
        stateLbl.TextColor3 = state and THEME.Accent or THEME.TextMuted
        if callback then callback(state) end
    end)
end

makeToggle("Auto Steal", CONFIG.AutoSteal, function(v)
    CONFIG.AutoSteal = v
    updateStatus(v and "Auto Steal ON" or "Auto Steal OFF", v and THEME.Text or THEME.TextDim)
end)

makeToggle("Anti Detect", CONFIG.AntiDetect, function(v)
    CONFIG.AntiDetect = v
end)

-- INFO
local infoLbl = Instance.new("TextLabel")
infoLbl.Size = UDim2.new(1, -4, 0, 36)
infoLbl.BackgroundColor3 = THEME.Card
infoLbl.BackgroundTransparency = 0.5
infoLbl.BorderSizePixel = 0
infoLbl.Text = "  Priority: Divine → Secret → Eternal\n  → Lunar → Harga Tertinggi"
infoLbl.TextColor3 = THEME.TextMuted
infoLbl.TextSize = 9
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextXAlignment = Enum.TextXAlignment.Left
infoLbl.TextYAlignment = Enum.TextYAlignment.Center
infoLbl.Parent = content
Instance.new("UICorner", infoLbl).CornerRadius = UDim.new(0, 6)

-- ═══════════════════════════════════════════════════════
--  CORE LOGIC
-- ═══════════════════════════════════════════════════════

-- Get rarity dari egg
local function getEggRarity(egg)
    local name = egg.Name:lower()
    local attr = ""
    pcall(function()
        attr = (egg:GetAttribute("Rarity") or egg:GetAttribute("Type") or egg:GetAttribute("Tier") or ""):lower()
    end)

    -- Cek dari daftar nama egg prioritas
    for key, rarity in pairs(HIGH_PRIORITY_EGGS) do
        if name:find(key, 1, true) then return rarity end
    end

    -- Cek dari attribute
    for _, rarity in ipairs(RARITY_ORDER) do
        if attr:find(rarity) then return rarity end
    end

    -- Cek dari nama
    for _, rarity in ipairs(RARITY_ORDER) do
        if name:find(rarity) then return rarity end
    end

    return "normal"
end

-- Get harga egg
local function getEggPrice(egg)
    local price = 0
    pcall(function()
        price = tonumber(egg:GetAttribute("Price"))
            or tonumber(egg:GetAttribute("Value"))
            or tonumber(egg:GetAttribute("Worth"))
            or tonumber(egg:GetAttribute("Cost"))
            or 0
    end)
    return price
end

-- Get prioritas angka dari rarity
local function getRarityPriority(rarity)
    for i, r in ipairs(RARITY_ORDER) do
        if r == rarity then return i end
    end
    return 99
end

-- Scan semua egg di workspace
local function scanAllEggs()
    local eggs = {}
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local myPos = hrp and hrp.Position or Vector3.new(0,0,0)

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("egg") then
                local ok, pos = pcall(function()
                    return obj.Position or obj:GetPivot().Position
                end)
                if ok and pos then
                    local dist = (pos - myPos).Magnitude
                    if dist <= CONFIG.MaxDistance then
                        table.insert(eggs, {
                            obj = obj,
                            name = obj.Name,
                            rarity = getEggRarity(obj),
                            price = getEggPrice(obj),
                            dist = dist,
                            pos = pos,
                        })
                    end
                end
            end
        end
    end

    -- Sort: rarity prioritas dulu, baru harga, baru jarak
    table.sort(eggs, function(a, b)
        local pa = getRarityPriority(a.rarity)
        local pb = getRarityPriority(b.rarity)
        if pa ~= pb then return pa < pb end
        if a.price ~= b.price then return a.price > b.price end
        return a.dist < b.dist
    end)

    return eggs
end

-- Walk ke posisi natural
local function walkTo(targetPos, timeout)
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end

    timeout = timeout or 15
    local startTime = tick()
    hum:MoveTo(targetPos)

    while tick() - startTime < timeout do
        if not RUNNING or not CONFIG.AutoSteal then return false end
        local dist = (hrp.Position - targetPos).Magnitude
        if dist < 6 then
            hum:MoveTo(hrp.Position)
            return true
        end
        hum:MoveTo(targetPos)
        task.wait(0.1)
    end
    return false
end

-- Cari remote steal
local function findRemotes()
    local remotes = {}
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n = obj.Name:lower()
            if n:find("steal") or n:find("egg") or n:find("collect")
            or n:find("grab") or n:find("pick") then
                table.insert(remotes, obj)
            end
        end
    end
    return remotes
end

-- Steal 1 egg
local function stealEgg(eggData)
    if not eggData or not eggData.obj then return end
    local egg = eggData.obj
    local remotes = findRemotes()

    -- Walk dulu (natural)
    local pos
    pcall(function() pos = egg.Position or egg:GetPivot().Position end)
    if pos then
        local arrived = walkTo(pos, 15)
        if not arrived then
            return
        end
    end

    -- Fire remote 1x aja (bukan spam)
    for _, r in ipairs(remotes) do
        pcall(function()
            if r:IsA("RemoteEvent") then
                r:FireServer(egg)
            elseif r:IsA("RemoteFunction") then
                r:InvokeServer(egg)
            end
        end)
        -- Random delay antar remote
        local delay = CONFIG.MinDelay + math.random() * (CONFIG.MaxDelay - CONFIG.MinDelay)
        task.wait(delay)
    end
end

-- Player nearby
local function playerNearby(range)
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local phrp = p.Character:FindFirstChild("HumanoidRootPart")
            if phrp and (phrp.Position - hrp.Position).Magnitude < range then
                return true
            end
        end
    end
    return false
end

-- ═══ LOOP UTAMA ═══
task.spawn(function()
    while RUNNING and gui.Parent do
        task.wait(0.5)
        if not CONFIG.AutoSteal then continue end

        pcall(function()
            -- Anti-report: pause kalau ada player dekat
            if CONFIG.AntiDetect and playerNearby(CONFIG.AntiReportRange) then
                updateStatus("Player nearby - PAUSED", THEME.TextDim)
                task.wait(3)
                return
            end

            -- Scan egg
            updateStatus("Scanning eggs...", THEME.Text)
            local eggs = scanAllEggs()

            if #eggs == 0 then
                updateStatus("No egg found, waiting...", THEME.TextMuted)
                task.wait(3)
                return
            end

            -- Ambil egg terbaik (prioritas rarity + harga)
            local best = eggs[1]
            updateStatus("Target: " .. best.rarity:upper() .. " ($" .. best.price .. ")", THEME.Text)

            -- Steal egg
            stealEgg(best)

            -- Cooldown random antar egg
            local cd = CONFIG.EggCooldown + math.random() * 1.0
            task.wait(cd)
        end)
    end
end)

-- ═══ ANTI-DETECT LAYER ═══

-- Random break
task.spawn(function()
    local lastBreak = tick()
    while RUNNING and gui.Parent do
        task.wait(1)
        if not CONFIG.AntiDetect or not CONFIG.RandomBreak then continue end
        if (tick() - lastBreak) > CONFIG.BreakInterval then
            updateStatus("Break " .. CONFIG.BreakDuration .. "s...", THEME.TextMuted)
            task.wait(CONFIG.BreakDuration)
            lastBreak = tick()
        end
    end
end)

-- Session limit
task.spawn(function()
    local sessionStart = tick()
    while RUNNING and gui.Parent do
        task.wait(5)
        if not CONFIG.AntiDetect then continue end
        if (tick() - sessionStart) > CONFIG.SessionLimit then
            updateStatus("Session rest " .. CONFIG.SessionRest .. "s...", THEME.TextMuted)
            task.wait(CONFIG.SessionRest)
            sessionStart = tick()
        end
    end
end)

-- Random movement (biar natural)
task.spawn(function()
    while RUNNING and gui.Parent do
        task.wait(15 + math.random() * 15)
        if not CONFIG.AntiDetect or not CONFIG.RandomMovement then continue end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                local offset = Vector3.new(math.random(-3,3), 0, math.random(-3,3))
                hum:MoveTo(hrp.Position + offset)
            end
        end
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ═══════════════════════════════════════════════════════
--  UI LOGIC
-- ═══════════════════════════════════════════════════════

local dragging, dragStart, startPos, hasDragged = false, nil, nil, false

circle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        hasDragged = false
        dragStart = input.Position
        startPos = circle.Position
    end
end)

circle.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            hasDragged = true
        end
        circle.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

circle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

circle.MouseButton1Click:Connect(function()
    if not hasDragged then
        panel.Visible = not panel.Visible
        if panel.Visible then
            panel.Position = UDim2.new(0.5, -125, 0.5, -130)
        end
    end
end)

minBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

circle.MouseEnter:Connect(function()
    TweenService:Create(circle, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }):Play()
    TweenService:Create(cStroke, TweenInfo.new(0.2), { Color = THEME.Text }):Play()
end)
circle.MouseLeave:Connect(function()
    TweenService:Create(circle, TweenInfo.new(0.2), { BackgroundColor3 = THEME.Bg }):Play()
    TweenService:Create(cStroke, TweenInfo.new(0.2), { Color = THEME.Border }):Play()
end)

minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(40, 40, 40) }):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.15), { BackgroundColor3 = THEME.Card }):Play()
end)

print("[CELZZ] Auto Steal Lo