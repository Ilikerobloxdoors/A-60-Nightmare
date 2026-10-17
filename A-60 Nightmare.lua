---====== Load spawner ======---

local Spawner = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RegularVynixu/DOORS-Entity-Spawner-V2/main/init.luau"
))()

---====== Create A-60 NIGHTMARE ======---

local entity = Spawner:Create({
    Entity = {
        Name = "A-60 Nightmare",
        Asset = "https://raw.githubusercontent.com/Ilikerobloxdoors/A-60-Nightmare/main/A-60%20Nightmare.rbxm",
        HeightOffset = 0
    },

    Lights = {
        Flicker = {
            Enabled = false,
            Duration = 1
        },
        Shatter = false,
        Repair = false
    },

    Earthquake = {
        Enabled = true
    },

    CameraShake = {
        Enabled = true,
        Range = 100,
        Values = {30, 45, 0.1, 0.7}
    },

    Movement = {
        Speed = 375,
        Delay = 3.7,
        Reversed = false
    },

    Rebounding = {
        Enabled = true,
        Type = "Ambush",
        Min = 3,
        Max = 6,
        Delay = 0.2
    },

    Damage = {
        Enabled = true,
        IgnoreHiding = false,
        Range = 40,
        Amount = 125
    },

    Crucifixion = {
        Type = "Curious",
        Enabled = true,
        Range = 40,
        Resist = false,
        Break = true
    },

    Death = {
        Type = "Curious",
        Hints = {
            "You died to A-60 NIGHTMARE...",
            "It is faster than you think.",
            "Hide when you hear it approaching.",
            "It may return several times. Stay hidden!"
        },
        Cause = ""
    }
})

---====== Blue Screen + Violent Camera Shake ======---

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local function playNightmareEffect()
    local duration = 1
    local startTime = os.clock()
    local bindName = "A60NightmareShake"

    -- Remove any previous copy of this effect
    RunService:UnbindFromRenderStep(bindName)

    local blue = Instance.new("ColorCorrectionEffect")
    blue.Name = "A60NightmareBlue"
    blue.TintColor = Color3.fromRGB(0, 80, 255)
    blue.Saturation = -0.3
    blue.Contrast = 0.6
    blue.Parent = Lighting

    RunService:BindToRenderStep(
        bindName,
        Enum.RenderPriority.Camera.Value + 1,
        function()
            if os.clock() - startTime >= duration then
                RunService:UnbindFromRenderStep(bindName)

                if blue.Parent then
                    blue:Destroy()
                end

                return
            end

            local camera = workspace.CurrentCamera

            if camera then
                local x = math.random(-100, 100) / 100
                local y = math.random(-100, 100) / 100

                local rx = math.rad(math.random(-15, 15))
                local ry = math.rad(math.random(-15, 15))
                local rz = math.rad(math.random(-15, 15))

                camera.CFrame = camera.CFrame
                    * CFrame.new(x, y, 0)
                    * CFrame.Angles(rx, ry, rz)
            end
        end
    )
end

---====== Debug Callbacks ======---

entity:SetCallback("OnSpawned", function()
    print("A-60 NIGHTMARE has spawned!")
    playNightmareEffect()
end)

entity:SetCallback("OnStartMoving", function()
    print("A-60 NIGHTMARE has started moving!")
end)

entity:SetCallback("OnEnterRoom", function(room, firstTime)
    if firstTime then
        print("A-60 NIGHTMARE entered room: " .. room.Name)
    else
        print("A-60 NIGHTMARE re-entered room: " .. room.Name)
    end
end)

entity:SetCallback("OnLookAt", function(lineOfSight)
    if lineOfSight then
        print("Player is looking at A-60 NIGHTMARE!")
    else
        print("A-60 NIGHTMARE is obstructed from view.")
    end
end)

entity:SetCallback("OnRebounding", function(startOfRebound)
    if startOfRebound then
        print("A-60 NIGHTMARE has started rebounding!")
    else
        print("A-60 NIGHTMARE has finished rebounding!")
    end
end)

entity:SetCallback("OnDespawning", function()
    print("A-60 NIGHTMARE is despawning!")
end)

entity:SetCallback("OnDespawned", function()
    print("A-60 NIGHTMARE has despawned!")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
    if newHealth <= 0 then
        print("A-60 NIGHTMARE killed the player!")
    else
        print("A-60 NIGHTMARE damaged the player!")
    end
end)

---====== Run Entity ======---

entity:Run(true)
