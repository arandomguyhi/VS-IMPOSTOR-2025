local ext = '../dk/stage/secret/'

setProperty('skipArrowStartTween', true)

function onCreate()
    removeLuaScript('scripts/susHUD')

    startVideo('banana', false, true, false, false)
    setObjectCamera('videoCutscene', 'camHUD')

    makeLuaSprite('bg', ext..'sky')

    makeLuaSprite('ohioSprite') makeGraphic('ohioSprite', 1280, 720, 'ffffff')
    setProperty('ohioSprite.alpha', 0)
    setProperty('ohioSprite.camera', instanceArg('camPause'), false, true)
    addLuaSprite('ohioSprite')

    makeLuaSprite('bushes', ext..'skyass', 300, 225)
    setScrollFactor('bushes', 0.75, 0.75)
    scaleObject('bushes', 0.5, 0.5, false)

    makeLuaSprite('stars', ext..'tree3', 0, -75)
    setScrollFactor('stars', 0.8, 0.8)

    makeLuaSprite('mountains', ext..'tree2', 0, -75)
    setScrollFactor('mountains', 0.85, 0.85)

    makeLuaSprite('mountains2', ext..'tree', 0, -75)
    setScrollFactor('mountains2', 0.9, 0.9)

    makeLuaSprite('floor', ext..'background')

    setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'diddy-dead')
    setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'diddyscream')
    setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'GameOverDK')
    setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'GameOverDK_end')

    createInstance('anotherCam', 'flixel.FlxCamera')
    setProperty('anotherCam.bgColor', 0x0)
    for _, cams in pairs({'camOther', 'camHUD', 'camPause'}) do
        callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg(cams), false}) end
    for _, cams in pairs({'camOther', 'camHUD', 'anotherCam', 'camPause'}) do
        callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg(cams), false}) end

    makeLuaSprite('blackSprite') makeGraphic('blackSprite', 1280, 720, '000000')
    setProperty('blackSprite.camera', instanceArg('anotherCam'), false, true)
    addLuaSprite('blackSprite')

    if shadersEnabled then
        initLuaShader('rozebud')

        makeLuaSprite('vhs') setSpriteShader('vhs', 'rozebud')
        runHaxeCode([[
            for (cams in [camHUD, camGame, getVar('camPause')])
                cams.setFilters([new ShaderFilter(game.getLuaObject('vhs').shader)]);
        ]])
     end

    for _, i in pairs({'bg', 'bushes', 'stars', 'mountains', 'mountains2', 'floor'}) do
        updateHitbox(i)
        scaleObject(i, 1.2, 1.2, false)
        addLuaSprite(i)
    end
end

function onCreatePost()
    for i = 0, 3 do
        setProperty('opponentStrums.members['..i..'].alpha', 0)

        setProperty('playerStrums.members['..i..'].scale.x', 0.7*4)
        setProperty('playerStrums.members['..i..'].scale.y', 0.7*4)
        updateHitboxFromGroup('playerStrums', i)
        setProperty('playerStrums.members['..i..'].x', _G['defaultPlayerStrumX'..i] + 50)
    end

    for i = 0, getProperty('unspawnNotes.length')-1 do
        setPropertyFromGroup('unspawnNotes', i, 'scale.x', 0.7*4)
        setPropertyFromGroup('unspawnNotes', i, 'scale.y', 0.7*4)
        updateHitboxFromGroup('unspawnNotes', i)
        setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.disabled', true)
    end

    for _, i in pairs({'comboGroup', 'scoreTxt', 'healthBar', 'iconP1', 'iconP2', 'timeBar', 'timeTxt'}) do
        setProperty(i..'.visible', false)
    end
end

function onSongStart()
    startTween('unblack', 'blackSprite', {alpha = 0}, 0.05, {startDelay = 0.05})

    callMethod('videoCutscene.play', {''})
    setProperty('inCutscene', false)
    setProperty('canPause', true)
end

function onEvent(eventName, value1, value2)
    if eventName == 'orange' then
        if value1 == 'dk' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') - 0.1)
            startTween('noVideo', 'videoCutscene', {alpha = 0}, 0.6, {})
        end
    end
end