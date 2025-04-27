luaDebugMode = true

function onCreate()
    runHaxeCode("createGlobalCallback('snapCamFollowToPos', function(x,y){parentLua.call('camSnap', [x,y]);});")
end

function camSnap(x,y)
    callMethod('camFollow.setPosition', {x,y})
    setCameraScroll(x,y)
end

function onEvent(eventName, value1, value2)
    if eventName ~= 'camTween' then return end

    local splitV2 = stringSplit(value2, ',')
    local duration, easing = splitV2[1], splitV2[2]

    if value1 == '' then
        setProperty('isCameraOnForcedPos', false)
        return
    end

    if value1:find(',') then
        local splitV1 = stringSplit(value1, ',')
        local posX, posY, zoom = splitV1[1], splitV1[2], splitV1[3]

        setProperty('isCameraOnForcedPos', true)
        startTween('camPosEvent', 'camFollow', {x = posX, y = posY}, duration, {ease = easing})

        if zoom then
            startTween('zoomEvent', 'game', {defaultCamZoom = zoom}, duration, {ease = easing})
        end
    else
        startTween('zoomEvent', 'camGame', {zoom = value1}, duration, {ease = easing})
        setProperty('defaultCamZoom', value1)
    end
end