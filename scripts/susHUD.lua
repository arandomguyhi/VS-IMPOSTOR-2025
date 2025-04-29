luaDebugMode = true

local customTextMap = {
  ['shit'] = 'SHIT!',
  ['bad'] = 'ASS',
  ['good'] = 'GOOD',
  ['sick'] = 'SUSSY!' -- SUSSY'S BETTER!!!
}
local holdColors = {'purple', 'blue', 'green', 'red'}

function onCreatePost()
    setPropertyFromClass('states.PlayState', 'SONG.splashSkin', 'noteskins/noteSplashes')

    for i = 0, 7 do
        setPropertyFromGroup('strumLineNotes', i, 'texture', 'noteskins/amongBfNoteAlt')
        setPropertyFromGroup('strumLineNotes', i%4, 'texture', 'noteskins/amongRedNoteAlt')
    end

    for i = 0, getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'noteskins/amongBfNoteAlt')
        else
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'noteskins/amongRedNoteAlt')
        end

        if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
            setPropertyFromGroup('unspawnNotes', i, 'offsetX', 50)
        end
    end

    setProperty('timeBar.visible', false)
    setProperty('timeTxt.visible', false)
    setProperty('comboGroup.visible', false)

    setTextFont('scoreTxt', 'liber.ttf')
    setTextSize('scoreTxt', 24)

    loadGraphic('healthBar.bg', 'hud/healthBarGuide')
    setProperty('healthBar.scale.x', getProperty('healthBar.scale.x') + 0.145)
    setProperty('healthBar.scale.y', getProperty('healthBar.scale.y') + 0.2)

    setProperty('healthBar.y', getProperty('healthBar.y') + (not downscroll and 3 or -21))
    setProperty('scoreTxt.y', getProperty('healthBar.y') + (not downscroll and 45 or -45))

    for v, i in pairs(holdColors) do
        makeAnimatedLuaSprite('glow'..i, 'noteskins/noteHoldCovers')
        addAnimationByPrefix('glow'..i, 'holdStart'..i, i..'start', 24, false)
        addAnimationByPrefix('glow'..i, 'hold'..i, i..'loop', 24, false)
        addAnimationByPrefix('glow'..i, 'holdEnd'..i, i..'end', 24, false)
        addOffset('glow'..i, 'hold'..i, 0, 0)
        addOffset('glow'..i, 'holdEnd'..i, 26, 8)
        scaleObject('glow'..i, 0.7, 0.7)
        addLuaSprite('glow'..i, true)
        setObjectCamera('glow'..i, 'camHUD')
        setProperty('glow'..i..'.alpha', 0.001)

        makeAnimatedLuaSprite('opGlow'..i, 'noteskins/noteHoldCovers')
        addAnimationByPrefix('opGlow'..i, 'hold'..i, i..'loop', 24, false)
        scaleObject('opGlow'..i, 0.7, 0.7)
        addLuaSprite('opGlow'..i, true)
        setObjectCamera('opGlow'..i, 'camHUD')
        setProperty('opGlow'..i..'.alpha', 0.001)

        runHaxeCode([[
            game.getLuaObject('glow]]..i..[[').animation.finishCallback = (anim:String) -> {
                switch (anim) {
                    case 'holdStart]]..i..[[':
                        game.getLuaObject('glow]]..i..[[').animation.play('hold]]..i..[[');
                    case 'holdEnd]]..i..[[':
                        game.getLuaObject('glow]]..i..[[').alpha = 0;
                }
            }

            game.getLuaObject('opGlow]]..i..[[').animation.finishCallback = (anim:String) -> {
                if (anim == 'hold]]..i..[[')
                    game.getLuaObject('opGlow]]..i..[[').alpha = 0;
            }
        ]])
    end

    makeAnimatedLuaSprite('tablet', 'hud/healthBarFG', 0, not downscroll and -38+641 or -143+56)
    scaleObject('tablet', 0.53, 0.53)
    addAnimationByPrefix('tablet', 'idle', 'healthbar', 48, true)
    playAnim('tablet', 'idle', true)
    setProperty('tablet.flipY', downscroll)
    setObjectCamera('tablet', 'hud')
    addLuaSprite('tablet')
	screenCenter('tablet', 'X')

	makeLuaText('ratingText', '', screenWidth, 0, downscroll and screenHeight * 0.8 or screenHeight * 0.1)
	setTextFont('ratingText', 'bahn.ttf')
	setTextSize('ratingText', 48)
	setTextAlignment('ratingText', 'center')
	screenCenter('ratingText', 'X')
	setProperty('ratingText.borderSize', 2.5)
	addLuaText('ratingText')
	setProperty('ratingText.alpha', 0)
end

function onUpdatePost()
    setProperty('tablet.alpha', getProperty('healthBar.alpha'))
end

function onUpdateScore()
    local str = 'N/A'
    if (getProperty('ratingPercent')*100) >= 98 then str = 'S'
    elseif (getProperty('ratingPercent')*100) >= 90 then str = 'A'
    elseif (getProperty('ratingPercent')*100) >= 80 then str = 'B'
    elseif (getProperty('ratingPercent')*100) >= 70 then str = 'C'
    elseif (getProperty('ratingPercent')*100) >= 60 then str = 'D'
    else str = 'F' end

    setTextString('scoreTxt', 'Score: '..callMethodFromClass('flixel.util.FlxStringUtil', 'formatMoney', {score, false})..'      '
    ..'Misses: '..misses..'      '..'Rank: '..str)
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if isSustainNote then
        local noteOffsets = {
            x = getPropertyFromGroup('opponentStrums', noteData, 'x'),
            y = getPropertyFromGroup('opponentStrums', noteData, 'y')
        }

        setProperty('opGlow'..holdColors[noteData+1]..'.alpha', getPropertyFromGroup('opponentStrums', noteData, 'alpha'))
        playAnim('opGlow'..holdColors[noteData+1], 'hold'..holdColors[noteData+1], true)

        setProperty('opGlow'..holdColors[noteData+1]..'.x', noteOffsets.x)
        setProperty('opGlow'..holdColors[noteData+1]..'.y', noteOffsets.y+3)
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if not isSustainNote then
        popUpScore(getPropertyFromGroup('notes', id, 'rating'), getProperty('combo'))
    else
        local noteOffsets = {
            x = getPropertyFromGroup('playerStrums', noteData, 'x'),
            y = getPropertyFromGroup('playerStrums', noteData, 'y')
        }

        setProperty('glow'..holdColors[noteData+1]..'.alpha', getPropertyFromGroup('playerStrums', noteData, 'alpha'))

        setProperty('glow'..holdColors[noteData+1]..'.x', noteOffsets.x-20)
        setProperty('glow'..holdColors[noteData+1]..'.y', noteOffsets.y-13)

        if string.find(getPropertyFromGroup('notes', id, 'animation.curAnim.name'):lower(), 'end') and isSustainNote then
            playAnim('glow'..holdColors[noteData+1], 'holdEnd'..holdColors[noteData+1])
        else
            playAnim('glow'..holdColors[noteData+1], 'hold'..holdColors[noteData+1], true)
        end
    end
end

function popUpScore(rateName, leCombo)
	callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('ratingText'), {'scale.x', 'scale.y', 'alpha'}})

        setTextString('ratingText', customTextMap[rateName:lower()])

	setProperty('ratingText.visible', getProperty('showRating'))
	scaleObject('ratingText', 0.8, 0.8, false)
	setProperty('ratingText.alpha', 1)

	startTween('rateTween', 'ratingText.scale', {x = 1, y = 1}, 0.5, {ease = 'expoOut'})
	startTween('rateAlpha', 'ratingText', {alpha = 0.001}, 0.5, {startDelay = 0.7})

        local seperatedScore = {}
	local daLoop = 0

	if leCombo >= 1000 then
		table.insert(seperatedScore, math.floor(leCombo/1000)%10)
	end
	table.insert(seperatedScore, math.floor(leCombo/100)%10)
	table.insert(seperatedScore, math.floor(leCombo/10)%10)
        table.insert(seperatedScore, leCombo%10)

	local totalWidth = (#seperatedScore * 20) - 10
	for v, i in pairs(seperatedScore) do
                if luaTextExists('num'..v) then
		    callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('num'..v), {'scale.x', 'scale.y', 'alpha'}})
	        end

		makeLuaText('num'..v, tostring(i), 0, 0, downscroll and screenHeight * 0.85 or screenHeight * 0.14)
		setTextFont('num'..v, 'liber.ttf')
		setTextSize('num'..v, 65)
		setTextAlignment('num'..v, 'center')
		setProperty('num'..v..'.borderSize', 5)
		addLuaText('num'..v)

		screenCenter('num'..v, 'X')
		setProperty('num'..v..'.x', getProperty('num'..v..'.x') + (daLoop * 20) - (totalWidth / 2))

		setProperty('num'..v..'.visible', getProperty('showRating'))
		scaleObject('num'..v, 0.6, 0.6, false)
		setProperty('num'..v..'.alpha', 1)

		startTween('numTween'..v, 'num'..v..'.scale', {x = 0.5, y = 0.5}, 0.5, {ease = 'expoOut'})
		startTween('numAlpha'..v, 'num'..v, {alpha = 0}, 0.2, {startDelay = crochet*0.002})

		daLoop = daLoop + 1
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