---@diagnostic disable: undefined-global

local Assets =
{
    Asset("ANIM", "anim/crystallite_build.zip"),
    Asset("ATLAS", "images/inventoryimages/crystallite.xml"),
}

STRINGS.NAMES.CRYSTALLITE = "水晶石英铸块"
STRINGS.RECIPE_DESC.DARKREPULSERSWORD = "西部极寒地区由巨龙所精炼的稀有材料."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CRYSTALLITE = "总觉得有种怪怪的气味~"

local function fn(Sim)
    local inst = CreateEntity()
       inst.entity:AddTransform()
       inst.entity:AddAnimState()
       inst.entity:AddSoundEmitter()
       inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("crystallite")
    inst.AnimState:SetBuild("crystallite_build")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("molebait")
    inst:AddTag("quakedebris")

    --判断: 如果不是主机, 直接结束函数 (因为后面的组件只能挂载在主机上)
    if not TheWorld.ismastersim then
        return inst
    end

    --节约一点网络带宽
    inst.entity:SetPristine()

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/crystallite.xml"

    inst:AddComponent("bait")

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab( "common/inventory/crystallite", fn, Assets)