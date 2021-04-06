---@diagnostic disable: undefined-global

local assets = {
    Asset("ANIM", "anim/blackplate.zip"),
    Asset("ANIM", "anim/swap_blackplate.zip"),
    Asset("IMAGE", "images/inventoryimages/blackplate.tex"),
    Asset("ATLAS", "images/inventoryimages/blackplate.xml"),
}

STRINGS.NAMES.BLACKPLATE = "漆黑巨剑"
STRINGS.RECIPE_DESC.BLACKPLATE = "Kirito 在 ALO 中的初期用剑"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLACKPLATE = "一把漆黑的巨剑, 光看起来就很沉"

-- 原本攻击速度
local attack_speed_old = 0.4
-- 新攻击速度
local attack_speed_new = 0.48
-- 攻击力
local attack_power = 60
-- 攻击距离
local attack_distance = 1.2
-- 耐久
local item_durability = 600

-- 移动速度
local move_speed = 0.95

-- 装备函数
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_blackplate", "swap_blackplate")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    inst:AddTag("sword")
    attack_speed_old = owner.components.combat.min_attack_period
    owner.components.combat.min_attack_period = attack_speed_new
end

-- 卸下函数
local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst:RemoveTag("sword")
    owner.components.combat.min_attack_period = attack_speed_old
end

-- 攻击函数
local function onattack(inst, owner, target, attacker)
end

-- 耐久用完函数
local function onfinished(inst)
    inst:Remove()
end

-- 物品创建函数
local function fn(Sim)
    -- 创建这个物品
    local inst = CreateEntity()
    -- 增加 Transform 组件
    inst.entity:AddTransform()
    -- 增加动画组件
    inst.entity:AddAnimState()
    -- 增加网络组件
    inst.entity:AddNetwork()
    -- 定义物理系统
    MakeInventoryPhysics(inst)

    -- 设置动画模板的轮廓
    inst.AnimState:SetBank("blackplate")
    -- 设置动画的模型
    inst.AnimState:SetBuild("blackplate")
    -- 动画初始状态
    inst.AnimState:PlayAnimation("idle")

    -- 设置武器攻击时具有音效
    inst:AddTag("sharp")

    -- 设置小地图图标
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("blackplate.tex")

    --判断: 如果不是主机, 直接结束函数 (因为后面的组件只能挂载在主机上)
    if not TheWorld.ismastersim then
        return inst
    end

    --节约一点网络带宽
    inst.entity:SetPristine()

    -- 设置武器组件
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(attack_power)
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetRange(attack_distance, attack_distance)

    -- 设置是否可调查
    inst:AddComponent("inspectable")

    -- 设置是否可存放到物品栏
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "blackplate"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/blackplate.xml"

    -- 设置是否可装备
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = move_speed

    -- 设置有限耐久 (设置可使用次数)
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(item_durability)
    inst.components.finiteuses:SetUses(item_durability)
    inst.components.finiteuses:SetOnFinished(onfinished)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab( "common/inventory/blackplate", fn, assets, prefabs)
