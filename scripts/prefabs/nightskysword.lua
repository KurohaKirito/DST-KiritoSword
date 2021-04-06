---@diagnostic disable: undefined-global

local assets = {
    Asset("ANIM", "anim/nightskysword.zip"),
    Asset("ANIM", "anim/swap_nightskysword.zip"),
    Asset("IMAGE", "images/inventoryimages/nightskysword.tex"),
    Asset("ATLAS", "images/inventoryimages/nightskysword.xml"),
}

STRINGS.NAMES.NIGHTSKYSWORD = "夜空之剑"
STRINGS.RECIPE_DESC.NIGHTSKYSWORD = "使用恶魔之树最顶端的树枝制作而成, 密度极高."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NIGHTSKYSWORD = "这把剑在 Under World 中的 ID 为 WLSS102382."

-- 原本攻击速度
local attack_speed_old = 0.4
-- 新攻击速度
local attack_speed_new = 0.36
-- 攻击力
local attack_power = 110
-- 攻击距离
local attack_distance = 1.2
-- 耐久
local item_durability = 2000

-- 技能额外伤害
local skill_damage = 360 - attack_power
-- 技能冷却时间
local skill_cool_time = 5

-- 移动速度
local move_speed = 1.2

-- 装备函数
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_nightskysword", "swap_nightskysword")
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
local function onattack(inst, owner, target)
    if target ~= nil
        and target.components.health
        and not target.components.health:IsDead()
        and not target:HasTag("structure")
        and not target:HasTag("wall")
        and not target:HasTag("hive")
        and not target:HasTag("hide")
        and not target:HasTag("alignwall")
        and not target:HasTag("groundspike")
        and not inst:HasTag("swordskillcooldown") then

        inst:AddTag("swordskillcooldown")
        target.components.combat:GetAttacked(inst, skill_damage)

        SpawnPrefab("shadow_despawn").Transform:SetPosition(target:GetPosition():Get())
        inst:DoTaskInTime(skill_cool_time, function() inst:RemoveTag("swordskillcooldown") end)
    end
end

-- 耐久用完函数
local function onfinished(inst)
    inst:Remove()
end

-- 物品创建函数
local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("nightskysword")
    inst.AnimState:SetBuild("nightskysword")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "nightskysword.tex" )

    --判断: 如果不是主机, 直接结束函数 (因为后面的组件只能挂载在主机上)
    if not TheWorld.ismastersim then
        return inst
    end

    --节约一点网络带宽
    inst.entity:SetPristine()

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(attack_power)
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetRange(attack_distance, attack_distance)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(item_durability)
    inst.components.finiteuses:SetUses(item_durability)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "nightskysword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/nightskysword.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = move_speed

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab( "common/inventory/nightskysword", fn, assets, prefabs)