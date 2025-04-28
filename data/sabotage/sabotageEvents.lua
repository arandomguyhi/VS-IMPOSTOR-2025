luaDebugMode = true

local bfCutOffsets = {
    ["covered-grey"] = {0, 0},
    ["covered"] = {1, -2},
    ["uncover"] = {1, 5},
    ["awkward"] = {4, 2},
    ["trans"] = {6, 35}
}

local devCutscene = false
local detective = false

function startInvestigationCountdown(seconds)
    local countdown = {value = seconds}

    setTextString('investigationText', 'Investigation ends in '..countdown.value)
    runTimer('countdownTimer', 1, seconds + 1)
    onTimerCompleted = function(tag) if tag == 'countdownTimer' then
        countdown.value = countdown.value - 1
        if countdown.value >= 0 then
            setTextString('investigationText', 'Investigation ends in '..countdown.value)
        else
            setTextString('investigationText', 'Investigation complete!')
        end end
    end
end

function onCreate()
    if devCutscene or (isStoryMode and not seenCutscene) then
        precacheSound('sabotageCutscene')

        -- 1950
        makeAnimatedLuaSprite('bfCutscene', 'stage/polus/sabotagecutscene/bfCutscene', getProperty('boyfriend.x')+10, getProperty('boyfriend.y')+25)
        addAnimationByPrefix('bfCutscene', 'covered-grey', 'boyfriend gray covered0', 24, false)
        addAnimationByPrefix('bfCutscene', 'trans', 'boyfriend ready', 24, false)
        addAnimationByPrefix('bfCutscene', 'awkward', 'boyfriend awkward', 24, false)
        addAnimationByPrefix('bfCutscene', 'covered', 'boyfriend covered0', 24, true)
        addAnimationByPrefix('bfCutscene', 'uncover', 'boyfriend uncover0', 24, false)
        for i = 16, 28 do addAnimationByPrefix('bfCutscene', 'uncoverLoop', 'boyfriend uncover', {i}, 24, false) end
        runHaxeCode([[
            game.getLuaObject('bfCutscene').animation.finishCallback = (ani:String) -> {
                if (ani == 'uncover')
                    game.getLuaObject('bfCutscene').animation.play('uncoverLoop', true);
            }
        ]])
        scaleObject('bfCutscene', 1.1, 1.1, false)
        addLuaSprite('bfCutscene', true)

        -- 12
        makeAnimatedLuaSprite('orangeGhost', 'stage/polus/sabotagecutscene/ghostOrange', 1040, 210)
        addAnimationByPrefix('orangeGhost', 'ghost', 'ghost orange0', 24, false)
        setProperty('orangeGhost.alpha', 0)
        setObjectOrder('orangeGhost', 12)
        addLuaSprite('orangeGhost')

        -- 2000
        makeAnimatedLuaSprite('shield', 'stage/polus/sabotagecutscene/shield', getProperty('bfCutscene.x')-115, getProperty('bfCutscene.y')-40)
        addAnimationByPrefix('shield', 'break', 'shield breaks0', 24, false)
        scaleObject('shield', 1.1, 1.1, false)
        setObjectOrder('shield', 2000)
        setProperty('shield.blend', 0)
        addLuaSprite('shield')

        -- 12
        makeAnimatedLuaSprite('shieldBreakBottom', 'stage/polus/sabotagecutscene/shield', getProperty('shield.x')-25, getProperty('shield.y')-50)
        addAnimationByPrefix('shieldBreakBottom', 'shatter', 'shield shatter bottom0', 24, false)
        scaleObject('shieldBreakBottom', 1.1, 1.1, false)
        setProperty('shieldBreakBottom.visible', false)
        setProperty('shieldBreakBottom.blend', 0)
        addLuaSprite('shieldBreakBottom', true)

        -- 12
        makeAnimatedLuaSprite('shieldBreakTop', 'stage/polus/sabotagecutscene/shield', getProperty('shield.x')-75, getProperty('shield.y')-100)
        addAnimationByPrefix('shieldBreakTop', 'shatter', 'shield shatter top0', 24, false)
        scaleObject('shieldBreakTop', 1.1, 1.1, false)
        setProperty('shieldBreakTop.visible', false)
        setProperty('shieldBreakTop.blend', 0)
        addLuaSprite('shieldBreakTop', true)

        -- 2000
        makeAnimatedLuaSprite('invertMask', 'stage/polus/sabotagecutscene/tempshieldthing', getProperty('shield.x')-300, getProperty('shield.y')-325)
        addAnimationByPrefix('invertMask', 'glow', 'temp0', 24, false)
        scaleObject('invertMask', 1.1, 1.1, false)
        setProperty('invertMask.blend', 0)
        setObjectOrder('invertMask', 2000)
        setProperty('invertMask.visible', false)
        addLuaSprite('invertMask')

        -- 6
        makeAnimatedLuaSprite('redCutscene', 'stage/polus/sabotagecutscene/redCutscene', getProperty('dad.x')-10, getProperty('dad.y')-7)
        addAnimationByPrefix('redCutscene', 'awky', 'red AWKWARD0', 24, false)
        addAnimationByIndices('redCutscene', 'idle', 'red AWKWARD0', {0}, 24, false)
        addAnimationByPrefix('redCutscene', 'trans', 'red transition back', 24, false)
        scaleObject('redCutscene', 0.9, 0.9, false)
        addLuaSprite('redCutscene', true)

        -- 2020
        makeLuaSprite('anotherBlackSprite', nil, 600, 0)
        makeGraphic('anotherBlackSprite', 3000, 2000, '000000')
        setObjectOrder('anotherBlackSprite', 2020)
        addLuaSprite('anotherBlackSprite')
    end

    -- 22
    makeAnimatedLuaSprite('boomBoxS', 'stage/polus/meltdown/boomboxfall')
    addAnimationByPrefix('boomBoxS', 'anim', 'boombox falls', 24, false)
    setObjectOrder('boomBoxS', getObjectOrder('gfGroup') + 10)
    scaleObject('boomBoxS', 1.1, 1.1, false)
    setProperty('boomBoxS.alpha', .001)

    -- 3
    createInstance('saboDetective', 'objects.Character', {2540, 81, 'detectiveSabotage'})
    setProperty('saboDetective.alpha', 0)
    setProperty('saboDetective.flipX', false)
    setObjectOrder('saboDetective', getObjectOrder('thingy')+1)
    addLuaSprite('saboDetective')

    makeLuaSprite('detectiveIcon', 'stage/polus/detective', 90, 1000)
    scaleObject('detectiveIcon', 0.65, 0.65, false)
    setObjectCamera('detectiveIcon', 'camHUD')
    addLuaSprite('detectiveIcon', true)

    makeLuaSprite('detectiveUI2', 'stage/polus/inside', -160, 1000)
    scaleObject('detectiveUI2', 0.6, 0.6, false)
    setObjectCamera('detectiveUI2', 'camHUD')
    addLuaSprite('detectiveUI2', true)

    runHaxeCode([[
        import flixel.ui.FlxBar;
        import flixel.ui.FlxBarFillDirection;

        var flxBar = new FlxBar(270, 560, FlxBarFillDirection.LEFT_TO_RIGHT, 290, 45, null, null, 0, 60, true);
        flxBar.createFilledBar(0xff000000, 0xFF62E0CF, true);
        flxBar.setParent(null, "x", "y", true);
        flxBar.percent = 0;
        flxBar.scale.set(1.3, 1.3);
        flxBar.alpha = 0;
        flxBar.cameras = [game.camHUD];
        game.add(flxBar);

        setVar('flxBar', flxBar);
    ]])

    makeLuaSprite('detectiveUI', 'stage/polus/frame', -160, 1000)
    scaleObject('detectiveUI', 0.6, 0.6, false)
    setObjectCamera('detectiveUI', 'camHUD')
    addLuaSprite('detectiveUI', true)

    makeLuaText('investigationText', 'Investigation ends in 0', 480, 180, 1000)
    setTextFont('investigationText', 'bahn.ttf')
    setTextSize('investigationText', 24)
    setTextAlignment('investigationText', 'center')
    addLuaText('investigationText', true)

    -- 15
    makeLuaSprite('applebar', 'stage/polus/saboSpotlight', 2250, -350)
    setProperty('applebar.alpha', 0)
    setProperty('applebar.blend', 0)
    addLuaSprite('applebar')
    setObjectOrder('applebar', 15)
end

function updateDetectiveIcon(elapsed)
    local mult = callMethodFromClass('flixel.math.FlxMath', 'lerp', {0.7, getProperty('detectiveIcon.scale.x'), math.exp(-elapsed * 9)})
    scaleObject('detectiveIcon', mult, mult)
end

function onBeatHit()
    scaleObject('detectiveIcon', 0.65, 0.65)
    updateDetectiveIcon(getPropertyFromClass('flixel.FlxG', 'elapsed'))

    local anim = getProperty('saboDetective.animation.curAnim.name')
    if not anim:find('sing') and curBeat % 2 == 0 then callMethod('saboDetective.dance', {''}) end
end

function onUpdate(e)
    if devCutscene and keyboardJustPressed('F5') then
        callMethodFromClass('flixel.FlxG', 'resetState', {''}) end
    updateDetectiveIcon(e)
end

function goodNoteHit(_,noteData)
    playAnim('saboDetective', getProperty('singAnimations')[noteData+1], true)
    setProperty('saboDetective.holdTimer', 0)
end

allowCountdown = false
function onStartCountdown()
    if not allowCountdown and isStoryMode then
        allowCountdown = true
        sabotageCutscene2ndHalf()
        return Function_Stop
    end
    return Function_Continue
end

function sabotageCutscene2ndHalf()
    runTimer('gfDance', 0.825, 20)
    runTimer('cutSound', 0.125)
    runTimer('mask', 2.75)
    runTimer('cameraPos1', 7.5)
    runTimer('uncover', 8.3)
    runTimer('redAnim', 9)
    runTimer('bfAnim', 11.3)
    runTimer('cameraPos2', 14)
    runTimer('transition', 15.75)
    runTimer('start', 16.5)

    -- 1900
    setProperty('blackSprite.alpha', 1)
    setObjectCamera('blackSprite', 'camGame')
    setObjectOrder('blackSprite', 1900)
    scaleObject('blackSprite', 3000, 2000)
    setProperty('blackSprite.x', getProperty('blackSprite.x')+300)
    setObjectOrder('blackSprite', getObjectOrder('bfCutscene'))

    doTweenAlpha('unblack', 'anotherBlackSprite', 0, 3, 'expoOut')

    setProperty('boyfriend.visible', false)
    setProperty('dad.visible', false)
    playAnim('redCutscene', 'idle')

    setProperty('isCameraOnForcedPos', true)
    setProperty('camZooming', false)

    callMethod('camFollow.setPosition', {1400, 685})
    setCameraScroll(1400, 685)

    startTween('camPos', 'camFollow', {x = 1490, y = 685}, 0.5, {ease = 'expoIn'})
    setProperty('camGame.zoom', 1)
    startTween('camZoom', 'camGame', {zoom = 1.3}, 0.75, {ease = 'expoIn', onComplete = 'anotherZoom'})
    function anotherZoom()
        startTween('camZoom', 'camGame', {zoom = 1.25}, 0.75, {ease = 'expoOut', onComplete = 'zoomAgain'})
        zoomAgain = function()
            startTween('camZoom', 'camGame', {zoom = 1.3}, 1, {ease = 'expoOut'})
            startTween('camPos', 'camFollow', {x = 1500, y = 685}, 0.5, {ease = 'expoIn'})
        end
    end

    setProperty('camHUD.alpha', 0)
    playAnim('shield', 'break')
    playAnim('bfCutscene', 'covered-grey')
    setProperty('bfCutscene.offset.x', bfCutOffsets['covered-grey'][1])
    setProperty('bfCutscene.offset.y', bfCutOffsets['covered-grey'][2])
end

function onTimerCompleted(tag, l, ll)
    if tag == 'gfDance' then
        if ll % 1 == 0 then callMethod('gf.dance', {''}) end
    elseif tag == 'cutSound' then
        playSound('sabotageCutscene')
    elseif tag == 'mask' then
        cameraShake('camGame', 0.00075, .5)
        setProperty('invertMask.visible', true)
        playAnim('invertMask', 'glow')
        callMethod('invertMask.animation.pause', {''})
        setProperty('invertMask.alpha', 0)
        scaleObject('invertMask', 1.5, 1.5, false)
        startTween('maskTween', 'invertMask', {alpha = 1, ['scale.x'] = .6, ['scale.y'] = .6}, .5, {ease = 'quadIn'})

        runTimer('blackMask', 0.5)
    elseif tag == 'blackMask' then
        setProperty('blackSprite.visible', false)
        setProperty('blackSprite.x', getProperty('blackSprite.x')-300)
        setProperty('shield.visible', false)
        playAnim('bfCutscene', 'covered')
        setProperty('bfCutscene.offset.x', bfCutOffsets['covered'][1]) setProperty('bfCutscene.offset.y', bfCutOffsets['covered'][2])
        setObjectOrder('bfCutscene', 12)
        for _, i in pairs({'shieldBreakTop', 'shieldBreakBottom'}) do
            playAnim(i, 'shatter')
            setProperty(i..'.visible', true)
            runHaxeCode("game.getLuaObject('"..i.."').animation.finishCallback = (anim:String) -> { game.getLuaObject('"..i.."').visible = false; }")
        end
        setProperty('invertMask.visible', true)
        callMethod('invertMask.animation.resume', {''})
        runHaxeCode("game.getLuaObject('invertMask').animation.finishCallback = (anim:String) -> { game.getLuaObject('invertMask').visible = false; }")
        cameraShake('camGame', 0.006, .5)
        startTween('maskScale', 'invertMask.scale', {x = 1.5, y = 1.5}, .75, {ease = 'quadOut'})
        startTween('camZoom', 'camGame', {zoom = 0.9}, 1.3, {ease = 'expoOut'})
        startTween('camPos', 'camFollow', {x = 1445, y = 665}, 1.3, {ease = 'expoOut'})

        runTimer('ghostAppear', 0.3)
        runTimer('noGhost', 4.5)
    elseif tag == 'ghostAppear' then
        playAnim('orangeGhost', 'ghost', true)
        setProperty('orangeGhost.visible', true)
        startTween('ghostPos', 'orangeGhost', {x = 1000, y = 250, alpha = 0.5}, 3, {ease = 'expoOut'})
    elseif tag == 'noGhost' then
        doTweenAlpha('ghsotAlpha', 'orangeGhost', 0, 0.75, 'expoOut')
    end

    if tag == 'cameraPos1' then
        startTween('camPos', 'camFollow', {x = 620, y = 670}, 2.3, {ease = 'quadInOut', startDelay = 0.1})
        startTween('camZoom', 'camGame', {zoom = 0.85}, 2.3, {ease = 'quadInOut', startDelay = 0.1})
    elseif tag == 'uncover' then
        playAnim('bfCutscene', 'uncover')
        setProperty('bfCutscene.offset.x', bfCutOffsets['uncover'][1]) setProperty('bfCutscene.offset.y', bfCutOffsets['uncover'][2])
    elseif tag == 'redAnim' then
        playAnim('redCutscene', 'awky')
    elseif tag == 'bfAnim' then
        playAnim('bfCutscene', 'awkward')
        setProperty('bfCutscene.offset.x', bfCutOffsets['awkward'][1]) setProperty('bfCutscene.offset.y', bfCutOffsets['awkward'][2])
        doTweenY('camY', 'camFollow', 560, 1.75, 'quadInOut')
        doTweenX('camX', 'camFollow', 850, 1.75, 'sineInOut')
        doTweenZoom('camZoom', 'camGame', 0.65, 1.75, 'quadInOut')
    elseif tag == 'cameraPos2' then
        startTween('camPos', 'camFollow', {x = 1025, y = 500}, 1.5, {ease = 'quadOut'})
        startTween('camZoom', 'camGame', {zoom = 0.5}, 1.5, {ease = 'sineOut'})
    elseif tag == 'transition' then
        playAnim('redCutscene', 'trans')
        playAnim('bfCutscene', 'trans')
        setProperty('redCutscene.offset.x', 5) setProperty('redCutscene.offset.y', -6)
        setProperty('bfCutscene.offset.x', bfCutOffsets['trans'][1]) setProperty('bfCutscene.offset.y', bfCutOffsets['trans'][2])
    elseif tag == 'start' then
        startCountdown()
        setProperty('bfCutscene.visible', false)
        setProperty('redCutscene.visible', false)
        setProperty('boyfriend.visible', true)
        setProperty('dad.visible', true)
        setProperty('isCameraOnForcedPos', false)
        startTween('hudAlpha', 'camHUD', {alpha = 1}, 0.75, {ease = 'expoOut', startDelay = 0.25})
        setPropertyFromClass('flixel.addons.transition.FlxTransitionableState', 'skipNextTransOut', false)
    end
end

function onDestroy()
    setPropertyFromClass('flixel.addons.transition.FlxTransitionableState', 'skipNextTransOut', false)
end