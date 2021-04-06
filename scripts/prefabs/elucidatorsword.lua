---@diagnostic disable: undefined-global

local assets = {
    Asset("ANIM", "anim/elucidatorsword.zip"),
    Asset("ANIM", "anim/swap_elucidatorsword.zip"),
    Asset("IMAGE", "images/inventoryimages/elucidatorsword.tex"),
    Asset("ATLAS", "images/inventoryimages/elucidatorsword.xml"),
}

STRINGS.NAMES.ELUCIDATORSWORD = "阐释者"
STRINGS.RECIPE_DESC.ELUCIDATORSWORD = "刀剑神域 50 层 BOSS 的掉落武器."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ELUCIDATORSWORD = "Star Burst Stream !"

-- 原本攻击速度
local attack_speed_old = 0.4
-- 新攻击速度
local attack_speed_new = 0.3
-- 攻击力
local attack_power = 120
-- 攻击距离
local attack_distance = 1.3
-- 耐久
local item_durability = 2400

-- 星爆气流斩额外伤害
local starBurstStream_damage = 360
-- 暴击率
local critRate = 0.35
-- 暴击额外伤害
local crit_damage = attack_power * 1

-- 移动速度
local move_speed = 1.25

-- 装备函数
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_elucidatorsword", "swap_elucidatorsword")
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
local function onattack (inst, owner, target, attacker)

    -- 星爆气流斩-附加黑色标记
    if not target:HasTag("StarBurstStream_Black") then
        target:AddTag("StarBurstStream_Black")
    end

    -- 星爆气流斩-消除蓝色标记
    if target:HasTag("StarBurstStream_Blue") then
        target:RemoveTag("StarBurstStream_Blue")
        target.components.combat:GetAttacked(inst, starBurstStream_damage)
        SpawnPrefab("shadowstrike_slash2_fx").Transform:SetPosition(target:GetPosition():Get())
    end

    -- 暴击
    if math.random() < critRate then
        if target ~= nil
            and target.components.health
            and not target.components.health:IsDead()
            and not target:HasTag("structure")
            and not target:HasTag("wall")
            and not target:HasTag("hive")
            and not target:HasTag("hide")
            and not target:HasTag("alignwall")
            and not target:HasTag("groundspike") then
            target.components.combat:GetAttacked(inst, crit_damage)
        end
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

    inst.AnimState:SetBank("elucidatorsword")
    inst.AnimState:SetBuild("elucidatorsword")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "elucidatorsword.tex" )

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
    inst.components.inventoryitem.imagename = "elucidatorsword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/elucidatorsword.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = move_speed

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab( "common/inventory/elucidatorsword", fn, assets, prefabs)