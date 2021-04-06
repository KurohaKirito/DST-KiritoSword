---@diagnostic disable: undefined-global

local Ingredient = GLOBAL.Ingredient
-- local RECIPETABS = GLOBAL.RECIPETABS
-- local Recipe = GLOBAL.Recipe
-- local TECH = GLOBAL.TECH

PrefabFiles = {
    "elucidatorsword",
    "darkrepulsersword",
    "blackplate",
    "nightskysword",
    "bluerosesword",
    "elucidatorgem",
    "gigascedar",
    "crystallite",
}

-- 资源路径
local assets = {
    Asset("ANIM", "anim/elucidatorsword.zip"),
    Asset("ANIM", "anim/swap_elucidatorsword.zip"),
    Asset("IMAGE", "images/inventoryimages/elucidatorsword.tex"),
    Asset("ATLAS", "images/inventoryimages/elucidatorsword.xml"),

    Asset("ANIM", "anim/darkrepulsersword.zip"),
    Asset("ANIM", "anim/swap_darkrepulsersword.zip"),
    Asset("IMAGE", "images/inventoryimages/darkrepulsersword.tex"),
    Asset("ATLAS", "images/inventoryimages/darkrepulsersword.xml"),

    Asset("ANIM", "anim/blackplate.zip"),
    Asset("ANIM", "anim/swap_blackplate.zip"),
    Asset("IMAGE", "images/inventoryimages/blackplate.tex"),
    Asset("ATLAS", "images/inventoryimages/blackplate.xml"),

    Asset("ANIM", "anim/nightskysword.zip"),
    Asset("ANIM", "anim/swap_nightskysword.zip"),
    Asset("IMAGE", "images/inventoryimages/nightskysword.tex"),
    Asset("ATLAS", "images/inventoryimages/nightskysword.xml"),

    Asset("ANIM", "anim/bluerosesword.zip"),
    Asset("ANIM", "anim/swap_bluerosesword.zip"),
    Asset("IMAGE", "images/inventoryimages/bluerosesword.tex"),
    Asset("ATLAS", "images/inventoryimages/bluerosesword.xml"),

    Asset("ANIM", "anim/elucidatorgem_build.zip"),
    Asset("ATLAS", "images/inventoryimages/elucidatorgem.xml"),

    Asset("ANIM", "anim/gigascedar_build.zip"),
    Asset("ATLAS", "images/inventoryimages/gigascedar.xml"),

    Asset("ANIM", "anim/crystallite_build.zip"),
    Asset("ATLAS", "images/inventoryimages/crystallite.xml"),
}

-- 小地图图标
AddMinimapAtlas("images/map_icons/elucidatorsword.xml")
AddMinimapAtlas("images/map_icons/darkrepulsersword.xml")
AddMinimapAtlas("images/map_icons/blackplate.xml")
AddMinimapAtlas("images/map_icons/nightskysword.xml")
AddMinimapAtlas("images/map_icons/bluerosesword.xml")

-- 合成公式: 漆黑巨剑
local blackplate = GLOBAL.Recipe("blackplate",
    {
        Ingredient("charcoal", 5),
        Ingredient("log", 2),
        Ingredient("flint", 5),
    },
    GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO)
blackplate.atlas = "images/inventoryimages/blackplate.xml"

-- 合成公式: 阐释者
local elucidatorsword = GLOBAL.Recipe("elucidatorsword",
    {
        Ingredient("elucidatorgem", 2, "images/inventoryimages/elucidatorgem.xml"),
        Ingredient("nightmarefuel", 8),
    },
    GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO)
elucidatorsword.atlas = "images/inventoryimages/elucidatorsword.xml"

-- 合成公式: 逐暗者
local darkrepulsersword = GLOBAL.Recipe("darkrepulsersword",
    {
        Ingredient("crystallite", 1, "images/inventoryimages/crystallite.xml"),
        Ingredient("hammer", 1),
        Ingredient("nightmarefuel", 8),
    },
    GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO)
darkrepulsersword.atlas = "images/inventoryimages/darkrepulsersword.xml"

-- 合成公式: 夜空之剑
local nightskysword = GLOBAL.Recipe("nightskysword",
    {
        Ingredient("gigascedar", 1, "images/inventoryimages/gigascedar.xml"),
        Ingredient("marble", 4),
        Ingredient("nightmarefuel", 8),
    },
    GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO)
nightskysword.atlas = "images/inventoryimages/nightskysword.xml"

-- 合成公式: 恶魔之树的顶枝
local gigascedar = GLOBAL.Recipe("gigascedar",
    {
        Ingredient("livinglog", 10),
    },
    GLOBAL.RECIPETABS.REFINE, GLOBAL.TECH.SCIENCE_TWO)
gigascedar.atlas = "images/inventoryimages/gigascedar.xml"

-- 合成公式: 蓝蔷薇之剑
local bluerosesword = GLOBAL.Recipe("bluerosesword",
    {
        Ingredient("ice", 25),
        Ingredient("blueamulet", 1),
    },
    GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO)
bluerosesword.atlas = "images/inventoryimages/bluerosesword.xml"

-- 克劳斯 BOSS 掉落: 阐释者, 逐暗者, 夜空之剑, 蓝蔷薇之剑
local function AddBossLootKlaus(prefab)
    if prefab.components.lootdropper then
        prefab.components.lootdropper:AddChanceLoot('elucidatorsword',0.1)
        prefab.components.lootdropper:AddChanceLoot('darkrepulsersword', 0.1)
        prefab.components.lootdropper:AddChanceLoot('nightskysword', 0.1)
        prefab.components.lootdropper:AddChanceLoot('bluerosesword', 0.1)
    end
end

-- 蚁狮 BOSS 掉落: 黑宝石, 水晶石英铸块
local function AddBossLootAntlion(prefab)
    if prefab.components.lootdropper then
        prefab.components.lootdropper:AddChanceLoot('elucidatorgem', 1)
        prefab.components.lootdropper:AddChanceLoot('crystallite', 1)
    end
end

AddPrefabPostInit("klaus", AddBossLootKlaus)
AddPrefabPostInit("antlion", AddBossLootAntlion)
