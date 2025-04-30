function onCreate()
    createInstance('bfStar', 'objects.Character', {1500, -1150, 'bfStar'})
    setProperty('bfStar.flipX', false)
    setScrollFactor('bfStar', 1.2, 1.2)
    setProperty('bfStar.alpha', 0)

    createInstance('redStar', 'objects.Character', {-100, -1200, 'redStar'})
    setProperty('redStar.flipX', false)
    setScrollFactor('redStar', 1.2, 1.2)
    setProperty('redStar.alpha', 0)

    addLuaSprite('bfStar')
    addLuaSprite('redStar')

    makeAnimatedLuaSprite('orange', 'stage/polus/orange', -800, 440)
    addAnimationByPrefix('orange', 'idle', 'orange_idle instance 1', 24, true)
    addAnimationByPrefix('orange', 'wave', 'wave instance 1', 24, true)
    addAnimationByPrefix('orange', 'walk', 'frolicking instance 1', 24, true)
    addAnimationByPrefix('orange', 'die', 'death instance 1', 24, false)
    playAnim('orange', 'walk')
    scaleObject('orange', 0.8, 0.8, false)
    setProperty('orange.alpha', 0)
    addLuaSprite('orange')

    makeAnimatedLuaSprite('green', 'stage/polus/orange', -800, 450)
    addAnimationByPrefix('green', 'idle', 'stand instance 1', 24, true)
    addAnimationByPrefix('green', 'kill', 'kill instance 1', 24, false)
    addAnimationByPrefix('green', 'walk', 'sneak instance 1', 24, true)
    addAnimationByPrefix('green', 'carry', 'pulling instance 1', 24, true)
    playAnim('green', 'walk')
    scaleObject('green', 0.8, 0.8, false)
    setProperty('green.alpha', 0)
    addLuaSprite('green')

    if isStoryMode then
        makeAnimatedLuaSprite('redCutscene', 'stage/polus/sabotagecutscene/redCutscene', getProperty('dad.x')-5, getProperty('dad.y'))
        addAnimationByPrefix('redCutscene', 'mad', 'red mad0', 24, false)
        scaleObject('redCutscene', 0.9, 0.9, false)
        playAnim('redCutscene', 'mad')
        setProperty('redCutscene.visible', false)
        addLuaSprite('redCutscene', true)

        makeAnimatedLuaSprite('gunshot', 'stage/polus/sabotagecutscene/gunshot', getProperty('redCutscene.x')+515, getProperty('redCutscene.y')+90)
        addAnimationByPrefix('gunshot', 'shot', 'stupid impact0', 24, false)
        scaleObject('gunshot', 0.9, 0.9, false)
        setProperty('gunshot.visible', false)
        addLuaSprite('gunshot', true)
    end
end

function onBeatHit()
    local anim = getProperty('bfStar.animation.curAnim.name')
    if not anim:find('sing') and curBeat % 2 == 0 then callMethod('bfStar.dance', {''}) end

    local anim2 = getProperty('redStar.animation.curAnim.name')
    if not anim2:find('sing') and curBeat % 2 == 0 then callMethod('redStar.dance', {''}) end
end

function opponentNoteHit(_,noteData)
    if getProperty('redStar.alpha') ~= 0 then
        playAnim('redStar', getProperty('singAnimations')[noteData+1], true)
        setProperty('redStar.holdTimer', 0)
    end
end

function goodNoteHit(_,noteData)
    if getProperty('bfStar.alpha') ~= 0 then
        playAnim('bfStar', getProperty('singAnimations')[noteData+1], true)
        setProperty('bfStar.holdTimer', 0)
    end
end

function onEndSong()
    if not allowToEnd and isStoryMode then
        allowToEnd = true
        sabotageCutscene1stHalf()

        return Function_Stop
    end
end

function sabotageCutscene1stHalf()
    setProperty('isCameraOnForcedPos', true)
    setProperty('camZooming', false)
    setProperty('dadGroup.visible', false)
    setProperty('redCutscene.visible', true)
    startTween('camPos', 'camFollow', {x = 1025, y = 500}, 2, {ease = 'expoOut'})
    startTween('camZoom', 'camGame', {zoom = 0.65}, 2, {ease = 'expoOut'})
    doTweenAlpha('noHUD', 'camHUD', 0, 0.75, 'expoOut')
    playSound('moogusCutscene')
    playAnim('redCutscene', 'mad')
    runHaxeCode([[
        game.getLuaObject('redCutscene').animation.finishCallback = (mad:String) -> {
            parentLua.call('endCut', ['']);
        }
    ]])
end

function endCut()
    setProperty('blackSprite.alpha', 1)
    setObjectCamera('blackSprite', 'camGame')
    setObjectOrder('blackSprite', getObjectOrder('gunshot')+1)
    scaleObject('blackSprite', 3000, 2000, false)
    setProperty('gunshot.visible', true)
    playAnim('gunshot', 'shot')
    runHaxeCode([[
        game.getLuaObject('gunshot').animation.finishCallback = (mad:String) -> {
            game.getLuaObject('gunshot').visible = false;
        }
    ]])
    runTimer('endLeSong', 2)
    onTimerCompleted = function(tag) if tag == 'endLeSong' then
        endSong()
        setPropertyFromClass('flixel.addons.transition.FlxTransitionableState', 'skipNextTransOut', true) end
    end
end