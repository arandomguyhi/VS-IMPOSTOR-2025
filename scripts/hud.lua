luaDebugMode = true

local customTextMap = {
  ['shit'] = 'SHIT!',
  ['bad'] = 'ASS',
  ['good'] = 'GOOD',
  ['sick'] = 'SUSSY!'
}

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
    end

    setProperty('comboGroup.visible', false)
    
    makeAnimatedLuaSprite('tablet', 'hud/healthBarFG', 0, not downScroll and -38+641 or -143+56)
    scaleObject('tablet', 0.53, 0.53)
    addAnimationByPrefix('tablet', 'idle', 'healthbar', 48, true)
    playAnim('tablet', 'idle', true)
    setProperty('tablet.flipY', downScroll)
    setObjectCamera('tablet', 'hud')
    addLuaSprite('tablet')

		makeLuaText('ratingText', '', screenWidth, 0, downScroll and screenHeight * 0.8 or screenHeight * 0.1)
		setTextFont('ratingText', 'bahn.ttf')
		setTextSize('ratingText', 48)
		setTextAlignment('ratingText', 'center')
		screenCenter('ratingText', 'X')
		setProperty('ratingText.borderSize', 2.5)
		addLuaText('ratingText')
		setProperty('ratingText.alpha', 0)

		makeLuaText('num', '0', 0, downScroll and screenHeight * 0.85 or screenHeight * 0.14)
		setTextFont('num', 'liber.ttf')
		setTextSize('num', 65)
		setTextAlignment('num', 'center')
		setProperty('num.borderSize', 5)
		setProperty('num.alpha', 0)
		addLuaText('num')
    
    screenCenter('tablet', 'X')
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if not isSustainNote then
        popUpScore(getPropertyFromGroup('notes', id, 'rating'), getProperty('combo'))
    end
end

local seperatedScore = {}
local daLoop = 0
local tc = 1

function popUpScore(rateName, combo)
    cancelTween('rateTween')
    cancelTween('rateAlpha')
    
    local newText = customTextMap[rateName:lower()] or getProperty('ratingText.text')
    setTextString('ratingText', newText)

		setProperty('ratingText.visible', getProperty('showRating'))
		scaleObject('ratingText', 0.8, 0.8, false)
		setProperty('ratingText.alpha', 1)
		
		startTween('rateTween', 'ratingText.scale', {x = 1, y = 1}, 0.5, {ease = 'expoOut'})
		startTween('rateAlpha', 'ratingText', {alpha = 0}, 0.5, {startDelay = 0.7})

		if combo >= 1000 then
		    table.insert(seperatedScore, math.floor(combo/1000)%10)
		end

		table.insert(seperatedScore, math.floor(combo/100)%10)
		table.insert(seperatedScore, math.floor(combo/10)%10)
    table.insert(seperatedScore, combo%10)
	
		local totalWidth = (#seperatedScore * 20) - 10
		
		for v, i in pairs(seperatedScore) do
		  debugPrint(i)
		    setTextString('num', tostring(i))
		    
		    screenCenter('num', 'X')
		    setProperty('num.x', getProperty('num.x') + (daLoop * 20) - (totalWidth / 2))
		    
		    setProperty('num.visible', getProperty('showCombo'))
		    scaleObject('num', 0.6, 0.6, false)
		    setProperty('num.alpha', 1)
		    
		    startTween('numTween', 'num.scale', {x = 0.5, y = 0.5}, 0.5, {ease = 'expoOut'})
		    
		    startTween('numAlpha', 'num', {alpha = 0}, 0.2, {onComplete = 'killNum', startDelay = crochet*0.002})
		    function killNum()
		       removeLuaSprite('num')
		    end
		    daLoop = daLoop + 1
		end
end