--[[
    CAT HUB Library
    ]]--

local CAT = {}
CAT.__index = CAT

CAT.Theme = {
    Background = Color3.fromRGB(18, 18, 22),
    Panel = Color3.fromRGB(27, 27, 33),
    PanelHover = Color3.fromRGB(39, 39, 47),
    Accent = Color3.fromRGB(255, 205, 65),
    Text = Color3.fromRGB(245, 245, 248),
    Muted = Color3.fromRGB(165, 165, 175),
    Stroke = Color3.fromRGB(66, 66, 76),
    Success = Color3.fromRGB(85, 210, 135),
    Error = Color3.fromRGB(255, 100, 100),
}

local function create(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, parent)
end

local function stroke(parent, color, thickness)
    return create("UIStroke", {
        Color = color or CAT.Theme.Stroke,
        Thickness = thickness or 1,
        Transparency = 0.15,
    }, parent)
end

local function padding(parent, left, right, top, bottom)
    return create("UIPadding", {
        PaddingLeft = UDim.new(0, left or 10),
        PaddingRight = UDim.new(0, right or 10),
        PaddingTop = UDim.new(0, top or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
    }, parent)
end

local function textLabel(parent, text, size, color, font)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text or "",
        TextColor3 = color or CAT.Theme.Text,
        TextSize = size or 14,
        Font = font or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
    }, parent)
end

local function makeButton(parent, text, height)
    local b = create("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = CAT.Theme.Panel,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, height or 34),
        Text = text or "Button",
        TextColor3 = CAT.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
    }, parent)
    corner(b, 7)
    stroke(b)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = CAT.Theme.PanelHover end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = CAT.Theme.Panel end)
    return b
end

local function makeList(parent, gap)
    return create("UIListLayout", {
        Padding = UDim.new(0, gap or 7),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, parent)
end

function CAT:SetTheme(theme)
    for key, value in pairs(theme or {}) do
        if self.Theme[key] ~= nil then self.Theme[key] = value end
    end
end

function CAT:Notify(options)
    options = options or {}
    local title = tostring(options.Title or "CAT HUB")
    local message = tostring(options.Content or options.Message or "")
    local duration = math.clamp(tonumber(options.Duration) or 3, 1, 12)
    local frame = create("Frame", {
        BackgroundColor3 = self.Theme.Panel,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 78),
    }, self.ToastHolder)
    corner(frame, 9)
    stroke(frame, self.Theme.Accent, 1)
    create("Frame", {
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 4, 1, 0),
    }, frame)
    local titleLabel = textLabel(frame, title, 14, self.Theme.Accent, Enum.Font.GothamBold)
    titleLabel.Position = UDim2.new(0, 14, 0, 8)
    titleLabel.Size = UDim2.new(1, -24, 0, 20)
    local contentLabel = textLabel(frame, message, 12, self.Theme.Text)
    contentLabel.Position = UDim2.new(0, 14, 0, 30)
    contentLabel.Size = UDim2.new(1, -24, 0, 38)
    task.delay(duration, function()
        if frame and frame.Parent then frame:Destroy() end
    end)
end

function CAT:CreateWindow(options)
    options = options or {}
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local gui = create("ScreenGui", {
        Name = options.Name or "CAT_HUB_Library",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, playerGui)

    local window = create("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, options.Width or 620, 0, options.Height or 430),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, gui)
    corner(window, 10)
    stroke(window, self.Theme.Accent, 1.2)

    local top = create("Frame", {
        Name = "Topbar",
        BackgroundColor3 = self.Theme.Panel,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 48),
    }, window)
    local title = textLabel(top, options.Title or "CAT HUB Library", 17, self.Theme.Accent, Enum.Font.GothamBold)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.Size = UDim2.new(1, -100, 1, 0)
    local close = create("TextButton", {
        Name = "Close",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -44, 0, 0),
        Size = UDim2.new(0, 44, 1, 0),
        Text = "×",
        TextColor3 = self.Theme.Text,
        TextSize = 26,
        Font = Enum.Font.Gotham,
    }, top)
    close.Activated:Connect(function() gui:Destroy() end)

    local nav = create("ScrollingFrame", {
        Name = "Tabs",
        BackgroundColor3 = self.Theme.Panel,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 48),
        Size = UDim2.new(0, 155, 1, -48),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Theme.Accent,
    }, window)
    padding(nav, 9, 9, 10, 10)
    makeList(nav, 6)

    local pages = create("Frame", {
        Name = "Pages",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 155, 0, 48),
        Size = UDim2.new(1, -155, 1, -48),
    }, window)

    local toastHolder = create("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 16),
        Size = UDim2.new(0, 280, 0, 300),
    }, gui)
    makeList(toastHolder, 8)

    -- Drag the window using the top bar.
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local win = {
        Library = self,
        Gui = gui,
        Frame = window,
        Nav = nav,
        Pages = pages,
        ToastHolder = toastHolder,
        _tabs = {},
        _activeTab = nil,
    }

    function win:Notify(opts)
        self.Library:Notify(opts)
    end

    function win:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tostring(tabOptions.Name or "Tab")
        local tabButton = makeButton(self.Nav, tabName, 34)
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.Text = "   " .. tabName

        local page = create("ScrollingFrame", {
            Name = tabName:gsub("%W", "") .. "Page",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = self.Library.Theme.Accent,
            Visible = false,
        }, self.Pages)
        padding(page, 14, 14, 12, 12)
        makeList(page, 9)

        local tab = {Window = self, Button = tabButton, Page = page, _order = 0}
        function tab:_addItem(height)
            self._order += 1
            return height
        end

        local function addSection(sectionName)
            local section = create("Frame", {
                Name = "Section",
                BackgroundColor3 = self.Library.Theme.Panel,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -4, 0, 40),
                AutomaticSize = Enum.AutomaticSize.Y,
            }, page)
            corner(section, 8)
            stroke(section)
            padding(section, 10, 10, 9, 10)
            local sectionTitle = textLabel(section, sectionName or "Section", 13, self.Library.Theme.Accent, Enum.Font.GothamBold)
            sectionTitle.Size = UDim2.new(1, 0, 0, 22)
            local items = create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 28),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
            }, section)
            makeList(items, 7)
            local function updateSection()
                section.Size = UDim2.new(1, -4, 0, 37)
            end
            local sec = {Frame = section, Items = items, Library = self.Library, Window = self.Window}
            function sec:AddButton(opts)
                opts = type(opts) == "string" and {Name = opts} or (opts or {})
                local b = makeButton(self.Items, opts.Name or "Button", 34)
                b.Activated:Connect(function()
                    if opts.Callback then
                        local ok, err = pcall(opts.Callback)
                        if not ok then self.Window:Notify({Title = "Button error", Content = tostring(err)}) end
                    end
                end)
                return b
            end
            function sec:AddToggle(opts)
                opts = opts or {}
                local value = opts.Default == true
                local row = create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34)}, self.Items)
                local label = textLabel(row, opts.Name or "Toggle", 13, self.Library.Theme.Text)
                label.Size = UDim2.new(1, -58, 1, 0)
                local toggle = create("TextButton", {
                    BackgroundColor3 = value and self.Library.Theme.Accent or self.Library.Theme.Stroke,
                    Position = UDim2.new(1, -48, 0.5, -10),
                    Size = UDim2.new(0, 44, 0, 20),
                    Text = value and "ON" or "OFF",
                    TextColor3 = value and Color3.fromRGB(25,25,25) or self.Library.Theme.Text,
                    TextSize = 10, Font = Enum.Font.GothamBold, AutoButtonColor = false,
                }, row)
                corner(toggle, 10)
                local function set(v, fire)
                    value = v == true
                    toggle.Text = value and "ON" or "OFF"
                    toggle.BackgroundColor3 = value and self.Library.Theme.Accent or self.Library.Theme.Stroke
                    toggle.TextColor3 = value and Color3.fromRGB(25,25,25) or self.Library.Theme.Text
                    if fire and opts.Callback then opts.Callback(value) end
                end
                toggle.Activated:Connect(function() set(not value, true) end)
                local control = {Set = function(_, v) set(v, true) end, Get = function() return value end}
                return control
            end
            function sec:AddSlider(opts)
                opts = opts or {}
                local min = tonumber(opts.Min) or 0
                local max = tonumber(opts.Max) or 100
                if max <= min then max = min + 1 end
                local value = math.clamp(tonumber(opts.Default) or min, min, max)
                local row = create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 54)}, self.Items)
                local label = textLabel(row, "", 13, self.Library.Theme.Text)
                label.Size = UDim2.new(1, 0, 0, 20)
                local track = create("TextButton", {
                    BackgroundColor3 = self.Library.Theme.Stroke, BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 29), Size = UDim2.new(1, 0, 0, 12),
                    Text = "", AutoButtonColor = false,
                }, row)
                corner(track, 6)
                local fill = create("Frame", {BackgroundColor3 = self.Library.Theme.Accent, BorderSizePixel = 0, Size = UDim2.new((value-min)/(max-min),0,1,0)}, track)
                corner(fill, 6)
                local function render(fire)
                    label.Text = (opts.Name or "Slider") .. ": " .. tostring(math.floor(value * 100 + 0.5)/100)
                    fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
                    if fire and opts.Callback then opts.Callback(value) end
                end
                local function update(input)
                    local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    value = min + (max-min)*alpha
                    render(true)
                end
                track.Activated:Connect(function(input) update(input) end)
                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then update(input) end
                end)
                render(false)
                return {Get = function() return value end, Set = function(_, v) value = math.clamp(tonumber(v) or min,min,max); render(true) end}
            end
            function sec:AddDropdown(opts)
                opts = opts or {}
                local values = opts.Options or {}
                local index = 1
                local row = create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 62)}, self.Items)
                local label = textLabel(row, opts.Name or "Dropdown", 13, self.Library.Theme.Text)
                label.Size = UDim2.new(1,0,0,22)
                local button = makeButton(row, "", 32)
                button.Position = UDim2.new(0,0,0,25)
                local function render(fire)
                    button.Text = tostring(values[index] or "No options") .. "  ▾"
                    if fire and opts.Callback then opts.Callback(values[index]) end
                end
                button.Activated:Connect(function()
                    if #values > 0 then index = index % #values + 1; render(true) end
                end)
                render(false)
                return {
                    Get = function() return values[index] end,
                    Set = function(_, v)
                        for i, item in ipairs(values) do if item == v then index = i; break end end
                        render(true)
                    end,
                    Refresh = function(_, newValues) values = newValues or {}; index = 1; render(false) end,
                }
            end
            function sec:AddTextBox(opts)
                opts = opts or {}
                local row = create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1,0,0,60)}, self.Items)
                local label = textLabel(row, opts.Name or "Text box", 13, self.Library.Theme.Text)
                label.Size = UDim2.new(1,0,0,22)
                local box = create("TextBox", {
                    BackgroundColor3 = self.Library.Theme.Background,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0,0,0,25),
                    Size = UDim2.new(1,0,0,32),
                    Text = tostring(opts.Default or ""),
                    PlaceholderText = opts.Placeholder or "Enter text...",
                    TextColor3 = self.Library.Theme.Text,
                    PlaceholderColor3 = self.Library.Theme.Muted,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    ClearTextOnFocus = false,
                }, row)
                corner(box, 6); stroke(box)
                box.FocusLost:Connect(function(enterPressed)
                    if opts.Callback then opts.Callback(box.Text, enterPressed) end
                end)
                return {Get = function() return box.Text end, Set = function(_, v) box.Text = tostring(v) end, Instance = box}
            end
            function sec:AddKeybind(opts)
                opts = opts or {}
                local key = opts.Default or Enum.KeyCode.RightShift
                local listening = false
                local row = create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1,0,0,34)}, self.Items)
                local label = textLabel(row, opts.Name or "Keybind", 13, self.Library.Theme.Text)
                label.Size = UDim2.new(1,-105,1,0)
                local button = makeButton(row, key.Name, 96)
                button.Position = UDim2.new(1,-96,0,0)
                button.Activated:Connect(function() listening = true; button.Text = "Press key..." end)
                local connection
                connection = game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
                    if processed then return end
                    if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
                        key = input.KeyCode; listening = false; button.Text = key.Name
                        if opts.Callback then opts.Callback(key) end
                    elseif not listening and input.KeyCode == key then
                        if opts.Callback then opts.Callback(key) end
                    end
                end)
                return {Get = function() return key end, Set = function(_, v) if typeof(v) == "EnumItem" then key = v; button.Text = key.Name end end, Destroy = function() connection:Disconnect() end}
            end
            function sec:AddColorPicker(opts)
                opts = opts or {}
                local value = typeof(opts.Default) == "Color3" and opts.Default or self.Library.Theme.Accent
                local row = create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1,0,0,58)}, self.Items)
                local label = textLabel(row, opts.Name or "Color picker", 13, self.Library.Theme.Text)
                label.Size = UDim2.new(1,-55,0,30)
                local swatch = create("TextButton", {BackgroundColor3 = value, Position = UDim2.new(1,-45,0,2), Size = UDim2.new(0,42,0,26), Text="", AutoButtonColor=false}, row)
                corner(swatch,6); stroke(swatch)
                local hint = textLabel(row, "Tap to cycle sample colors", 10, self.Library.Theme.Muted)
                hint.Position = UDim2.new(0,0,0,30); hint.Size = UDim2.new(1,0,0,20)
                local palette = {Color3.fromRGB(255,205,65), Color3.fromRGB(90,190,255), Color3.fromRGB(160,110,255), Color3.fromRGB(90,220,145), Color3.fromRGB(255,105,125), Color3.fromRGB(245,245,248)}
                local index = 1
                swatch.Activated:Connect(function()
                    index = index % #palette + 1; value = palette[index]; swatch.BackgroundColor3 = value
                    if opts.Callback then opts.Callback(value) end
                end)
                return {Get = function() return value end, Set = function(_, v) if typeof(v)=="Color3" then value=v; swatch.BackgroundColor3=v; if opts.Callback then opts.Callback(v) end end end}
            end
            function sec:AddLabel(text)
                local label = textLabel(self.Items, tostring(text or ""), 12, self.Library.Theme.Muted)
                label.Size = UDim2.new(1,0,0,24)
                return label
            end

            return sec
        end

        function tab:AddSection(name)
            return addSection(name)
        end
        function tab:AddButton(opts)
            local section = addSection("Actions")
            return section:AddButton(opts)
        end
        function tab:AddToggle(opts)
            local section = addSection("Options")
            return section:AddToggle(opts)
        end
        function tab:AddSlider(opts)
            local section = addSection("Options")
            return section:AddSlider(opts)
        end
        function tab:AddDropdown(opts)
            local section = addSection("Options")
            return section:AddDropdown(opts)
        end
        function tab:AddTextBox(opts)
            local section = addSection("Input")
            return section:AddTextBox(opts)
        end
        function tab:AddKeybind(opts)
            local section = addSection("Controls")
            return section:AddKeybind(opts)
        end
        function tab:AddColorPicker(opts)
            local section = addSection("Appearance")
            return section:AddColorPicker(opts)
        end

        tabButton.Activated:Connect(function()
            for _, other in ipairs(self._tabs) do
                other.Page.Visible = false
                other.Button.BackgroundColor3 = self.Library.Theme.Panel
                other.Button.TextColor3 = self.Library.Theme.Text
            end
            page.Visible = true
            tabButton.BackgroundColor3 = self.Library.Theme.Accent
            tabButton.TextColor3 = Color3.fromRGB(25,25,25)
            self._activeTab = tab
        end)
        table.insert(self._tabs, tab)
        if #self._tabs == 1 then tabButton:Activate() end
        return tab
    end

    return win
end

-- Save/load settings using a JSON string. Store it in your own DataStore
-- from a server script if persistence across sessions is required.
function CAT:EncodeSettings(settings)
    return game:GetService("HttpService"):JSONEncode(settings or {})
end

function CAT:DecodeSettings(json)
    local ok, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(json)
    end)
    if ok and type(result) == "table" then return result end
    return {}
end

return CAT
