-- variables, do not touch
local deliveries = {}
local playersOnJob = {}

RegisterNetEvent("DrugTrafficking:StartedCollecting", function(drugVan)
    local src = source
    playersOnJob[src] = true
    -- No exploit check for starting the job
end)

RegisterNetEvent("DrugTrafficking:DrugsDelivered", function(location)
    local src = source
    -- keep track of amount of deliveries made
    if not deliveries[src] then
        deliveries[src] = 0
    end
    deliveries[src] = deliveries[src] + 1
end)

RegisterNetEvent("DrugTrafficking:NeedsPayment", function()
    local src = source

    -- Check if player completed any deliveries
    if not deliveries[src] or deliveries[src] == 0 then
        print(string.format("^1Warning: Player %s requested payment without completing the job", GetPlayerName(src)))
        return
    end

    -- Calculate reward
    local amount = Config.DrugPay * deliveries[src]

    -- Reset job data
    deliveries[src] = 0
    playersOnJob[src] = false

    -- Give cash using Az-Framework
    exports['Az-Framework']:addMoney(src, amount)

    print(string.format("^2Success: Gave $%d to %s for drug trafficking deliveries", amount, GetPlayerName(src)))
end)
