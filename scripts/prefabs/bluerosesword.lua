---@diagnostic disable: undefined-global

local assets = {
    Asset("ANIM", "anim/bluerosesword.zip"),
    Asset("ANIM", "anim/swap_bluerosesword.zip"),
    Asset("IMAGE", "images/inventoryimages/bluerosesword.tex"),
    Asset("ATLAS", "images/inventoryimages/bluerosesword.xml"),
}

STRINGS.NAMES.BLUEROSESWORD = "蓝蔷薇之剑"
STRINGS.RECIPE_DESC.BLUEROSESWORD = "一把来自边缘山脉的极寒之剑"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLUEROSESWORD = "蓝蔷薇, 绽放吧!"

-- 原本攻击速度
local attack_speed_old = 0.4
-- 新攻击速度
local attack_speed_new = 0.36
-- 攻击力
local attack_power = 100
-- 攻击距离
local attack_distance = 1.2
-- 耐久
local item_durability = 1600

-- 冰冻技能发动率
local critRate = 0.35
-- 冰冻技能的范围
local skill_range = 5
-- 冰冻技能效果强度
local skill_freeze_effect = 0.5
-- 普攻冰冻效果强度
local attack_freeze_effect = 0.2

-- 移动速度
local move_speed = 1.1

-- 装备函数
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_bluerosesword", "swap_bluerosesword")
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
    -- 定义临时变量: 冰块
    local icspikes
    -- 获取目标怪物的位置
    local x, y, z = target.Transform:GetWorldPosition()

    -- 技能冰冻
    if math.random() <= critRate then
        local ents = TheSim:FindEntities(x, y, z, skill_range, nil)
        for index, monster_temp in pairs(ents) do
            if monster_temp and monster_temp:IsValid()
                and monster_temp.components.health ~= nil
                and not monster_temp.components.health:IsDead() then
                if not (monster_temp:HasTag("player")
                    or monster_temp:HasTag("INLIMBO")
                    or monster_temp:HasTag("structure")
                    or monster_temp:HasTag("companion")
                    or monster_temp:HasTag("abigial")) then

                    local rnd = math.random(1, 4)
                    if rnd == 1 then
                        icspikes = SpawnPrefab("icespike_fx_1")
                    elseif rnd == 2 then
                        icspikes = SpawnPrefab("icespike_fx_2")
                    elseif rnd == 3 then
                        icspikes = SpawnPrefab("icespike_fx_3")
                    elseif rnd == 4 then
                        icspikes = SpawnPrefab("icespike_fx_4")
                    end

                    icspikes.Transform:SetScale(2, 2, 2)
                    icspikes.Transform:SetPosition(monster_temp:GetPosition():Get())

                    if monster_temp ~= target then
                        monster_temp.components.health:DoDelta(-10)
                    end

                    if monster_temp.components.freezable ~= nil then
                        monster_temp.components.freezable:AddColdness(skill_freeze_effect)
                        monster_temp.components.freezable:SpawnShatterFX()
                    end
                end
            end
        end
    end

    -- 普攻冰冻
    if target.components.freezable ~= nil then
        target.components.freezable:AddColdness(attack_freeze_effect)
        target.components.freezable:SpawnShatterFX()
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

    inst.AnimState:SetBank("bluerosesword")
    inst.AnimState:SetBuild("bluerosesword")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "bluerosesword.tex" )

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
    inst.components.inventoryitem.imagename = "bluerosesword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bluerosesword.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = move_speed

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab( "common/inventory/bluerosesword", fn, assets, prefabs)