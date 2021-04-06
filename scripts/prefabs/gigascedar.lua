---@diagnostic disable: undefined-global

local Assets =
{
    Asset("ANIM", "anim/gigascedar_build.zip"),
    Asset("ATLAS", "images/inventoryimages/gigascedar.xml"),
}

STRINGS.NAMES.GIGASCEDAR = "恶魔之树的顶枝"
STRINGS.RECIPE_DESC.GIGASCEDAR = "制作夜空之剑的材料"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GIGASCEDAR = "恶魔之树 (Gigas Cedar) 被蓝蔷薇之剑砍倒后其最顶端的树枝被制作成夜空之剑."

local function fn(Sim)
    local inst = CreateEntity()
       inst.entity:AddTransform()
       inst.entity:AddAnimState()
       inst.entity:AddSoundEmitter()
       inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("gigascedar")
    inst.AnimState:SetBuild("gigascedar_build")
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
    inst.components.inventoryitem.atlasname = "images/inventoryimages/gigascedar.xml"

    inst:AddComponent("bait")

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab( "common/inventory/gigascedar", fn, Assets)