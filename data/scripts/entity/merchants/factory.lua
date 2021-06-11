Factory.buildConfigUI = function(tab)
    local thsplit = UIHorizontalSplitter(Rect(tab.size), 10, 0, 0.35)
    local thsplit2 = UIHorizontalSplitter(thsplit.top, 10, 0, 0.75)

    -- top area showing production
    tab:createFrame(thsplit2.top)

    local vsplit = UIVerticalMultiSplitter(thsplit2.top, 80, 10, 2)

    local lister = UIVerticalLister(vsplit:partition(0), 4, 0)
    ingredientLabels = {}
    for i = 1, 20 do
        local rect = lister:nextRect(10)
        local vsplit = UIVerticalSplitter(rect, 5, 0, 0.86)

        local left = tab:createLabel(vsplit.left, "", 11)
        left:setLeftAligned()
        left.font = FontType.Normal

        local right = tab:createLabel(vsplit.left, "", 11)
        right:setRightAligned()
        right.font = FontType.Normal

        local supply = tab:createLabel(vsplit.right, "", 11)
        supply:setRightAligned()
        supply.font = FontType.Normal
        supply.color = ColorRGB(0, 1, 0)

        table.insert(ingredientLabels, {left = left, right = right, supply = supply})
    end

    local lister = UIVerticalLister(vsplit:partition(1), 4, 0)
    productLabels = {}
    for i = 1, 20 do
        local rect = lister:nextRect(10)
        local vsplit = UIVerticalSplitter(rect, 5, 0, 0.86)

        local left = tab:createLabel(vsplit.left, "", 11)
        left:setLeftAligned()
        left.font = FontType.Normal

        local right = tab:createLabel(vsplit.left, "", 11)
        right:setRightAligned()
        right.font = FontType.Normal

        local supply = tab:createLabel(vsplit.right, "", 11)
        supply:setRightAligned()
        supply.font = FontType.Normal
        supply.color = ColorRGB(0, 1, 0)

        table.insert(productLabels, {left = left, right = right, supply = supply})
    end

    local lister = UIVerticalLister(vsplit:partition(2), 4, 0)
    statsLabels = {}
    for i = 1, 8 do
        local rect = lister:nextRect(10)

        local left = tab:createLabel(rect, "", 11)
        left:setLeftAligned()
        left.font = FontType.Normal

        local right = tab:createLabel(rect, "", 11)
        right:setRightAligned()
        right.font = FontType.Normal

        table.insert(statsLabels, {left = left, right = right})
    end

    local a = vsplit:partition(0)
    local b = vsplit:partition(1)
    local center = (a.center + b.center) / 2

    local r = Rect(center - 30, center + 30)
    r.position = r.position + vec2(0, -20)
    productionIcon = tab:createPicture(r, "data/textures/icons/production.png")
    productionIcon.isIcon = true

    r.position = r.position + vec2(0, 40)
    numProductionsLabel = tab:createLabel(r, "x3", 20)
    numProductionsLabel:setCenterAligned()

    -- error label for production problems
    productionErrorSign = UICollection()
    local frame = tab:createFrame(thsplit2.bottom)

    thsplit2:setPadding(15, 15, 15, 15)

    local label = tab:createLabel(thsplit2.bottom, "Station can't produce because ingredients are missing!", 14)
    label.color = ColorRGB(1, 1, 0)
    label.centered = true

    local vsplit = UIVerticalSplitter(thsplit2.bottom, 0, 0, 0.5)
    vsplit:setLeftQuadratic()

    local icon = tab:createPicture(vsplit.left, "data/textures/icons/hazard-sign.png")
    icon.isIcon = true
    icon.color = ColorRGB(1, 1, 0)
    icon.lower = icon.lower - vec2(5, 5)
    icon.upper = icon.upper + vec2(5, 5)

    productionErrorSign:insert(label)
    productionErrorSign:insert(icon)
    productionErrorSign:insert(frame)
    productionErrorSign.label = label
    productionErrorSign.icon = icon

    productionErrorSign:hide()


    -- lower area with config options
    local hsplit = UIHorizontalSplitter(thsplit.bottom, 10, 0, 0.8)
    local vsplit = UIVerticalMultiSplitter(thsplit.bottom, 10, 0, 2)
    local lister = UIVerticalLister(vsplit:partition(0), 5, 0)

    basePriceLabel = tab:createLabel(Rect(), "Base Price %"%_t, 12)
    lister:placeElementTop(basePriceLabel)
    basePriceLabel.centered = true

    basePriceSlider = tab:createSlider(Rect(), -20, 20, 40, "", "onBasePriceSliderChanged")
    lister:placeElementTop(basePriceSlider)
    basePriceSlider:setValueNoCallback(0)
    basePriceSlider.unit = "%"
    basePriceSlider.tooltip = "Sets the base price of goods bought and sold by this station. A low base price attracts more buyers and a high base price attracts more sellers."%_t


    lister:nextRect(15)

    allowBuyCheckBox = tab:createCheckBox(Rect(), "Buy goods from others"%_t, "onAllowBuyChecked")
    lister:placeElementTop(allowBuyCheckBox)
    allowBuyCheckBox:setCheckedNoCallback(true)
    allowBuyCheckBox.tooltip = "If checked, the station will buy goods from traders from other factions than you."%_t

    allowSellCheckBox = tab:createCheckBox(Rect(), "Sell goods to others"%_t, "onAllowSellChecked")
    lister:placeElementTop(allowSellCheckBox)
    allowSellCheckBox:setCheckedNoCallback(true)
    allowSellCheckBox.tooltip = "If checked, the station will sell goods to traders from other factions than you."%_t

    lister:nextRect(10)

    activelyRequestCheckBox = tab:createCheckBox(Rect(), "Actively request goods"%_t, "onActivelyRequestChecked")
    lister:placeElementTop(activelyRequestCheckBox)
    activelyRequestCheckBox:setCheckedNoCallback(true)
    activelyRequestCheckBox.tooltip = "If checked, the station will actively request traders to deliver goods when it's empty.\nIf unchecked, it may stay empty until a trader visits randomly."%_t

    activelySellCheckBox = tab:createCheckBox(Rect(), "Actively sell goods"%_t, "onActivelySellChecked")
    lister:placeElementTop(activelySellCheckBox)
    activelySellCheckBox:setCheckedNoCallback(true)
    activelySellCheckBox.tooltip = "If checked, the station will request traders that will buy its goods when it's full.\nIf unchecked, its goods may sit around until a trader visits randomly."%_t

    lister:nextRect(10)


    -- delivery UI
    local lister = UIVerticalLister(vsplit:partition(1), 8, 0)
    local label = tab:createLabel(Rect(), "Deliver goods to stations:"%_t, 12)
    lister:placeElementTop(label)
    label.centered = true

    lister:nextRect(5)

	for i = 1, 9 do
		local combo = tab:createValueComboBox(Rect(), "sendConfig")
		lister:placeElementTop(combo)
		table.insert(deliveredStationsCombos, combo)
	end
	
    lister:nextRect(30)

	local lister = UIVerticalLister(vsplit:partition(2), 8, 0)
    local label = tab:createLabel(Rect(), "Fetch goods from stations:"%_t, 12)
    lister:placeElementTop(label)
    label.centered = true

    lister:nextRect(5)

	for i = 1, 9 do 
		local combo = tab:createValueComboBox(Rect(), "sendConfig")
		lister:placeElementTop(combo)
		table.insert(deliveringStationsCombos, combo)
	end

    -- error labels
    local lister = UIVerticalLister(vsplit:partition(2), 15, 0)
    local label = tab:createLabel(Rect(), "", 6)
    lister:placeElementTop(label)
    label.centered = true
    lister:nextRect(0)

    local label = tab:createLabel(Rect(), "No more shuttles!", 14)
    lister:placeElementTop(label)
    table.insert(deliveredStationsErrorLabels, label)

    local label = tab:createLabel(Rect(), "No more shuttles!", 14)
    lister:placeElementTop(label)
    table.insert(deliveredStationsErrorLabels, label)

    local label = tab:createLabel(Rect(), "No more shuttles!", 14)
    lister:placeElementTop(label)
    table.insert(deliveredStationsErrorLabels, label)

    lister:nextRect(12)

    local label = tab:createLabel(Rect(), "", 12)
    lister:placeElementTop(label)
    label.centered = true

    lister:nextRect(5)

    local label = tab:createLabel(Rect(), "No more shuttles!", 14)
    lister:placeElementTop(label)
    table.insert(deliveringStationsErrorLabels, label)

    local label = tab:createLabel(Rect(), "No more shuttles!", 14)
    lister:placeElementTop(label)
    table.insert(deliveringStationsErrorLabels, label)

    local label = tab:createLabel(Rect(), "No more shuttles!", 14)
    lister:placeElementTop(label)
    table.insert(deliveringStationsErrorLabels, label)

    for _, labels in pairs({deliveringStationsErrorLabels, deliveredStationsErrorLabels}) do
        for _, label in pairs(labels) do
            label.caption = ""
            label.color = ColorRGB(1, 1, 0)
        end
    end


    -- upgrade UI
    local vsplit = UIVerticalMultiSplitter(hsplit.bottom, 10, 0, 2)
    local bhsplit = UIHorizontalSplitter(vsplit:partition(0), 10, 0, 0.4)

    upgradePriceLabel = tab:createLabel(bhsplit.top, "", 14)

    upgradeButton = tab:createButton(bhsplit.bottom, "Upgrade"%_t, "onUpgradeFactoryButtonPressed")
end

Factory.setConfig = function(config)
    if onClient() then
        -- apply config to UI elements
        basePriceSlider:setValueNoCallback(round((config.priceFactor - 1.0) * 100.0))
        basePriceLabel.tooltip = "This station will buy and sell its goods for ${percentage}% of the normal price."%_t % {percentage = round(config.priceFactor * 100.0)}

        allowBuyCheckBox:setCheckedNoCallback(config.buyFromOthers)
        allowSellCheckBox:setCheckedNoCallback(config.sellToOthers)
        activelyRequestCheckBox:setCheckedNoCallback(config.activelyRequest)
        activelySellCheckBox:setCheckedNoCallback(config.activelySell)

        local i = 1
        for id, trades in pairs(config.deliveredStations) do
            deliveredStationsCombos[i]:setSelectedValueNoCallback(id)
            i = i + 1
        end

        for a = i, 9 do
            deliveredStationsCombos[a]:setSelectedIndexNoCallback(0)
        end

        local i = 1
        for id, trades in pairs(config.deliveringStations) do
            deliveringStationsCombos[i]:setSelectedValueNoCallback(id)
            i = i + 1
        end

        for a = i, 9 do
            deliveringStationsCombos[a]:setSelectedIndexNoCallback(0)
        end

        if TradingAPI.window.visible then
            Factory.refreshConfigUI()
        end
    else
        if not config then return end

        -- apply config to factory settings
        local owner, station, player = checkEntityInteractionPermissions(Entity(), AlliancePrivilege.ManageStations)
        if not owner then return end

        Factory.trader.buyPriceFactor = math.min(1.5, math.max(0.5, config.priceFactor))
        Factory.trader.sellPriceFactor = Factory.trader.buyPriceFactor + 0.2

        Factory.trader.buyFromOthers = config.buyFromOthers
        Factory.trader.sellToOthers = config.sellToOthers
        Factory.trader.activelyRequest = config.buyFromOthers and config.activelyRequest
        Factory.trader.activelySell = config.sellToOthers and config.activelySell
        Factory.trader.deliveredStations = config.deliveredStations or {}
        Factory.trader.deliveringStations = config.deliveringStations or {}

        Factory.sendConfig()
    end
end