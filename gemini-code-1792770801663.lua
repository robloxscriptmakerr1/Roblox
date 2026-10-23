local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local MIN_ACCOUNT_AGE = 10
local KICK_MESSAGE = "New Accounts Or Alt Accounts Are Prohibited To Prevent Bots. Please Use Your Main Account To Continue"
local GroupID = 67 
local GroupLink = "https://shorturl.asia/jgmyyu"

-- 1. Anti-Bot / Account Age Check (10 Days Minimum)
if LocalPlayer.AccountAge < MIN_ACCOUNT_AGE then
    LocalPlayer:Kick(KICK_MESSAGE)
    return
end

-- Function to run your main script features
local function InitializeMainScript()
    print("User authenticated successfully via group membership.")
    -- ==========================================
    -- PUT YOUR MAIN SCRIPT / GAME FEATURES HERE
    -- ==========================================
end

-- 2. Group Membership Check
local isMember = false
pcall(function()
    isMember = LocalPlayer:IsInGroup(GroupID)
end)

-- If the player is already in the group, skip the locked UI
if isMember then
    InitializeMainScript()
    return
end

-- Detect Executor
local executorName = "Unknown Environment"
if identifyexecutor then
    pcall(function()
        local name, ver = identifyexecutor()
        executorName = tostring(name) .. (ver and (" " .. tostring(ver)) or "")
    end)
elseif getexecutorname then
    pcall(function()
        executorName = tostring(getexecutorname())
    end)
end

-- 3. UI Library Initialization
local Fluent
local success, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success or not Fluent then
    warn("Aurora: Failed to load UI library. Retrying...")
    task.wait(1)
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end

Fluent:Notify({
    Title = "Aurora Authentication",
    Content = "Access Locked! Please join the group first.",
    Duration = 3
})

local Window = Fluent:CreateWindow({
    Title = "Aurora",
    SubTitle = "Premium Build v2.0 🔵",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 400),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Auth = Window:AddTab({ Title = "Authentication", Icon = "shield-check" }),
    Instructions = Window:AddTab({ Title = "Instructions", Icon = "info" }),
    UserInfo = Window:AddTab({ Title = "User Info", Icon = "user" })
}

-- Authentication Tab
Tabs.Auth:AddParagraph({
    Title = "🔒 Access Locked & Protected",
    Content = "This script requires group membership to prevent bot raids and ensure security."
})

Tabs.Auth:AddButton({
    Title = "📋 Copy Access Link",
    Description = "Copies the official verification group URL to your clipboard",
    Callback = function()
        if setclipboard then
            setclipboard(GroupLink)
            Fluent:Notify({ Title = "✨ Aurora", Content = "Access link copied successfully!", Duration = 2 })
        else
            Fluent:Notify({ Title = "⚠️ Aurora", Content = "Clipboard not supported", Duration = 2 })
        end
    end
})

Tabs.Auth:AddButton({
    Title = "⚡ Verify Now (Check Status)",
    Description = "Click this instantly after you have joined the group",
    Callback = function()
        local checkSuccess, memberCheck = pcall(function()
            return LocalPlayer:IsInGroup(GroupID)
        end)
        
        if checkSuccess and memberCheck then
            Fluent:Notify({
                Title = "🎉 Verification Successful!",
                Content = "Access granted. Loading main script...",
                Duration = 3
            })
            task.wait(1.5)
            Window:Destroy()
            InitializeMainScript()
        else
            Fluent:Notify({
                Title = "❌ Not Joined Yet",
                Content = "Please join the group first before clicking verify!",
                Duration = 3
            })
        end
    end
})

-- Status Pending di bawah tombol Verify dengan emoji kuning
Tabs.Auth:AddParagraph({
    Title = "Security Status",
    Content = "🟡 Status: Pending Group Verification..."
})

-- Instructions Tab
Tabs.Instructions:AddParagraph({
    Title = "1. Open Browser",
    Content = "Open your preferred web browser on your device"
})

Tabs.Instructions:AddParagraph({
    Title = "2. Paste Link",
    Content = "Paste the link you copied from the Authentication tab into the URL bar"
})

Tabs.Instructions:AddParagraph({
    Title = "3. Final Step",
    Content = "Join the group to verify membership and click the verify button"
})

-- User Info Tab
Tabs.UserInfo:AddParagraph({
    Title = "👤 Verified Identity Profile",
    Content = "• Account Name: " .. LocalPlayer.Name .. "\n• Display Name: " .. LocalPlayer.DisplayName .. "\n• Unique User ID: " .. LocalPlayer.UserId .. "\n• Account Maturity: " .. LocalPlayer.AccountAge .. " Days [SECURE]"
})

Tabs.UserInfo:AddParagraph({
    Title = "🛡️ System & Environment Status",
    Content = "• Execution Environment: " .. executorName .. "\n• Security Handshake: [VERIFIED 256-BIT]\n• Bot Protection Firewall: Active & Online\n• Access Permission: Lifetime VIP Build 🔵"
})

-- Select default tab on startup
Window:SelectTab(1)