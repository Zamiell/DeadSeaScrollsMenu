---A user may have two or more mods that each use Dead Sea Scrolls, with each mod running their own
---version of "dssmenucore.lua". Thus, in order to not conflict with other versions of itself, Dead
---Sea Scrolls will defer control to whichever version currently exists with the highest version
---number.
local DSSCoreVersion = 7

---The Lua module that this file returns when end-users use `require` or `include`.
local dssmenucore = {}

---@class DSSMenuProvider
---@field GetGamepadToggleSetting fun(): number
---@field GetHudOffsetSetting fun(): number
---@field GetMenuBuzzerSetting fun(): number
---@field GetMenuHintSetting fun(): number
---@field GetMenuKeybindSetting fun(): number
---@field GetMenusNotified fun(): table<string, boolean>
---@field GetMenusPoppedUp fun(): table<string, boolean>
---@field GetPaletteSetting fun(): number
---@field SaveGamepadToggleSetting fun(gamepadToggleSetting: number): nil
---@field SaveHudOffsetSetting fun(hudOffsetSetting: number): nil
---@field SaveMenuBuzzerSetting fun(menuBuzzerSetting: number): nil
---@field SaveMenuHintSetting fun(menuHintSetting: number): nil
---@field SaveMenuKeybindSetting fun(menuKeybindSetting: number): nil
---@field SaveMenusNotified fun(menusNotified: table<string, boolean>)
---@field SaveMenusPoppedUp fun(menusPoppedUp: table<string, boolean>)
---@field SavePaletteSetting fun(paletteSetting: number): nil
---@field SaveSaveData fun(): nil

---@class Mod
---@class SoundEffect

---@class MenuSound
---@field Sound SoundEffect
---@field Volume number
---@field Pitch number
---@field PitchVariance number

---@class DSSMod: Mod
---@field menuSounds table<string, MenuSound>
---@field playSound fun(): nil A variadic method to play sounds. Allows ordered or paired tables.
---@field getInput fun(playerNum: number): nil
---@field setOption fun(variable: any, setting: any, button: any, item: any, directoryKey: any): nil
---@field generateDynamicSet fun(base: any, selected: any, fSize: any, clr: any, shine: any, noCursor: any): nil
---@field generateMenuDraw fun(item: any, buttons: any, panelPos: any, panel: any): nil
---@field drawMenu fun(tbl: any, tab: any): nil
---@field handleInputs fun(item: any, itemSwitched: any, tbl: any): nil
---@field defaultPanelStartAppear fun(panel: any, tbl: any, skipOpenAnimation: any): nil
---@field defaultPanelAppearing fun(panel: any): nil
---@field defaultPanelDisappearing fun(panel: any, tbl: any): nil
---@field defaultPanelRenderBack fun(panel: any, pos: any, tbl: any): nil
---@field defaultPanelRenderFront fun(panel: any, pos: any, tbl: any): nil
---@field panels table<string, any>
---@field defaultFormat table<string, any>
---@field runMenu fun(tbl: any): nil
---@field back fun(tbl: any): nil
---@field checkMenu fun(): nil
---@field reloadButton fun(button: any, item: any, tbl: any): nil
---@field openMenu fun(tbl: any, openedFromNothing: any)
---@field closeMenu fun(tbl: any, fullClose: any, noAnimate: any)
---@field postRender fun(): nil
---@field hudOffsetButton table<string, any>
---@field gamepadToggleButton table<string, any>
---@field menuKeybindButton table<string, any>
---@field menuHintButton table<string, any>
---@field menuBuzzerButton table<string, any>
---@field paletteButton table<string, any>
---@field changelogsButton table<string, any>
---@field menuOpenToolTip table<string, any>

---The function to initialize the Dead Sea Scrolls library, which will create a `DeadSeaScrollsMenu`
---global variable if it does not already exist.
---@param DSSModName string A string used as an identifier for your mod's menu. It should be unique.
---                         We recommend something like "Dead Sea Scrolls (Mod Name)".
---@param MenuProvider DSSMenuProvider A table that MUST implement a certain set of functions. These
---                                    are mostly data storage functions, as Dead Sea Scrolls does
---                                    not natively handle data storage. This mod has a simple data
---                                    storage implementation included that allows it to work on its
---                                    own that you can reference.
---@return DSSMod
function dssmenucore.init(DSSModName, MenuProvider)
    local dssmod = RegisterMod(DSSModName, 1)
    local game = Game()
    local sfx = SFXManager()

    local dssmenu = DeadSeaScrollsMenu

    local mfdat = {}
    mfdat['a'] = { 0, 4, 7, 11 };
    mfdat['b'] = { 1, 4, 8, 12 };
    mfdat['c'] = { 2, 4, 7, 10 };
    mfdat['d'] = { 3, 4, 8, 12 };
    mfdat['e'] = { 4, 4, 7, 10 };
    mfdat['f'] = { 5, 4, 6, 9 };
    mfdat['g'] = { 6, 5, 8, 12 };
    mfdat['h'] = { 7, 4, 8, 11 };
    mfdat['i'] = { 8, 1, 3, 4 };
    mfdat['j'] = { 9, 4, 7, 11 };
    mfdat['k'] = { 10, 4, 6, 9 };
    mfdat['l'] = { 11, 4, 8, 10 };
    mfdat['m'] = { 12, 5, 8, 13 };
    mfdat['n'] = { 13, 4, 8, 10 };
    mfdat['o'] = { 14, 5, 10, 12 };
    mfdat['p'] = { 15, 4, 7, 10 };
    mfdat['q'] = { 16, 5, 9, 13 };
    mfdat['r'] = { 17, 4, 7, 10 };
    mfdat['s'] = { 18, 4, 6, 10 };
    mfdat['t'] = { 19, 4, 7, 10 };
    mfdat['u'] = { 20, 4, 7, 13 };
    mfdat['v'] = { 21, 5, 8, 13 };
    mfdat['w'] = { 22, 5, 11, 16 };
    mfdat['x'] = { 23, 4, 6, 12 };
    mfdat['y'] = { 24, 4, 7, 10 };
    mfdat['z'] = { 25, 4, 6, 9 };
    mfdat['0'] = { 26, 4, 8, 12 };
    mfdat['1'] = { 27, 4, 8, 10 };
    mfdat['2'] = { 28, 4, 8, 10 };
    mfdat['3'] = { 29, 4, 8, 10 };
    mfdat['4'] = { 30, 4, 7, 10 };
    mfdat['5'] = { 31, 4, 8, 9 };
    mfdat['6'] = { 32, 4, 8, 10 };
    mfdat['7'] = { 33, 4, 8, 10 };
    mfdat['8'] = { 34, 4, 8, 9 };
    mfdat['9'] = { 35, 4, 8, 9 };
    mfdat["'"] = { 36, 1, 2, 3 };
    mfdat['"'] = { 37, 3, 4, 5 };
    mfdat[':'] = { 38, 1, 3, 4 };
    mfdat['/'] = { 39, 3, 6, 8 };
    mfdat['.'] = { 40, 1, 2, 4 };
    mfdat[','] = { 41, 2, 3, 4 };
    mfdat['!'] = { 42, 2, 4, 6 };
    mfdat['?'] = { 43, 3, 6, 8 };
    mfdat['['] = { 44, 2, 4, 6 };
    mfdat[']'] = { 45, 2, 4, 6 };
    mfdat['('] = { 44, 2, 4, 6 };
    mfdat[')'] = { 45, 2, 4, 6 };
    mfdat['$'] = { 46, 4, 6, 8 };
    mfdat['C'] = { 47, 5, 6, 8 };
    mfdat['+'] = { 48, 5, 6, 8 };
    mfdat['-'] = { 49, 4, 6, 10 };
    mfdat['X'] = { 50, 5, 6, 8 };
    mfdat['D'] = { 51, 5, 6, 8 };
    mfdat['%'] = { 52, 4, 6, 8 };
    mfdat['_'] = { 54, 2, 4, 5 };
    mfdat[' '] = { 54, 4, 6, 8 };
    mfdat['='] = { 53, 5, 8, 12 };
    mfdat['^'] = { 55, 3, 4, 5 };
    mfdat['<'] = { 56, 5, 7, 10 };
    mfdat['>'] = { 57, 5, 7, 10 };

    dssmod.menuSounds = {
        Pop2 = {
            Sound = Isaac.GetSoundIdByName("deadseascrolls_pop"),
            PitchVariance = .1,
        },
        Pop3 = {
            Sound = Isaac.GetSoundIdByName("deadseascrolls_pop"),
            Pitch = .8,
            PitchVariance = .1,
        },
        Open = {
            Sound = Isaac.GetSoundIdByName("deadseascrolls_whoosh"),
            Volume = .5,
            PitchVariance = .1,
        },
        Close = {
            Sound = Isaac.GetSoundIdByName("deadseascrolls_whoosh"),
            Volume = .5,
            Pitch = .8,
            PitchVariance = .1,
        }
    }

    ---A variadic method to play sounds. Allows ordered or paired tables.
    dssmod.playSound = function(...)
        local args = { ... }

        for i = 1, 6 do -- table.remove won't work to move values down if values inbetween are nil.
            if args[i] == nil then
                args[i] = -1111
            end
        end

        local npc, tbl

        if type(args[1]) == "userdata" and args[1].Type then
            npc = args[1]:ToNPC()
            table.remove(args, 1)
        end

        if type(args[1]) == "table" then
            tbl = args[1]
            table.remove(args, 1)
            if type(tbl[1]) == "table" then
                for _, sound in ipairs(tbl) do
                    if npc then
                        dssmod.playSound(npc, sound)
                    else
                        dssmod.playSound(sound)
                    end
                end

                return
            end
        elseif args[1] == -1111 then
            return
        end

        local soundArgs = {}
        for i, v in ipairs(args) do
            if v == -1111 then
                args[i] = nil
            end

            soundArgs[i] = args[i]
        end

        if tbl then
            if #tbl > 0 then
                soundArgs = tbl
            else
                soundArgs = { tbl.Sound, tbl.Volume, tbl.Delay, tbl.Loop, tbl.Pitch }
            end

            -- If there are any remaining args after npc and table are removed, they override
            -- volume, delay, loop, and pitch.
            for i = 1, 4 do
                if args[i] ~= nil then
                    soundArgs[i + 1] = args[i]
                end
            end
        end

        soundArgs[2] = soundArgs[2] or 1
        soundArgs[3] = soundArgs[3] or 0
        soundArgs[4] = soundArgs[4] or false
        soundArgs[5] = soundArgs[5] or 1

        if tbl and tbl.PitchVariance then
            local variance = math.random()
            if tbl.NegativeVariance then
                variance = variance - 0.5
            end

            soundArgs[5] = soundArgs[5] + variance * tbl.PitchVariance
        end

        if npc then
            npc:PlaySound(table.unpack(soundArgs))
        else
            sfx:Play(table.unpack(soundArgs))
        end
    end

    local menuSounds = dssmod.menuSounds
    local PlaySound = dssmod.playSound

    local function getScreenBottomRight()
        return game:GetRoom():GetRenderSurfaceTopLeft() * 2 + Vector(442, 286)
    end

    local function getScreenCenterPosition()
        return getScreenBottomRight() / 2
    end

    local function approach(aa, bb, cc)
        cc = cc or 1
        if bb > aa then
            return math.min(aa + cc, bb)
        elseif bb < aa then
            return math.max(aa - cc, bb)
        else
            return bb
        end
    end

    local function Lerp(aa, bb, cc)
        return (aa + (bb - aa) * cc)
    end

    local function KeysShareVals(tbl1, tbl2)
        if not tbl1 or not tbl2 then
            return false
        end

        for k, v in pairs(tbl1) do
            if tbl2[k] ~= v then
                return false
            end
        end

        for k, v in pairs(tbl2) do
            if tbl1[k] ~= v then
                return false
            end
        end

        return true
    end

    local function SafeKeyboardTriggered(key, controllerIndex)
        return Input.IsButtonTriggered(key, controllerIndex)
            and not Input.IsButtonTriggered(key % 32, controllerIndex)
    end

    local function AnyKeyboardTriggered(key, controllerIndex)
        if SafeKeyboardTriggered(key, controllerIndex) then
            return true
        end

        for i = 0, 4 do
            if SafeKeyboardTriggered(key, i) then
                return true
            end
        end

        return false
    end

    local function SafeKeyboardPressed(key, controllerIndex)
        return Input.IsButtonPressed(key, controllerIndex)
            and not Input.IsButtonPressed(key % 32, controllerIndex)
    end

    local inputButtonNames = {
        [-1] = "none",
        [0] = "dpad left",
        [1] = "dpad right",
        [2] = "dpad up",
        [3] = "dpad down",
        [4] = "action down",
        [5] = "action right",
        [6] = "action left",
        [7] = "action up",
        [8] = "left bumper",
        [9] = "left trigger",
        [10] = "left stick",
        [11] = "right bumper",
        [12] = "right trigger",
        [13] = "right stick",
        [14] = "select",
        [15] = "start",
        [Keyboard.KEY_KP_0] = "numpad 0",
        [Keyboard.KEY_KP_1] = "numpad 1",
        [Keyboard.KEY_KP_2] = "numpad 2",
        [Keyboard.KEY_KP_3] = "numpad 3",
        [Keyboard.KEY_KP_4] = "numpad 4",
        [Keyboard.KEY_KP_5] = "numpad 5",
        [Keyboard.KEY_KP_6] = "numpad 6",
        [Keyboard.KEY_KP_7] = "numpad 7",
        [Keyboard.KEY_KP_8] = "numpad 8",
        [Keyboard.KEY_KP_9] = "numpad 9",
        [Keyboard.KEY_KP_DECIMAL] = "numpad decimal",
        [Keyboard.KEY_KP_DIVIDE] = "numpad divide",
        [Keyboard.KEY_KP_MULTIPLY] = "numpad multiply",
        [Keyboard.KEY_KP_SUBTRACT] = "numpad subtract",
        [Keyboard.KEY_KP_ADD] = "numpad add",
        [Keyboard.KEY_KP_ENTER] = "numpad enter",
        [Keyboard.KEY_KP_EQUAL] = "numpad equal",
    }

    for k, v in pairs(Keyboard) do
        if not inputButtonNames[v] then
            local name = string.sub(k, 5)
            name = name:gsub("_", " ")
            name = name:lower()
            inputButtonNames[v] = name
        end
    end

    local function GetInputtedButtons(controllerIndex, press)
        local func = SafeKeyboardTriggered
        if press then
            func = SafeKeyboardPressed
        end

        local inputs = {}
        for i = 0, 15 do
            if func(i, controllerIndex) then
                inputs[#inputs + 1] = i
            end
        end

        for name, key in pairs(Keyboard) do
            if func(key, controllerIndex) then
                inputs[#inputs + 1] = key
            end
        end

        return inputs
    end

    local menuinput
    local function InitializeInput()
        if not menuinput then
            menuinput = {
                raw = {
                    up = -100, down = -100, left = -100, right = -100,
                },
                menu = {
                    up = false,
                    down = false,
                    left = false,
                    right = false,
                    toggle = false,
                    confirm = false,
                    back = false,
                    keybinding = false,
                },
            }
        end
    end

    function dssmod.getInput(playerNum)
        local player = Isaac.GetPlayer(playerNum)

        InitializeInput()

        local input = menuinput
        local indx = player.ControllerIndex

        local raw = input.raw
        local menu = input.menu
        if not game:IsPaused() then
            local moveinput = player:GetMovementInput()
            local moveinputang = moveinput:GetAngleDegrees()
            local digitalmovedir = math.floor(4 + (moveinputang + 45) / 90) % 4
            local movelen = moveinput:Length()

            if (movelen > .3 and digitalmovedir == 0)
                or SafeKeyboardPressed(Keyboard.KEY_RIGHT, indx)
                or SafeKeyboardPressed(Keyboard.KEY_D, indx) then
                raw.right = math.max(raw.right, 0) + 1
            else
                raw.right = math.max(-100, math.min(1, raw.right) - 1)
            end

            if (movelen > .3 and digitalmovedir) == 1
                or SafeKeyboardPressed(Keyboard.KEY_DOWN, indx)
                or SafeKeyboardPressed(Keyboard.KEY_S, indx) then
                raw.down = math.max(raw.down, 0) + 1
            else
                raw.down = math.max(-100, math.min(1, raw.down) - 1)
            end
            if (movelen > .3 and digitalmovedir) == 2
                or SafeKeyboardPressed(Keyboard.KEY_LEFT, indx)
                or SafeKeyboardPressed(Keyboard.KEY_A, indx) then
                raw.left = math.max(raw.left, 0) + 1
            else
                raw.left = math.max(-100, math.min(1, raw.left) - 1)
            end
            if (movelen > .3 and digitalmovedir) == 3
                or SafeKeyboardPressed(Keyboard.KEY_UP, indx)
                or SafeKeyboardPressed(Keyboard.KEY_W, indx) then
                raw.up = math.max(raw.up, 0) + 1
            else
                raw.up = math.max(-100, math.min(1, raw.up) - 1)
            end

            local dssmenu = DeadSeaScrollsMenu
            local ctog = dssmenu.GetGamepadToggleSetting() or 1

            local baseKey = dssmenu.GetMenuKeybindSetting()
            local safeKey = Keyboard.KEY_F1

            --toggle
            menu.toggle = AnyKeyboardTriggered(safeKey, indx)
                or (ctog <= 2 and Input.IsButtonTriggered(10, indx))
                or ((ctog == 1 or ctog == 3) and Input.IsButtonTriggered(13, indx))
                or (ctog == 4 and Input.IsButtonTriggered(10, indx) and Input.IsButtonPressed(13, indx))
                or (ctog == 4 and Input.IsButtonTriggered(13, indx) and Input.IsButtonPressed(10, indx))
                or (ctog == 5 and Input.IsButtonTriggered(14, indx))
                or (ctog == 6 and Input.IsButtonPressed(12, indx) and Input.IsButtonTriggered(14, indx))

            if baseKey ~= -1 then
                menu.toggle = menu.toggle or AnyKeyboardTriggered(baseKey, indx)
            end

            --confirm
            menu.confirm = SafeKeyboardTriggered(Keyboard.KEY_ENTER, indx) or
                SafeKeyboardTriggered(Keyboard.KEY_SPACE, indx) or
                SafeKeyboardTriggered(Keyboard.KEY_E, indx) or
                Input.IsButtonTriggered(4, indx) or
                Input.IsButtonTriggered(7, indx)

            --back
            menu.back = SafeKeyboardTriggered(Keyboard.KEY_BACKSPACE, indx) or
                SafeKeyboardTriggered(Keyboard.KEY_Q, indx) or
                Input.IsButtonTriggered(5, indx) or
                Input.IsButtonTriggered(6, indx)

            --directions
            menu.up = raw.up == 1 or (raw.up >= 18 and raw.up % 6 == 0)
            menu.down = raw.down == 1 or (raw.down >= 18 and raw.down % 6 == 0)
            menu.left = raw.left == 1 or (raw.left >= 18 and raw.left % 6 == 0)
            menu.right = raw.right == 1 or (raw.right >= 18 and raw.right % 6 == 0)

            menu.keybind = nil
            if menu.keybinding then
                menu.toggle = false
                menu.confirm = false
                menu.back = false
                menu.up = false
                menu.down = false
                menu.left = false
                menu.right = false
                local buttons = GetInputtedButtons(indx)
                if #buttons == 1 then
                    menu.keybind = buttons[1]
                end
            end
        end
    end

    function dssmod.setOption(variable, setting, button, item, directoryKey)
        if setting then
            if variable then
                directoryKey.Settings[variable] = setting
                directoryKey.SettingsChanged = true
            end

            if button and button.changefunc then
                button.changefunc(button, item)
            end
        end
    end

    local function hsvToRGB(hue, saturation, value, alpha) --credit EmmanuelOga
        local r, g, b

        local i = math.floor(hue * 6);
        local f = hue * 6 - i;
        local p = value * (1 - saturation);
        local q = value * (1 - f * saturation);
        local t = value * (1 - (1 - f) * saturation);

        i = i % 6

        if i == 0 then
            r, g, b = value, t, p
        elseif i == 1 then
            r, g, b = q, value, p
        elseif i == 2 then
            r, g, b = p, value, t
        elseif i == 3 then
            r, g, b = p, q, value
        elseif i == 4 then
            r, g, b = t, p, value
        elseif i == 5 then
            r, g, b = value, p, q
        end

        return Color(r, g, b, alpha, 0, 0, 0)
    end

    local function buttonSelectionToXY(buttonSelection, gridX, buttons)
        local x = 1
        local y = 1
        local buttonSelectionX
        local bselY
        local maxX = {}
        for i, button in ipairs(buttons) do
            if i == buttonSelection then
                buttonSelectionX, bselY = x, y
            end

            if i == #buttons then
                maxX[y] = x
                return buttonSelectionX, bselY, maxX, y
            end

            local prevX = x
            x = x + (button.fullRow and gridX or 1)
            if x > gridX then
                maxX[y] = prevX
                y = y + 1
                x = 1
            end
        end
    end

    local function xyToButtonSelection(x, y, gridX, buttons)
        local x2, y2 = 1, 1
        for i, button in ipairs(buttons) do
            if x2 == x and y2 == y then
                return i
            end

            x2 = x2 + (button.fullRow and gridX or 1)
            if x2 > gridX then
                y2 = y2 + 1
                x2 = 1
            end
        end
    end

    local fontspacers = { 8, 12, 16 }


    local function getMenuStringLength(str, fSize)
        fSize = fSize + 1
        local length = 0
        local chr = {}
        for i = 1, string.len(str) do
            local sub = string.sub(str, i, i)
            if not mfdat[sub] then
                Isaac.ConsoleOutput("Invalid character " .. sub .. "!\n")
                sub = '!'
            end

            local len = mfdat[sub][fSize]
            table.insert(chr, { sub, length })
            length = length + len + 1
        end

        return length, chr
    end

    function dssmod.generateDynamicSet(base, selected, fSize, clr, shine, noCursor)
        local dssmenu = DeadSeaScrollsMenu
        local menuPalette = dssmenu.GetPalette()
        local rainbow = menuPalette.Rainbow
        fSize = base.fSize or fSize or 2
        local clr1 = menuPalette[2]
        local clr2 = menuPalette[3]
        local useclr = base.clr or clr or 2
        useclr = menuPalette[useclr]
        local shine = base.shine or shine

        local height = 0

        -- Since buttons are arranged vertically, only the widest part of the button should count
        -- for width.
        local width = {}

        local dynamicSet = {
            type = 'dynamicset',
            selected = selected,
            set = {},
            pos = base.pos or Vector(0, 0),
        }

        local modules = {}
        if base.strpair then
            local part = base.strpair[1]
            modules[#modules + 1] = {
                type = 'str',
                str = part.str,
                height = 0,
                hAlign = -1,
                color = useclr,
                alpha = part.alpha,
                shine = shine
            }

            local part = base.strpair[2]
            modules[#modules + 1] = {
                type = 'str',
                str = part.str,
                hAlign = 1,
                color = clr2,
                alpha = part.alpha,
                shine = shine,
                select = false
            }
        elseif base.str then
            modules[#modules + 1] = {
                type = 'str',
                str = base.str,
                color = useclr,
                alpha = 1,
                shine = shine,
            }

            if base.substr then
                local subsize = base.substr.size or math.max(1, fSize - 1)
                modules[#modules + 1] = {
                    type = 'str',
                    str = base.substr.str,
                    size = subsize,
                    color = clr2,
                    alpha = base.substr.alpha or .8,
                    shine = shine,
                    select = false
                }
            end
        elseif base.strset then
            for i, str in ipairs(base.strset) do
                local newstr = { type = 'str', str = str }
                if i ~= 1 then
                    newstr.select = false
                end

                modules[#modules + 1] = newstr
            end
        elseif base.spr then
            modules[#modules + 1] = {
                type = 'spr',
                fontColor = useclr,
                color = base.spr.color,
                sprite = base.spr.sprite,
                center = base.spr.center,
                centerX = base.spr.centerX,
                centerY = base.spr.centerY,
                width = base.spr.width,
                height = base.spr.height,
                float = base.spr.float,
                shadow = base.spr.shadow,
                invisible = base.spr.invisible,
                scale = base.spr.scale
            }
        end

        if base.variable or base.setting then
            local sizedown = math.max(1, fSize - 1)
            local select = false --- @type boolean | nil
            if base.inline then
                sizedown = fSize
                select = nil
            end

            local setting = {
                type = 'str',
                settingscursor = not base.keybind,
                size = sizedown,
                color = clr2,
                alpha = .8,
                shine = shine,
                select = select,
                inline = base.inline
            }
            setting.min = base.min
            setting.max = base.max
            setting.setting = base.setting
            if base.slider then
                setting.slider = true
                setting.increment = base.increment
                setting.str = ''
                for i = 1, math.ceil(base.max / base.increment) do
                    setting.str = setting.str .. 'i'
                end
            elseif base.choices then
                setting.choices = #base.choices
                setting.str = base.choices[base.setting]
            elseif base.max then
                setting.str = (base.pref or '') .. base.setting .. (base.suf or '')
            elseif base.keybind then
                if base.keybinding then
                    setting.str = '[awaiting input]'
                else
                    setting.str = '[' .. inputButtonNames[base.setting] .. ']'
                end
            end

            modules[#modules + 1] = setting
        end

        for _, module in ipairs(modules) do
            if module.type == 'str' then
                if module.size == nil then module.size = fSize end
                if module.height == nil then module.height = fontspacers[module.size] end

                local fullstr = module.str
                if type(module.str) == "table" then
                    fullstr = ''
                    for _, val in ipairs(module.str) do
                        fullstr = fullstr .. val.str
                    end
                end

                local length, chr = getMenuStringLength(fullstr, module.size)
                module.len = length
                module.chr = chr
                width[#width + 1] = length
            else
                width[#width + 1] = module.width
            end

            if module.noCursor == nil then module.noCursor = noCursor end
            if module.colorSelect == nil then module.colorSelect = base.colorSelect end
            if module.select == nil then module.select = selected end
            if module.useMenuClr == nil then module.useMenuClr = base.useMenuClr end
            if module.useColorize == nil then module.useColorize = base.useColorize end
            if module.palColor == nil then module.palColor = base.palColor end
            if module.glowColor == nil then module.glowColor = base.glowColor end
            if module.glowTime == nil then module.glowTime = base.glowTime end
            if module.noClip == nil then module.noClip = base.noClip end
            if module.cursorOff == nil then module.cursorOff = base.cursorOff end

            module.ref = base

            height = height + module.height
            module.rainbow = rainbow or nil
            table.insert(dynamicSet.set, module)
        end

        dynamicSet.width = math.max(table.unpack(width))
        dynamicSet.height = height

        if base.fullRow then dynamicSet.fullRow = true end

        return dynamicSet
    end

    function dssmod.generateMenuDraw(item, buttons, panelPos, panel)
        local dssmenu = DeadSeaScrollsMenu
        local menuPalette = dssmenu.GetPalette()
        local rainbow = menuPalette.Rainbow

        local drawings = {}
        local vAlign = item.vAlign or 0
        local hAlign = item.hAlign or 0
        local fSize = item.fSize or panel.DefaultFontSize or 3
        local noCursor = (item.noCursor or item.scroller)
        local width = 82
        local seloff = 0

        local dynamicSet = {
            type = 'dynamicset',
            set = {},
            vAlign = vAlign,
            hAlign = hAlign,
            width = width,
            height = 0,
            pos = panel.DrawPositionOffset or Vector.Zero,
            centerItems = item.centerItems
        }

        if item.gridX then
            dynamicSet.gridX = item.gridX
            dynamicSet.widest = 0
            dynamicSet.highest = 0
        end

        --buttons
        local bsel = item.bsel
        if buttons then
            for i, btn in ipairs(buttons) do
                if not btn.forcenodisplay then
                    local btnset = dssmod.generateDynamicSet(
                        btn,
                        btn.selected,
                        fSize,
                        item.clr,
                        item.shine,
                        noCursor
                    )

                    if dynamicSet.widest then
                        if btnset.width > dynamicSet.widest then
                            dynamicSet.widest = btnset.width
                        end
                    end

                    if dynamicSet.highest then
                        if btnset.height > dynamicSet.highest then
                            dynamicSet.highest = btnset.height
                        end
                    end

                    table.insert(dynamicSet.set, btnset)

                    dynamicSet.height = dynamicSet.height + btnset.height

                    if btn.selected then
                        seloff = dynamicSet.height - btnset.height / 2
                    end
                end
            end
        end

        if dynamicSet.gridX then
            dynamicSet.height = 0

            local gridX, gridY = 1, 1
            local rowDrawings = {}
            for i, drawing in ipairs(dynamicSet.set) do
                if drawing.fullRow then
                    if #rowDrawings > 0 then
                        rowDrawings = {}
                        gridY = gridY + 1
                    end

                    gridX = math.ceil(dynamicSet.gridX / 2)
                    drawing.hAlign = -2
                end

                drawing.gridXPos = gridX
                drawing.gridYPos = gridY

                rowDrawings[#rowDrawings + 1] = drawing

                local highestInRow, widestInRow, buttonSelectionInRow
                for _, rowDrawing in ipairs(rowDrawings) do
                    if not highestInRow or rowDrawing.height > highestInRow then
                        highestInRow = rowDrawing.height
                    end

                    if not widestInRow or rowDrawing.width > widestInRow then
                        widestInRow = rowDrawing.width
                    end

                    buttonSelectionInRow = buttonSelectionInRow or rowDrawing.buttonSelectionInRow or rowDrawing
                        .selected
                end

                for _, rowDrawing in ipairs(rowDrawings) do
                    rowDrawing.highestInRow = highestInRow
                    rowDrawing.widestInRow = widestInRow
                    rowDrawing.buttonSelectionInRow = buttonSelectionInRow
                end

                gridX = gridX + 1
                if gridX > dynamicSet.gridX
                    or i == #dynamicSet.set
                    or drawing.fullRow
                    or (dynamicSet.set[i + 1] and dynamicSet.set[i + 1].fullRow) then
                    dynamicSet.height = dynamicSet.height + highestInRow
                    if buttonSelectionInRow then
                        seloff = dynamicSet.height - highestInRow / 2
                    end

                    rowDrawings = {}
                    gridY = gridY + 1
                    gridX = 1
                end
            end
        end

        local yOffset = -(dynamicSet.height / 2)

        if panel.Bounds then
            if yOffset < panel.Bounds[2] + panel.TopSpacing then
                yOffset = panel.Bounds[2] + panel.TopSpacing
            end

            if item.vAlign == -1 then
                yOffset = panel.Bounds[2] + panel.TopSpacing
            elseif item.vAlign == 1 then
                yOffset = (panel.Bounds[4] - panel.BottomSpacing) - dynamicSet.height
            end
        end

        if not item.noscroll then
            if item.scroller then
                item.scroll = item.scroll or 0
                item.scroll = math.max(
                    panel.Height / 2,
                    math.min(item.scroll, dynamicSet.height - panel.Height / 2)
                )
                seloff = item.scroll
            end

            if dynamicSet.height > panel.Height - (panel.TopSpacing + panel.BottomSpacing) then
                seloff = -seloff + panel.Height / 2
                seloff = math.max(
                    -dynamicSet.height + panel.Height - panel.BottomSpacing,
                    math.min(0, seloff)
                )
                if item.vScroll then
                    item.vScroll = Lerp(item.vScroll, seloff, .2)
                else
                    item.vScroll = seloff
                end
                dynamicSet.pos = Vector(0, item.vScroll)
            end
        end

        dynamicSet.pos = dynamicSet.pos + Vector(0, yOffset)
        table.insert(drawings, dynamicSet)

        --scroll indicator
        if item.scroller and item.scroll then
            local jumpy = (game:GetFrameCount() % 20) / 10
            if item.scroll > panel.Height / 2 then
                local sym = {
                    type = 'sym',
                    frame = 9,
                    pos = Vector(panel.ScrollerSymX, panel.ScrollerSymYTop - jumpy),
                }
                table.insert(drawings, sym)
            end

            if item.scroll < dynamicSet.height - panel.Height / 2 then
                local sym = {
                    type = 'sym',
                    frame = 10,
                    pos = Vector(panel.ScrollerSymX, panel.ScrollerSymYBottom + jumpy)
                }
                table.insert(drawings, sym)
            end
        end

        --title
        if item.title then
            local title = {
                type = 'str',
                str = item.title,
                size = 3,
                color = menuPalette[3],
                pos = panel.TitleOffset,
                hAlign = 0,
                underline = true,
                bounds = false
            }
            title.rainbow = rainbow or nil
            table.insert(drawings, title)
        end

        for _, drawing in ipairs(drawings) do
            if drawing.bounds == nil then drawing.bounds = panel.Bounds end
            if drawing.root == nil then drawing.root = panelPos end
        end

        return drawings
    end

    function dssmod.drawMenu(tbl, tab)
        local dType = tab.type
        local scale = tab.scale or Vector(1, 1)
        local root = tab.root or getScreenCenterPosition()
        local pos = tab.pos or Vector(0, 0)
        local dssmenu = DeadSeaScrollsMenu
        tbl = tbl or dssmenu.OpenedMenu
        local uispr = tbl.MenuSprites or dssmenu.GetDefaultMenuSprites()
        local font = uispr.Font
        local menuspr = uispr.Symbols
        local menuPalette = dssmenu.GetPalette()
        local alpha = tab.alpha or 1
        local color = tab.color
            or (tab.sprite and not tab.usemenuclr and Color(1, 1, 1, 1, 0, 0, 0))
            or menuPalette[tab.palColor or 2]
        local fontColor = tab.fontColor or color
        if type(fontColor) == "number" then
            fontColor = menuPalette[fontColor]
        end

        local shine = tab.shine or 0
        local bottomcutoff = false

        if tab.glowColor then
            local glowLength = tab.glowtime or 60
            local glowTime = game:GetFrameCount() % glowLength
            local percent
            if glowTime <= (glowLength / 2) then
                percent = glowTime / (glowLength / 2)
            else
                percent = (glowTime - (glowLength / 2)) / (glowLength / 2)
                percent = 1 - percent
            end

            if type(tab.glowColor) == "number" then
                color = Color.Lerp(color, menuPalette[tab.glowColor], percent)
                fontColor = Color.Lerp(fontColor, menuPalette[tab.glowColor], percent)
            else
                color = Color.Lerp(color, tab.glowColor, percent)
                fontColor = Color.Lerp(fontColor, tab.glowColor, percent)
            end
        end

        if tab.rainbow then
            local hue = pos.Y % 256
            if tab.glowColor then
                local glowLength = tab.glowtime or 60
                local glowTime = game:GetFrameCount() % glowLength
                hue = hue + (glowTime / glowLength) * 255
                hue = hue % 256
            end

            color = hsvToRGB(hue / 255, 1, 1, 1)
            fontColor = hsvToRGB(hue / 255, 1, 1, 1)
        end

        if tab.colorselect and not tab.select then
            alpha = alpha / 2
        end

        color = Color(color.R, color.G, color.B, alpha, shine, shine, shine)
        if tab.usecolorize then
            local r, g, b = color.R, color.G, color.B
            color = Color(1, 1, 1, alpha, shine, shine, shine)
            color:SetColorize(r, g, b, 1)
        end

        fontColor = Color(fontColor.R, fontColor.G, fontColor.B, alpha, shine, shine, shine)
        local fnames = { '12', '16', '24' }
        local scaler = { 8, 12, 16 }

        local selectCursorPos
        local settingsCursorXPlace

        if dType == 'sym' then
            menuspr.Color = color
            menuspr:SetFrame("Sym", tab.frame or 6)
            menuspr:Render(root + pos, Vector(0, 0), Vector(0, 0))
        elseif dType == 'spr' then
            local uSprite = tab.sprite
            local floatY = 0
            if tab.float then
                floatY = Vector(0, tab.float[1]):Rotated((game:GetFrameCount() * tab.float[2]) % 360)
                floatY = floatY.Y
            end

            if (tab.center or tab.centerX) and tab.width then
                pos = pos - Vector(tab.width / 2 * scale.X, 0)
            end

            if (tab.center or tab.centerY) and tab.height then
                pos = pos - Vector(0, tab.height / 2 * scale.Y)
            end

            pos = pos + Vector(0, floatY)

            local clipt = 0
            local clipb = 0
            if tab.bounds and not tab.noClip then
                clipt = math.min(math.max(0, tab.bounds[2] - pos.Y))
                clipb = math.min(math.max(0, (pos.Y + tab.height - 16) - tab.bounds[4]))
            end

            if tab.anim then
                uSprite:SetAnimation(tab.anim, false)
            end

            if tab.frame then
                uSprite:SetFrame(tab.frame)
            end

            if tab.height and clipt + clipb >= tab.height then
                bottomcutoff = clipb >= tab.height
            else
                uSprite.Scale = scale
                if tab.shadow then
                    uSprite.Color = Color(0, 0, 0, alpha / 2, 0, 0, 0)
                    uSprite:Render(root + pos + scale, Vector(0, clipt), Vector(0, clipb))
                end

                if not tab.invisible then
                    uSprite.Color = color

                    if tab.ref then
                        tab.ref.renderedtopos = root + pos
                    end

                    uSprite:Render(root + pos, Vector(0, clipt), Vector(0, clipb))
                end
            end

            if tab.height then
                selectCursorPos = pos + Vector(-12, tab.height / 2 * scale.Y)
            end
        elseif dType == 'str' then
            tab.size = tab.size or 1
            tab.str = tab.str or 'nostring'
            tab.hAlign = tab.hAlign or 0

            local str = tab.str
            local fullstr = str
            if type(str) == "table" then
                fullstr = ''
                for _, val in ipairs(str) do
                    fullstr = fullstr .. val.str
                end
            end

            local idx = tab.size + 1
            if not tab.chr or not tab.len then
                tab.len, tab.chr = getMenuStringLength(fullstr, tab.size)
            end

            -- drawing string
            local fname = fnames[tab.size]
            local myscale = scaler[tab.size]
            font.Scale = scale
            -- Horizontal alignment is handled by text when it is drawn, vertical alignment is
            -- handled by main generator.
            local xoff = ((tab.hAlign == 0 and tab.len / -2) or (tab.hAlign == 1 and tab.len * -1) or 0) +
                ((tab.parentwidth or 82) * tab.hAlign)
            if tab.hAlign == -2 then
                xoff = 0
            end

            local clipt = 0
            local clipb = 0
            local usepos = pos + Vector(xoff, 0)

            local wtf = tab.size == 1 and -8 or tab.size == 2 and -4 or 0
            if tab.bounds and not tab.noClip then
                clipt = math.min(math.max(0, tab.bounds[2] - (usepos.Y)), myscale) -- myscale
                clipb = math.min(math.max(0, (usepos.Y + wtf) - tab.bounds[4]), myscale)
            end

            if clipt + clipb >= myscale then
                bottomcutoff = clipb >= myscale
            else
                for i, chr in ipairs(tab.chr) do
                    local substr
                    local usecolor = fontColor
                    if type(str) == "table" then
                        local j = 0
                        for _, val in ipairs(str) do
                            if not substr and i <= (j + string.len(val.str)) then
                                substr = val
                            end

                            j = j + string.len(val.str)
                        end
                    end

                    if substr then
                        if substr.color then
                            if type(substr.color) == "number" then
                                usecolor = menuPalette[substr.color]
                            else
                                usecolor = substr.color
                            end
                        end
                    end

                    font.Color = usecolor

                    local fpos = usepos + Vector(chr[2], 0)
                    if tab.slider then
                        local iii = math.ceil(tab.max / tab.increment)
                        if i > iii * (tab.setting / tab.max) then
                            font.Color = Color(usecolor.R, usecolor.G, usecolor.B, tab.alpha / 2, 0, 0, 0)
                        end
                    end

                    if (not tab.bounds) or (clipt < myscale and clipb < myscale) then
                        if tab.hintletter then
                            if tab.hintletter == chr[1] then
                                font.Color = Color(usecolor.R, usecolor.G, usecolor.B, alpha * 0.83, 0, 0, 0)
                            else
                                font.Color = Color(usecolor.R, usecolor.G, usecolor.B, alpha, 0, 0, 0)
                            end
                        end

                        font:SetFrame(fname, mfdat[chr[1]][1])
                        font:Render(root + fpos, Vector(0, clipt), Vector(0, clipb))
                    end
                end

                --underline
                if tab.underline then
                    menuspr:SetFrame("Sym", 0)
                    menuspr.Color = fontColor
                    menuspr:Render(root + pos + Vector(0, 16) + Vector(0, myscale / 2), Vector(0, 0), Vector(0, 0))
                end
            end

            selectCursorPos = pos + Vector(xoff - 12, myscale / 2)
            if tab.size == 1 then
                selectCursorPos = pos + Vector(xoff - 6, myscale / 2)
            end

            if tab.inline and tab.setting ~= 1 then
                selectCursorPos = selectCursorPos + Vector(-16, 0)
            end

            settingsCursorXPlace = math.max(40, -xoff + 10)
        elseif dType == 'dynamicset' then
            local yy = 0

            if tab.gridX and tab.centerItems then
                yy = yy + tab.highest / 2
            end

            for i, drawing in ipairs(tab.set) do
                drawing.root = root
                drawing.bounds = tab.bounds

                if tab.gridX then
                    local totalwidth = tab.gridX * drawing.widestInRow
                    local x = drawing.gridXPos - 1
                    local xPos = (-totalwidth / 2) + Lerp(0, totalwidth - drawing.widestInRow, x / (tab.gridX - 1))
                    drawing.pos = (drawing.pos or Vector(0, 0)) + pos + Vector(xPos, yy)

                    if tab.centerItems then
                        local widthDiff = drawing.widestInRow - drawing.width
                        local heightDiff = drawing.highestInRow - drawing.height
                        drawing.pos = drawing.pos +
                            Vector(widthDiff / 2 + drawing.width / 2, -heightDiff / 2 - drawing.height / 2)
                    end

                    if tab.set[i + 1] and tab.set[i + 1].gridYPos > drawing.gridYPos then
                        yy = yy + drawing.highestInRow
                    end
                else
                    drawing.pos = (drawing.pos or Vector(0, 0)) + pos + Vector(0, yy)
                    yy = yy + (drawing.height or 16)
                end

                drawing.hAlign = drawing.hAlign or tab.hAlign
                drawing.width = drawing.width or tab.width or 82
                drawing.parentwidth = tab.parentwidth or tab.width or drawing.width or 82
            end

            for i, drawing in ipairs(tab.set) do
                drawing.pos = drawing.pos
                if dssmod.drawMenu(tbl, drawing) then -- returns true if cutoff
                    return true
                end
            end
        end

        -- draw selected / choice arrows

        -- selected
        if tab.select and not tab.noCursor and selectCursorPos then
            if tab.size == 1 then
                menuspr:SetFrame("Sym", 2)
            else
                menuspr:SetFrame("Sym", 1)
            end

            if tab.cursorOff then
                selectCursorPos = selectCursorPos + tab.cursorOff
            end

            menuspr.Color = fontColor

            local clipt = math.min(math.max(0, tab.bounds[2] - (selectCursorPos.Y - 8)), 16)
            local clipb = math.min(math.max(0, (selectCursorPos.Y - 8) - tab.bounds[4]), 16)
            menuspr:Render(root + selectCursorPos, Vector(0, clipt), Vector(0, clipb))
        end

        -- choices
        if tab.settingscursor and settingsCursorXPlace then
            menuspr.Color = fontColor
            if (tab.choices and tab.setting > 1) or (tab.max and tab.setting > (tab.min or 0)) then
                menuspr:SetFrame("Sym", 8)

                local sympos = pos + Vector(-settingsCursorXPlace, 7)
                local clipt = math.min(math.max(0, tab.bounds[2] - (sympos.Y - 8)), 16)
                local clipb = math.min(math.max(0, (sympos.Y - 8) - tab.bounds[4]), 16)
                menuspr:Render(root + sympos, Vector(0, clipt), Vector(0, clipb))
            end

            if (tab.choices and tab.setting < tab.choices) or (tab.max and tab.setting < tab.max) then
                menuspr:SetFrame("Sym", 7)

                local sympos = pos + Vector(settingsCursorXPlace, 7)
                local clipt = math.min(math.max(0, tab.bounds[2] - (sympos.Y - 8)), 16)
                local clipb = math.min(math.max(0, (sympos.Y - 8) - tab.bounds[4]), 16)
                menuspr:Render(root + sympos, Vector(0, clipt), Vector(0, clipb))
            end
        end

        if bottomcutoff then
            return true
        end
    end

    function dssmod.handleInputs(item, itemSwitched, tbl)
        local directory = tbl.Directory
        local directoryKey = tbl.DirectoryKey
        local input = menuinput.menu
        local buttonSelection = item.buttonSelection or 1
        local buttons = item.buttons
        local action = false
        local func = nil
        local changeFunc = nil
        local prevButton = nil
        local dest = false
        local button = false
        local allNoSel = false
        local buttonInteracted = false
        local buttonSelectionChanged

        if item.scroller then
            item.scroll = item.scroll or 0
            if input.down then
                item.scroll = item.scroll + 16
            elseif input.up then
                item.scroll = item.scroll - 16
            end
        end

        --buttons
        if buttons and #buttons > 0 then
            --button selection
            item.buttonSelection = math.min((item.buttonSelection or 1), #buttons)

            allNoSel = true
            for i, button in ipairs(buttons) do
                if button.originalNoSel == nil then
                    if button.noSel == nil then
                        button.originalNoSel = false
                    else
                        button.originalNoSel = button.noSel
                    end
                end

                button.selected = false
                if button.generate and itemSwitched then
                    button.generate(button, item, tbl)
                end

                if button.update then
                    button.update(button, item, tbl)
                end

                if button.display ~= nil or button.displayIf then
                    if button.display == false
                        or (button.displayIf and not button.displayIf(button, item, tbl)) then
                        button.noSel = true
                        button.forceNoDisplay = true
                    elseif button.forceNoDisplay then
                        button.noSel = button.originalNoSel
                        button.forceNoDisplay = nil
                    end
                end

                if not button.noSel then
                    -- Select the first selectable button if the currently selected button is not
                    -- selectable.
                    if allNoSel and item.buttonSelection < i then
                        item.buttonSelection = i
                    end

                    allNoSel = false
                end
            end

            local previousButtonSelection = item.buttonSelection
            if buttons[item.buttonSelection].changefunc then
                prevButton = buttons[item.buttonSelection]
                changeFunc = buttons[item.buttonSelection].changefunc
            end

            if allNoSel then
                item.buttonSelection = 1
            elseif item.gridX then
                local firstLoop = true --- @type boolean | nil
                local tryKeepX, tryKeepY
                while buttons[item.buttonSelection].noSel or firstLoop do
                    local x, y, maxX, maxY = buttonSelectionToXY(item.buttonSelection, item.gridX, buttons)
                    if tryKeepX then
                        x = tryKeepX
                        tryKeepX = nil
                    end

                    if tryKeepY then
                        y = tryKeepY
                        tryKeepY = nil
                    end

                    if input.up then
                        y = y - 1
                    elseif input.down then
                        y = y + 1
                    elseif input.left then
                        x = x - 1
                    elseif input.right then
                        x = x + 1
                    end

                    local prevX, prevY = x, y

                    if y < 1 then
                        y = maxY
                    elseif y > maxY then
                        y = 1
                    end

                    maxX = maxX[y]
                    if x < 1 then
                        x = maxX
                    elseif x > maxX then
                        if input.down or input.up then
                            x = maxX
                        else
                            x = 1
                        end
                    end

                    item.buttonSelection = xyToButtonSelection(x, y, item.gridX, buttons)
                    if buttons[item.buttonSelection].noSel then
                        if input.up or input.down then
                            tryKeepX = prevX
                        elseif input.left or input.right then
                            tryKeepY = prevY
                        end
                    end

                    --(y - 1) * item.gridX + x
                    firstLoop = nil
                end
            else
                if input.up then
                    item.buttonSelection = ((item.buttonSelection - 2) % #buttons) + 1
                    while buttons[item.buttonSelection].noSel do
                        item.buttonSelection = ((item.buttonSelection - 2) % #buttons) + 1
                    end
                elseif input.down or buttons[item.buttonSelection].noSel then
                    item.buttonSelection = (item.buttonSelection % #buttons) + 1
                    while buttons[item.buttonSelection].noSel do
                        item.buttonSelection = (item.buttonSelection % #buttons) + 1
                    end
                end
            end

            buttonSelection = item.buttonSelection
            buttonSelectionChanged = buttonSelection ~= previousButtonSelection
            if not buttonSelectionChanged then
                prevButton = nil
                changeFunc = nil
            end

            dest = directory[buttons[buttonSelection].dest]
            button = buttons[buttonSelection]

            -- button confirmation
            if input.confirm and not itemSwitched and not allNoSel then
                if button then
                    PlaySound(menuSounds.Pop2)
                    if button.action then
                        action = button.action
                    end

                    if button.func then
                        func = button.func
                    end
                end

                if dest and not button.menu then
                    if not item.removefrompath then
                        table.insert(directoryKey.Path, { menuname = tbl.Name, item = item })
                    end

                    directoryKey.Item = dest
                end
            end

            -- button choice selection
            if button then
                if (button.variable or button.setting) and not allNoSel then
                    if button.choices then
                        button.setting = button.setting or 1
                        if (input.right or input.dright) and button.setting < #button.choices then
                            button.setting = button.setting + 1
                            sfx:Play(SoundEffect.SOUND_PLOP, 1, 0, false,
                                .9 + (.2 * (#button.choices / (#button.choices - (button.setting - 1)))))
                            dssmod.setOption(button.variable, button.setting, button, directoryKey.Item, directoryKey)
                            buttonInteracted = true
                        elseif (input.left or input.dleft) and button.setting > 1 then
                            button.setting = button.setting - 1
                            sfx:Play(SoundEffect.SOUND_PLOP, 1, 0, false,
                                .9 + (.2 * (#button.choices / (#button.choices - (button.setting - 1)))))
                            dssmod.setOption(button.variable, button.setting, button, directoryKey.Item, directoryKey)
                            buttonInteracted = true
                        elseif input.confirm then
                            button.setting = (button.setting % #button.choices) + 1
                            sfx:Play(SoundEffect.SOUND_PLOP, 1, 0, false,
                                .9 + (.2 * (#button.choices / (#button.choices - (button.setting - 1)))))
                            dssmod.setOption(button.variable, button.setting, button, directoryKey.Item, directoryKey)
                            buttonInteracted = true
                        end
                    elseif button.max then
                        local inc, min, max = button.increment or 1, button.min or 0, button.max
                        local pop = false
                        button.setting = button.setting or 0
                        if (input.right or input.dright or input.confirm) then
                            if button.setting < max then
                                button.setting = math.min(button.setting + inc, max)
                                pop = true
                            elseif input.confirm then
                                button.setting = button.min or 0
                                pop = true
                            end
                        elseif (input.left or input.dleft) and button.setting > min then
                            button.setting = math.max(button.setting - inc, min)
                            pop = true
                        end

                        if pop then
                            dssmod.setOption(button.variable, button.setting, button, directoryKey.Item, directoryKey)
                            sfx:Play(SoundEffect.SOUND_PLOP, 1, 0, false, .9 + (.2 * (button.setting / button.max)))
                            buttonInteracted = true
                        end
                    elseif button.keybind then
                        if input.keybinding then
                            if input.keybind then
                                if (input.keybind == Keyboard.KEY_ESCAPE or input.keybind == Keyboard.KEY_BACKSPACE) and button.setting ~= -1 then
                                    input.keybind = -1
                                end

                                button.setting = input.keybind
                                dssmod.setOption(button.variable, button.setting, button, directoryKey.Item, directoryKey)
                                input.keybinding = nil
                                button.keybinding = nil
                            end

                            buttonInteracted = true
                        elseif input.confirm then
                            button.keybinding = true
                            input.keybinding = true
                            buttonInteracted = true
                        end
                    end
                end
            end

            button.selected = true
            item.selectedbutton = button
        end

        --pages
        local pages = item.pages
        if pages and #pages > 0 then
            item.psel = math.min((item.psel or 1), #pages)
            if not buttonInteracted and not buttonSelectionChanged and item.defaultpageselector then
                if input.left then
                    item.psel = ((item.psel - 2) % #pages) + 1
                elseif input.right then
                    item.psel = (item.psel % #pages) + 1
                end
            end
        end

        --BUTTON FUNCTIONS
        if func then
            func(button, directoryKey.Item, tbl)
        end

        if changeFunc then
            changeFunc(prevButton, directoryKey.Item, tbl)
        end

        --BUTTON ACTIONS
        if action then
            if action == 'resume' then
                dssmenu.CloseMenu(true)
            elseif action == "openmenu" and button then
                table.insert(directoryKey.Path, { menuname = tbl.Name, item = item })
                if button.dest then
                    dssmenu.OpenMenuToPath(button.menu, button.dest, directoryKey.Path)
                else
                    dssmenu.OpenMenuToPath(button.menu, "main", directoryKey.Path)
                end
            elseif action == "back" then
                dssmod.back(tbl)
            end
        end
    end

    dssmod.defaultPanelStartAppear = function(panel, tbl, skipOpenAnimation)
        local playAnim = "Appear"
        if skipOpenAnimation then
            playAnim = "Idle"
            panel.MaskAlpha = 0
            panel.Idle = true
        else
            panel.MaskAlpha = 1
            panel.Idle = false
        end

        for k, v in pairs(panel.Sprites) do
            v:Play(playAnim, true)
        end
    end

    dssmod.defaultPanelAppearing = function(panel)
        if not panel.Sprites.Face:IsPlaying("Appear") or panel.Sprites.Face:GetFrame() > 4 then
            panel.Idle = true
            for k, v in pairs(panel.Sprites) do
                v:Play("Idle")
            end

            panel.MaskAlpha = approach(panel.MaskAlpha, 0, .25)
            if panel.MaskAlpha == 0 then
                return true
            end
        end
    end

    dssmod.defaultPanelDisappearing = function(panel, tbl)
        panel.MaskAlpha = approach(panel.MaskAlpha, 1, .25)

        if panel.MaskAlpha == 1 or not panel.Sprites.MaskAlpha then
            panel.Idle = false
            if panel.Sprites.Face:IsFinished("Disappear") then
                return true
            elseif not panel.Sprites.Face:IsPlaying("Disappear") then
                for k, v in pairs(panel.Sprites) do
                    v:Play("Disappear", true)
                end
            end
        end
    end

    dssmod.defaultPanelRenderBack = function(panel, pos, tbl)
        local useClr = panel.Color or Color.Default
        if type(useClr) == "number" then
            useClr = DeadSeaScrollsMenu.GetPalette()[useClr]
        end

        if panel.Sprites.Shadow then
            panel.Sprites.Shadow:Render(pos, Vector.Zero, Vector.Zero)
        end

        if panel.Sprites.Back then
            panel.Sprites.Back.Color = useClr
            panel.Sprites.Back:Render(pos, Vector.Zero, Vector.Zero)
        end

        if panel.Sprites.Face then
            panel.Sprites.Face.Color = useClr
            panel.Sprites.Face:Render(pos, Vector.Zero, Vector.Zero)
        end
    end

    dssmod.defaultPanelRenderFront = function(panel, pos, tbl)
        if panel.Sprites.Border then
            panel.Sprites.Border:Render(pos, Vector.Zero, Vector.Zero)
        end

        if panel.Sprites.Mask and panel.Idle and panel.MaskAlpha > 0 then
            local useClr = panel.Color or Color.Default
            if type(useClr) == "number" then
                useClr = DeadSeaScrollsMenu.GetPalette()[useClr]
            end

            panel.Sprites.Mask.Color = Color(useClr.R, useClr.G, useClr.B, panel.MaskAlpha, 0, 0, 0)
            panel.Sprites.Mask:Render(pos, Vector.Zero, Vector.Zero)
        end
    end

    dssmod.panels = {
        main = {
            Sprites = "main",
            TitleOffset = Vector(0, -82),
            Bounds = { -86, -62, 86, 79 },
            Height = 141,
            TopSpacing = 8,
            BottomSpacing = 8,
            ScrollerSymX = -94,
            ScrollerSymYTop = -46,
            ScrollerSymYBottom = 78,
            DefaultFontSize = 3,
            GetItem = function(panel, item)
                return item
            end,
            GetDrawButtons = function(panel, item)
                local psel = item.psel or 1
                local pages = item.pages
                local page
                if pages and #pages > 0 then
                    page = item.pages[psel]
                end

                local buttons = {}
                if item.buttons then
                    for _, button in ipairs(item.buttons) do
                        buttons[#buttons + 1] = button
                    end
                end

                if page and page.buttons then
                    for _, button in ipairs(page.buttons) do
                        buttons[#buttons + 1] = button
                    end
                end

                return buttons
            end,
            HandleInputs = function(panel, input, item, itemswitched, tbl)
                dssmod.handleInputs(item, itemswitched, tbl)
            end,
            DefaultRendering = true
        },
        tooltip = {
            Sprites = "tooltip",
            Bounds = { -59, -60, 58, 58 },
            Height = 118,
            TopSpacing = 0,
            BottomSpacing = 0,
            DefaultFontSize = 2,
            DrawPositionOffset = Vector(2, 2),
            GetItem = function(panel, item)
                if item.selectedbutton and item.selectedbutton.tooltip then
                    return item.selectedbutton.tooltip
                else
                    return item.tooltip
                end
            end,
            GetDrawButtons = function(panel, tooltip)
                if tooltip then
                    if tooltip.buttons then
                        return tooltip.buttons
                    else
                        return { tooltip }
                    end
                end
            end,
            DefaultRendering = true
        }
    }

    dssmod.defaultFormat = {
        Panels = {
            {
                Panel = dssmod.panels.main,
                Offset = Vector(-42, 10),
                Color = 1
            },
            {
                Panel = dssmod.panels.tooltip,
                Offset = Vector(130, -2),
                Color = 1
            }
        }
    }

    local function getPanelSprites(panelData)
        local panel = panelData.Panel
        if panel.Sprites then
            if type(panel.Sprites) == "string" then
                return DeadSeaScrollsMenu.GetDefaultPanelSprites(panel.Sprites)
            else
                return panel.Sprites
            end
        end
    end

    function dssmod.runMenu(tbl)
        local directory = tbl.Directory
        local directorykey = tbl.DirectoryKey
        local scenter = getScreenCenterPosition()
        local item = directorykey.Item
        if item.menuname and item.item then
            if type(item.item) == "string" then
                directorykey.Item = directory[item.item]
            else
                directorykey.Item = item.item
            end

            item = directorykey.Item
        end

        local format = item.format or dssmod.defaultFormat

        if not directorykey.ActivePanels then
            directorykey.ActivePanels = {}
        end

        directorykey.SpriteUpdateFrame = not directorykey.SpriteUpdateFrame

        if not tbl.Exiting then -- don't add or adjust panels while exiting
            for i, panelData in ipairs(format.Panels) do
                local activePanel
                for _, active in ipairs(directorykey.ActivePanels) do
                    if active.Panel == panelData.Panel then
                        activePanel = active
                        break
                    end
                end

                local justAppeared
                if not activePanel then
                    activePanel = {
                        Sprites = getPanelSprites(panelData),
                        Offset = panelData.Offset,
                        Panel = panelData.Panel
                    }

                    if panelData.Panel.DefaultRendering then
                        panelData.Panel.StartAppear = panelData.Panel.StartAppear or dssmod.defaultPanelStartAppear
                        panelData.Panel.UpdateAppear = panelData.Panel.UpdateAppear or dssmod.defaultPanelAppearing
                        panelData.Panel.UpdateDisappear = panelData.Panel.UpdateDisappear or
                            dssmod.defaultPanelDisappearing
                        panelData.Panel.RenderBack = panelData.Panel.RenderBack or dssmod.defaultPanelRenderBack
                        panelData.Panel.RenderFront = panelData.Panel.RenderFront or dssmod.defaultPanelRenderFront
                    end

                    activePanel.Appearing = true
                    justAppeared = true
                    table.insert(directorykey.ActivePanels, i, activePanel)
                end

                activePanel.TargetOffset = panelData.Offset
                activePanel.PanelData = panelData
                activePanel.Color = panelData.Color

                local startAppearFunc = panelData.StartAppear or panelData.Panel.StartAppear
                if startAppearFunc and justAppeared then
                    startAppearFunc(activePanel, tbl, directorykey.SkipOpenAnimation)
                end
            end
        end

        if directorykey.SkipOpenAnimation then
            directorykey.SkipOpenAnimation = false
        end

        for _, active in ipairs(directorykey.ActivePanels) do
            active.SpriteUpdateFrame = directorykey.SpriteUpdateFrame
            local shouldDisappear = tbl.Exiting
            if not shouldDisappear then
                local isActive
                for _, panelData in ipairs(format.Panels) do
                    if panelData.Panel == active.Panel then
                        isActive = true
                        break
                    end
                end

                shouldDisappear = not isActive
            end

            if shouldDisappear then
                if not active.Disappearing then
                    active.Disappearing = true

                    local startDisappearFunc = active.PanelData.StartDisappear or active.Panel.StartDisappear
                    if startDisappearFunc then
                        startDisappearFunc(active, tbl)
                    end
                end
            end
        end

        for i = #directorykey.ActivePanels, 1, -1 do
            local active = directorykey.ActivePanels[i]
            if active.Disappearing then
                local disappearFunc = active.PanelData.UpdateDisappear or active.Panel.UpdateDisappear
                local remove = true
                if disappearFunc then
                    remove = disappearFunc(active, tbl)
                end

                if remove then
                    table.remove(directorykey.ActivePanels, i)
                end
            elseif active.Appearing then
                local appearFunc = active.PanelData.UpdateAppear or active.Panel.UpdateAppear
                local finished = true
                if appearFunc then
                    finished = appearFunc(active, tbl)
                end

                if finished then
                    active.Appearing = nil
                end
            end
        end

        if tbl.Exiting and #directorykey.ActivePanels == 0 then
            directorykey.Item = directory[directorykey.Main]
            directorykey.Path = {}
            directorykey.ActivePanels = nil
            tbl.Exiting = nil
            return
        end

        local itemswitched = false
        if item ~= directorykey.PreviousItem then
            itemswitched = true

            if item.generate then
                item.generate(item, tbl)
            end

            directorykey.PreviousItem = item
        end

        if item.update then
            item.update(item, tbl)
        end

        local input = menuinput.menu

        for _, active in ipairs(directorykey.ActivePanels) do
            active.Offset = Lerp(active.Offset, active.TargetOffset, 0.2)

            local panelPos = scenter + active.Offset

            if active.Sprites and active.SpriteUpdateFrame then
                for k, v in pairs(active.Sprites) do
                    v:Update()
                end
            end

            local renderBack = active.PanelData.RenderBack or active.Panel.RenderBack
            if renderBack then
                renderBack(active, panelPos, tbl)
            end

            if active.Idle then
                local getItem = active.PanelData.GetItem or active.Panel.GetItem
                local object = item
                if getItem then
                    object = getItem(active, item, tbl)
                end

                local handleInputs = active.PanelData.HandleInputs or active.Panel.HandleInputs
                if handleInputs then
                    handleInputs(active, menuinput, object, itemswitched, tbl)
                end

                local draw = active.PanelData.Draw or active.Panel.Draw
                if draw then
                    draw(active, panelPos, object, tbl)
                elseif object then
                    local getDrawButtons = active.PanelData.GetDrawButtons or active.Panel.GetDrawButtons
                    if getDrawButtons then
                        local drawings = dssmod.generateMenuDraw(object, getDrawButtons(active, object, tbl), panelPos,
                            active.Panel)
                        for _, drawing in ipairs(drawings) do
                            dssmod.drawMenu(tbl, drawing)
                        end
                    end
                end
            end

            local renderFront = active.PanelData.RenderFront or active.Panel.RenderFront
            if renderFront then
                renderFront(active, panelPos, tbl)
            end
        end

        --menu regressing
        if not tbl.Exiting then
            if (input.back or input.toggle) and not itemswitched then
                dssmod.back(tbl)
            end
        end

        if item.postrender then
            item.postrender(item, tbl)
        end
    end

    function dssmod.back(tbl)
        local dssmenu = DeadSeaScrollsMenu
        local directorykey = tbl.DirectoryKey
        if #directorykey.Path > 0 then
            PlaySound(menuSounds.Pop3)
            local backItem = directorykey.Path[#directorykey.Path]
            directorykey.Path[#directorykey.Path] = nil
            if backItem.menuname and backItem.menuname ~= tbl.Name then
                local newPath = {}
                for _, val in ipairs(directorykey.Path) do
                    newPath[#newPath + 1] = val
                end

                dssmenu.OpenMenu(backItem.menuname)
                local menu = dssmenu.Menus[backItem.menuname]


                if type(backItem.item) == "string" then
                    menu.DirectoryKey.Item = menu.Directory[backItem.item]
                else
                    menu.DirectoryKey.Item = backItem.item
                end

                menu.DirectoryKey.Path = newPath
                menu.DirectoryKey.PreviousItem = nil
            elseif backItem.menuname then
                if type(backItem.item) == "string" then
                    directorykey.Item = tbl.Directory[backItem.item]
                else
                    directorykey.Item = backItem.item
                end
            else
                directorykey.Item = backItem
            end
        elseif not directorykey.PreventClosing then
            dssmenu.CloseMenu()
        end
    end

    function dssmod.checkMenu()
        if not menuinput then
            return false
        end

        local input = menuinput.menu
        if not input then
            return false
        end

        local dssmenu = DeadSeaScrollsMenu
        if input.toggle and not dssmenu.IsOpen() then
            if dssmenu.IsMenuSafe() then
                if dssmenu.CanOpenGlobalMenu() then
                    dssmenu.OpenMenu("Menu")
                else                                       -- if only one mod is using the menu, open its menu and ignore this one
                    for k, menu in pairs(dssmenu.Menus) do -- this is non-specific to simplify copying, less to swap
                        if k ~= "Menu" then
                            dssmenu.OpenMenu(k)
                        end
                    end
                end
            else
                if not dssmenu.PlayedBuzzer then
                    if dssmenu.GetMenuBuzzerSetting() == 1 then
                        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ, .75, 0, false, 1.5)
                    end

                    dssmenu.PlayedBuzzer = true
                end
            end
        end

        if dssmenu.OpenedMenu then
            if dssmenu.ExitingMenu and not dssmenu.OpenedMenu.Exiting then
                dssmenu.ExitingMenu = nil
                dssmenu.OpenedMenu = nil
            else
                dssmenu.OpenedMenu.Run(dssmenu.OpenedMenu)
            end
        else
            dssmenu.ExitingMenu = nil
        end
    end

    function dssmod.reloadButton(button, item, tbl)
        if button.load then
            local setting = button.load(button, item, tbl)
            button.setting = setting
            if button.variable then
                tbl.DirectoryKey.Settings[button.variable] = setting
            end
        end
    end

    function dssmod.reloadButtons(tbl, item)
        if item then
            for _, button in ipairs(item.buttons) do
                dssmod.reloadButton(button, item, tbl)
            end
        else
            for k, item in pairs(tbl.Directory) do
                if item.buttons then
                    for _, button in ipairs(item.buttons) do
                        dssmod.reloadButton(button, item, tbl)
                    end
                end
            end
        end
    end

    local eidHidden = false
    function dssmod.openMenu(tbl, openedFromNothing)
        if not openedFromNothing then
            tbl.DirectoryKey.SkipOpenAnimation = true
        end

        tbl.DirectoryKey.PreviousItem = nil
        tbl.DirectoryKey.ActivePanels = nil
        tbl.Exiting = nil

        dssmod.reloadButtons(tbl)

        if EID then
            if EID.isHidden then
                eidHidden = true
                EID.isHidden = true
            end
        end
    end

    function dssmod.closeMenu(tbl, fullClose, noAnimate)
        if fullClose and not noAnimate then
            tbl.Exiting = true
        else
            tbl.DirectoryKey.ActivePanels = {}
        end

        tbl.DirectoryKey.Path = {}
        tbl.DirectoryKey.Main = 'main'
        tbl.DirectoryKey.PreventClosing = false
        tbl.DirectoryKey.Item = tbl.Directory[tbl.DirectoryKey.Main]

        if tbl.DirectoryKey.SettingsChanged then
            tbl.DirectoryKey.SettingsChanged = false
            for k, item in pairs(tbl.Directory) do
                if item.buttons then
                    for _, button in ipairs(item.buttons) do
                        if button.store and button.variable then
                            button.store(tbl.DirectoryKey.Settings[button.variable] or button.setting, button, item, tbl)
                        end
                    end
                end
            end

            MenuProvider.SaveSaveData()
        end

        if eidHidden then
            eidHidden = false
            if EID then
                EID.isHidden = false
            end
        end
    end

    local hintFont = Font()
    hintFont:Load("font/pftempestasevencondensed.fnt")

    --POST RENDER
    local openToggle -- only store data when menu opens / closes
    function dssmod:postRender()
        local dssmenu = DeadSeaScrollsMenu
        local isCore = MenuProvider.IsMenuCore()
        local isOpen = dssmenu.IsOpen()
        if isCore or isOpen then
            dssmod.getInput(0)
        end

        local level = game:GetLevel()
        local inFirstRoom = level:GetStage() == LevelStage.STAGE1_1 and
            level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() and game:GetRoom():IsFirstVisit() and
            level:GetStageType() ~= StageType.STAGETYPE_REPENTANCE and
            level:GetStageType() ~= StageType.STAGETYPE_REPENTANCE_B and
            not game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
        if isCore and not isOpen and DeadSeaScrollsMenu.GetMenuHintSetting() == 1 and inFirstRoom then
            local keybind = DeadSeaScrollsMenu.GetMenuKeybindSetting()
            local keybindText = string.upper(inputButtonNames[keybind])
            local text = "Press [" .. keybindText .. "] to open Dead Sea Scrolls Menu"
            hintFont:DrawStringScaled(text, (Isaac.GetScreenWidth() / 2) - (hintFont:GetStringWidth(text) / 2),
                Isaac.GetScreenHeight() - 38, 1, 1, KColor(1, 191 / 255, 0, 0.6), 0)
            local text2 = "(this hint can be turned off in the menu's settings!)"
            hintFont:DrawStringScaled(text2, (Isaac.GetScreenWidth() / 2) - (hintFont:GetStringWidth(text2) / 4),
                Isaac.GetScreenHeight() - 26, 0.5, 0.5, KColor(1, 191 / 255, 0, 0.6), 0)
        end

        if not isCore and dssmenu and openToggle ~= isOpen then -- If not in control of certain settings, be sure to store them!
            openToggle = isOpen

            local change

            local paletteSetting = dssmenu.GetPaletteSetting()
            if paletteSetting ~= MenuProvider.GetPaletteSetting() then
                change = true
                MenuProvider.SavePaletteSetting(paletteSetting)
            end

            if not REPENTANCE then
                local hudSetting = dssmenu.GetHudOffsetSetting()
                if hudSetting ~= MenuProvider.GetHudOffsetSetting() then
                    change = true
                    MenuProvider.SaveHudOffsetSetting(hudSetting)
                end
            end

            local gamepadSetting = dssmenu.GetGamepadToggleSetting()
            if gamepadSetting ~= MenuProvider.GetGamepadToggleSetting() then
                change = true
                MenuProvider.SaveGamepadToggleSetting(gamepadSetting)
            end

            local keybindSetting = dssmenu.GetMenuKeybindSetting()
            if keybindSetting ~= MenuProvider.GetMenuKeybindSetting() then
                change = true
                MenuProvider.SaveMenuKeybindSetting(keybindSetting)
            end

            local menusNotified = dssmenu.GetMenusNotified()
            local knownNotified = MenuProvider.GetMenusNotified()
            if not KeysShareVals(menusNotified, knownNotified) then
                change = true
                MenuProvider.SaveMenusNotified(menusNotified)
            end

            local menusPoppedUp = dssmenu.GetMenusPoppedUp()
            local knownPoppedUp = MenuProvider.GetMenusPoppedUp()
            if not KeysShareVals(menusPoppedUp, knownPoppedUp) then
                change = true
                MenuProvider.SaveMenusPoppedUp(menusPoppedUp)
            end

            if change then
                MenuProvider.SaveSaveData()
            end
        end
    end

    dssmod:AddCallback(ModCallbacks.MC_POST_RENDER, dssmod.postRender)

    -- These buttons will be included in this mod's menu if it is the only active menu, or in the
    -- global menu if it exists and this mod is managing it.
    local function sharedButtonDisplayCondition(button, item, tbl)
        return tbl.Name == "Menu" or not dssmenu.CanOpenGlobalMenu()
    end

    dssmod.hudOffsetButton = {
        str = 'hud offset',
        increment = 1,
        max = 10,
        variable = "HudOffset",
        slider = true,
        setting = 0,
        load = function()
            return DeadSeaScrollsMenu.GetHudOffsetSetting()
        end,
        store = function(var)
            DeadSeaScrollsMenu.SaveHudOffsetSetting(var)
        end,
        displayif = function(btn, item, tbl)
            return not REPENTANCE and sharedButtonDisplayCondition(btn, item, tbl)
        end,
        tooltip = { strset = { 'be sure to', 'match the', 'setting', 'in the', 'pause menu' } }
    }

    dssmod.gamepadToggleButton = {
        str = 'gamepad toggle',
        choices = {
            'either stick',
            'left stick',
            'right stick',
            'both sticks',
            '[select]',
            '[rt] + [select]',
            'keybind only'
        },
        variable = 'ControllerToggle',
        tooltip = {
            strset = {
                'to open',
                'and close',
                'this menu with',
                'a controller',
                '',
                '[f1] always',
                'works',
            },
        },
        setting = 1,
        load = function()
            return DeadSeaScrollsMenu.GetGamepadToggleSetting()
        end,
        store = function(var)
            DeadSeaScrollsMenu.SaveGamepadToggleSetting(var)
        end,
        displayif = sharedButtonDisplayCondition
    }

    dssmod.menuKeybindButton = {
        str = 'menu keybind',
        tooltip = {
            strset = {
                'rebinds key',
                'used to open',
                'this menu.',
                '[f1] always',
                'works.',
            },
        },
        variable = 'MenuKeybind',
        keybind = true,
        setting = Keyboard.KEY_C,
        load = function()
            return DeadSeaScrollsMenu.GetMenuKeybindSetting()
        end,
        store = function(var)
            DeadSeaScrollsMenu.SaveMenuKeybindSetting(var)
        end,
        changefunc = function(button)
            DeadSeaScrollsMenu.SaveMenuKeybindSetting(button.setting)
        end,
        displayif = sharedButtonDisplayCondition
    }

    dssmod.menuHintButton = {
        str = 'menu hint',
        tooltip = {
            strset = {
                'disables',
                'the starting',
                'room hint',
                'on how to',
                'use this',
                'menu',
            },
        },
        choices = { "enabled", "disabled" },
        variable = 'MenuHint',
        setting = 1,
        load = function()
            return DeadSeaScrollsMenu.GetMenuHintSetting()
        end,
        store = function(var)
            DeadSeaScrollsMenu.SaveMenuHintSetting(var)
        end,
        changefunc = function(button)
            DeadSeaScrollsMenu.SaveMenuHintSetting(button.setting)
        end,
        displayif = sharedButtonDisplayCondition
    }

    dssmod.menuBuzzerButton = {
        str = 'menu buzzer',
        tooltip = {
            strset = {
                'disables',
                'the buzzer',
                'when trying',
                'to open this',
                'menu in a',
                'combat room',
            },
        },
        choices = { "enabled", "disabled" },
        variable = 'MenuBuzzer',
        setting = 1,
        load = function()
            return DeadSeaScrollsMenu.GetMenuBuzzerSetting()
        end,
        store = function(var)
            DeadSeaScrollsMenu.SaveMenuBuzzerSetting(var)
        end,
        changefunc = function(button)
            DeadSeaScrollsMenu.SaveMenuBuzzerSetting(button.setting)
        end,
        displayif = sharedButtonDisplayCondition
    }

    dssmod.paletteButton = {
        str = 'menu palette',
        variable = "MenuPalette",
        setting = 1,
        load = function()
            return DeadSeaScrollsMenu.GetPaletteSetting()
        end,
        store = function(var)
            DeadSeaScrollsMenu.SavePaletteSetting(var)
        end,
        changefunc = function(button)
            DeadSeaScrollsMenu.SavePaletteSetting(button.setting)
        end,
        displayif = sharedButtonDisplayCondition,
        generate = function(button, item, tbl)
            local dssmenu = DeadSeaScrollsMenu
            if not button.generated or button.generated ~= #dssmenu.Palettes then
                button.setting = math.min(button.setting, #dssmenu.Palettes)
                button.generated = #dssmenu.Palettes
                button.choices = {}
                for _, palette in ipairs(dssmenu.Palettes) do
                    button.choices[#button.choices + 1] = palette.Name
                end
            end
        end
    }

    local function changelogsGenerate(item, tbl)
        item.buttons = {}

        if not item.logTable then
            item.logTable = DeadSeaScrollsMenu.Changelogs
        end

        local dir = tbl.Directory
        for _, key in ipairs(item.logTable.List) do
            local glowColor = (DeadSeaScrollsMenu.DoesLogWantNotification(key) and 3) or nil
            if type(key) == "table" then
                item.buttons[#item.buttons + 1] = {
                    str = key.Name,
                    dest = key.Key,
                    glowColor = glowColor
                }
            else
                item.buttons[#item.buttons + 1] = {
                    str = dir[key].title,
                    dest = key,
                    glowColor = glowColor
                }
            end
        end
    end

    dssmod.changelogsButton = {
        str = 'changelogs',
        action = "openmenu",
        menu = 'Menu',
        dest = 'changelogs',
        generate = function(btn)
            if DeadSeaScrollsMenu.DoesLogWantNotification(DeadSeaScrollsMenu.Changelogs) then
                btn.glowColor = 3
            else
                btn.glowColor = nil
            end
        end,
        displayif = function(btn, item, tbl)
            if sharedButtonDisplayCondition(btn, item, tbl) then
                return #DeadSeaScrollsMenu.Changelogs.List > 0
            end

            return false
        end
    }


    dssmod.menuOpenToolTip = {
        strset = {
            'toggle menu',
            '',
            'keyboard:',
            '[c] or [f1]',
            '',
            'controller:',
            'press analog',
        },
        fSize = 2,
    }
    local function InitializeMenuCore()
        if not dssmenu.Palettes then
            dssmenu.Palettes = {}
        end

        if not dssmenu.ExistingPalettes then
            dssmenu.ExistingPalettes = {}
        end

        if not dssmenu.Menus then
            dssmenu.Menus = {}
        end

        if not dssmenu.Changelogs then
            dssmenu.Changelogs = { Key = 'changelogs', Name = 'changelogs', List = {} }
        end

        if not dssmenu.ChangelogItems then
            dssmenu.ChangelogItems = {}
        end

        if not dssmenu.QueuedMenus then
            dssmenu.QueuedMenus = {}
        end

        function dssmenu.AddPalettes(palettes)
            for _, palette in ipairs(palettes) do
                if not dssmenu.ExistingPalettes[palette.Name] then
                    dssmenu.ExistingPalettes[palette.Name] = true

                    for i, color in ipairs(palette) do
                        if type(color) == "table" then
                            palette[i] = Color(color[1] / 255, color[2] / 255, color[3] / 255, 1, 0, 0, 0)
                        else
                            palette[i] = color
                        end
                    end

                    dssmenu.Palettes[#dssmenu.Palettes + 1] = palette
                end
            end
        end

        local function stringLineIterator(s)
            if s:sub(-1) ~= "\n" then s = s .. "\n" end
            return s:gmatch("(.-)\n")
        end

        dssmenu.AddPalettes({
            {
                Name = "classic",
                { 199, 178, 154 }, -- Back
                { 54,  47,  45 },  -- Text
                { 94,  57,  61 },  -- Highlight Text
            },
            {
                Name = "soy milk",
                { 255, 237, 206 },
                { 134, 109, 103 },
                { 73,  56,  67 },
            },
            {
                Name = "phd",
                { 224, 208, 208 },
                { 84,  43,  39 },
                { 118, 66,  72 },
            },
            {
                Name = "faded polaroid",
                { 219, 199, 188 },
                { 111, 81,  63 },
                { 86,  29,  37 },
            },
            {
                Name = "missing page 2",
                { 178, 112, 110 },
                { 40,  0,   0 },
                { 63,  13,  18 },
            },
            {
                Name = "???",
                { 77,  98,  139 },
                { 29,  36,  52 },
                { 156, 200, 205 },
            },
            {
                Name = "succubus",
                { 51, 51, 51 },
                { 12, 12, 12 },
                { 81, 10, 22 },
            },
            {
                Name = "birthright",
                { 214, 186, 155 },
                { 38,  30,  22 },
                { 112, 7,   0 },
            },
            {
                Name = "impish",
                { 170, 142, 214 },
                { 47,  34,  68 },
                { 56,  3,   6 },
            },
            {
                Name = "queasy",
                { 87, 125, 73 },
                { 32, 38,  28 },
                { 56, 55,  23 },
            },
            {
                Name = "fruitcake",
                Rainbow = true,
                { 243, 226, 226 },
                { 54,  47,  45 },
                { 64,  57,  50 },
            },
            {
                Name = "delirious",
                { 255, 255, 255 },
                { 254, 240, 53 },
                { 139, 104, 104 },
            },
            {
                Name = "searing",
                { 255, 255, 255 },
                { 117, 120, 125 },
                { 114, 137, 218 },
            },
        })

        function dssmenu.GetPaletteSetting()
            local palette = MenuProvider.GetPaletteSetting()
            if palette and dssmenu.Palettes[palette] then
                return palette
            else
                MenuProvider.SavePaletteSetting(1)
                MenuProvider.SaveSaveData()
                return 1
            end
        end

        function dssmenu.SavePaletteSetting(var)
            MenuProvider.SavePaletteSetting(var)
            MenuProvider.SaveSaveData()
        end

        function dssmenu.GetPalette()
            return dssmenu.Palettes[dssmenu.GetPaletteSetting()]
        end

        function dssmenu.GetHudOffsetSetting()
            if REPENTANCE then
                return Options.HUDOffset * 10
            else
                local hudOffset = MenuProvider.GetHudOffsetSetting()
                if hudOffset then
                    return hudOffset
                else
                    MenuProvider.SaveHudOffsetSetting(0)
                    MenuProvider.SaveSaveData()
                    return 0
                end
            end
        end

        function dssmenu.SaveHudOffsetSetting(var)
            if not REPENTANCE then
                MenuProvider.SaveHudOffsetSetting(var)
                MenuProvider.SaveSaveData()
            end
        end

        function dssmenu.GetGamepadToggleSetting()
            local gamepadToggle = MenuProvider.GetGamepadToggleSetting()
            if gamepadToggle then
                return gamepadToggle
            else
                MenuProvider.SaveGamepadToggleSetting(1)
                MenuProvider.SaveSaveData()
                return 1
            end
        end

        function dssmenu.SaveGamepadToggleSetting(var)
            MenuProvider.SaveGamepadToggleSetting(var)
            MenuProvider.SaveSaveData()
        end

        function dssmenu.GetMenuKeybindSetting()
            local menuKeybind = MenuProvider.GetMenuKeybindSetting()
            if menuKeybind then
                return menuKeybind
            else
                MenuProvider.SaveMenuKeybindSetting(Keyboard.KEY_C)
                MenuProvider.SaveSaveData()
                return Keyboard.KEY_C
            end
        end

        function dssmenu.SaveMenuKeybindSetting(var)
            MenuProvider.SaveMenuKeybindSetting(var)
            MenuProvider.SaveSaveData()
        end

        function dssmenu.GetMenuHintSetting()
            local menuHint = MenuProvider.GetMenuHintSetting()
            if menuHint then
                return menuHint
            else
                MenuProvider.SaveMenuHintSetting(1)
                MenuProvider.SaveSaveData()
                return 1
            end
        end

        function dssmenu.SaveMenuHintSetting(var)
            MenuProvider.SaveMenuHintSetting(var)
            MenuProvider.SaveSaveData()
        end

        function dssmenu.GetMenuBuzzerSetting()
            local menuHint = MenuProvider.GetMenuBuzzerSetting()
            if menuHint then
                return menuHint
            else
                MenuProvider.SaveMenuBuzzerSetting(1)
                MenuProvider.SaveSaveData()
                return 1
            end
        end

        function dssmenu.SaveMenuBuzzerSetting(var)
            MenuProvider.SaveMenuBuzzerSetting(var)
            MenuProvider.SaveSaveData()
        end

        function dssmenu.GetMenusNotified()
            local menusNotified = MenuProvider.GetMenusNotified()
            if menusNotified then
                return menusNotified
            else
                MenuProvider.SaveMenusNotified({})
                MenuProvider.SaveSaveData()
                return {}
            end
        end

        function dssmenu.SaveMenusNotified(var)
            MenuProvider.SaveMenusNotified(var)
            MenuProvider.SaveSaveData()
        end

        function dssmenu.GetMenusPoppedUp()
            local menusNotified = MenuProvider.GetMenusPoppedUp()
            if menusNotified then
                return menusNotified
            else
                MenuProvider.SaveMenusPoppedUp({})
                MenuProvider.SaveSaveData()
                return {}
            end
        end

        function dssmenu.SaveMenusPoppedUp(var)
            MenuProvider.SaveMenusPoppedUp(var)
            MenuProvider.SaveSaveData()
        end

        dssmenu.MenuSprites = nil
        function dssmenu.GetDefaultMenuSprites()
            if not dssmenu.MenuSprites then
                dssmenu.MenuSprites = {
                    Shadow = Sprite(),
                    Back = Sprite(),
                    Face = Sprite(),
                    Mask = Sprite(),
                    Border = Sprite(),
                    Font = Sprite(),
                    Symbols = Sprite()
                }

                dssmenu.MenuSprites.Back:Load("gfx/ui/deadseascrolls/menu_back.anm2", true)
                dssmenu.MenuSprites.Face:Load("gfx/ui/deadseascrolls/menu_face.anm2", true)
                dssmenu.MenuSprites.Mask:Load("gfx/ui/deadseascrolls/menu_mask.anm2", true)
                dssmenu.MenuSprites.Border:Load("gfx/ui/deadseascrolls/menu_border.anm2", true)
                dssmenu.MenuSprites.Font:Load("gfx/ui/deadseascrolls/menu_font.anm2", true)
                dssmenu.MenuSprites.Shadow:Load("gfx/ui/deadseascrolls/menu_shadow.anm2", true)
                dssmenu.MenuSprites.Symbols:Load("gfx/ui/deadseascrolls/menu_symbols.anm2", true)
            end

            return dssmenu.MenuSprites
        end

        local spritePaths = {
            Shadow = "gfx/ui/deadseascrolls/menu_shadow.png",
            Back = "gfx/ui/deadseascrolls/menu_back.png",
            Face = "gfx/ui/deadseascrolls/menu_face.png",
            Border = "gfx/ui/deadseascrolls/menu_border.png",
            Mask = "gfx/ui/deadseascrolls/menu_mask.png",
        }

        dssmenu.MenuSpritesMain = nil
        dssmenu.MenuSpritesTooltip = nil
        function dssmenu.GetDefaultPanelSprites(panelType)
            if panelType == "main" then
                if not dssmenu.MenuSpritesMain then
                    dssmenu.MenuSpritesMain = {}

                    for k, v in pairs(spritePaths) do
                        local sprite = Sprite()
                        sprite:Load("gfx/ui/deadseascrolls/menu_main.anm2", false)
                        sprite:ReplaceSpritesheet(0, v)
                        sprite:LoadGraphics()
                        dssmenu.MenuSpritesMain[k] = sprite
                    end
                end

                return dssmenu.MenuSpritesMain
            elseif panelType == "tooltip" then
                if not dssmenu.MenuSpritesTooltip then
                    dssmenu.MenuSpritesTooltip = {}

                    for k, v in pairs(spritePaths) do
                        local sprite = Sprite()
                        sprite:Load("gfx/ui/deadseascrolls/menu_tooltip.anm2", false)
                        sprite:ReplaceSpritesheet(0, v)
                        sprite:LoadGraphics()
                        dssmenu.MenuSpritesTooltip[k] = sprite
                    end
                end

                return dssmenu.MenuSpritesTooltip
            end
        end

        function dssmenu.IsMenuSafe()
            local roomHasDanger = false
            for _, entity in pairs(Isaac.GetRoomEntities()) do
                if (
                    entity:IsActiveEnemy()
                    and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
                    and not entity:GetData().DSSMenuSafe
                    )
                    or
                    (
                    entity.Type == EntityType.ENTITY_PROJECTILE
                    and entity:ToProjectile().ProjectileFlags & ProjectileFlags.CANT_HIT_PLAYER == 0
                    )
                    or entity.Type == EntityType.ENTITY_BOMBDROP
                then
                    roomHasDanger = true
                    break
                end
            end

            if game:GetRoom():IsClear() and not roomHasDanger then
                return true
            end

            return false
        end

        local dssdirectory = {
            main = {
                title = 'dead sea scrolls',
                buttons = {}, -- constructed in ReconstructMenus()
                tooltip = dssmod.menuOpenToolTip
            },
            othermenus = {
                title = 'other mods',
                buttons = {},
                tooltip = dssmod.menuOpenToolTip,
            },
            menusettings = {
                title = 'menu settings',
                buttons = {
                    dssmod.hudOffsetButton,
                    dssmod.gamepadToggleButton,
                    dssmod.menuKeybindButton,
                    dssmod.menuHintButton,
                    dssmod.menuBuzzerButton,
                    dssmod.paletteButton
                },
                tooltip = dssmod.menuOpenToolTip
            },
            changelogs = {
                title = 'changelogs',
                fSize = 3,
                generate = changelogsGenerate,
                tooltip = dssmod.menuOpenToolTip
            }
        }

        if dssmenu.ChangelogItems then
            for k, v in pairs(dssmenu.ChangelogItems) do
                dssdirectory[k] = v
            end
        end

        local dssdirectorykey = {
            Item = dssdirectory.main,
            Main = 'main',
            Idle = false,
            MaskAlpha = 1,
            Settings = {},
            SettingsChanged = false,
            Path = {},
        }

        local changelogFormatCodes = {
            "{CLR1",
            "{CLR2",
            "{CLR3",
            "{SYM",
            "{FSIZE2}",
            "{FSIZE3}",
            "}"
        }

        function dssmenu.AddChangelog(...)
            local args = { ... }
            local changelogText, changelogTextIndex

            if #args < 2 then
                changelogTextIndex = 1
            else
                for i = #args, 2, -1 do
                    if type(args[i]) == "string" then
                        changelogTextIndex = i
                        changelogText = args[i]
                        break
                    end
                end
            end

            if changelogTextIndex == 1 then
                error(
                    "DeadSeaScrollsMenu.AddChangelog requires a category arg to be placed under, before changelog text.",
                    2
                )
            end

            local categories = {}
            for i = 1, changelogTextIndex - 1 do
                categories[#categories + 1] = string.lower(args[i])
            end

            local tooltip = args[changelogTextIndex + 1] or dssmod.menuOpenToolTip
            local notify = args[changelogTextIndex + 2]
            local popup = args[changelogTextIndex + 3]
            local defaultFSize = args[changelogTextIndex + 4] or 1

            local lines = {}
            for line in stringLineIterator(changelogText) do
                lines[#lines + 1] = line
            end

            if not tooltip.strset then
                tooltip = { strset = tooltip }
            end

            local buttons = {}
            local changelogItem = {
                title = categories[#categories],
                tooltip = tooltip,
                fSize = defaultFSize,
                scroller = true,
                noCursor = true,
                buttons = buttons,
                wantspopup = popup,
                wantsnotify = notify,
                generate = function(item)
                    if item.wantsnotify then
                        local notifies = DeadSeaScrollsMenu.GetMenusNotified()
                        if not notifies[item.keyInDirectory] then
                            notifies[item.keyInDirectory] = true
                            DeadSeaScrollsMenu.SaveMenusNotified(notifies)
                        end
                    end
                end
            }

            for i, line in ipairs(lines) do
                local btn = {}
                local substrs = {}

                local formatParsingDone = false
                local strStart = 1
                local strEnd = string.len(line)
                local strIndex = strStart
                local fSize
                local subStrData = { Start = strIndex }

                while not formatParsingDone do
                    local nextFormatCode, nextFormatCodeStart, nextFormatCodeEnd
                    for _, code in ipairs(changelogFormatCodes) do
                        local startInd, endInd = string.find(line, code, strIndex)
                        if startInd then
                            if not nextFormatCode or nextFormatCodeStart > startInd then
                                nextFormatCode = code
                                nextFormatCodeStart = startInd
                                nextFormatCodeEnd = endInd
                            end
                        end
                    end

                    if nextFormatCode then
                        if nextFormatCode == "{FSIZE1}" then
                            fSize = 1
                        elseif nextFormatCode == "{FSIZE2}" then
                            fSize = 2
                        elseif nextFormatCode == "{FSIZE3}" then
                            fSize = 3
                        end

                        -- substr, must be closed later
                        if string.sub(nextFormatCode, -1, -1) ~= "}" or nextFormatCode == "}" then
                            -- terminate existing substring
                            if subStrData then
                                local subStrEnd = nextFormatCodeStart - 1
                                if subStrEnd > 0 then
                                    local substr = string.sub(line, subStrData.Start, subStrEnd)
                                    if not subStrData.NoLower then
                                        substr = string.lower(substr)
                                    end

                                    substrs[#substrs + 1] = {
                                        str = substr,
                                        color = subStrData.Color,
                                    }
                                end
                            end

                            -- starts where code starts because code will be removed
                            subStrData = { Start = nextFormatCodeStart }

                            if nextFormatCode == "{SYM" then
                                subStrData.NoLower = true
                            elseif nextFormatCode == "{CLR1" then
                                subStrData.Color = 1
                            elseif nextFormatCode == "{CLR2" then
                                subStrData.Color = 2
                            elseif nextFormatCode == "{CLR3" then
                                subStrData.Color = 3
                            end
                        end

                        -- remove formatting code from line
                        line = string.sub(line, nextFormatCodeEnd + 1, -1)
                    else
                        formatParsingDone = true
                    end

                    if subStrData.Start > string.len(line) then
                        formatParsingDone = true
                    elseif formatParsingDone and subStrData.Start then
                        local substr = string.sub(line, subStrData.Start, -1)
                        if not subStrData.NoLower then
                            substr = string.lower(substr)
                        end

                        substrs[#substrs + 1] = { str = substr, color = subStrData.Color }
                    end
                end

                btn.fSize = fSize
                if #substrs > 0 then
                    btn.str = substrs
                else
                    btn.str = ''
                end

                buttons[#buttons + 1] = btn
            end

            local changelogKey = '{'
            local changelogPath = dssmenu.Changelogs
            for i, v in ipairs(categories) do
                local found, foundIndex
                for i2, tbl in ipairs(changelogPath.List) do
                    if tbl.Name == v then
                        found = tbl
                        foundIndex = i2
                        break
                    end
                end

                if not found then
                    changelogPath.List[#changelogPath.List + 1] = {
                        Name = v,
                        List = {}
                    }
                    foundIndex = #changelogPath.List
                end

                changelogPath = changelogPath.List[foundIndex]

                changelogKey = changelogKey .. v .. "{"

                if not changelogPath.Key then
                    changelogPath.Key = changelogKey
                end

                if not dssdirectory[changelogKey] and i ~= #categories then
                    dssdirectory[changelogKey] = {
                        title = v,
                        tooltip = dssmod.menuOpenToolTip,
                        fSize = 2,
                        buttons = {},
                        logTable = changelogPath,
                        generate = changelogsGenerate
                    }
                    dssmenu.ChangelogItems[changelogKey] = dssdirectory[changelogKey]
                end
            end

            local ind = #changelogPath.List + 1
            for i, v in ipairs(changelogPath.List) do
                if v == changelogKey then
                    ind = i
                end
            end

            changelogPath.List[ind] = changelogKey

            changelogItem.keyInDirectory = changelogKey
            dssdirectory[changelogKey] = changelogItem
            dssmenu.ChangelogItems[changelogKey] = changelogItem
        end

        function dssmenu.DoesLogWantNotification(log)
            local menusNotified = dssmenu.GetMenusNotified()
            if type(log) == "string" then
                return dssdirectory[log]
                    and dssdirectory[log].wantsnotify
                    and not menusNotified[log]
            elseif log.List then
                for _, val in ipairs(log.List) do
                    if dssmenu.DoesLogWantNotification(val) then
                        return true
                    end
                end
            end
        end

        function dssmenu.ReconstructMenus()
            dssdirectory.main.buttons = {
                { str = 'resume game',   action = 'resume' },
                { str = 'menu settings', dest = 'menusettings' },
                dssmod.changelogsButton,
            }

            dssdirectory.othermenus.buttons = {}

            local hasNonSubMenu
            local menuCount = 0
            local submenuCount = 0
            for k, v in pairs(dssmenu.Menus) do
                menuCount = menuCount + 1
                if v.UseSubMenu then
                    submenuCount = submenuCount + 1
                elseif k ~= "Menu" then
                    hasNonSubMenu = true
                end
            end

            dssmenu.MenuCount = menuCount

            for k, v in pairs(dssmenu.Menus) do
                if k ~= "Menu" then
                    local menubutton = { str = string.lower(k), action = "openmenu", menu = k }
                    if v.UseSubMenu and submenuCount > 1 then
                        table.insert(dssdirectory.othermenus.buttons, menubutton)
                    else
                        table.insert(dssdirectory.main.buttons, menubutton)
                    end
                end
            end

            if submenuCount > 1 and hasNonSubMenu then
                table.insert(dssdirectory.main.buttons, { str = 'other mods', dest = 'othermenus' })
            end
        end

        function dssmenu.AddMenu(name, tbl)
            tbl.Name = name
            dssmenu.Menus[name] = tbl
            dssmenu.ReconstructMenus()
        end

        dssmenu.ReconstructMenus()

        local openCalledRecently
        function dssmenu.OpenMenu(name)
            openCalledRecently = true

            local openFromNothing = not dssmenu.OpenedMenu
            if not openFromNothing then
                if dssmenu.OpenedMenu.Close then
                    dssmenu.OpenedMenu.Close(dssmenu.OpenedMenu, false, true, true)
                end
            else
                PlaySound(menuSounds.Open)
            end

            dssmenu.OpenedMenu = dssmenu.Menus[name]

            if dssmenu.OpenedMenu.Open then
                dssmenu.OpenedMenu.Open(dssmenu.OpenedMenu, openFromNothing)
            end
        end

        function dssmenu.CloseMenu(fullClose, noAnimate)
            local shouldFullClose = fullClose
                or dssmenu.MenuCount <= 2
                or dssmenu.OpenedMenu.Name == "Menu"
            if dssmenu.OpenedMenu and dssmenu.OpenedMenu.Close then
                dssmenu.OpenedMenu.Close(dssmenu.OpenedMenu, shouldFullClose, noAnimate)
            end

            if shouldFullClose then
                PlaySound(menuSounds.Close)
            end

            if not shouldFullClose and dssmenu.OpenedMenu and dssmenu.OpenedMenu.Name ~= "Menu" then
                dssmenu.OpenMenu("Menu")
            elseif dssmenu.OpenedMenu then
                -- support for animating menus out
                if noAnimate or not dssmenu.OpenedMenu.Exiting then
                    dssmenu.OpenedMenu = nil
                else
                    dssmenu.ExitingMenu = true
                end
            end
        end

        function dssmenu.IsOpen()
            return dssmenu.OpenedMenu
        end

        function dssmenu.CanOpenGlobalMenu()
            return dssmenu.MenuCount ~= 2 or #dssmenu.Changelogs.List > 1
        end

        function dssmenu.GetCoreInput() -- allows overriding the menu's input
            return MenuProvider.GetCoreInput()
        end

        function dssmenu.OpenMenuToPath(name, item, path, preventClosing)
            local menu = dssmenu.Menus[name]
            if not menu.Directory then
                error("Unsupported menu passed to DeadSeaScrollsMenu.OpenMenuToPath.", 2)
            end

            local dir, key = menu.Directory, menu.DirectoryKey
            DeadSeaScrollsMenu.OpenMenu(name)

            key.Item = dir[item]
            key.PreviousItem = nil

            if path then
                for i, v in ipairs(path) do
                    if type(v) == "string" then
                        path[i] = {
                            menuname = name,
                            item = v
                        }
                    elseif (v.menuname or v.menu) and v.item then
                        local menuname = v.menuname or v.menu
                        local menu2 = dssmenu.Menus[menuname]
                        if menu2.Directory then
                            path[i] = {
                                menuname = menuname,
                                item = v.item
                            }
                        else
                            error(
                                "Unsupported menu passed to DeadSeaScrollsMenu.OpenMenuToPath.",
                                2
                            )
                        end
                    else
                        error("Invalid path passed to DeadSeaScrollsMenu.OpenMenuToPath.", 2)
                    end
                end
            end

            key.Path = path or {}
            if preventClosing then
                key.PreventClosing = true
            end

            key.Main = item
        end

        function dssmenu.QueueMenuOpen(name, item, priority, preventClosing)
            local placeAt = #dssmenu.QueuedMenus + 1
            for i, menu in ipairs(dssmenu.QueuedMenus) do
                if priority > menu.priority then
                    placeAt = i
                    break
                end
            end

            table.insert(dssmenu.QueuedMenus, placeAt,
                { menu = name, item = item, priority = priority, preventClosing = preventClosing })
        end

        function dssmod:DisablePlayerControlsInMenu(player)
            local open = dssmenu.IsOpen()
            if open then
                player.ControlsCooldown = math.max(player.ControlsCooldown, 3)
                player:GetData().MenuDisabledControls = true
            else
                player:GetData().MenuDisabledControls = nil
            end
        end

        dssmod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, dssmod.DisablePlayerControlsInMenu)

        function dssmod:CheckMenuOpen()
            openCalledRecently = false

            if not StageAPI or not StageAPI.Loaded or StageAPI.IsPauseMenuOpen() then
                dssmod.checkMenu()
            end
        end

        function dssmod.CheckMenuOpenStageAPI(isPauseMenuOpen)
            if not isPauseMenuOpen then
                dssmod.checkMenu()
            end
        end

        if StageAPI and StageAPI.Loaded then
            StageAPI.UnregisterCallbacks("DeadSeaScrollsMenu")
            StageAPI.AddCallback(
                "DeadSeaScrollsMenu",
                "POST_HUD_RENDER",
                99,
                dssmod.CheckMenuOpenStageAPI
            )
        end

        dssmod:AddCallback(ModCallbacks.MC_POST_RENDER, dssmod.CheckMenuOpen)

        local recentGameStart = false --- @type boolean | nil
        function dssmod:CloseMenuOnGameStart()
            if not openCalledRecently and dssmenu.IsOpen() then
                dssmenu.CloseMenu(true, true)
            end

            recentGameStart = true
        end

        dssmod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, dssmod.CloseMenuOnGameStart)

        dssmenu.PlayedBuzzer = false
        function dssmod.ResetBuzzerCheck()
            dssmenu.PlayedBuzzer = false
        end

        dssmod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, dssmod.ResetBuzzerCheck)

        function dssmod:OpenQueuedMenus()
            if #dssmenu.QueuedMenus > 0 and not dssmenu.IsOpen() then
                local first, exceptFirst = dssmenu.QueuedMenus[1], nil
                if #dssmenu.QueuedMenus > 1 then
                    exceptFirst = {}
                    for i = #dssmenu.QueuedMenus, 2, -1 do
                        exceptFirst[#exceptFirst + 1] = dssmenu.QueuedMenus[i]
                    end
                end

                dssmenu.OpenMenuToPath(first.menu, first.item, exceptFirst, first.preventClosing)
                dssmenu.QueuedMenus = {}
            end

            -- This is delayed from game start to allow mods to add changelogs on game start without
            -- breaking notifications / popups.
            if recentGameStart then
                recentGameStart = nil

                local popups = dssmenu.GetMenusPoppedUp()
                local shouldSave
                for k, v in pairs(dssdirectory) do
                    if v.wantspopup then
                        if not popups[k] then
                            popups[k] = true
                            dssmenu.QueueMenuOpen("Menu", k, 0)
                            shouldSave = true
                        end
                    end
                end

                for k, v in pairs(popups) do
                    if not dssdirectory[k] or not dssdirectory[k].wantspopup then
                        popups[k] = nil
                        shouldSave = true
                    end
                end

                local notifies = dssmenu.GetMenusNotified()
                for k, v in pairs(notifies) do
                    if not dssdirectory[k] or not dssdirectory[k].wantsnotify then
                        notifies[k] = nil
                        shouldSave = true
                    end
                end

                if shouldSave then
                    MenuProvider.SaveMenusPoppedUp(popups)
                    MenuProvider.SaveMenusNotified(notifies)
                    MenuProvider.SaveSaveData()
                end
            end
        end

        dssmod:AddCallback(ModCallbacks.MC_POST_UPDATE, dssmod.OpenQueuedMenus)

        function dssmenu.RemoveCallbacks()
            dssmod:RemoveCallback(
                ModCallbacks.MC_POST_PEFFECT_UPDATE,
                dssmod.DisablePlayerControlsInMenu
            )
            dssmod:RemoveCallback(ModCallbacks.MC_POST_RENDER, dssmod.CheckMenuOpen)
            dssmod:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, dssmod.CloseMenuOnGameStart)
            dssmod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, dssmod.OpenQueuedMenus)
            dssmod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, dssmod.ResetBuzzerCheck)

            if StageAPI and StageAPI.Loaded then
                StageAPI.UnregisterCallbacks("DeadSeaScrollsMenu")
            end
        end

        dssmenu.AddMenu("Menu",
            {
                Run = dssmod.runMenu,
                Open = dssmod.openMenu,
                Close = dssmod.closeMenu,
                Directory = dssdirectory,
                DirectoryKey = dssdirectorykey
            })

        DeadSeaScrollsMenu = dssmenu
    end

    if not dssmenu or (dssmenu.CoreVersion < DSSCoreVersion) then
        if dssmenu then
            dssmenu.RemoveCallbacks()
        else
            dssmenu = { Menus = {} }
        end

        dssmenu.CoreVersion = DSSCoreVersion
        dssmenu.CoreMod = DSSModName
        DeadSeaScrollsMenu = dssmenu
    end

    function MenuProvider.IsMenuCore()
        return DeadSeaScrollsMenu.CoreMod == DSSModName
    end

    function MenuProvider.GetCoreInput()
        return menuinput
    end

    if MenuProvider.IsMenuCore() then
        InitializeMenuCore()
    end

    return dssmod
end

return dssmenucore
