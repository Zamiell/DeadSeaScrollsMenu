--
-- Generic and very straightforward data storage system used in the MenuProvider functions below
-- Use your own mod's functions for this if it has them! If not, however, feel free to copy this and
-- change the mod name.
--
local saveDataMod = RegisterMod("Dead Sea Scrolls Workshop", 1)
saveDataMod.menuSaveData = nil

local json = require("json")

function saveDataMod.GetSaveData()
    if not saveDataMod.menuSaveData then
        if Isaac.HasModData(saveDataMod) then
            saveDataMod.menuSaveData = json.decode(Isaac.LoadModData(saveDataMod))
        else
            saveDataMod.menuSaveData = {}
        end
    end

    return saveDataMod.menuSaveData
end

function saveDataMod.StoreSaveData()
    Isaac.SaveModData(saveDataMod, json.encode(saveDataMod.menuSaveData))
end

--
-- End of generic data storage manager
--

--
-- Start of menu code
--

-- Change this variable to match your mod. The standard is "Dead Sea Scrolls (Mod Name)"
local DSSModName = "Dead Sea Scrolls (Main)"

-- Every MenuProvider function below must have its own implementation in your mod, in order to
-- handle menu save data.
local MenuProvider = {}

function MenuProvider.SaveSaveData()
    saveDataMod.StoreSaveData()
end

function MenuProvider.GetPaletteSetting()
    return saveDataMod.GetSaveData().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    saveDataMod.GetSaveData().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return saveDataMod.GetSaveData().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        saveDataMod.GetSaveData().HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    return saveDataMod.GetSaveData().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    saveDataMod.GetSaveData().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return saveDataMod.GetSaveData().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    saveDataMod.GetSaveData().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return saveDataMod.GetSaveData().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    saveDataMod.GetSaveData().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return saveDataMod.GetSaveData().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    saveDataMod.GetSaveData().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    return saveDataMod.GetSaveData().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    saveDataMod.GetSaveData().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return saveDataMod.GetSaveData().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    saveDataMod.GetSaveData().MenusPoppedUp = var
end

local dssmenucore = include("dssmenucore")
dssmenucore.init(DSSModName, MenuProvider)
