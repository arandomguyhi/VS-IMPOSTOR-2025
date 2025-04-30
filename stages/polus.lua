setVar('snowAlpha', 0)
local ext = 'stage/polus/'

local everyoneLook = ''
local rv = 0
local bv = 0
function onCreate()
    makeAnimatedLuaSprite('bg', ext..'sky', -832, -974) addAnimationByPrefix('bg', 'sky', 'sky', 0, false)
    scaleObject('bg', 2, 2)
    setScrollFactor('bg', 0.3, 0.3)

    makeAnimatedLuaSprite('stars', ext..'sky', -832, -974) addAnimationByPrefix('stars', 'stars', 'stars', 0, false)
    scaleObject('stars', 2, 2)
    setScrollFactor('stars', 1.1, 1.1)

    makeAnimatedLuaSprite('mountains', ext..'bg2', -1569, -185) addAnimationByPrefix('mountains', 'bg', 'bgBack', 0, false)
    setScrollFactor('mountains', 0.8, 0.8)

    makeAnimatedLuaSprite('mountains2', ext..'bg2', -1467, -25) addAnimationByPrefix('mountains2', 'bg', 'bgFront', 0, false)
    setScrollFactor('mountains2', 0.9, 0.9)

    makeAnimatedLuaSprite('floor', ext..'bg2', -1410, -139) addAnimationByPrefix('floor', 'bg', 'groundnew', 0, false)

    createInstance('snowEmitter', 'flixel.group.FlxTypedSpriteGroup', {})
    addInstance('snowEmitter', true)

    makeAnimatedLuaSprite('thingy', ext..'guylmao', 2468, -115)
    addAnimationByPrefix('thingy', 'idle', 'REACTOR_THING', 24, true)
    playAnim('thingy', 'idle')

    makeLuaSprite('thingy2', ext..'thing front', 2467, 269)

    makeLuaSprite('vignette', ext..'polusvignette')
    setObjectCamera('vignette', 'camOther')
    setProperty('vignette.alpha', 0.8)
    addLuaSprite('vignette')

    makeLuaSprite('blackSprite')
    makeGraphic('blackSprite', 1280, 720, '000000')
    setObjectCamera('blackSprite', 'camOther')
    addLuaSprite('blackSpite')
    setProperty('blackSprite.alpha', 0)

    makeLuaSprite('nigga')
    makeGraphic('nigga', 1280, 720, '000000')
    setObjectCamera('nigga', 'camOther')
    addLuaSprite('nigga')
    setProperty('nigga.alpha', 0)

    for _, i in ipairs({'bg', 'stars', 'mountains', 'mountains2', 'floor', 'thingy', 'thingy2'}) do
        addLuaSprite(i) end

    if songName == 'Meltdown' then
        buildMeltdownBG()
    end
end

function onCreatePost()
    if songName:lower() == 'sussus moogus' then
        setProperty('isCameraOnForcedPos', true)
        setCameraScroll(1025, -800)
        callMethod('camFollow.setPosition', {1025, -800})
        setProperty('camHUD.alpha', 0)
        setProperty('camGame.zoom', 0.4)
        setProperty('nigga.alpha', 1)

        if not lowQuality then
		makeAnimatedLuaSprite('evilGreen', ext..'green', -550, 760)
		addAnimationByPrefix('evilGreen', 'cutscene', 'scene instance 1', 24, false)
		scaleObject('evilGreen', 2.3, 2.3, false)
		setScrollFactor('evilGreen', 1.2, 1.2)
		setProperty('evilGreen.alpha', 0)
		addLuaSprite('evilGreen')
	end

	makeLuaSprite('vignette2', ext..'vignette2')
	setProperty('vignette2.alpha', 0)
	addLuaSprite('vignette2')

        createInstance('anotherCam', 'flixel.FlxCamera')
        setProperty('anotherCam.bgColor', 0x0)

        createInstance('evilCam', 'flixel.FlxCamera')
        setProperty('evilCam.bgColor', 0x0)

        for _, cams in pairs({'camOther', 'camHUD', 'camPause'}) do
            callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg(cams), false}) end
        for _, cams in pairs({'camOther', 'camHUD', 'evilCam', 'anotherCam', 'camPause'}) do
            callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg(cams), false}) end

        if not lowQuality then
            setToCamera('evilGreen', 'evilCam') end
        setToCamera('vignette2', 'anotherCam')
    end

	if songName:lower() == 'meltdown' then
		setProperty('isCameraOnForcedPos', true)
		snapCamFollowToPos(1025, 500)
		setProperty('camGame.zoom', 0.5)
		setProperty('gf.y', getProperty('gf.y')+1000)
		setProperty('gf.alpha', 0)
		setProperty('gfDead.alpha', 1)
		setProperty('boomBox.alpha', 1)
		setProperty('cyan.alpha', 1)
		setProperty('rose.alpha', 1)
	end

	setVar('snowAlpha', (songName == 'Sussus Moogus' and 0 or 1))
end

local particles = {}
local toRemove = {}
local timer = 0
local frequency = not lowQuality and 0.05 or 0.1

local speedUp = false

function createSnow()
	local id = 'snow'..tostring(#particles)

	makeAnimatedLuaSprite(id, 'snow_particles')
	addAnimationByPrefix(id, 'snow', 0, false)
	setScrollFactor(id, getRandomFloat(1,1.5), getRandomFloat(1,1.5))
	callMethod('snowEmitter.add', {instanceArg(id)})

	setProperty(id..'.animation.curAnim.curFrame', getRandomInt(0, 7))

	local particle = {
		id = id,
		x = getRandomFloat(getProperty('floor.x'), getProperty('floor.width')),
		y = getProperty('floor.y') - 200,
		speed = not speedUp and getRandomInt(500, 700) or getRandomInt(1400, 1700),
		launchAngle = getRandomInt(100, 160),
		angularVelocity = getRandomInt(-80, 100),
		lifespan = 10
	}
	table.insert(particles, particle)
end

function onUpdate(elapsed)
	setProperty('anotherCam.zoom', getProperty('camHUD.zoom'))
	if not lowQuality then
		setProperty('evilCam.zoom', getProperty('camGame.zoom'))
		setProperty('evilCam.scroll.x', getProperty('camGame.scroll.x'))
		setProperty('evilCam.scroll.y', getProperty('camGame.scroll.y'))
	end

	timer = timer + elapsed
	if timer >= frequency then
		createSnow()
		timer = 0
	end

	for i = #particles, 1, -1 do
		local p = particles[i]
		p.lifespan = p.lifespan - elapsed

		if p.lifespan <= 0 then
			removeLuaSprite(p.id, true)
		else
			p.x = p.x + math.cos(math.rad(p.launchAngle)) * p.speed * elapsed
			p.y = p.y + math.sin(math.rad(p.launchAngle)) * p.speed * elapsed
			setProperty(p.id..'.x', p.x)
			setProperty(p.id..'.y', p.y)

			setProperty(p.id..'.angle', getProperty(p.id..'.angle') + p.angularVelocity * elapsed)

			setProperty(p.id..'.alpha', getVar('snowAlpha'))
		end
	end
end

function refreshVoters()
	runHaxeCode([[
		getVar('redVoters').forEach(function(spr:FlxSprite) {
			if (spr.ID == ]]..tonumber(rv)..[[) FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.backOut});
			FlxTween.tween(spr, {x: dad.x + 100 + (((spr.ID - 1) * 100) - (getVar('redVoters').length * (75 / 2)))}, (spr.ID == ]]..tonumber(rv)..[[ ? 0.1 : 0.5), {ease: FlxEase.quadInOut});
		});

		getVar('bfVoters').forEach(function(spr:FlxSprite) {
			if (spr.ID == ]]..tonumber(bv)..[[) FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.backOut});
			FlxTween.tween(spr, {x: boyfriend.x + (((spr.ID - 1) * 100) - (getVar('bfVoters').length * (75 / 2)))}, (spr.ID == ]]..tonumber(bv)..[[ ? 0.1 : 0.5), {ease: FlxEase.quadInOut});
		});
	]])
end

function onBeatHit()
	if curBeat % 2 == 0 then
		if luaSpriteExists('boomBox') and getProperty('boomBox.animation.curAnim.name') == 'sus' then playAnim('boomBox', 'sus', true) end
		if luaSpriteExists('roseTable') and getProperty('roseTable.animation.curAnim.name') == 'idle'..everyoneLook then playAnim('roseTable', 'idle'..everyoneLook) end
		if luaSpriteExists('greenTable') and getProperty('greenTable.animation.curAnim.name') == 'idle'..everyoneLook then playAnim('greenTable', 'idle'..everyoneLook) end
	end
end

function onSongStart()
    setProperty('nigga.alpha', 0)
end

function onEvent(eventName, value1, value2)
	if eventName == '' then
		if value1 == 'speedUp' then
			speedUp = true
			frequency = 0.04
		end
    elseif eventName == 'orange' then
		if lowQuality and (value1 == 'walk' or value1 == 'die' or value1 == 'idle' or value2 == 'walk' or value2 == 'kill' or value2 == 'carry') then
			return end
		
		if value1 == 'walk' then
			setProperty('orange.alpha', 1)
			startTween('orangeWalk', 'orange', {x = 60}, 3.5, {onComplete = 'orangeIdle'})
			function orangeIdle() playAnim('orange', 'idle') setProperty('orange.y', getProperty('orange.y')+30) end
		elseif value1 == 'die' then
			playAnim('orange', 'die')
		elseif value1 == 'wave' then
			playAnim('orange', 'wave')
			setProperty('orange.y', getProperty('orange.y')-100)
		elseif value1 == 'camMiddle' then
			setProperty('isCameraOnForcedPos', true)
			startTween('camPos', 'camFollow', {x = 1025, y = 500}, 1, {})
			startTween('camZoom', 'camGame', {zoom = 0.5}, 1, {ease = 'smootherStepInOut'})
			setProperty('defaultCamZoom', 0.5)
		elseif value1 == 'camMiddleSlow' then
			setProperty('isCameraOnForcedPos', true)
			startTween('camPos', 'camFollow', {x = 1025, y = 500}, 1.5, {})
			startTween('camZoom', 'camGame', {zoom = 0.5}, 2, {})
			setProperty('defaultCamZoom', 0.5)
		elseif value1 == 'camMiddleTuah' then
			setProperty('isCameraOnForcedPos', true)
			startTween('camPos', 'camFollow', {x = 1025, y = 500}, 1, {})
			startTween('camZoom', 'camGame', {zoom = 0.55}, 1, {ease = 'smootherStepInOut'})
			setProperty('defaultCamZoom', 0.55)
		elseif value1 == 'camNormal' then
			setProperty('isCameraOnForcedPos', false)
		elseif value1 == 'camRight' then
			setProperty('isCameraOnForcedPos', true)
			startTween('camPos', 'camFollow', {x = 1600, y = 525}, 5, {ease = 'smootherStepInOut'})
			setProperty('defaultCamZoom', 0.5)
			startTween('camZoom', 'camGame', {zoom = 0.5}, 1, {ease = 'smootherStepInOut'})
		elseif value1 == 'evilgreen' then
			if lowQuality then return end

			runHaxeCode([[
				game.strumLineNotes.camera = getVar('anotherCam');
				game.notes.camera = getVar('anotherCam');
			]])
                        setToCamera('flashSprite', 'evilCam')
                        scaleObject('flashSprite', 5, 5, false)

			setProperty('evilGreen.alpha', 1)
			doTweenAlpha('vig', 'vignette2', 0.6, 3)
			playAnim('evilGreen', 'cutscene')
			startTween('unvig', 'vignette2', {alpha = 0}, 2, {startDelay = 9})
			startTween('que', 'vignette2', {alpha = 0}, 2, {startDelay = 9, onComplete = 'normalCam'})
			function normalCam()
				runTimer('backToHUD', 2)
				onTimerCompleted = function(tag) if tag == 'backToHUD' then
					runHaxeCode([[
						game.strumLineNotes.camera = camHUD;
						game.notes.camera = camHUD;
					]])
                                        setObjectCamera('flashSprite', 'camOther')
                                        scaleObject('flashSprite', 1, 1, false)
					removeLuaSprite('evilGreen', true) end
				end
			end
		elseif value1 == 'idle' then
			playAnim('orange', 'idle')
			setProperty('orange.y', getProperty('orange.y')+100)
		elseif value1 == 'intro' then
			runHaxeCode([[
				FlxTween.num(getVar('snowAlpha'), 1, 2, {startDelay: 7.5}, (f:Float) -> {
					setVar('snowAlpha', f);
				});
			]])

            startTween('leHUd', 'camHUD', {alpha = 1}, 2.5, {startDelay = 9.5})
            startTween('camZoom', 'camGame', {zoom = 0.5}, 12, {ease = 'smootherStepInOut'})
            startTween('camPos', 'camFollow', {y = 500}, 12, {ease = 'smootherStepInOut', startDelay = 0, onComplete = 'unforceCamera'})
		elseif value1 == 'star' then
			setProperty('isCameraOnForcedPos', true)

			runHaxeCode([[
				FlxTween.num(getVar('snowAlpha'), 0, 2, {startDelay: 1.5}, (f:Float) -> {
					setVar('snowAlpha', f);
				});
			]])

			startTween('red', 'redStar', {alpha = 0.9}, 5, {})
			startTween('bf', 'bfStar', {alpha = 0.9}, 3, {startDelay = 5})

			startTween('leZoom', 'game', {['camGame.zoom'] = 0.4, defaultCamZoom = 0.4}, 5, {ease = 'smootherStepInOut'})
			startTween('camPos', 'camFollow', {x = 1025, y = -800}, 5, {ease = 'smootherStepInOut', startDelay = 0})
		elseif value1 == 'down' then
			doTweenAlpha('byered', 'redStar', 0, 1)
			doTweenAlpha('byebf', 'bfStar', 0, 1)

			runHaxeCode([[
				FlxTween.num(getVar('snowAlpha'), 1, 0.5, {startDelay: 1}, (f:Float) -> {
					setVar('snowAlpha', f);
				});
			]])

			startTween('leZoom', 'game', {['camGame.zoom'] = 0.5, defaultCamZoom = 0.5}, 1, {ease = 'smootherStepInOut'})
			startTween('camPos', 'camFollow', {x = 800, y = 500}, 1, {ease = 'smootherStepInOut', startDelay = 0, onComplete = 'unforceCamera'})
        end

		if value2 == 'walk' then
			setProperty('green.alpha', 1)
			startTween('walkG', 'green', {x = -200}, 3.5, {onComplete = 'GIdle'})
			function GIdle() playAnim('green', 'idle') end
		elseif value2 == 'kill' then
			playAnim('green', 'kill')
		elseif value2 == 'carry' then
			setProperty('orange.alpha', 0)
			playAnim('green', 'carry')
			doTweenX('carryO', 'green', -1000, 5)
		end
    end

        if eventName == 'dialogue' then
		if value1 == 'red' then
			setProperty('redtalk.alpha', 1)
			if value2 == '1' then
				playAnim('redtalk', '1')
				runHaxeCode([[
					game.getLuaObject('redtalk').animation.finishCallback = function() {
						game.getLuaObject('redtalk').alpha = 0;
					};
				]])
			elseif value2 == '2' then
				playAnim('redtalk', '2')
				runHaxeCode([[
					game.getLuaObject('redtalk').animation.finishCallback = function() {
						game.getLuaObject('redtalk').alpha = 0;
					};
				]])
			elseif value2 == '3' then
				setProperty('redtalk.x', 80)
				setProperty('redtalk.y', 195)
				playAnim('redtalk', '3')
				runHaxeCode([[
					game.getLuaObject('redtalk').animation.finishCallback = function() {
						game.getLuaObject('redtalk').alpha = 0;
						remove(game.getLuaObject('redtalk'));
					};
				]])
			end
		elseif value1 == 'bf' then
			setProperty('bftalk.alpha', 1)
			if value2 == '1' then
				setProperty('bftalk.x', 1025)
				setProperty('bftalk.y', 140)
				playAnim('bftalk', '1')
				runHaxeCode([[
					game.getLuaObject('bftalk').animation.finishCallback = function() {
						game.getLuaObject('bftalk').alpha = 0;
					};
				]])
			elseif value2 == '2' then
				setProperty('bftalk.x', 1030)
				setProperty('bftalk.y', 200)
				playAnim('bftalk', '2')
				runHaxeCode([[
					game.getLuaObject('bftalk').animation.finishCallback = function() {
						game.getLuaObject('bftalk').alpha = 0;
					};
				]])
			elseif value2 == '3' then
				setProperty('bftalk.x', 1050)
				setProperty('bftalk.y', 185)
				playAnim('bftalk', '3')
				runHaxeCode([[
					game.getLuaObject('bftalk').animation.finishCallback = function() {
						game.getLuaObject('bftalk').alpha = 0;
						remove(game.getLuaObject('bftalk'));
					};
				]])
			end
		end
	end

	if eventName == 'sabotage' then
		if value1 == 'noOpp' then
			for _, i in pairs({'healthBar', 'iconP1', 'iconP2', 'scoreTxt'}) do
				doTweenAlpha('blz'.._, i, 0, 7)
                                noteTweenAlpha('BZL'.._-1, _-1, 0, 7)
                        end
			doTweenAlpha('dect', 'saboDetective', 1, 3)
			setProperty('healthLoss', 0)
		elseif value1 == 'drop' then
			setProperty('boomBoxS.alpha', 1)
			playAnim('boomBoxS', 'anim')
			setProperty('boomBoxS.x', getProperty('gf.x')+240)
			setProperty('boomBoxS.y', getProperty('gf.y')+50)
			addLuaSprite('boomBoxS') setObjectOrder('boomBoxS', getObjectOrder('gfGroup')+1)
		elseif value1 == 'oppReturn' then
			for _, i in pairs({'healthBar', 'iconP1', 'iconP2', 'scoreTxt'}) do
				doTweenAlpha('blz'.._, i, 1, 5)
                                noteTweenAlpha('getBack'.._-1, _-1, 1, 5)
                        end

			for _, i in pairs({'investigationText', 'detectiveUI', 'detectiveIcon', 'flxBar'}) do
				doTweenY('BZL'.._, i, 1000, 0.7, 'expoIn') end
			startTween('lastOne', 'detectiveUI2', {y = 1000}, 0.7, {
				ease = 'expoIn',
				onComplete = 'setVisible'
			})
			function setVisible()
				setProperty('detectiveUI.visible', setProperty('detectiveUI.active', false))
				setProperty('detectiveUI2.visible', setProperty('detectiveUI2.active', false))
				setProperty('flxBar.visible', setProperty('flxBar.active', false))
			end
		elseif value1 == 'detective alt idle' then
			setProperty('saboDetective.idleSuffix', '-alt')
		elseif value1 == 'obiturary' then
			playAnim('saboDetective', 'turn', true)
                        setProperty('saboDetective.specialAnim', true)
			setProperty('saboDetective.idleSuffix', '')
		elseif value1 == 'saltyDKFunkin' then
			doTweenAlpha('spotLight', 'applebar', 0.7, 3)
		elseif value1 == 'jammy' then
			doTweenAlpha('jamy', 'applebar', 0, 3)
		elseif value1 == 'ending' then
			setProperty('camGame.visible', setProperty('camHUD.visible', false))
			setProperty('inCutscene', true)
		elseif value1 == 'slideUp' then
			callOnLuas('startInvestigationCountdown', {35})

			doTweenY('d1', 'detectiveIcon', 540, 0.4, 'expoOut')
			doTweenY('d2', 'investigationText', 618, 0.4, 'expoOut')
			doTweenY('d3', 'detectiveUI', 415, 0.4, 'expoOut')
			startTween('d4', 'detectiveUI2', {y = 415}, 0.4, {
				ease = 'expoOut',
				onComplete = 'showBar'
			})
			function showBar()
				setProperty('flxBar.alpha', 1)
				startTween('barVal', 'flxBar', {value = 60}, 35, {})
			end
		end
	end

        if eventName == 'speechbubble' then
		if value1 == 'red' then
			setProperty('speechBubbleBlue.alpha', 1)
			if value2 == 'intro' then
				setProperty('speechBubbleBlue.x', 0)
				setProperty('speechBubbleBlue.y', 200)
				setProperty('speechBubbleBlue.x', getProperty('speechBubbleBlue.x') + -70)
				setProperty('speechBubbleBlue.y', getProperty('speechBubbleBlue.y') + -100)
				playAnim('speechBubbleBlue', 'intro')
				runHaxeCode([[
					var speechBubbleBlue = game.getLuaObject('speechBubbleBlue');
					speechBubbleBlue.animation.finishCallback = function() {
						speechBubbleBlue.animation.play('idle', true);
						speechBubbleBlue.x += 70;
						speechBubbleBlue.y += 100;
					};
				]])
			elseif value2 == 'exit' then
				setProperty('speechBubbleRed.x', 1000)
				setProperty('speechBubbleRed.y', 175)
				setProperty('speechBubbleBlue.x', getProperty('speechBubbleBlue.x') + -20)
				setProperty('speechBubbleBlue.y', getProperty('speechBubbleBlue.y') + -40)
				playAnim('speechBubbleBlue', 'exit')
				runHaxeCode([[
					var speechBubbleBlue = game.getLuaObject('speechBubbleBlue');
					speechBubbleBlue.animation.finishCallback = function() {
						speechBubbleBlue.alpha = 0;
					};
				]])
			end
		elseif value1 == 'blue' then
			setProperty('speechBubbleRed.alpha', 1)
			if value2 == 'intro' then
				setProperty('speechBubbleRed.x', 1000)
				setProperty('speechBubbleRed.y', 175)
				setProperty('speechBubbleRed.x', getProperty('speechBubbleRed.x') + -65)
				setProperty('speechBubbleRed.y', getProperty('speechBubbleRed.y') + -100)
				playAnim('speechBubbleRed', 'intro')
				runHaxeCode([[
					var speechBubbleRed = game.getLuaObject('speechBubbleRed');
					speechBubbleRed.animation.finishCallback = function() {
						speechBubbleRed.animation.play('idle', true);
						speechBubbleRed.x += 65;
						speechBubbleRed.y += 100;
					};
				]])
			elseif value2 == 'exit' then
				setProperty('speechBubbleRed.x', 1000)
				setProperty('speechBubbleRed.y', 175)
				setProperty('speechBubbleRed.x', getProperty('speechBubbleRed.x') + -65)
				setProperty('speechBubbleRed.y', getProperty('speechBubbleRed.y') + -100)
				playAnim('speechBubbleRed', 'exit')
				runHaxeCode([[
					var speechBubbleRed = game.getLuaObject('speechBubbleRed');
					speechBubbleRed.animation.finishCallback = function() {
						speechBubbleRed.alpha = 0;
					};
				]])
			end
		end
	end

	if eventName == 'meltdown' then
		if value1 == 'boombox' then
			setProperty('boomBox.x', 1135)
			setProperty('boomBox.y', 525)
			playAnim('boomBox', 'alert')
			runHaxeCode([[
				var boomBox = game.getLuaObject('boomBox');
				boomBox.animation.finishCallback = function(anim:String) {
					boomBox.x = 1140;
					boomBox.y = 680;
					boomBox.animation.play('sus');
				};
			]])
		elseif value1 == 'redVote' then
			local v = tonumber(value2)
			rv = rv + 1
			makeLuaSprite('voter'..rv, nil, getProperty('dad.x')+100, getProperty('dad.y')-100)
			loadGraphic('voter'..rv, ext..'meltdown/votingIcons', 150, 150)
			addAnimation('voter'..rv, 'yy', {8, v}, 0, false)
			playAnim('voter'..rv, 'yy')
			setProperty('voter'..rv..'.origin.x', 75) setProperty('voter'..rv..'.origin.y', 75)
			setProperty('voter'..rv..'.animation.curAnim.curFrame', 1)
			setProperty('voter'..rv..'.ID', rv)
			scaleObject('voter'..rv, 0, 0, false)
			callMethod('redVoters.add', {instanceArg('voter'..rv)})
			refreshVoters()
		elseif value1 == 'bfVote' then
			local v = tonumber(value2)
			bv = bv + 1
			makeLuaSprite('voterB'..bv, nil, getProperty('boyfriend.x'), getProperty('boyfriend.y')-100)
			loadGraphic('voterB'..bv, ext..'meltdown/votingIcons', 150, 150)
			addAnimation('voterB'..bv, 'yy', {8, v}, 0, false)
			playAnim('voterB'..bv, 'yy')
			scaleObject('voterB'..bv, 0, 0, false)
			setProperty('voterB'..bv..'.animation.curAnim.curFrame', 1)
			setProperty('voterB'..bv..'.origin.x', 75) setProperty('voterB'..bv..'.origin.y', 75)
			setProperty('voterB'..bv..'.ID', bv)
			callMethod('bfVoters.add', {instanceArg('voterB'..bv)})
			refreshVoters()
		elseif value1 == 'meeting' then
			setProperty('stars.alpha', 0)
			doTweenAlpha('fTween', 'floor', 0, 0.5)
			doTweenAlpha('mTween', 'mountains', 0, 0.5)
			doTweenAlpha('m2Tween', 'mountains2', 0, 0.5)

			startTween('gtTween', 'greenTable', {x = -100, y = 500}, 0.2, {})
			startTween('ltTween', 'limeTable', {x = 2050, y = 400}, 0.4, {})
			startTween('rtTween', 'roseTable', {x = 1700, y = 320}, 0.8, {ease = 'smootherStepInOut'})
			startTween('ctTween', 'cyanTable', {x = -550, y = 650}, 0.8, {ease = 'smootherStepInOut'})
			startTween('ptTween', 'purpleTable', {x = 725, y = 970}, 1, {ease = 'smootherStepInOut'})

			setProperty('emergency.alpha', 1)
			playAnim('emergency', 'idle')
			setProperty('meltdownBGLeft.alpha', 1)
			setProperty('meltdownBGRight.alpha', 1)
			setProperty('meltdownTable.alpha', 1)
			setProperty('lime.alpha', 0)
			setProperty('purple.alpha', 0)
			setProperty('rose.alpha', 0)
			setProperty('cyan.alpha', 0)

			setObjectOrder('snowEmitter', getObjectOrder('meltdownBGBack')+1)

			startTween('mbbTween', 'meltdownBGBack', {x = 50, y = 335}, 0.4, {ease = 'smootherStepInOut'})
			startTween('mblTween', 'meltdownBGLeft', {x = -1100}, 0.2, {})
			startTween('mbrTween', 'meltdownBGRight', {x = (1 * getProperty('meltdownBGLeft.width') - 1100)}, 0.2, {})
			startTween('gfTween', 'gf', {alpha = 1}, 0.6, {onComplete = 'emergency'})
			function emergency() startTween('eTween', 'emergency', {alpha = 0}, 1, {startDelay = 1}) end

			startTween('gfYTween', 'gf', {y = 480}, 0.8, {ease = 'smootherStepInOut'})
			startTween('mtTween', 'meltdownTable', {y = 650}, 0.3, {ease = 'smootherStepInOut'})
			doTweenAlpha('gdTween', 'gfDead', 0, 0.5)
			doTweenAlpha('bbTween', 'boomBox', 0, 0.5)

			doTweenAlpha('vigTween', 'vignette', 0, 0.5)
		elseif value1 == 'facepalm' then
			playAnim('greenTable', 'facepalm')
			runHaxeCode([[
				game.getLuaObject('greenTable').animation.finishCallback = function() {
					game.getLuaObject('greenTable').animation.play('loop', true);
				};
			]])
		elseif value1 == 'watch' then
			playAnim('greenTable', 'idle-peep')
			playAnim('limeTable', 'idle-peep')
			playAnim('roseTable', 'idle-peep')
			playAnim('cyanTable', 'idle-peep')
			playAnim('purpleTable', 'idle-peep')
                        everyoneLook = '-peep'
		elseif value1 == 'bop' then
			playAnim('limeTable', 'idle')
			playAnim('roseTable', 'idle')
			playAnim('cyanTable', 'idle')
			playAnim('purpleTable', 'idle')
                        everyoneLook = ''
		elseif value1 == 'camMiddle' then
			setProperty('isCameraOnForcedPos', true)
			startTween('camPos', 'camFollow', {x = 1025, y = 500}, 1, {ease = 'smootherStepInOut'})
			startTween('camZoom', 'game', {['camGame.zoom'] = 0.5, defaultCamZoom = 0.5}, 1, {ease = 'smootherStepInOut'})
		elseif value1 == 'camMiddleMeeting' then
			setProperty('isCameraOnForcedPos', true)
			startTween('camPos', 'camFollow', {x = 1025, y = 500}, 1, {})
			startTween('camZoom', 'camGame', {zoom = 0.6}, 1, {onComplete = 'defZoom'})
			function defZoom() setProperty('defaultCamZoom', 0.65) end
		elseif value1 == 'camMiddleAyo' then
			setProperty('isCameraOnForcedPos', true)
			startTween('camPos', 'camFollow', {x = 1025, y = 500}, 1, {ease = 'smootherStepInOut', onComplete = 'leZoom'})
			function leZoom()
				startTween('camZoom', 'game', {['camGame.zoom'] = 0.8, defaultCamZoom = 0.8}, 0.8, {ease = 'smootherStepInOut', startDelay = 2})
			end
		elseif value1 == 'camMiddle6' then
			setProperty('isCameraOnForcedPos', true)
			startTween('camPos', 'camFollow', {x = 1025, y = 500}, 1, {ease = 'smootherStepInOut'})
			startTween('camZoom', 'game', {['camGame.zoom'] = 0.6, defaultCamZoom = 0.6}, 1, {ease = 'smootherStepInOut'})
		elseif value1 == 'camNormal' then
			setProperty('isCameraOnForcedPos', false)
		elseif value1 == 'camMiddleSlow' then
			setProperty('isCameraOnForcedPos', true)
			startTween('camPos', 'camFollow', {x = 1025, y = 500}, 1.5, {ease = 'smootherStepInOut'})
			startTween('camZoom', 'game', {['camGame.zoom'] = 0.5, defaultCamZoom = 0.5}, 1.5, {ease = 'smootherStepInOut'})
		elseif value1 == 'meetingZoom' then
			setProperty('isCameraOnForcedPos', true)
		end

		if value2 == 'idle' then
			playAnim('green', 'idle')
			setProperty('green.y', getProperty('green.y')+100)
		elseif value2 == 'cyan' then
			startTween('cyanWalk', 'cyan', {x = -25}, 6, {onComplete = 'cyanIdle'})
			function cyanIdle()
				playAnim('cyan', 'idle')
				setProperty('cyan.y', getProperty('cyan.y')+20)
			end
		elseif value2 == 'purple' then
			startTween('purpleWalk', 'purple', {x = 2050}, 5, {onComplete = 'purpleIdle'})
			function purpleIdle() playAnim('purple', 'idle') end
		elseif value2 == 'rose' then
			startTween('roseWalk', 'rose', {x = 1800}, 5, {onComplete = 'roseIdle'})
			function roseIdle() playAnim('rose', 'idle') end
		elseif value2 == 'lime' then
			startTween('limeWalk', 'lime', {x = -300}, 5, {ease = 'smootherStepInOut'})
		end
	end
end

function buildMeltdownBG()
	makeLuaSprite('meltdownBGBack', ext..'meltdown/buildingsbg', 50, 4000)
	setScrollFactor('meltdownBGBack', 0.85, 0.85)
	addLuaSprite('meltdownBGBack')

	makeLuaSprite('meltdownBGLeft', ext..'meltdown/wallBGLeft', -4000, -300)
	setProperty('meltdownBGLeft.alpha', 0)
	addLuaSprite('meltdownBGLeft')

	makeAnimatedLuaSprite('cyan', ext..'meltdown/crewOutside', -2000, 475)
	addAnimationByPrefix('cyan', 'walk', 'CYAN WALK', 24, true)
	addAnimationByPrefix('cyan', 'idle', 'IDLE CYAN', 24, true)
	playAnim('cyan', 'walk')
	addLuaSprite('cyan')

	makeAnimatedLuaSprite('rose', ext..'meltdown/crewOutside', 3000, 305)
	addAnimationByIndices('rose', 'walk', 'ROSE', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}, 24, true)
	addAnimationByIndices('rose', 'idle', 'ROSE', {16,17,18,19}, 24, true)
	playAnim('rose', 'walk')
	addLuaSprite('rose')

	makeLuaSprite('meltdownBGRight', ext..'meltdown/wallBGRight', ((getProperty('meltdownBGLeft.width')) + getProperty('meltdownBGLeft.x')) + 4000, getProperty('meltdownBGLeft.y'))
	addLuaSprite('meltdownBGRight')
	setProperty('meltdownBGRight.alpha', 0)

	makeAnimatedLuaSprite('speechBubbleBlue', ext..'meltdown/textbox', 100, 250)
	addAnimationByPrefix('speechBubbleBlue', 'idle', 'RedBubbleBoil', 24, true)
	addAnimationByPrefix('speechBubbleBlue', 'intro', 'RedBubblePop', 24, false)
	addAnimationByPrefix('speechBubbleBlue', 'exit', 'RedBubbleOut', 24, false)
	scaleObject('speechBubbleBlue', 0.9, 0.9, false)
	addLuaSprite('speechBubbleBlue')
	setProperty('speechBubbleBlue.alpha', 0)

	makeAnimatedLuaSprite('speechBubbleRed', ext..'meltdown/textbox', 1000, 175)
	addAnimationByPrefix('speechBubbleRed', 'idle', 'BlueBubbleBoil', 24, true)
	addAnimationByPrefix('speechBubbleRed', 'intro', 'BlueBubblePop', 24, false)
	addAnimationByPrefix('speechBubbleRed', 'exit', 'BlueBubbleOut', 24, false)
	scaleObject('speechBubbleRed', 0.9, 0.9, false)
	addLuaSprite('speechBubbleRed')
	setProperty('speechBubbleRed.alpha', 0)

	makeAnimatedLuaSprite('redtalk', ext..'meltdown/RedSpeech1', 80, 230)
	addAnimationByPrefix('redtalk', '1', 'red1', 24, false)
	addAnimationByPrefix('redtalk', '2', 'red2', 24, false)
	addAnimationByPrefix('redtalk', '3', 'red3', 24, false)
	scaleObject('redtalk', 0.85, 0.72, false)
	setProperty('redtalk.alpha', 0)
	addLuaSprite('redtalk')

	makeAnimatedLuaSprite('bftalk', ext..'meltdown/BFSpeech1', 1025, 140)
	addAnimationByPrefix('bftalk', '1', 'bf1', 24, false)
	addAnimationByPrefix('bftalk', '2', 'bf2', 24, false)
	addAnimationByPrefix('bftalk', '3', 'bf3', 24, false)
	scaleObject('bftalk', 0.85, 0.72, false)
	setProperty('bftalk.alpha', 0)
	addLuaSprite('bftalk')

	makeAnimatedLuaSprite('gfDead', ext..'meltdown/gfDead', 920, 580)
	addAnimationByPrefix('gfDead', 'idle', 'gf DEAD', 24, true)
	setProperty('gfDead.alpha', 0)
	scaleObject('gfDead', 1.1, 1.1, false)
	addLuaSprite('gfDead')
	playAnim('gfDead', 'idle')

	makeAnimatedLuaSprite('boomBox', ext..'meltdown/boombox', 1175, 780)
	addAnimationByPrefix('boomBox', 'idle', 'floor boombox', 24, true)
	addAnimationByPrefix('boomBox', 'alert', 'boombox alert', 24, false)
	addAnimationByPrefix('boomBox', 'sus', 'boombox anim', 24, false)
	setProperty('boomBox.alpha', 0)
	scaleObject('boomBox', 1.1, 1.1, false)
	addLuaSprite('boomBox')
	playAnim('boomBox', 'idle')

	makeAnimatedLuaSprite('emergency', ext..'meltdown/meeting', 0, 50)
	setObjectCamera('emergency', 'camHUD')
	addAnimationByPrefix('emergency', 'idle', 'meeting', 24, false)
	setProperty('emergency.alpha', 0)
	addLuaSprite('emergency')
	playAnim('emergency', 'idle')

	makeAnimatedLuaSprite('greenTable', ext..'meltdown/crewInside', -1000, 570)
	addAnimationByPrefix('greenTable', 'idle', 'GREEN LOOP', 24, false)
	addAnimationByPrefix('greenTable', 'idle-peep', 'GRELOOKATRED', 24, false)
	addAnimationByPrefix('greenTable', 'facepalm', 'GREEN FACEPALM', 24, false)
	addAnimationByPrefix('greenTable', 'loop', 'GREEN ANGER LOOP', 24, true)
	playAnim('greenTable', 'idle')
	scaleObject('greenTable', 0.9, 0.9, false)

	makeLuaText('investigationText', 'Investigation ends in 0', 480, 180, 1000)
	setTextFont('investigationText', 'bahn.ttf')
	setTextSize('investigationText', 24)
	setTextAlignment('investigationText', 'center')
	addLuaText('investigationText')

	makeAnimatedLuaSprite('roseTable', ext..'meltdown/crewInside', 3000, 370)
	addAnimationByPrefix('roseTable', 'idle', 'MEETING ROSE', 24, false)
	addAnimationByPrefix('roseTable', 'idle-peep', 'LOOKING ROSE', 24, false)
	playAnim('roseTable', 'idle')
	scaleObject('roseTable', 0.9, 0.9, false)

	addLuaSprite('greenTable', true)
	addLuaSprite('roseTable', true)

	createInstance('bfVoters', 'flixel.group.FlxTypedSpriteGroup', {})
	addInstance('bfVoters', true)

	createInstance('redVoters', 'flixel.group.FlxTypedSpriteGroup', {})
	addInstance('redVoters', true)

	makeAnimatedLuaSprite('purple', ext..'meltdown/crewOutside', 3000, 650)
	addAnimationByIndices('purple', 'walk', 'PURPLE', {0, 1, 2, 3, 4, 5, 6, 7}, 24, true)
	addAnimationByIndices('purple', 'idle', 'PURPLE', {4, 5, 6, 7}, 24, true)
	playAnim('purple', 'walk')
	setProperty('purple.alpha', 0)
	if songName:lower() == 'meltdown' then
		setProperty('purple.alpha', 1)
	end
	setScrollFactor('purple', 1.2, 1.2)
	scaleObject('purple', 1.1, 1.1, false)
	addLuaSprite('purple', true)

	makeAnimatedLuaSprite('lime', ext..'meltdown/crewOutside', -2500, 375)
	addAnimationByPrefix('lime', 'idle', 'LIME', 24, true)
	playAnim('lime', 'idle')
	scaleObject('lime', 1.1, 1.1, false)
	setScrollFactor('lime', 1.2, 1.2)
	addLuaSprite('lime', true)

	makeLuaSprite('meltdownTable', ext..'meltdown/Table', 0, 4000)
	setProperty('meltdownTable.alpha', 0)
	addLuaSprite('meltdownTable', true)

	makeAnimatedLuaSprite('cyanTable', ext..'meltdown/crewInside', -1600, 650)
	addAnimationByPrefix('cyanTable', 'idle', 'MEETING CYAN', 24, true)
	addAnimationByPrefix('cyanTable', 'idle-peep', 'CYAN PEEP', 24, true)
	playAnim('cyanTable', 'idle')
	setScrollFactor('cyanTable', 1.1, 1.1)
	scaleObject('cyanTable', 1.1, 1.1, false)
	addLuaSprite('cyanTable', true)

	makeAnimatedLuaSprite('purpleTable', ext..'meltdown/crewInside', 900, 2000)
	addAnimationByPrefix('purpleTable', 'idle', 'PURPLE MEETING', 24, true)
	playAnim('purpleTable', 'idle')
	setScrollFactor('purpleTable', 1.2, 1.2)
	scaleObject('purpleTable', 1.3, 1.3, false)
	addLuaSprite('purpleTable', true)

	makeAnimatedLuaSprite('limeTable', ext..'meltdown/crewInside', 3000, 400)
	addAnimationByPrefix('limeTable', 'idle', 'LIME MEETING', 24, true)
	addAnimationByPrefix('limeTable', 'idle-peep', 'LIMELOOK', 24, true)
	playAnim('limeTable', 'idle')
	setScrollFactor('limeTable', 1.1, 1.1)
	scaleObject('limeTable', 1.3, 1.3, false)
	addLuaSprite('limeTable', true)
end

function setToCamera(obj, cam) runHaxeCode("game.getLuaObject('"..obj.."').camera = getVar('"..cam.."');") end

function unforceCamera()
	setProperty('isCameraOnForcedPos', false)
end