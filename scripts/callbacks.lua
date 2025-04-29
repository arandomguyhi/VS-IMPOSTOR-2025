luaDebugMode = true

function onCreate()
    runHaxeCode("createGlobalCallback('snapCamFollowToPos', function(x,y){parentLua.call('camSnap', [x,y]);});")

    makeLuaSprite('flashSprite') makeGraphic('flashSprite', 1280, 720, 'b30000')
    setProperty('flashSprite.alpha', 0)
    setObjectCamera('flashSprite', 'camOther')
    addLuaSprite('flashSprite')

    runHaxeCode([[
        var camPause = new FlxCamera();
        camPause.bgColor = 0x0;

        for (cams in [game.camHUD, game.camOther])
            FlxG.cameras.remove(cams, false);
        for (cams in [game.camOther, game.camHUD, camPause]) // yes, camOther is behind camHUD
            FlxG.cameras.add(cams, false);

        setVar('camPause', camPause);
    ]])
end

function camSnap(x,y)
    callMethod('camFollow.setPosition', {x,y})
    setCameraScroll(x,y)
end

function onEvent(eventName, value1, value2)
    if eventName == 'Reactor Flash' then
        if flashingLights then
            setProperty('flashSprite.alpha', 0.3)
            local flashDuration = tonumber(value1)
            if type(flashDuration) ~= 'number' then
                flashDuration = 0.5 end
            doTweenAlpha('reactorTween', 'flashSprite', 0, flashDuration)
        end
    end

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