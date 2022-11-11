---@diagnostic disable: undefined-global

local Ingredient = GLOBAL.Ingredient

PrefabFiles = {
    "blackplate", -- 漆黑巨剑
    "elucidatorsword", -- 阐释者
    "darkrepulsersword", -- 逐暗者
    "nightskysword", -- 夜空之剑
    "bluerosesword", -- 蓝蔷薇之剑
    "elucidatorgem", -- 阐释宝石
    "gigascedar", -- 恶魔之树的顶枝
    "crystallite", -- 水晶石英铸块
}

-- 资源路径
Assets = {
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

    Asset("IMAGE", "images/recipefiltericon.tex"),
    Asset("ATLAS", "images/recipefiltericon.xml"),
}

-- 小地图图标
AddMinimapAtlas("images/map_icons/elucidatorsword.xml")
AddMinimapAtlas("images/map_icons/darkrepulsersword.xml")
AddMinimapAtlas("images/map_icons/blackplate.xml")
AddMinimapAtlas("images/map_icons/nightskysword.xml")
AddMinimapAtlas("images/map_icons/bluerosesword.xml")

-- 自定义过滤器
GLOBAL.STRINGS.UI.CRAFTING_FILTERS["KIRITO_SWORD_FILTER"] = "刀剑神域"
AddRecipeFilter(
    {
        name = "KIRITO_SWORD_FILTER",
        atlas = "images/recipefiltericon.xml",
        image = "recipefiltericon.tex",
    }
)

-- 添加物品到自定义过滤器
AddRecipeToFilter("blackplate", "KIRITO_SWORD_FILTER")
AddRecipeToFilter("elucidatorsword", "KIRITO_SWORD_FILTER")
AddRecipeToFilter("darkrepulsersword", "KIRITO_SWORD_FILTER")
AddRecipeToFilter("nightskysword", "KIRITO_SWORD_FILTER")
AddRecipeToFilter("bluerosesword", "KIRITO_SWORD_FILTER")
AddRecipeToFilter("elucidatorgem", "KIRITO_SWORD_FILTER")
AddRecipeToFilter("gigascedar", "KIRITO_SWORD_FILTER")
AddRecipeToFilter("crystallite", "KIRITO_SWORD_FILTER")

-- 合成公式: 漆黑巨剑
AddRecipe2(
    "blackplate",
    {
        Ingredient("charcoal", 5),
        Ingredient("log", 2),
        Ingredient("flint", 5),
    },
    GLOBAL.TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages/blackplate.xml"
    },
    {"WEAPONS", "MODS", "KIRITO_SWORD_FILTER"}
)

-- 合成公式: 阐释者
AddRecipe2(
    "elucidatorsword",
    {
        Ingredient("elucidatorgem", 2, "images/inventoryimages/elucidatorgem.xml"),
        Ingredient("nightmarefuel", 8),
    },
    GLOBAL.TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages/elucidatorsword.xml"
    },
    {"WEAPONS", "MODS", "KIRITO_SWORD_FILTER"}
)

-- 合成公式: 逐暗者
AddRecipe2(
    "darkrepulsersword",
    {
        Ingredient("crystallite", 1, "images/inventoryimages/crystallite.xml"),
        Ingredient("hammer", 1),
        Ingredient("nightmarefuel", 8),
    },
    GLOBAL.TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages/darkrepulsersword.xml"
    },
    {"WEAPONS", "MODS", "KIRITO_SWORD_FILTER"}
)

-- 合成公式: 夜空之剑
AddRecipe2(
    "nightskysword",
    {
        Ingredient("gigascedar", 1, "images/inventoryimages/gigascedar.xml"),
        Ingredient("marble", 4),
        Ingredient("nightmarefuel", 8),
    },
    GLOBAL.TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages/nightskysword.xml"
    },
    {"WEAPONS", "MODS", "KIRITO_SWORD_FILTER"}
)

-- 合成公式: 蓝蔷薇之剑
AddRecipe2(
    "bluerosesword",
    {
        Ingredient("ice", 25),
        Ingredient("blueamulet", 1),
    },
    GLOBAL.TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages/bluerosesword.xml"
    },
    {"WEAPONS", "MODS", "KIRITO_SWORD_FILTER"}
)

-- 合成公式: 恶魔之树的顶枝
AddRecipe2(
    "gigascedar",
    {
        Ingredient("livinglog", 10),
    },
    GLOBAL.TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages/gigascedar.xml"
    },
    {"REFINE", "MODS", "KIRITO_SWORD_FILTER"}
)

-- 合成公式: 阐释宝石
AddRecipe2(
    "elucidatorgem",
    {
        Ingredient("redgem", 1),
        Ingredient("greengem", 1),
    },
    GLOBAL.TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages/elucidatorgem.xml"
    },
    {"REFINE", "MODS", "KIRITO_SWORD_FILTER"}
)

-- 合成公式: 水晶石英铸块
AddRecipe2(
    "crystallite",
    {
        Ingredient("ice", 25),
        Ingredient("bluegem", 1),
    },
    GLOBAL.TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages/crystallite.xml"
    },
    {"REFINE", "MODS", "KIRITO_SWORD_FILTER"}
)

-- 定义克劳斯 BOSS 新增掉落: 阐释者, 逐暗者, 夜空之剑, 蓝蔷薇之剑
local function AddBossLootKlaus(prefab)
    if prefab.components.lootdropper then
        prefab.components.lootdropper:AddChanceLoot('elucidatorsword', 0.3)
        prefab.components.lootdropper:AddChanceLoot('darkrepulsersword', 0.3)
        prefab.components.lootdropper:AddChanceLoot('nightskysword', 0.4)
        prefab.components.lootdropper:AddChanceLoot('bluerosesword', 0.4)
    end
end

-- 实装克劳斯掉落
AddPrefabPostInit("klaus", AddBossLootKlaus)

-- 定义蚁狮 BOSS 新增掉落: 黑宝石, 水晶石英铸块
local function AddBossLootAntlion(prefab)
    if prefab.components.lootdropper then
        prefab.components.lootdropper:AddChanceLoot('elucidatorgem', 2)
        prefab.components.lootdropper:AddChanceLoot('crystallite', 1)
    end
end

-- 实装蚁狮掉落
AddPrefabPostInit("antlion", AddBossLootAntlion)

-- 增加 "可作为武器修复材料" 组件
local function MaterialsToFixedWeapon(inst)
    if not inst.components.tradable then
        inst:AddComponent("tradable")
    end
end

-- 设置 "木炭" 可作为武器修补材料 (漆黑巨剑)
AddPrefabPostInit("charcoal", MaterialsToFixedWeapon)

-- 设置 "冰" 可作为武器修补材料 (蓝蔷薇之剑)
AddPrefabPostInit("ice", MaterialsToFixedWeapon)

-- 设置 "活木" 可作为武器修补材料 (夜空之剑)
AddPrefabPostInit("livinglog", MaterialsToFixedWeapon)

-- 设置 "荧光果" 可作为武器修补材料 (逐暗者)
AddPrefabPostInit("lightbulb", MaterialsToFixedWeapon)

-- 设置 "噩梦燃料" 可作为武器修补材料 (阐释者)
AddPrefabPostInit("nightmarefuel", MaterialsToFixedWeapon)
