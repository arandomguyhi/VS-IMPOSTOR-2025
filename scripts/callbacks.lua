luaDebugMode = true

function onCreate()
    runHaxeCode("createGlobalCallback('snapCamFollowToPos', function(x,y){parentLua.call('camSnap', [x,y]);});")

    makeLuaSprite('flashSprite') makeGraphic('flashSprite', 1280, 720, 'b30000')
    setProperty('flashSprite.alpha', 0)
    setObjectCamera('flashSprite', 'camOther')
    addLuaSprite('flashSprite', true)

    createInstance('camPause', 'flixel.FlxCamera')
    setProperty('camPause.bgColor', 0x0)

    for _, cams in pairs({'camHUD', 'camOther'}) do
        callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg(cams), false}) end
    for _, cams in pairs({'camOther', 'camHUD', 'camPause'}) do -- yes, camOther is behind camHUD
        callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg(cams), false}) end
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
    if value1 == '' then
        setProperty('isCameraOnForcedPos', false)
        return
    end

    setProperty('isCameraOnForcedPos', true)
    local coords = stringSplit(value1, ',')
    local timing = stringSplit(value2, ',')

    if value2 == '' and #coords >= 2 then
       local x = tonumber(coords[1])
       local y = tonumber(coords[2])
       callMethod('camFollow.setPosition', {x, y})

       if #coords == 3 then
           local zoom = tonumber(coords[3])
           setProperty('camGame.zoom', zoom)
           setProperty('defaultCamZoom', zoom)
       end
       return
    end

    if #coords == 1 and #timing == 2 then
        local leZoom, leTime, easingMethod = tonumber(value1), tonumber(timing[1]), tostring(timing[2])
        startTween('zoomEvent', 'game', {['camGame.zoom'] = leZoom, defaultCamZoom = leZoom}, leTime, {ease = easingMethod})
        return
    end

    if (#coords == 2 or #coords == 3) and #timing == 2 then
        local x, y = tonumber(coords[1]), tonumber(coords[2])
        local time, easingMethod = tonumber(timing[1]), tostring(timing[2])

        startTween('camPosEvent', 'camFollow', {x = x, y = y}, time, {ease = easingMethod})
        if #coords == 3 then
            local zoom = tonumber(coords[3])
            startTween('zoomEvent', 'game', {defaultCamZoom = zoom}, time, {ease = easingMethod})
        end
    end
end