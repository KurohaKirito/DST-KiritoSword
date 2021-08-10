---@diagnostic disable: undefined-global

local assets = {
    Asset("ANIM", "anim/darkrepulsersword.zip"),
    Asset("ANIM", "anim/swap_darkrepulsersword.zip"),
    Asset("IMAGE", "images/inventoryimages/darkrepulsersword.tex"),
    Asset("ATLAS", "images/inventoryimages/darkrepulsersword.xml"),
}

STRINGS.NAMES.DARKREPULSERSWORD = "逐暗者"
STRINGS.RECIPE_DESC.DARKREPULSERSWORD = "莉兹贝特倾注其爱意所锻造的剑."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DARKREPULSERSWORD = "Star Burst Stream !"

-- 原本攻击速度
local attack_speed_old = 0.4
-- 新攻击速度
local attack_speed_new = 0.36
-- 攻击力
local attack_power = 75
-- 攻击距离
local attack_distance = 1.2
-- 最大耐久
local max_uses = 1600

-- 星爆气流斩额外伤害
local starBurstStream_damage = 360

-- 暴击率
local critRate = 0.35
-- 暴击额外伤害
local crit_damage = attack_power * 1

-- 移动速度
local move_speed = 1.25

-- 每次可修复的耐久
local fixed_uses = max_uses * 0.1
-- 修补材料
local fixed_material = "lightbulb"

-- 装备函数
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_darkrepulsersword", "swap_darkrepulsersword")
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

    -- 星爆气流斩-附加蓝色标记
    if not target:HasTag("StarBurstStream_Blue") then
        target:AddTag("StarBurstStream_Blue")
    end

    -- 星爆气流斩-消除黑色标记
    if target:HasTag("StarBurstStream_Black") then
        target:RemoveTag("StarBurstStream_Black")
        target.components.combat:GetAttacked(inst, starBurstStream_damage)
        SpawnPrefab("shadowstrike_slash2_fx").Transform:SetPosition(target:GetPosition():Get())
    end

    -- 暴击
    if math.random() <= critRate then
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

-- 指定修复材料
local function acceptitem(inst, item)
    return (inst.components.finiteuses:GetUses() < max_uses) and (item.prefab == fixed_material)
end

-- 修复耐久函数
local function onaccept(inst, giver, item, player)
    if inst.components.finiteuses then
        inst.components.finiteuses:SetUses(inst.components.finiteuses:GetUses() + fixed_uses)
        if inst.components.finiteuses:GetUses() > max_uses then
            inst.components.finiteuses:SetUses(max_uses)
        end
    end
    giver.components.talker:Say("当前耐久: "..inst.components.finiteuses:GetUses())
end

-- 物品创建函数
local function fn(Sim)
    local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("darkrepulsersword")
    inst.AnimState:SetBuild("darkrepulsersword")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("darkrepulsersword.tex")

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
    inst.components.finiteuses:SetMaxUses(max_uses)
    inst.components.finiteuses:SetUses(max_uses)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "darkrepulsersword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/darkrepulsersword.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = move_speed

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(acceptitem)
    inst.components.trader.onaccept = onaccept

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab( "common/inventory/darkrepulsersword", fn, assets, prefabs)