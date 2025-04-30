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

    if eventName == 'Set Cam Zoom' then
        if value2 == '' then
            setProperty('defaultCamZoom', tonumber(value1))
        else
            startTween('j', 'game', {defaultCamZoom = tonumber(value1)}, tonumber(value2), {})
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

function onGameOverStart()
    makeLuaSprite('efecto','defeat effect',getMidpointX('boyfriend')-400,getMidpointY('boyfriend')-250)
    scaleObject('efecto',0.044,1)
    setProperty('efecto.alpha',0)
    addLuaSprite('efecto')

    makeLuaSprite('gameover','game over',getMidpointX('boyfriend')-540,getMidpointY('boyfriend')-500)
    setProperty('gameover.alpha',0)
    addLuaSprite('gameover')

    makeLuaSprite('textt','controls_death',0,670)
    setObjectCamera('textt','camOther')
    addLuaSprite('textt')

    startTween('gZoom', 'camGame', {zoom = getProperty('defaultCamZoom') + 0.3}, 3, {startDelay = 1.5, onComplete = 'effects'})
    function effects()
        doTweenAlpha('aa','efecto',1,1.5,'sineInOut')
        doTweenX('aaa','efecto.scale',4.74,3,'quadOut')
        doTweenAlpha('aatula','gameover',1,2,'quadOut')
        doTweenY('aaaAA','gameover',350,1.5,'quadOut')
    end
end

function onCountdownStarted()
    playSound('cancelMenu')

    makeLuaSprite('count', 'get-ready')
    addLuaSprite('count')
    runHaxeCode("game.getLuaObject('count').camera = getVar('camPause');")

    scaleObject('count', 0.5, 0.5)
    screenCenter('count')

    local oldY = getProperty('count.y')
    setProperty('count.y', screenHeight)
    startTween('counTween', 'count', {y = oldY}, crochet/1000, {ease = 'cubeInOut'})
end

function onCountdownTick(tick)
    setProperty('countdownReady.visible', false)
    setProperty('countdownSet.visible', false)
    setProperty('countdownGo.visible', false)

    local time = crochet/1000

    if tick < 4 then
        scaleObject('count', 0.55, 0.55, false)
        startTween('countScale', 'count.scale', {x = 0.5, y = 0.5}, time/2, {})
    end

    if tick == 1 then
        loadGraphic('count', 'ready')
        updateHitbox('count')
        screenCenter('count')
    elseif tick == 2 then
        loadGraphic('count', 'set')
        updateHitbox('count')
        screenCenter('count')
    elseif tick == 3 then
        loadGraphic('count', 'go')
        updateHitbox('count')
        screenCenter('count')
    elseif tick == 4 then
        startTween('byeCount', 'count', {y = screenHeight}, time, {ease = 'cubeInOut', onComplete = 'removeCount'})
        function removeCount() removeLuaSprite('count', true) end
    end
end