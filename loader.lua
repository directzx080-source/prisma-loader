-- Prisma Services | NEBULA V6.2 | server-authorized access.
local ORIGIN = "https://prisma-sniper-keys-c7f2.ochregleam1.chatgpt.site"
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
assert(localPlayer, "Roblox player is not ready.")
local playerGui = localPlayer:WaitForChild("PlayerGui", 10)
assert(playerGui, "PlayerGui is unavailable.")
local old = playerGui:FindFirstChild("PrismaKeyGate_v2")
if old then
    local shutdown = old:FindFirstChild("Shutdown")
    if shutdown and old:GetAttribute("Ready") then pcall(function() shutdown:Invoke() end) end
    old:Destroy()
end

local copy = {
    ["pt-BR"] = {
        title = "PRISMA / ACESSO", edition = "NEBULA V6.2  /  PRISMA SERVICES", access = "SUA EXPERIÊNCIA COMEÇA AQUI",
        welcome = "Bem-vindo ao Prisma Services", introNote = "UMA NOVA FORMA DE VIVER O PRISMA", skip = "Pular introdução",
        label = "CHAVE DE ACESSO", placeholder = "Cole sua chave de acesso", submit = "VALIDAR E ABRIR PAINEL", validating = "VALIDANDO...",
        getKey = "GERAR MINHA CHAVE  ↗", hint = "Gere sua chave no site. Seu acesso é validado pelo servidor.",
        footer = "ACESSO POR CHAVE  ·  CONEXÃO SEGURA", language = "IDIOMA", close = "Fechar Prisma",
        incomplete = "Cole a chave completa gerada no site.", noHttp = "Este executor não oferece HTTP request para validar chaves.",
        connection = "Não foi possível conectar ao servidor. Tente novamente.", invalidResponse = "O servidor enviou uma resposta inválida.",
        invalidKey = "Chave inválida, desativada ou expirada.", unavailable = "A validação está indisponível. Tente novamente.",
        refused = "A solicitação de acesso foi recusada.", noSource = "O servidor não enviou o painel.",
        compile = "Não foi possível compilar o painel neste executor.", openFailed = "Não foi possível abrir o painel neste executor.",
        expired = "Sua chave expirou. Gere outra no site.", renewal = "Não foi possível renovar seu acesso. Valide sua chave novamente.",
        copied = "Link copiado. Abra no navegador para gerar sua chave.",
    },
    en = {
        title = "PRISMA / ACCESS", edition = "NEBULA V6.2  /  PRISMA SERVICES", access = "YOUR EXPERIENCE STARTS HERE",
        welcome = "Welcome to Prisma Services", introNote = "A NEW WAY TO EXPERIENCE PRISMA", skip = "Skip introduction",
        label = "ACCESS KEY", placeholder = "Paste your access key", submit = "VALIDATE & OPEN PANEL", validating = "VALIDATING...",
        getKey = "GET MY ACCESS KEY  ↗", hint = "Get your key on the website. Access is verified by the server.",
        footer = "KEY ACCESS  ·  SECURE CONNECTION", language = "LANGUAGE", close = "Close Prisma",
        incomplete = "Paste the complete key generated on the website.", noHttp = "This executor does not provide HTTP request for key validation.",
        connection = "Could not connect to the server. Please try again.", invalidResponse = "The server returned an invalid response.",
        invalidKey = "This key is invalid, disabled or expired.", unavailable = "Key validation is unavailable. Please try again.",
        refused = "The access request was rejected.", noSource = "The server did not return the panel.",
        compile = "The panel could not compile in this executor.", openFailed = "The panel could not open in this executor.",
        expired = "Your key has expired. Get a new key on the website.", renewal = "Could not renew access. Please validate your key again.",
        copied = "Link copied. Open it in your browser to get a key.",
    },
}
local language = playerGui:GetAttribute("PrismaLanguage") == "en" and "en" or "pt-BR"
playerGui:SetAttribute("PrismaLanguage", language)
local function tr(key) return copy[language][key] or key end
local alive, busy, introActive = true, false, true
local generation, controller = 0, nil
local connections, heartbeat, introConnection, revealConnection = {}, nil, nil, nil
local root = Instance.new("ScreenGui")
root.Name = "PrismaKeyGate_v2"
root.ResetOnSpawn = false
root.Enabled = true
root.DisplayOrder = 2147483001
root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
root.IgnoreGuiInset = true
root.AutoLocalize = false
root.Parent = playerGui
local function cleanup(destroyGui)
    if not alive then return end
    alive = false
    introActive = false
    generation = generation + 1
    if controller and type(controller.Stop) == "function" then pcall(controller.Stop) end
    controller = nil
    for _, connection in ipairs(connections) do connection:Disconnect() end
    table.clear(connections)
    if destroyGui ~= false then root:Destroy() end
end
local shutdown = Instance.new("BindableFunction")
shutdown.Name = "Shutdown"
shutdown.OnInvoke = cleanup
shutdown.Parent = root
connections[#connections + 1] = root.Destroying:Connect(function() cleanup(false) end)
root:SetAttribute("Ready", true)
local function make(class, properties, parent)
    local object = Instance.new(class)
    for key, value in pairs(properties) do object[key] = value end
    object.Parent = parent
    return object
end
local purple, muted, white = Color3.fromRGB(164, 105, 255), Color3.fromRGB(133, 123, 154), Color3.fromRGB(242, 236, 255)
local function corner(parent, radius) return make("UICorner", {CornerRadius = UDim.new(0, radius)}, parent) end
local function stroke(parent, color, transparency, thickness)
    return make("UIStroke", {Color = color or purple, Transparency = transparency or 0, Thickness = thickness or 1}, parent)
end
local function text(parent, name, value, x, y, w, h, size, color, bold)
    return make("TextLabel", {Name = name, Text = value, Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h),
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham, TextSize = size, TextColor3 = color or white,
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22}, parent)
end
local runs = {{0,0,1,72},{1,0,1,240},{2,0,13,255},{15,0,17,240},{32,0,1,255},{2,1,11,255},{13,1,1,240},{14,1,1,255},{15,1,20,240},{3,2,11,255},{14,2,22,240},{4,3,10,255},{14,3,23,240},{5,4,9,255},{14,4,24,240},{6,5,6,255},{12,5,1,240},{13,5,1,255},{14,5,25,240},{7,6,1,255},{8,6,1,240},{9,6,4,255},{13,6,26,240},{8,7,23,240},{31,7,1,216},{32,7,7,240},{39,7,1,192},{31,8,1,168},{32,8,1,216},{33,8,7,240},{32,9,1,168},{33,9,1,192},{34,9,6,240},{32,10,3,192},{35,10,5,240},{31,11,1,144},{32,11,4,192},{36,11,4,240},{31,12,4,192},{35,12,2,216},{37,12,3,240},{30,13,2,192},{32,13,6,216},{38,13,1,240},{39,13,1,255},{13,14,1,255},{14,14,3,144},{17,14,4,168},{21,14,9,192},{30,14,8,216},{38,14,1,240},{12,15,2,255},{14,15,2,144},{16,15,4,168},{20,15,7,192},{27,15,10,216},{37,15,2,240},{11,16,3,255},{14,16,1,144},{15,16,4,168},{19,16,6,192},{25,16,10,216},{35,16,3,240},{10,17,4,255},{14,17,1,144},{15,17,3,168},{18,17,5,192},{23,17,9,216},{32,17,6,240},{9,18,5,255},{14,18,1,144},{15,18,2,168},{17,18,4,192},{21,18,9,216},{30,18,7,240},{7,19,1,240},{8,19,6,255},{14,19,2,168},{16,19,4,192},{20,19,8,216},{28,19,8,240},{6,20,8,255},{14,20,2,168},{16,20,3,192},{19,20,6,216},{25,20,9,240},{5,21,1,240},{6,21,8,255},{14,21,1,168},{15,21,3,192},{18,21,5,216},{23,21,9,240},{5,22,3,255},{8,22,1,240},{9,22,5,255},{14,22,1,168},{15,22,3,192},{18,22,1,216},{5,23,1,255},{6,23,1,240},{7,23,1,255},{8,23,3,240},{11,23,2,255},{13,23,1,240},{14,23,1,168},{15,23,2,192},{17,23,1,216},{5,24,8,240},{13,24,1,255},{14,24,1,168},{15,24,2,192},{5,25,9,240},{14,25,1,168},{15,25,1,192},{5,26,9,240},{14,26,1,168},{5,27,9,240},{5,28,9,240},{5,29,9,240},{5,30,9,240},{5,31,9,240},{5,32,9,240},{5,33,8,240},{5,34,6,240},{5,35,5,240},{5,36,4,240},{5,37,2,240},{7,37,1,216},{5,38,2,240},{5,39,1,255}}
local function logo(parent, size, position, index)
    local mark = make("Frame", {Name = "PrismaTransparentMark", Position = position, Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ZIndex = index}, parent)
    for _, run in ipairs(runs) do
        make("Frame", {Position = UDim2.fromScale(run[1] / 40, run[2] / 40), Size = UDim2.fromScale(run[3] / 40, 1 / 40),
            BackgroundColor3 = Color3.fromRGB(run[4], run[4], run[4]), BorderSizePixel = 0, ZIndex = index}, mark)
    end
    return mark
end

-- The gate exists from the start, but neither input nor authorization can bypass the intro.
local panel = make("Frame", {Name = "KeyPanel", Visible = false, AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(470, 410), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, ZIndex = 20}, root)
corner(panel, 18)
stroke(panel, Color3.fromRGB(103, 56, 164), 0.22, 1.2)
local panelScale = make("UIScale", {Scale = 1}, panel)
local function resize()
    local viewport = root.AbsoluteSize
    if viewport and viewport.X > 0 and viewport.Y > 0 then panelScale.Scale = math.max(0.35, math.min(1, (viewport.X - 28) / 470, (viewport.Y - 28) / 410)) end
end
resize()
connections[#connections + 1] = root:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize)
local accent = make("Frame", {Position = UDim2.fromOffset(26, 0), Size = UDim2.new(1, -52, 0, 2), BackgroundColor3 = purple, BorderSizePixel = 0, ZIndex = 21}, panel)
corner(accent, 2)
logo(panel, 46, UDim2.fromOffset(27, 28), 22)
local heading = text(panel, "AccessTitle", tr("title"), 90, 28, 300, 25, 19, white, true)
local edition = text(panel, "Edition", tr("edition"), 91, 55, 300, 14, 9, muted)
local close = make("TextButton", {Name = "CloseAccess", Position = UDim2.fromOffset(417, 22), Size = UDim2.fromOffset(30, 30), Text = "×",
    BackgroundColor3 = Color3.fromRGB(16, 10, 25), TextColor3 = muted, Font = Enum.Font.Gotham, TextSize = 23, BorderSizePixel = 0, ZIndex = 22}, panel)
corner(close, 8)
local accessNote = text(panel, "AccessNote", tr("access"), 28, 101, 410, 17, 10, purple, true)
local fieldLabel = text(panel, "KeyLabel", tr("label"), 28, 137, 410, 18, 10, muted, true)
local input = make("TextBox", {Name = "KeyInput", Position = UDim2.fromOffset(28, 161), Size = UDim2.fromOffset(414, 53), Text = "",
    PlaceholderText = tr("placeholder"), ClearTextOnFocus = false, TextColor3 = white, PlaceholderColor3 = Color3.fromRGB(102, 93, 120),
    BackgroundColor3 = Color3.fromRGB(9, 5, 15), BorderSizePixel = 0, Font = Enum.Font.Code, TextSize = 12, ZIndex = 22}, panel)
corner(input, 10)
stroke(input, Color3.fromRGB(73, 45, 104), 0.1)
local submit = make("TextButton", {Name = "KeySubmit", Position = UDim2.fromOffset(28, 229), Size = UDim2.fromOffset(414, 47), Text = tr("submit"),
    BackgroundColor3 = Color3.fromRGB(132, 73, 227), TextColor3 = white, BorderSizePixel = 0, Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 22}, panel)
corner(submit, 10)
local getKey = make("TextButton", {Name = "GetKeyInput", Position = UDim2.fromOffset(28, 286), Size = UDim2.fromOffset(414, 29), Text = tr("getKey"),
    BackgroundTransparency = 1, TextColor3 = purple, Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 22}, panel)
local message = text(panel, "AccessStatus", tr("hint"), 28, 320, 414, 35, 11, muted)
message.TextWrapped = true
message.TextXAlignment = Enum.TextXAlignment.Center
make("Frame", {Position = UDim2.fromOffset(28, 368), Size = UDim2.fromOffset(414, 1), BackgroundColor3 = Color3.fromRGB(32, 21, 45), BorderSizePixel = 0, ZIndex = 21}, panel)
local footer = text(panel, "AccessFooter", tr("footer"), 28, 380, 275, 14, 8, muted)
local languageLabel = text(panel, "LanguageLabel", tr("language"), 298, 380, 58, 15, 8, muted)
local languageButtons = {}
for i, code in ipairs({"pt-BR", "en"}) do
    local button = make("TextButton", {Name = code == "en" and "LanguageEN" or "LanguagePTBR", Position = UDim2.fromOffset(357 + (i - 1) * 44, 376), Size = UDim2.fromOffset(39, 24),
        Text = code == "en" and "EN" or "BR", Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0, ZIndex = 22}, panel)
    corner(button, 6)
    languageButtons[code] = button
end
local statusKey, statusRaw, statusError = "hint", nil, false
local intro, introTitle, introNote, skip
local function localize()
    heading.Text, edition.Text, accessNote.Text = tr("title"), tr("edition"), tr("access")
    fieldLabel.Text, input.PlaceholderText = tr("label"), tr("placeholder")
    submit.Text = tr(busy and "validating" or "submit")
    getKey.Text, footer.Text, languageLabel.Text = tr("getKey"), tr("footer"), tr("language")
    message.Text = statusRaw or tr(statusKey)
    message.TextColor3 = statusError and Color3.fromRGB(236, 142, 176) or muted
    for code, button in pairs(languageButtons) do
        button.BackgroundColor3 = code == language and Color3.fromRGB(49, 26, 77) or Color3.fromRGB(13, 8, 21)
        button.TextColor3 = code == language and white or muted
    end
    if introTitle then introTitle.Text = tr("welcome") end
    if introNote then introNote.Text = tr("introNote") end
    if skip then skip.Text = tr("skip") end
end
local function setMessage(key, isError, raw)
    statusKey, statusError, statusRaw = key, isError == true, raw
    localize()
end
for code, button in pairs(languageButtons) do
    connections[#connections + 1] = button.Activated:Connect(function()
        language = code
        playerGui:SetAttribute("PrismaLanguage", code)
        localize()
    end)
end
localize()

local function fadeItems(parent)
    local items = {}
    for _, object in ipairs(parent:GetDescendants()) do
        if object:IsA("GuiObject") then
            items[#items + 1] = {object = object, property = "BackgroundTransparency", base = object.BackgroundTransparency or 0}
            if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                items[#items + 1] = {object = object, property = "TextTransparency", base = object.TextTransparency or 0}
                items[#items + 1] = {object = object, property = "TextStrokeTransparency", base = object.TextStrokeTransparency or 1}
            end
        elseif object:IsA("UIStroke") then items[#items + 1] = {object = object, property = "Transparency", base = object.Transparency or 0} end
    end
    return items
end
local function fade(items, opacity)
    for _, item in ipairs(items) do item.object[item.property] = 1 - (1 - item.base) * opacity end
end
local function smooth(t) t = math.clamp(t, 0, 1); return t * t * (3 - 2 * t) end
local panelFadeItems = fadeItems(panel)
local function revealPanel()
    if not alive then return end
    if revealConnection then revealConnection:Disconnect(); revealConnection = nil end
    panel.Visible = true
    panel.Position = UDim2.new(0.5, 0, 0.5, 14)
    local items, elapsed = panelFadeItems, 0
    fade(items, 0)
    panel.BackgroundTransparency = 1
    revealConnection = RunService.Heartbeat:Connect(function(dt)
        if not alive then return end
        elapsed = elapsed + math.max(0, dt)
        local amount = smooth(elapsed / 0.52)
        panel.BackgroundTransparency = 1 - amount
        panel.Position = UDim2.new(0.5, 0, 0.5, 14 * (1 - amount))
        fade(items, amount)
        if elapsed >= 0.52 then revealConnection:Disconnect(); revealConnection = nil end
    end)
    connections[#connections + 1] = revealConnection
end

-- A UI-only cinematic: no camera, world time, or gameplay state is modified.
intro = make("Frame", {Name = "IntroOverlay", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Active = true, ZIndex = 100, ClipsDescendants = true}, root)
local glow = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.49), Size = UDim2.fromOffset(640, 230),
    BackgroundColor3 = Color3.fromRGB(56, 13, 104), BackgroundTransparency = 0.93, BorderSizePixel = 0, ZIndex = 101}, intro)
corner(glow, 115)
local center = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.49), Size = UDim2.fromOffset(660, 210), BackgroundTransparency = 1, ZIndex = 105}, intro)
local centerScale = make("UIScale", {Scale = math.max(0.35, math.min(1, (root.AbsoluteSize.X - 24) / 660))}, center)
local introMark = logo(center, 64, UDim2.fromOffset(298, 0), 106)
introTitle = text(center, "IntroTitle", tr("welcome"), 0, 91, 660, 45, 29, white, true)
introTitle.TextXAlignment, introTitle.ZIndex = Enum.TextXAlignment.Center, 106
introNote = text(center, "WelcomeSubtitle", tr("introNote"), 0, 149, 660, 20, 10, purple, true)
introNote.TextXAlignment, introNote.ZIndex = Enum.TextXAlignment.Center, 106
local introLine = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(330, 187), Size = UDim2.fromOffset(90, 2), BackgroundColor3 = purple, BorderSizePixel = 0, ZIndex = 106}, center)
corner(introLine, 2)
skip = make("TextButton", {Name = "IntroSkip", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -26, 1, -25), Size = UDim2.fromOffset(180, 35), Text = tr("skip"),
    BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(194, 166, 228), Font = Enum.Font.Gotham, TextSize = 11, ZIndex = 110}, intro)
local particles = {}
for i = 1, 22 do
    local isLine = i <= 10
    local object = make("Frame", {Name = "NebulaParticle", Size = isLine and UDim2.fromOffset(65 + (i * 31) % 160, 2) or UDim2.fromOffset(2 + i % 3, 2 + i % 3),
        BackgroundColor3 = i % 3 == 0 and Color3.fromRGB(106, 49, 220) or purple, BackgroundTransparency = 1, BorderSizePixel = 0,
        Rotation = isLine and -21 or 0, ZIndex = 103}, intro)
    corner(object, 4)
    particles[#particles + 1] = {object = object, x = (i * 0.149) % 1.3 - 0.15, y = (i * 0.237) % 1, speed = isLine and 0.16 + (i % 4) * 0.03 or 0.025 + (i % 5) * 0.008, line = isLine}
end
local centerItems, introElapsed = fadeItems(center), 0
fade(centerItems, 0)
local function finishIntro()
    if not alive or not introActive then return end
    introActive = false
    if introConnection then introConnection:Disconnect(); introConnection = nil end
    if intro then intro:Destroy(); intro = nil; introTitle = nil; introNote = nil; skip = nil end
    revealPanel()
end
connections[#connections + 1] = skip.Activated:Connect(finishIntro)
introConnection = RunService.Heartbeat:Connect(function(dt)
    if not alive or not introActive then return end
    introElapsed = introElapsed + math.max(0, dt)
    local dim = smooth(introElapsed / 1.05) * (1 - smooth((introElapsed - 3.55) / 0.75))
    local ink = smooth((introElapsed - 0.55) / 1.15) * (1 - smooth((introElapsed - 2.65) / 0.95))
    intro.BackgroundTransparency = 1 - dim * 0.92
    glow.BackgroundTransparency = 1 - ink * 0.07
    fade(centerItems, ink)
    center.Position = UDim2.new(0.5, 0, 0.49, 16 * (1 - smooth((introElapsed - 0.55) / 1.15)))
    centerScale.Scale = math.max(0.35, math.min(1, (root.AbsoluteSize.X - 24) / 660))
    introLine.Size = UDim2.fromOffset(90 + 150 * smooth((introElapsed - 0.8) / 2.6), 2)
    for i, particle in ipairs(particles) do
        local x = (particle.x + introElapsed * particle.speed + 0.2) % 1.5 - 0.2
        local y = particle.y - introElapsed * particle.speed * 0.3
        particle.object.Position = UDim2.fromScale(x, y % 1)
        particle.object.BackgroundTransparency = 1 - dim * (particle.line and 0.32 or 0.52) * (0.55 + 0.45 * math.sin(introElapsed * 1.4 + i)^2)
    end
    skip.TextTransparency = 1 - dim * 0.8
    if introElapsed >= 4.3 then finishIntro() end
end)
connections[#connections + 1] = introConnection

local httpRequest = (type(request) == "function" and request)
    or (type(http_request) == "function" and http_request)
    or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
    or (type(http) == "table" and type(http.request) == "function" and http.request)
local function post(path, key)
    if not httpRequest then return nil, "noHttp" end
    local ok, response = pcall(httpRequest, {Url = ORIGIN .. path, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode({key = key})})
    if not ok or type(response) ~= "table" or type(response.Body) ~= "string" or #response.Body > 500000 then return nil, "connection" end
    local decoded, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
    if not decoded or type(data) ~= "table" then return nil, "invalidResponse" end
    local status = tonumber(response.StatusCode)
    if status ~= 200 or data.success ~= true then
        local reason = status == 401 and "invalidKey" or (status == 403 and "refused" or "unavailable")
        return nil, reason, status
    end
    return data
end
local function showLogin(key)
    generation = generation + 1
    if controller then pcall(controller.Stop); controller = nil end
    if heartbeat then heartbeat:Disconnect(); heartbeat = nil end
    if not alive then return end
    language = playerGui:GetAttribute("PrismaLanguage") == "en" and "en" or "pt-BR"
    root.Enabled, busy, submit.Active = true, false, true
    setMessage(key, true)
    if not introActive then revealPanel() end
end
local function unlock()
    if busy or not alive or introActive then return end
    local key = string.upper(string.match(input.Text, "^%s*(.-)%s*$") or "")
    if #key < 12 or #key > 80 then setMessage("incomplete", true); return end
    busy = true
    generation = generation + 1
    local attempt = generation
    submit.Active = false
    localize()
    task.spawn(function()
        local data, failure = post("/api/script", key)
        if not alive or generation ~= attempt then return end
        if not data or type(data.source) ~= "string" or (data.lifetime ~= true and type(data.expiresAt) ~= "number") then showLogin(failure or "noSource"); return end
        local chunk = loadstring(data.source)
        if not chunk then showLogin("compile"); return end
        local ok, result = pcall(chunk)
        if not ok or type(result) ~= "table" or type(result.Stop) ~= "function" or type(result.IsRunning) ~= "function" then showLogin("openFailed"); return end
        if not alive or generation ~= attempt then pcall(result.Stop); return end
        controller = result
        root.Enabled, busy = false, false
        if revealConnection then revealConnection:Disconnect(); revealConnection = nil end
        local expiresAt, elapsed, failures, checking = data.expiresAt, 0, 0, false
        if data.lifetime == true then expiresAt = nil end
        heartbeat = RunService.Heartbeat:Connect(function(dt)
            if not alive or generation ~= attempt then return end
            if not controller or not controller.IsRunning() then cleanup(); return end
            if expiresAt and os.time() >= expiresAt then showLogin("expired"); return end
            elapsed = elapsed + dt
            if elapsed < 15 or checking then return end
            elapsed, checking = 0, true
            task.spawn(function()
                local valid, reason, status = post("/api/validate", key)
                if not alive or generation ~= attempt then return end
                checking = false
                if valid and (valid.lifetime == true or type(valid.expiresAt) == "number") then
                    failures, expiresAt = 0, valid.expiresAt
                    if valid.lifetime == true then expiresAt = nil end
                else
                    failures = failures + 1
                    if status == 401 or failures >= 2 then showLogin(reason or "renewal") end
                end
            end)
        end)
        connections[#connections + 1] = heartbeat
    end)
end
connections[#connections + 1] = close.Activated:Connect(cleanup)
connections[#connections + 1] = submit.Activated:Connect(unlock)
connections[#connections + 1] = input.FocusLost:Connect(function(enter) if enter then unlock() end end)
connections[#connections + 1] = getKey.Activated:Connect(function()
    if introActive or not alive then return end
    if type(setclipboard) == "function" and pcall(setclipboard, ORIGIN) then setMessage("copied", false) else setMessage("hint", false, ORIGIN) end
end)
return {Stop = cleanup}
