luaDebugMode = true

setVar('snowAlpha', 0)
local ext = 'stage/polus/'

local everyoneLook = ''
local rv = 0
local bv = 0

function onCreate()
	-- 0
    makeAnimatedLuaSprite('bg', ext..'sky', -832, -974) addAnimationByPrefix('bg', 'sky', 'sky', 0, false)
    scaleObject('bg', 2, 2)
    setScrollFactor('bg', 0.3, 0.3)

	-- 0
    makeAnimatedLuaSprite('stars', ext..'sky', -832, -974) addAnimationByPrefix('stars', 'stars', 'stars', 0, false)
	scaleObject('stars', 2, 2)
    setScrollFactor('stars', 1.1, 1.1)

	-- 2
    makeAnimatedLuaSprite('mountains', ext..'bg2', -1569, -185) addAnimationByPrefix('mountains', 'bg', 'bgBack', 0, false)
    setScrollFactor('mountains', 0.8, 0.8)

	-- 2
    makeAnimatedLuaSprite('mountains2', ext..'bg2', -1467, -25) addAnimationByPrefix('mountains2', 'bg', 'bgFront', 0, false)
    setScrollFactor('mountains2', 0.9, 0.9)

	-- 2
    makeAnimatedLuaSprite('floor', ext..'bg2', -1410, -139) addAnimationByPrefix('floor', 'bg', 'groundnew', 0, false)

	createInstance('snowEmitter', 'flixel.group.FlxTypedSpriteGroup', {})
	addInstance('snowEmitter', true)

	-- 3
    makeAnimatedLuaSprite('thingy', ext..'guylmao', 2468, -115)
    addAnimationByPrefix('thingy', 'idle', 'REACTOR_THING', 24, true)
    playAnim('thingy', 'idle')

	-- 4
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

	if not lowQuality then
		makeAnimatedLuaSprite('evilGreen', ext..'green', -550, 725)
		addAnimationByPrefix('evilGreen', 'cutscene', 'scene instance 1', 24, false)
		scaleObject('evilGreen', 2.3, 2.3, false)
		setScrollFactor('evilGreen', 1.2, 1.2)
		setProperty('evilGreen.alpha', 0)
		addLuaSprite('evilGreen')

		runHaxeCode([[
			var evilCam = new FlxCamera();
			evilCam.bgColor = 0x0;

			setVar('evilCam', evilCam);
		]])
	end

	makeLuaSprite('vignette2', ext..'vignette2')
	setProperty('vignette2.alpha', 0)
	addLuaSprite('vignette2')

	runHaxeCode([[
		var anotherCam = new FlxCamera();
		anotherCam.bgColor = 0x0;

		for (cams in [camHUD, camOther])
			FlxG.cameras.remove(cams, false);
		for (cams in [camHUD, getVar('evilCam'), anotherCam, camOther])
			FlxG.cameras.add(cams, false);

		game.getLuaObject('evilGreen').camera = getVar('evilCam');
		game.getLuaObject('vignette2').camera = anotherCam;
		setVar('anotherCam', anotherCam);
	]])
end

local particles = {}
local toRemove = {}
local timer = 0
local frequency = 0.05

local speedUp = false

function createSnow()
	local id = 'snow'..tostring(#particles)

	makeAnimatedLuaSprite(id, 'snow_particles')
	addAnimationByPrefix(id, 'snow', 0, false)
	setScrollFactor(id, getRandomFloat(1,1.5), getRandomFloat(1,1.5))
	addLuaSprite(id, true)
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
		if luaSpriteExists('boomBox') and getProperty('boomBom.animation.curAnim.name') == 'sus' then playAnim('boomBox', 'sus', true) end
		if luaSpriteExists('roseTable') and getProperty('roseTable.animation.curAnim.name') == 'idle' then playAnim('roseTable', 'idle'..everyoneLook) end
		if luaSpriteExists('greenTable') and getProperty('greenTable.animation.curAnim.name') == 'idle' then playAnim('greenTable', 'idle'..everyoneLook) end
		if luaSpriteExists('roseTable') and getProperty('roseTable.animation.curAnim.name') == 'idle-peep' then playAnim('roseTable', 'idle-peep'..everyoneLook) end
		if luaSpriteExists('greenTable') and getProperty('greenTable.animation.curAnim.name') == 'idle-peep' then playAnim('greenTable', 'idle-peep'..everyoneLook) end
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
				doTweenAlpha('blz'.._, i, 0, 7) end
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
				doTweenAlpha('blz'.._, i, 1, 5) end

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
			setObjectOrder('boyfriendGroup', getObjectOrder('dadGroup')+5)

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
		elseif value1 == 'bop' then
			playAnim('limeTable', 'idle')
			playAnim('roseTable', 'idle')
			playAnim('cyanTable', 'idle')
			playAnim('purpleTable', 'idle')
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
	-- 5
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

	-- 6
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
	addAnimationByPrefix('greenTable', 'idle-peep', 'GREENLOOKATRED', 24, false)
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

	makeAnimatedLuaSprite('purpleTable', ext..'meltdown/crewInside', -1600, 650)
	addAnimationByPrefix('purpleTable', 'idle', 'PURPLE MEETING', 24, true)
	playAnim('purpleTable', 'idle')
	setScrollFactor('purpleTable', 1.2, 1.2)
	scaleObject('purpleTable', 1.3, 1.3, false)
	addLuaSprite('purpleTable', true)

	makeAnimatedLuaSprite('limeTable', ext..'meltdown/crewInside', -1600, 650)
	addAnimationByPrefix('limeTable', 'idle', 'LIME MEETING', 24, true)
	addAnimationByPrefix('limeTable', 'idle-peep', 'LIMELOOK', 24, true)
	playAnim('limeTable', 'idle')
	setScrollFactor('limeTable', 1.1, 1.1)
	scaleObject('limeTable', 1.3, 1.3, false)
	addLuaSprite('limeTable', true)
end

--[[
function onCreatePost()
{
	dadGroup.zIndex = 12;
	gfGroup.zIndex = 12;
	boyfriendGroup.zIndex = 12;
	
	// ^ temp
	if (PlayState.SONG.song.toLowerCase() == 'sussus moogus')
	{
		game.isCameraOnForcedPos = true;
		game.snapCamFollowToPos(1025, -800);
		game.camHUD.alpha = 0;
		FlxG.camera.zoom = 0.4;
		nigga.alpha = 1;
	}
	
	if (PlayState.SONG.song.toLowerCase() == 'meltdown')
	{
		game.isCameraOnForcedPos = true;
		game.snapCamFollowToPos(1025, 500);
		FlxG.camera.zoom = 0.5;
		gf.y += 1000;
		gf.alpha = 0;
		gfDead.alpha = 1;
		boomBox.alpha = 1;
		cyan.alpha = 1;
		rose.alpha = 1;
	}
	
	snowAlpha = (songName == 'Sussus Moogus' ? 0 : 1);
	
	// sususs
	if (!ClientPrefs.lowQuality)
	{
		evilGreen = new BGSprite(null, -550, 725).loadSparrowFrames(ext + "green");
		evilGreen.animation.addByPrefix('cutscene', 'scene instance 1', 24, false);
		evilGreen.scale.set(2.3, 2.3);
		evilGreen.scrollFactor(1.2, 1.2);
		evilGreen.alpha = 0;
		add(evilGreen);
		
		evilCam = CameraUtil.quickCreateCam(false);
		FlxG.cameras.insert(evilCam, FlxG.cameras.list.indexOf(game.camPause), false);
		
		evilGreen.cameras = [evilCam];
	}
	
	anotherCam = CameraUtil.quickCreateCam(false);
	FlxG.cameras.insert(anotherCam, FlxG.cameras.list.indexOf(game.camPause), false);
	
	// loggo is a nigger
	
	vignette2 = new BGSprite(ext + "vignette2", 0, 0);
	vignette2.cameras = [anotherCam];
	vignette2.alpha = 0;
	add(vignette2);
	
	refreshZ();
}

function onUpdate(elapsed)
{
	// Making them move!
	/*
		p+=1; // IDK IF THIS IS TIED TO THE FPS I HAVENT TRIED IT

		redVoters.forEach(function(spr:FlxSprite){
			spr.scale.x = 1+(Math.sin((p+(50*spr.ID))/5 / (FlxG.updateFramerate / 60)) * 0.05);
			spr.scale.y = 1+(Math.sin((p+(50*spr.ID))/5 / (FlxG.updateFramerate / 60)) * 0.05);
		});
		bfVoters.forEach(function(spr:FlxSprite){
			spr.scale.x = 1+(Math.sin((p+(50*spr.ID))/5 / (FlxG.updateFramerate / 60)) * 0.05);
			spr.scale.y = 1+(Math.sin((p+(50*spr.ID))/5 / (FlxG.updateFramerate / 60)) * 0.05);
		});

		This is to make them move around, which looks kind of cool but in reality it's actually kind of dumb and gay.
	 */
	anotherCam.zoom = game.camHUD.zoom;
	if (!ClientPrefs.lowQuality)
	{
		evilCam.zoom = game.camGame.zoom;
		evilCam.scroll.x = FlxG.camera.scroll.x;
		evilCam.scroll.y = FlxG.camera.scroll.y;
	}
}

function revealVoters()
{
	// Scrapped (BUT IT LOOKS SO FUN)
	redVoters.forEach(function(spr:FlxSprite) {
		FlxTween.tween(spr.scale, {x: 0}, 0.25,
			{
				ease: FlxEase.quadIn,
				onComplete: function(tween:FlxTween) {
					FlxTween.tween(spr.scale, {x: 1}, 0.25, {ease: FlxEase.quadOut});
					spr.animation.curAnim.curFrame = 1;
				}
			});
	});
	bfVoters.forEach(function(spr:FlxSprite) {
		FlxTween.tween(spr.scale, {x: 0}, 0.25,
			{
				ease: FlxEase.quadIn,
				onComplete: function(tween:FlxTween) {
					FlxTween.tween(spr.scale, {x: 1}, 0.25, {ease: FlxEase.quadOut});
					spr.animation.curAnim.curFrame = 1;
				}
			});
	});
}

function refreshVoters()
{
	// trace(rv + ' ' + bv);
	redVoters.forEach(function(spr:FlxSprite) {
		if (spr.ID == rv) FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.backOut});
		FlxTween.tween(spr, {x: dad.x + 100 + (((spr.ID - 1) * 100) - (redVoters.length * (75 / 2)))}, (spr.ID == rv ? 0.1 : 0.5), {ease: FlxEase.quadInOut});
	});
	bfVoters.forEach(function(spr:FlxSprite) {
		if (spr.ID == bv) FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.backOut});
		FlxTween.tween(spr, {x: boyfriend.x + (((spr.ID - 1) * 100) - (bfVoters.length * (75 / 2)))}, (spr.ID == bv ? 0.1 : 0.5), {ease: FlxEase.quadInOut});
	});
}

function onBeatHit()
{
	if (game.curBeat % 2 == 0)
	{
		if (boomBox != null && boomBox.animation.curAnim.name == 'sus') boomBox.animation.play('sus', true);
		if (roseTable != null && roseTable.animation.curAnim.name == 'idle') roseTable.animation.play('idle' + everyoneLook);
		if (greenTable != null && greenTable.animation.curAnim.name == 'idle') greenTable.animation.play('idle' + everyoneLook);
		if (roseTable != null && roseTable.animation.curAnim.name == 'idle-peep') roseTable.animation.play('idle-peep' + everyoneLook);
		if (greenTable != null && greenTable.animation.curAnim.name == 'idle-peep') greenTable.animation.play('idle-peep' + everyoneLook);
	}
}

function onSongStart()
{
	// blackSprite.alpha = 0;
	nigga.alpha = 0;
}


function onEvent(eventName, value1, value2)
{
	switch (eventName)
	{
		case '':
			switch (value1)
			{
				case 'speedUp':
					snowEmitter.speed.set(1400, 1700);
					snowEmitter.frequency = 0.04;
			}
		case 'orange':
			var orange = global.get('sussus_orange');
			var green = global.get('sussus_green');
			
			if (ClientPrefs.lowQuality
				&& (value1 == 'walk' || value1 == 'die' || value1 == 'idle' || value2 == 'walk' || value2 == 'kill' || value2 == 'carry')) return;
				
			switch (value1)
			{
				case 'walk':
					orange.alpha = 1;
					FlxTween.tween(orange, {x: 60}, 3.5,
						{
							onComplete: function() {
								orange.animation.play('idle');
								orange.y += 30;
							}
						});
				case 'die':
					orange.animation.play('die');
				case 'wave':
					orange.animation.play('wave');
					orange.y -= 100;
				// super unorganized, but here's my camera tweens. it's done shittily i know but it was faster. sum1 else can touch it up if needed
				case 'camMiddle':
					game.isCameraOnForcedPos = true;
					FlxTween.tween(game.camFollow, {x: 1025, y: 500}, 1, {ease: FlxEase.linear});
					FlxTween.tween(FlxG.camera, {zoom: 0.5}, 1, {ease: FlxEase.smootherStepInOut});
					game.defaultCamZoom = 0.5;
				case 'camMiddleSlow':
					game.isCameraOnForcedPos = true;
					FlxTween.tween(game.camFollow, {x: 1025, y: 500}, 1.5, {ease: FlxEase.linear});
					FlxTween.tween(FlxG.camera, {zoom: 0.5}, 2, {ease: FlxEase.linear});
					game.defaultCamZoom = 0.5;
				case 'camMiddleTuah':
					game.isCameraOnForcedPos = true;
					FlxTween.tween(game.camFollow, {x: 1025, y: 500}, 1, {ease: FlxEase.linear});
					FlxTween.tween(FlxG.camera, {zoom: 0.55}, 1, {ease: FlxEase.smootherStepInOut});
					game.defaultCamZoom = 0.55;
				case 'camNormal':
					game.isCameraOnForcedPos = false;
				case 'camRight':
					game.isCameraOnForcedPos = true;
					FlxTween.tween(game.camFollow, {x: 1600, y: 525}, 5, {ease: FlxEase.smootherStepInOut});
					game.defaultCamZoom = 0.5;
					FlxTween.tween(FlxG.camera, {zoom: 0.5}, 1, {ease: FlxEase.smootherStepInOut});
				case 'evilgreen':
					if (ClientPrefs.lowQuality) return;
					
					game.playFields.cameras = [anotherCam];
					game.notes.cameras = [anotherCam];
					game.grpNoteSplashes.cameras = [anotherCam];
					flashSprite.scale.set(5, 5);
					flashSprite.cameras = [evilCam];
					evilGreen.alpha = 1;
					FlxTween.tween(vignette2, {alpha: 0.6}, 3, {ease: FlxEase.linear});
					evilGreen.animation.play('cutscene');
					FlxTween.tween(vignette2, {alpha: 0}, 2, {ease: FlxEase.linear, startDelay: 9});
					FlxTween.tween(vignette2, {alpha: 0}, 2,
						{
							ease: FlxEase.linear,
							startDelay: 9,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(2, function(tmr:FlxTimer) {
									game.playFields.cameras = [game.camHUD];
									game.notes.cameras = [game.camHUD];
									game.grpNoteSplashes.cameras = [game.camHUD];
									flashSprite.scale.set(1, 1);
									flashSprite.cameras = [game.camOther];
									remove(evilGreen);
								});
							}
						});
				case 'idle':
					orange.animation.play('idle');
					orange.y += 100;
				case 'intro':
					FlxTween.num(snowAlpha, 1, 2, {startDelay: 7.5}, (f) -> {
						snowAlpha = f;
					});
					
					FlxTween.tween(game.camHUD, {alpha: 1}, 2.5, {ease: FlxEase.linear, startDelay: 9.5});
					FlxTween.tween(FlxG.camera, {zoom: 0.5}, 12, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(game.camFollow, {y: 500}, 12,
						{
							ease: FlxEase.smootherStepInOut,
							startDelay: 0,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0.2, function(tmr:FlxTimer) {
									game.isCameraOnForcedPos = false;
								});
							}
						});
				case 'star':
					game.isCameraOnForcedPos = true;
					
					FlxTween.num(snowAlpha, 0, 2, {startDelay: 1.5}, (f) -> {
						snowAlpha = f;
					});
					
					FlxTween.tween(global.get('redStar'), {alpha: 0.9}, 5, {ease: FlxEase.linear});
					FlxTween.tween(global.get('bfStar'), {alpha: 0.9}, 3, {ease: FlxEase.linear, startDelay: 5});
					
					FlxTween.tween(FlxG.camera, {zoom: 0.4}, 5, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(game, {defaultCamZoom: 0.4}, 5, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(game.camFollow, {x: 1025, y: -800}, 5,
						{
							ease: FlxEase.smootherStepInOut,
							startDelay: 0,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									game.defaultCamZoom = 0.4;
								});
							}
						});
				case 'down':
					FlxTween.tween(global.get('redStar'), {alpha: 0}, 1, {ease: FlxEase.linear});
					// FlxTween.tween(snow, {alpha: 0.7}, 0.5, {ease: FlxEase.linear, startDelay: 1});
					FlxTween.num(snowAlpha, 1, 0.5, {startDelay: 1}, (f) -> {
						snowAlpha = f;
					});
					FlxTween.tween(global.get('bfStar'), {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(FlxG.camera, {zoom: 0.5}, 1, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(game, {defaultCamZoom: 0.5}, 1, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(game.camFollow, {x: 800, y: 500}, 1,
						{
							ease: FlxEase.smootherStepInOut,
							startDelay: 0,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									game.defaultCamZoom = 0.5;
									game.isCameraOnForcedPos = false;
								});
							}
						});
			}
			switch (value2)
			{
				case 'walk':
					green.alpha = 1;
					FlxTween.tween(green, {x: -200,}, 3.5,
						{
							onComplete: function() {
								green.animation.play('idle');
							}
						});
				case 'kill':
					green.animation.play('kill');
				case 'carry':
					orange.alpha = 0;
					green.animation.play('carry');
					FlxTween.tween(green, {x: -1000,}, 5);
			}
		case 'dialogue':
			switch (value1)
			{
				case 'red':
					redtalk.alpha = 1;
					switch (value2)
					{
						case '1':
							redtalk.animation.play('1');
							redtalk.animation.finishCallback = function() {
								redtalk.alpha = 0;
							};
						case '2':
							redtalk.animation.play('2');
							redtalk.animation.finishCallback = function() {
								redtalk.alpha = 0;
							};
						case '3':
							redtalk.x = 80;
							redtalk.y = 195;
							redtalk.animation.play('3');
							redtalk.animation.finishCallback = function() {
								redtalk.alpha = 0;
								remove(redtalk);
							};
					}
				case 'bf':
					bftalk.alpha = 1;
					switch (value2)
					{
						case '1':
							bftalk.x = 1025;
							bftalk.y = 140;
							bftalk.animation.play('1');
							bftalk.animation.finishCallback = function() {
								bftalk.alpha = 0;
							};
						case '2':
							bftalk.x = 1030;
							bftalk.y = 200;
							bftalk.animation.play('2');
							bftalk.animation.finishCallback = function() {
								bftalk.alpha = 0;
							};
						case '3':
							bftalk.x = 1050;
							bftalk.y = 185;
							bftalk.animation.play('3');
							bftalk.animation.finishCallback = function() {
								bftalk.alpha = 0;
								remove(bftalk);
							};
					}
			}
		case 'sabotage':
			var detectData = global.get('detectiveUI');
			switch (value1)
			{
				case 'noOpp':
					FlxTween.tween(global.get('sabo_detective'), {alpha: 1}, 3, {ease: FlxEase.linear});
					FlxTween.tween(game.opponentStrums, {alpha: 0}, 7, {ease: FlxEase.linear});
					FlxTween.tween(game.playHUD.healthBar, {alpha: 0}, 7, {ease: FlxEase.linear});
					FlxTween.tween(game.playHUD.iconP1, {alpha: 0}, 7, {ease: FlxEase.linear});
					FlxTween.tween(game.playHUD.iconP2, {alpha: 0}, 7, {ease: FlxEase.linear});
					FlxTween.tween(game.playHUD.scoreTxt, {alpha: 0}, 7, {ease: FlxEase.linear});
					healthLoss = 0;
				case 'drop':
					var boomBoxS:BGSprite = global.get('boomBoxS');
					
					boomBoxS.alpha = 1;
					boomBoxS.animation.play('anim');
					boomBoxS.setPosition(gf.x + 240, gf.y + 50);
					stage.insert(stage.members.indexOf(gfGroup) + 1, boomBoxS);
				case 'oppReturn':
					healthLoss = 1;
					FlxTween.tween(game.opponentStrums, {alpha: 1}, 5, {ease: FlxEase.linear});
					FlxTween.tween(game.playHUD.healthBar, {alpha: 1}, 5, {ease: FlxEase.linear});
					FlxTween.tween(game.playHUD.iconP1, {alpha: 1}, 5, {ease: FlxEase.linear});
					FlxTween.tween(game.playHUD.iconP2, {alpha: 1}, 5, {ease: FlxEase.linear});
					FlxTween.tween(game.playHUD.scoreTxt, {alpha: 1}, 5, {ease: FlxEase.linear});
					
					FlxTween.tween(detectData.investigationText, {y: 1000}, 0.7, {ease: FlxEase.expoIn});
					FlxTween.tween(detectData.detectiveUI, {y: 1000}, 0.7, {ease: FlxEase.expoIn});
					FlxTween.tween(detectData.detectiveIcon, {y: 1000}, 0.7, {ease: FlxEase.expoIn});
					
					FlxTween.tween(detectData.flxBar, {y: 1000}, 0.7, {ease: FlxEase.expoIn});
					FlxTween.tween(detectData.detectiveUI2, {y: 1000}, 0.7,
						{
							ease: FlxEase.expoIn,
							onComplete: function(tween:FlxTween) {
								FlxTimer.wait(0, () -> {
									detectData.detectiveUI.visible = detectData.detectiveUI.active = false;
									detectData.detectiveUI2.visible = detectData.detectiveUI2.active = false;
									detectData.flxBar.visible = detectData.flxBar.active = false;
								});
							}
						});
				case 'detective alt idle':
					var detective:Character = global.get('sabo_detective');
					detective.idleSuffix = '-alt';
					detective.recalculateDanceIdle();
				case 'obiturary':
					var detective:Character = global.get('sabo_detective');
					detective.playAnim('turn', true);
					detective.specialAnim = true;
					detective.idleSuffix = '';
					detective.recalculateDanceIdle();
				case 'saltyDKFunkin':
					FlxTween.tween(global.get('sabo_spotlight'), {alpha: 0.7}, 3, {ease: FlxEase.linear, startDelay: 0});
				case 'jammy':
					FlxTween.tween(global.get('sabo_spotlight'), {alpha: 0}, 3, {ease: FlxEase.linear});
				case 'ending':
					camGame.visible = camHUD.visible = false;
					inCutscene = true;
				case 'slideUp':
					startCountdown();
					
					global.get('startInvestigationCountdown')(35);
					
					FlxTween.tween(detectData.detectiveIcon, {y: 540}, 0.4, {ease: FlxEase.expoOut});
					FlxTween.tween(detectData.investigationText, {y: 618}, 0.4, {ease: FlxEase.expoOut});
					FlxTween.tween(detectData.detectiveUI, {y: 415}, 0.4, {ease: FlxEase.expoOut});
					FlxTween.tween(detectData.detectiveUI2, {y: 415}, 0.4,
						{
							ease: FlxEase.expoOut,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									detectData.flxBar.alpha = 1;
									FlxTween.tween(detectData.flxBar, {value: 60}, 35, {ease: FlxEase.linear});
								});
							}
						});
			}
			
		case 'speechbubble':
			switch (value1)
			{
				case 'red':
					speechBubbleBlue.alpha = 1;
					switch (value2)
					{
						case 'intro':
							speechBubbleBlue.x = 0;
							speechBubbleBlue.y = 200;
							speechBubbleBlue.x += -70; // Adjust x offset for intro animation
							speechBubbleBlue.y += -100; // Adjust y offset for intro animation
							speechBubbleBlue.animation.play('intro', false);
							speechBubbleBlue.animation.finishCallback = function() {
								speechBubbleBlue.animation.play('idle', true);
								speechBubbleBlue.x += 70;
								speechBubbleBlue.y += 100;
							};
						case 'exit':
							speechBubbleRed.x = 1000;
							speechBubbleRed.y = 175;
							speechBubbleBlue.x += -20; // Adjust x offset for exit animation
							speechBubbleBlue.y += -40; // Adjust y offset for exit animation
							speechBubbleBlue.animation.play('exit', false);
							speechBubbleBlue.animation.finishCallback = function() {
								speechBubbleBlue.alpha = 0;
							};
					}
				case 'blue':
					speechBubbleRed.alpha = 1;
					switch (value2)
					{
						case 'intro':
							speechBubbleRed.x = 1000;
							speechBubbleRed.y = 175;
							speechBubbleRed.x += -65; // Adjust x offset for intro animation
							speechBubbleRed.y += -100; // Adjust y offset for intro animation
							speechBubbleRed.animation.play('intro', false);
							speechBubbleRed.animation.finishCallback = function() {
								speechBubbleRed.animation.play('idle', true);
								speechBubbleRed.x += 65; // Adjust x offset for exit animation
								speechBubbleRed.y += 100;
							};
						case 'exit':
							speechBubbleRed.x = 1000;
							speechBubbleRed.y = 175;
							speechBubbleRed.x += -65; // Adjust x offset for intro animation
							speechBubbleRed.y += -100; // Adjust y offset for exit animation
							speechBubbleRed.animation.play('exit', false);
							speechBubbleRed.animation.finishCallback = function() {
								speechBubbleRed.alpha = 0;
							};
					}
			}
		case 'meltdown':
			switch (value1)
			{
				case 'boombox':
					boomBox.x = 1135;
					boomBox.y = 525;
					boomBox.animation.play('alert');
					boomBox.animation.finishCallback = function() {
						boomBox.x = 1140;
						boomBox.y = 680;
						boomBox.animation.play('sus');
					};
					
				case 'redVote':
					var v = Std.parseInt(value2);
					rv += 1;
					var voter:FlxSprite = new FlxSprite(dad.x + 100, dad.y - 100).loadGraphic(Paths.image(ext + 'meltdown/votingIcons'), true, 150, 150);
					voter.animation.add('yy', [8, v], 0, false);
					voter.animation.play('yy');
					voter.origin.set(75, 75);
					voter.animation.curAnim.curFrame = 1;
					voter.ID = rv;
					voter.scale.set(0, 0);
					voter.antialiasing = ClientPrefs.globalAntialiasing;
					redVoters.add(voter);
					refreshVoters();
				case 'bfVote':
					var v = Std.parseInt(value2);
					bv += 1;
					var voter:FlxSprite = new FlxSprite(boyfriend.x, boyfriend.y - 100).loadGraphic(Paths.image(ext + 'meltdown/votingIcons'), true, 150, 150);
					voter.animation.add('yy', [8, v], 0, false);
					voter.animation.play('yy');
					voter.scale.set(0, 0);
					voter.animation.curAnim.curFrame = 1;
					voter.origin.set(75, 75);
					voter.ID = bv;
					voter.antialiasing = ClientPrefs.globalAntialiasing;
					bfVoters.add(voter);
					refreshVoters();
				case 'meeting':
					stars.alpha = 0;
					FlxTween.tween(floor, {alpha: 0}, 0.5, {ease: FlxEase.linear});
					FlxTween.tween(mountains, {alpha: 0}, 0.5, {ease: FlxEase.linear});
					FlxTween.tween(mountains2, {alpha: 0}, 0.5, {ease: FlxEase.linear});
					
					FlxTween.tween(greenTable, {x: -100, y: 500}, 0.2, {ease: FlxEase.linear});
					FlxTween.tween(limeTable, {x: 2050, y: 400}, 0.4, {ease: FlxEase.linear});
					FlxTween.tween(roseTable, {x: 1700, y: 320}, 0.8, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(cyanTable, {x: -550, y: 650}, 0.8, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(purpleTable, {x: 725, y: 970}, 1, {ease: FlxEase.smootherStepInOut});
					
					emergency.alpha = 1;
					emergency.animation.play('idle');
					meltdownBGLeft.alpha = 1;
					meltdownBGRight.alpha = 1;
					meltdownTable.alpha = 1;
					lime.alpha = 0;
					purple.alpha = 0;
					rose.alpha = 0;
					cyan.alpha = 0;
					
					// meltdownBGBack.zIndex = 0;
					// snowEmitter.zIndex = 1;
					// refreshZ();
					snowEmitter.scrollFactor.x.set(0.8, 1);
					snowEmitter.scrollFactor.y.set(0.8, 1);
					stage.remove(snowEmitter);
					stage.insert(stage.members.indexOf(meltdownBGBack) + 1, snowEmitter);
					
					FlxTween.tween(meltdownBGBack, {x: 50, y: 335}, 0.4, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(meltdownBGLeft, {x: -1100}, 0.2, {ease: FlxEase.linear});
					FlxTween.tween(meltdownBGRight, {x: (1 * meltdownBGLeft.width) - 1100}, 0.2, {ease: FlxEase.linear});
					FlxTween.tween(gf, {alpha: 1}, 0.6,
						{
							ease: FlxEase.linear,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									FlxTween.tween(emergency, {alpha: 0}, 1, {ease: FlxEase.linear, startDelay: 1});
								});
							}
						});
					FlxTween.tween(gf, {y: 480}, 0.8, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(meltdownTable, {y: 650}, 0.3, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(gfDead, {alpha: 0}, 0.5, {ease: FlxEase.linear});
					FlxTween.tween(boomBox, {alpha: 0}, 0.5, {ease: FlxEase.linear});
					
					// FlxTween.tween(snow2, {alpha: 1}, 0.5, {ease: FlxEase.linear});
					
					// FlxTween.tween(overlay, {alpha: 0}, 0.5, {ease: FlxEase.linear});
					FlxTween.tween(vignette, {alpha: 0}, 0.5, {ease: FlxEase.linear});
				case 'facepalm':
					greenTable.animation.play('facepalm', false);
					greenTable.animation.finishCallback = function() {
						greenTable.animation.play('loop', true);
					};
				case 'watch':
					greenTable.animation.play('idle-peep');
					limeTable.animation.play('idle-peep');
					roseTable.animation.play('idle-peep');
					cyanTable.animation.play('idle-peep');
					purpleTable.animation.play('idle-peep');
				case 'bop':
					limeTable.animation.play('idle');
					roseTable.animation.play('idle');
					cyanTable.animation.play('idle');
					purpleTable.animation.play('idle');
					
				case 'camMiddle':
					game.isCameraOnForcedPos = true;
					FlxTween.tween(game.camFollow, {x: 1025, y: 500}, 1, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(FlxG.camera, {zoom: 0.5}, 1,
						{
							ease: FlxEase.smootherStepInOut,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									game.defaultCamZoom = 0.5;
								});
							}
						});
				case 'camMiddleMeeting':
					game.isCameraOnForcedPos = true;
					FlxTween.tween(game.camFollow, {x: 1025, y: 500}, 1, {ease: FlxEase.linear});
					FlxTween.tween(FlxG.camera, {zoom: 0.6}, 1,
						{
							ease: FlxEase.linear,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									game.defaultCamZoom = 0.65;
								});
							}
						});
						
				case 'camMiddleAyo':
					game.isCameraOnForcedPos = true;
					FlxTween.tween(game.camFollow, {x: 1025, y: 500}, 1,
						{
							ease: FlxEase.smootherStepInOut,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									FlxTween.tween(FlxG.camera, {zoom: 0.8}, 0.8,
										{
											ease: FlxEase.smootherStepInOut,
											startDelay: 2,
											onComplete: function(tween:FlxTween) {
												new FlxTimer().start(0, function(tmr:FlxTimer) {
													game.defaultCamZoom = 0.8;
												});
											}
										});
								});
							}
						});
						
				case 'camMiddle6':
					game.isCameraOnForcedPos = true;
					FlxTween.tween(game.camFollow, {x: 1025, y: 500}, 1, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(FlxG.camera, {zoom: 0.6}, 1,
						{
							ease: FlxEase.smootherStepInOut,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									game.defaultCamZoom = 0.6;
								});
							}
						});
				case 'camNormal':
					game.isCameraOnForcedPos = false;
				case 'camMiddleSlow':
					game.isCameraOnForcedPos = true;
					FlxTween.tween(game.camFollow, {x: 1025, y: 500}, 1.5, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(FlxG.camera, {zoom: 0.65}, 1.5,
						{
							ease: FlxEase.linear,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									game.defaultCamZoom = 0.5;
								});
							}
						});
				case 'meetingZoom':
					game.isCameraOnForcedPos = true;
			}
			switch (value2)
			{
				case 'idle':
					green.animation.play('idle');
					green.y += 100;
				case 'cyan':
					FlxTween.tween(cyan, {x: -25}, 6,
						{
							ease: FlxEase.linear,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									cyan.animation.play('idle');
									cyan.y += 20;
								});
							}
						});
				case 'purple':
					FlxTween.tween(purple, {x: 2050}, 5,
						{
							ease: FlxEase.linea,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									purple.animation.play('idle');
								});
							}
						});
				case 'rose':
					FlxTween.tween(rose, {x: 1800}, 5,
						{
							ease: FlxEase.linear,
							onComplete: function(tween:FlxTween) {
								new FlxTimer().start(0, function(tmr:FlxTimer) {
									rose.animation.play('idle');
								});
							}
						});
				case 'lime':
					FlxTween.tween(lime, {x: -300}, 5, {ease: FlxEase.smootherStepInOut});
			}
	}
}

function buildMeltdownBG()
{
	meltdownBGBack = new BGSprite(ext + "meltdown/buildingsbg", 50, 4000);
	meltdownBGBack.scrollFactor.set(0.85, 0.85);
	add(meltdownBGBack);
	meltdownBGBack.zIndex = 5;
	
	meltdownBGLeft = new BGSprite(ext + "meltdown/wallBGLeft", -4000, -300);
	meltdownBGLeft.alpha = 0;
	add(meltdownBGLeft);
	meltdownBGLeft.zIndex = 5;
	
	cyan = new BGSprite(null, -2000, 475).loadSparrowFrames(ext + "meltdown/crewOutside");
	cyan.animation.addByPrefix('walk', 'CYAN WALK', 24, true);
	cyan.animation.addByPrefix('idle', 'IDLE CYAN', 24, true);
	cyan.animation.play('walk');
	add(cyan);
	cyan.zIndex = 5;
	
	rose = new BGSprite(null, 3000, 305).loadSparrowFrames(ext + 'meltdown/crewOutside');
	rose.animation.addByIndices('walk', 'ROSE', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], "", 24, true);
	rose.animation.addByIndices('idle', 'ROSE', [16, 17, 18, 19], "", 24, true);
	rose.animation.play('walk');
	add(rose);
	rose.zIndex = 5;
	
	meltdownBGRight = new BGSprite(ext + "meltdown/wallBGRight", ((meltdownBGLeft.width) + meltdownBGLeft.x) + 4000, meltdownBGLeft.y);
	add(meltdownBGRight);
	meltdownBGRight.alpha = 0;
	meltdownBGRight.zIndex = 6;
	
	speechBubbleBlue = new BGSprite(null, 100, 250).loadSparrowFrames(ext + "meltdown/textbox");
	speechBubbleBlue.animation.addByPrefix('idle', 'RedBubbleBoil', 24, true);
	speechBubbleBlue.animation.addByPrefix('intro', 'RedBubblePop', 24, false);
	speechBubbleBlue.animation.addByPrefix('exit', 'RedBubbleOut', 24, false);
	speechBubbleBlue.scale.set(0.9, 0.9);
	add(speechBubbleBlue);
	speechBubbleBlue.alpha = 0;
	speechBubbleBlue.zIndex = 6;
	
	speechBubbleRed = new BGSprite(null, 1000, 175).loadSparrowFrames(ext + "meltdown/textbox");
	speechBubbleRed.animation.addByPrefix('idle', 'BlueBubbleBoil', 24, true);
	speechBubbleRed.animation.addByPrefix('intro', 'BlueBubblePop', 24, false);
	speechBubbleRed.animation.addByPrefix('exit', 'BlueBubbleOut', 24, false);
	speechBubbleRed.scale.set(0.9, 0.9);
	add(speechBubbleRed);
	speechBubbleRed.alpha = 0;
	speechBubbleRed.zIndex = 6;
	
	redtalk = new BGSprite(null, 80, 230).loadSparrowFrames(ext + "meltdown/RedSpeech1");
	redtalk.animation.addByPrefix('1', 'red1', 24, false);
	redtalk.animation.addByPrefix('2', 'red2', 24, false);
	redtalk.animation.addByPrefix('3', 'red3', 24, false);
	redtalk.scale.set(0.85, 0.72);
	redtalk.alpha = 0;
	redtalk.zIndex = 6;
	add(redtalk);
	
	bftalk = new BGSprite(null, 1025, 140).loadSparrowFrames(ext + "meltdown/BFSpeech1");
	bftalk.animation.addByPrefix('1', 'bf1', 24, false);
	bftalk.animation.addByPrefix('2', 'bf2', 24, false);
	bftalk.animation.addByPrefix('3', 'bf3', 24, false);
	bftalk.scale.set(0.85, 0.72);
	bftalk.alpha = 0;
	bftalk.zIndex = 6;
	add(bftalk);
	
	gfDead = new BGSprite(null, 920, 580).loadSparrowFrames(ext + "meltdown/gfDead");
	gfDead.animation.addByPrefix('idle', 'gf DEAD', 24, true);
	gfDead.alpha = 0;
	gfDead.scale.set(1.1, 1.1);
	add(gfDead);
	gfDead.animation.play('idle');
	gfDead.zIndex = 6;
	
	boomBox = new BGSprite(null, 1175, 780).loadSparrowFrames(ext + "meltdown/boombox");
	boomBox.animation.addByPrefix('idle', 'floor boombox', 24, true);
	boomBox.animation.addByPrefix('alert', 'boombox alert', 24, false);
	boomBox.animation.addByPrefix('sus', 'boombox anim', 24, false);
	boomBox.alpha = 0;
	boomBox.scale.set(1.1, 1.1);
	add(boomBox);
	boomBox.animation.play('idle');
	boomBox.zIndex = 6;


	emergency = new BGSprite(null, 0, 50).loadSparrowFrames(ext + "meltdown/meeting");
	emergency.cameras = [game.camHUD];
	emergency.animation.addByPrefix('idle', 'meeting', 24, false);
	emergency.alpha = 0;
	add(emergency);
	emergency.animation.play('idle');
	emergency.zIndex = 6;
	
	greenTable = new BGSprite(null, -1000, 570).loadSparrowFrames(ext + "meltdown/crewInside");
	greenTable.animation.addByPrefix('idle', 'GREEN LOOP', 24, false);
	greenTable.animation.addByPrefix('idle-peep', 'GRELOOKATRED', 24, false);
	greenTable.animation.addByPrefix('facepalm', 'GREEN FACEPALM', 24, false);
	greenTable.animation.addByPrefix('loop', 'GREEN ANGER LOOP', 24, true);
	greenTable.animation.play('idle');
	greenTable.scale.set(0.9, 0.9);
	
	greenTable.zIndex = 14;
	
	investigationText = new FlxText(180, 1000, 480, "Investigation ends in 0", true);
	investigationText.setFormat(Paths.font("bahn.ttf"), 24, 0xFFFFFF, "center");
	investigationText.cameras = [game.camHUD];
	investigationText.alpha = 1;
	investigationText.antialiasing = ClientPrefs.globalAntialiasing;
	game.add(investigationText);
	
	roseTable = new BGSprite(null, 3000, 370).loadSparrowFrames(ext + "meltdown/crewInside");
	roseTable.animation.addByPrefix('idle', 'METING ROSE', 24, false);
	roseTable.animation.addByPrefix('idle-peep', 'LOOKING ROSE', 24, false);
	roseTable.animation.play('idle');
	roseTable.alpha = 1;
	roseTable.scale.set(0.9, 0.9);
	roseTable.zIndex = 14;
	
	add(greenTable);
	
	add(roseTable);
	
	redVoters = new FlxTypedGroup();
	redVoters.zIndex = 14;
	add(redVoters);

	global.set('redVoters',redVoters);
	
	bfVoters = new FlxTypedGroup();
	bfVoters.zIndex = 14;
	add(bfVoters);
	global.set('bfVoters',bfVoters);

	
	purple = new BGSprite(null, 3000, 650).loadSparrowFrames(ext + "meltdown/crewOutside");
	purple.animation.addByIndices('walk', 'PURPLE', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, true);
	purple.animation.addByIndices('idle', 'PURPLE', [4, 5, 6, 7], "", 24, true);
	purple.animation.play('walk');
	purple.alpha = 0;
	if (PlayState.SONG.song.toLowerCase() == 'meltdown')
	{
		purple.alpha = 1;
	}
	purple.scrollFactor.set(1.2, 1.2);
	purple.scale.set(1.1, 1.1);
	add(purple);
	
	purple.zIndex = 15;
	
	lime = new BGSprite(null, -2500, 375).loadSparrowFrames(ext + "meltdown/crewOutside");
	lime.animation.addByPrefix('idle', 'LIME', 24, true);
	lime.animation.play('idle');
	lime.scale.set(1.1, 1.1);
	lime.scrollFactor.set(1.2, 1.2);
	add(lime);
	lime.zIndex = 15;
	
	meltdownTable = new BGSprite(ext + "meltdown/Table", 0, 4000);
	meltdownTable.alpha = 0;
	add(meltdownTable);
	
	meltdownTable.zIndex = 15;
	
	cyanTable = new BGSprite(null, -1600, 650).loadSparrowFrames(ext + "meltdown/crewInside");
	cyanTable.animation.addByPrefix('idle', 'MEETING CYAN', 24, true);
	cyanTable.animation.addByPrefix('idle-peep', 'CYAN PEEP', 24, true);
	cyanTable.animation.play('idle');
	cyanTable.scrollFactor.set(1.1, 1.1);
	cyanTable.scale.set(1.1, 1.1);
	add(cyanTable);
	
	cyanTable.zIndex = 15;
	
	purpleTable = new BGSprite(null, 900, 2000).loadSparrowFrames(ext + "meltdown/crewInside");
	purpleTable.animation.addByPrefix('idle', 'PURPLE MEETING', 24, true);
	purpleTable.animation.play('idle');
	purpleTable.scrollFactor.set(1.2, 1.2);
	purpleTable.scale.set(1.3, 1.3);
	add(purpleTable);
	
	purpleTable.zIndex = 15;
	
	limeTable = new BGSprite(null, 3000, 400).loadSparrowFrames(ext + "meltdown/crewInside");
	limeTable.animation.addByPrefix('idle', 'LIME MEETING', 24, true);
	limeTable.animation.addByPrefix('idle-peep', 'LIMELOOK', 24, true);
	limeTable.animation.play('idle');
	limeTable.scrollFactor.set(1.1, 1.1);
	limeTable.scale.set(1.3, 1.3);
	add(limeTable);
	
	limeTable.zIndex = 15;
}
]]

function unforceCamera()
	setProperty('isCameraOnForcedPos', false)
end