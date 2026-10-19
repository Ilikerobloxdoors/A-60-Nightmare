
--// A-60 NIGHTMARE - HARDCORE MODE
--// Entity + GitHub raw model URL + random-face death sequence

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURATION
--==================================================

local MODEL_URL =
    "https://raw.githubusercontent.com/Ilikerobloxdoors/A-60-Nightmare/main/A-60%20NIGHTMARE%20OLDEST.rbxm"

local FACE_IDS = {
    "rbxassetid://11710144220",
    "rbxassetid://11710147805",
    "rbxassetid://12633510500",
    "rbxassetid://17432116100",
}

local AUDIO_URL =
    "https://raw.githubusercontent.com/DripCapybara/Doors-Modes/main/HardcoreMode/A-60jumpscare%20(1).mp3"

--==================================================
-- HARDCORE JUMPSCARE
-- Called by the entity's death callback
--==================================================

local jumpscareRunning = false

local function loadHardcoreAudio(url)
    if not (writefile and getcustomasset and request) then
        warn("A-60: Custom audio APIs unavailable.")
        return nil
    end

    local ok, result = pcall(function()
        local response = request({
            Url = url,
            Method = "GET",
            Headers = {
                Accept = "audio/mpeg, application/octet-stream",
            },
        })

        if response.StatusCode ~= 200 then
            error("Audio download failed: " ..
                tostring(response.StatusCode))
        end

        local filename = "A60Hardcore.mp3"
        writefile(filename, response.Body)

        return getcustomasset(filename)
    end)

    if ok then
        return result
    end

    warn("A-60 audio error:", result)
    return nil
end

local function playHardcoreJumpscare()
    if jumpscareRunning then
        return
    end

    jumpscareRunning = true

    local previous = playerGui:FindFirstChild("A60_Hardcore")
    if previous then
        previous:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "A60_Hardcore"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999
    gui.Parent = playerGui

    local background = Instance.new("Frame")
    background.Size = UDim2.fromScale(1, 1)
    background.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    background.BackgroundTransparency = 0.25
    background.BorderSizePixel = 0
    background.ZIndex = 1
    background.Parent = gui

    local face = Instance.new("ImageLabel")
    face.AnchorPoint = Vector2.new(0.5, 0.5)
    face.Position = UDim2.fromScale(0.5, 0.5)
    face.Size = UDim2.fromScale(0.55, 0.75)
    face.BackgroundTransparency = 1
    face.Image = FACE_IDS[1]
    face.ScaleType = Enum.ScaleType.Fit
    face.ZIndex = 3
    face.Parent = gui

    local ghost = Instance.new("ImageLabel")
    ghost.AnchorPoint = Vector2.new(0.5, 0.5)
    ghost.Position = UDim2.fromScale(0.53, 0.48)
    ghost.Size = UDim2.fromScale(0.7, 0.9)
    ghost.BackgroundTransparency = 1
    ghost.Image = FACE_IDS[2]
    ghost.ImageColor3 = Color3.fromRGB(255, 0, 0)
    ghost.ImageTransparency = 0.55
    ghost.ZIndex = 2
    ghost.Parent = gui

    local text = Instance.new("TextLabel")
    text.Size = UDim2.fromScale(1, 0.13)
    text.Position = UDim2.fromScale(0, 0.83)
    text.BackgroundTransparency = 1
    text.Text = "A - 6 0"
    text.TextColor3 = Color3.new(1, 1, 1)
    text.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
    text.TextStrokeTransparency = 0
    text.TextScaled = true
    text.Font = Enum.Font.Arcade
    text.ZIndex = 4
    text.Parent = gui

    local sound = Instance.new("Sound")
    sound.Name = "A60JumpscareAudio"
    sound.Volume = 3
    sound.Parent = gui

    local audioId = loadHardcoreAudio(AUDIO_URL)
    if audioId then
        sound.SoundId = audioId
        sound:Play()
    end

    local colorEffect = Instance.new("ColorCorrectionEffect")
    colorEffect.Name = "A60HardcoreEffect"
    colorEffect.Contrast = 0.4
    colorEffect.Saturation = 0.8
    colorEffect.TintColor = Color3.fromRGB(255, 90, 90)
    colorEffect.Parent = Lighting

    -- Rapid random-face phase
    local startTime = os.clock()
    local duration = 3.5
    local previousFace = 0

    if sound.IsLoaded and sound.TimeLength > 1 then
        duration = math.max(2, sound.TimeLength - 0.35)
    end

    while os.clock() - startTime < duration do
        local index = math.random(1, #FACE_IDS)

        if #FACE_IDS > 1 then
            while index == previousFace do
                index = math.random(1, #FACE_IDS)
            end
        end

        previousFace = index
        face.Image = FACE_IDS[index]
        ghost.Image = FACE_IDS[math.random(1, #FACE_IDS)]

        face.Position = UDim2.fromScale(
            0.5 + math.random(-70, 70) / 1000,
            0.5 + math.random(-70, 70) / 1000
        )

        face.Rotation = math.random(-15, 15)
        face.Size = UDim2.fromScale(
            math.random(45, 75) / 100,
            math.random(60, 95) / 100
        )

        ghost.Position = UDim2.fromScale(
            0.5 + math.random(-100, 100) / 1000,
            0.5 + math.random(-100, 100) / 1000
        )

        ghost.ImageTransparency = math.random(30, 80) / 100

        if math.random() < 0.8 then
            background.BackgroundColor3 =
                math.random() < 0.15
                and Color3.new(1, 1, 1)
                or Color3.fromRGB(255, 0, 0)

            background.BackgroundTransparency =
                math.random(15, 75) / 100
        else
            background.BackgroundTransparency = 1
        end

        colorEffect.Contrast = math.random(20, 90) / 100

        task.wait(0.035)
    end

    -- Final lunge
    text.Text = "YOU DIED"
    face.Image = FACE_IDS[math.random(1, #FACE_IDS)]
    face.Position = UDim2.fromScale(0.5, 0.5)
    face.Rotation = 0
    face.Size = UDim2.fromScale(0.65, 0.85)
    face.ImageTransparency = 0

    ghost.ImageTransparency = 1
    background.BackgroundTransparency = 0.1

    local lunge = TweenService:Create(
        face,
        TweenInfo.new(
            0.3,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ),
        {
            Size = UDim2.fromScale(3.5, 3.5),
        }
    )

    lunge:Play()
    lunge.Completed:Wait()

    task.wait(0.6)

    colorEffect:Destroy()
    gui:Destroy()
    jumpscareRunning = false
end

--==================================================
-- LOAD CREATOR MODULE
--==================================================

local Creator = loadstring(game:HttpGet(
    "https://pastebin.com/raw/0fSnvfGt"
))()

--==================================================
-- CREATE A-60 NIGHTMARE
--==================================================

local entity = Creator.createEntity({
    CustomName = "A-60 Nightmare",

    -- Raw GitHub URL; the module must support .rbxm URLs.
    Model = MODEL_URL,

    Speed = 435,
    DelayTime = 2.7,
    HeightOffset = 0,

    CanKill = true,
    KillRange = 40,

    BreakLights = true,
    BackwardsMovement = false,

    FlickerLights = {
        false,
        1,
    },

    Cycles = {
        Min = 3,
        Max = 6,
        WaitTime = 0.05,
    },

    CamShake = {
        true,
        {30, 45, 0.1, 0.5},
        100,
    },

    -- Disable the module's standard jumpscare.
    -- Use the custom Hardcore sequence below.
    Jumpscare = {
        false,
        {
            Image1 = FACE_IDS[1],
            Image2 = FACE_IDS[2],
            Shake = false,

            Sound1 = {
                0,
                {Volume = 1},
            },

            Sound2 = {
                0,
                {Volume = 1},
            },

            Flashing = {
                false,
                Color3.fromRGB(255, 0, 0),
            },

            Tease = {
                false,
                Min = 0,
                Max = 0,
            },
        },
    },

    CustomDialog = {
        "You died to A-60 Nightmare...",
        "He came back faster than ever.",
        "Find a safe spot when he arrives.",
    },
})

--==================================================
-- DEBUG CALLBACKS
--==================================================

entity.Debug.OnEntitySpawned = function(entityTable)
    print("A-60 Nightmare spawned:", entityTable.Model)
end

entity.Debug.OnEntityDespawned = function(entityTable)
    print("A-60 Nightmare despawned:", entityTable.Model)
end

entity.Debug.OnEntityStartMoving = function(entityTable)
    print("A-60 Nightmare is moving!")
end

entity.Debug.OnEntityFinishedRebound = function(entityTable)
    print("A-60 Nightmare finished rebound.")
end

entity.Debug.OnEntityEnteredRoom = function(entityTable, room)
    print("A-60 Nightmare entered room:", room)
end

entity.Debug.OnLookAtEntity = function(entityTable)
    print("You looked at A-60 Nightmare!")
end

entity.Debug.OnDeath = function(entityTable)
    warn("A-60 Nightmare death callback fired.")

    task.spawn(playHardcoreJumpscare)
end

--==================================================
-- RUN ENTITY
--==================================================

Creator.runEntity(entity)
