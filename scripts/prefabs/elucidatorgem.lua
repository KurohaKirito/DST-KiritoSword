---@diagnostic disable: undefined-global

local Assets =
{
    Asset("ANIM", "anim/elucidatorgem_build.zip"),
    Asset("ATLAS", "images/inventoryimages/elucidatorgem.xml"),
}

STRINGS.NAMES.ELUCIDATORGEM = "黑宝石"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ELUCIDATORGEM = "质地极其坚硬的漆黑宝石"

local function fn(Sim)
    local inst = CreateEntity()
       inst.entity:AddTransform()
       inst.entity:AddAnimState()
       inst.entity:AddSoundEmitter()
       inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("elucidatorgem")
    inst.AnimState:SetBuild("elucidatorgem_build")
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
    inst.components.inventoryitem.atlasname = "images/inventoryimages/elucidatorgem.xml"

    inst:AddComponent("bait")

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab( "common/inventory/elucidatorgem", fn, Assets)