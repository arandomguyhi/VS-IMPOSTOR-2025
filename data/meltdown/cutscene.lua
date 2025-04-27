luaDebugMode = true

function onCreate()
	createInstance('cutsceneAssets', 'flixel.group.FlxTypedSpriteGroup', {})
	addInstance('cutsceneAssets', true)

	makeAnimatedLuaSprite('cliff', 'stage/polus/meltdown/cutscene/bg')
	addAnimationByPrefix('cliff', 'idle', 'polus_cliff', 24, false)
	callMethod('cutsceneAssets.add', {instanceArg('cliff')})
	scaleObject('cliff', 2, 2)

	makeAnimatedLuaSprite('crew', 'stage/polus/meltdown/cutscene/bg', getProperty('cliff.x') + (1060 * getProperty('cliff.scale.x') / 2), getProperty('cliff.y') + (398 * getProperty('cliff.scale.y') / 2))
	addAnimationByPrefix('crew', 'idle', 'bg_crewmates_fuck..my_butt_hurts', 24, false)
	scaleObject('crew', getProperty('cliff.scale.x'), getProperty('cliff.scale.y'))
	callMethod('cutsceneAssets.add', {instanceArg('crew')})

	makeAnimatedLuaSprite('buildings', 'stage/polus/meltdown/cutscene/bg', getProperty('cliff.x') + (996 * getProperty('cliff.scale.x') / 2), getProperty('cliff.y') + (549 * getProperty('cliff.scale.y') / 2))
	addAnimationByPrefix('buildings', 'idle', 'bg_building', 24, false)
	scaleObject('buildings', getProperty('cliff.scale.x'), getProperty('cliff.scale.y'))
	callMethod('cutsceneAssets.add', {instanceArg('buildings')})

	local charOffsetX = 200
	local charOffsetY = 150

	makeAnimatedLuaSprite('pushingBF', 'stage/polus/meltdown/cutscene/bf_meltdown_cutscene',
		getProperty('cliff.x') + (1500 * (getProperty('cliff.scale.x') / 2)) + charOffsetX,
		getProperty('cliff.y') + (300 * (getProperty('cliff.scale.y') / 2)) + charOffsetY
	)
	scaleObject('pushingBF', getProperty('cliff.scale.x') / 2, getProperty('cliff.scale.y') / 2)
	addAnimationByPrefix('pushingBF', 'ready', 'bf ready to push', 24, true)
	addAnimationByPrefix('pushingBF', 'push', 'bf push him', 24, false)
	playAnim('pushingBF', 'ready')
	callMethod('cutsceneAssets.add', {instanceArg('pushingBF')})

	makeAnimatedLuaSprite('lava', 'stage/polus/meltdown/cutscene/bg', getProperty('cliff.x') + (-386 * getProperty('cliff.scale.x') / 2), getProperty('cliff.y') + (2574 * getProperty('cliff.scale.y') / 2))
	addAnimationByPrefix('lava', 'idle', 'bottom_lava', 24, false)
	scaleObject('lava', getProperty('cliff.scale.x'), getProperty('cliff.scale.y'))
	callMethod('cutsceneAssets.add', {instanceArg('lava')})

	makeAnimatedLuaSprite('impostor', 'stage/polus/meltdown/cutscene/red_meltdown_cutscene',
		getProperty('cliff.x') + (1625 * (getProperty('cliff.scale.x') / 2)) + charOffsetX,
		getProperty('cliff.y') + (180 * (getProperty('cliff.scale.y') / 2)) + charOffsetY
	)
	scaleObject('impostor', getProperty('cliff.scale.x') / 2, getProperty('cliff.scale.y') / 2)
	addAnimationByPrefix('impostor', 'nervous', 'nervous buddy', 24, true)
	addAnimationByPrefix('impostor', 'getPushed', 'nervous getting pushed', 24, false)
	addAnimationByPrefix('impostor', 'thumbsup', 'thumb up', 24, false)
	addAnimationByPrefix('impostor', 'falling', 'falling buddy', 24)
	addOffset('impostor', 'getPushed', 0, 20.5 * 2)
	addOffset('impostor', 'falling', -25 * 2, -15 * 2)
	addOffset('impostor', 'thumbsup', -65 * 2, 5 * 2)
	playAnim('impostor', 'nervous')
	runHaxeCode("game.getLuaObject('impostor').animation.pause();")
	setProperty('impostor.animation.curAnim.curFrame', 0)
	callMethod('cutsceneAssets.add', {instanceArg('impostor')})

	runHaxeCode([[
		game.getLuaObject('impostor').animation.finishCallback = (anim:String) -> {
			if (anim == 'getPushed')
				game.getLuaObject('impostor').animation.play('falling');
		}
	]])

	makeAnimatedLuaSprite('brdige', 'stage/polus/meltdown/cutscene/bg', getProperty('cliff.x') + (1664 * getProperty('cliff.scale.x') / 2), getProperty('cliff.y') + (600 * getProperty('cliff.scale.y') / 2))
	addAnimationByPrefix('brdige', 'idle', 'bridge', 24, false)
	scaleObject('brdige', getProperty('cliff.scale.x'), getProperty('cliff.scale.y'))
	callMethod('cutsceneAssets.add', {instanceArg('brdige')})

	makeAnimatedLuaSprite('lavaSplash', 'stage/polus/meltdown/cutscene/lava_splash', getProperty('cliff.x') + (1700 * getProperty('cliff.scale.x') / 2), getProperty('cliff.y') + (2700 * getProperty('cliff.scale.y') / 2))
	addAnimationByPrefix('lavaSplash', 'idle', 'lava splash', 24, false)
	setProperty('lavaSplash.animation.curAnim.looped', false)
	runHaxeCode("game.getLuaObject('lavaSplash').animation.pause();")
	scaleObject('lavaSplash', (getProperty('cliff.scale.x') / 2) * 0.9, (getProperty('cliff.scale.y') / 2) * 0.9)
	setProperty('lavaSplash.visible', false)
	callMethod('cutsceneAssets.add', {instanceArg('lavaSplash')})
	setProperty('lavaSplash.offset.y', 300)

	makeAnimatedLuaSprite('lavaCover', 'stage/polus/meltdown/cutscene/bg', getProperty('cliff.x') + (-386 * getProperty('cliff.scale.x') / 2), getProperty('cliff.y') + (3155 * getProperty('cliff.scale.y') / 2))
	addAnimationByPrefix('lavaCover', 'idle', 'upper_lava', 24, false)
	scaleObject('lavaCover', getProperty('cliff.scale.x'), getProperty('cliff.scale.y'))
	callMethod('cutsceneAssets.add', {instanceArg('lavaCover')})

	setProperty('cutsceneAssets.visible', false)
end

function push()
	setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.05)
	startTween('camZoom', 'camGame', {zoom = 0.5}, 1, {ease = 'sineOut'})

	playAnim('pushingBF', 'push')
	playAnim('impostor', 'getPushed')
	setObjectOrder('impostor', getObjectOrder('lavaSplash')+10)

	local sc = getProperty('impostor.scale.x')

	startTween('iPush', 'impostor', {y = getProperty('impostor.y') - 50}, 0.2, {
		ease = 'sineOut',
		onComplete = 'moreShit'
	})
	function moreShit()
		startTween('toLava', 'impostor', {y = getProperty('lavaSplash.y') + getProperty('impostor.frameHeight') + 300}, 2, {ease = 'sineIn', onComplete = 'splash'})
		startTween('iScale', 'impostor.scale', {x = sc * 1.7, y = sc * 1.7}, 1, {ease = 'sineOut', onComplete = 'lastScale'})
		lastScale = function()
			startTween('iScale', 'impostor.scale', {x = sc * 1.3, y = sc  * 1.3}, 1, {ease = 'sineIn'})
		end
	end

	startTween('iX', 'impostor', {x = getProperty('impostor.x') + 80}, 0.4, {ease = 'sineOut', onComplete = 'XBack'})
	function XBack()
		startTween('iX', 'impostor', {x = getProperty('impostor.x') - 80}, 1, {ease = 'sineOut', startDelay = 0.5}) end
	
	startTween('camPos', 'camFollow', {y = getProperty('camFollow.y') - 25}, 0.2, {onComplete = 'camShit'})
	function camShit()
		startTween('camPos', 'camFollow', {y = getProperty('lavaSplash.y') - 25}, 1.2, {})
		startTween('camZoom', 'camGame', {zoom = 0.35}, 1.2, {})
	end
end

function splash()
	callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('impostor'), {'scale.x', 'scale.y', 'y', 'x'}})
	runHaxeCode("game.getLuaObject('lavaSplash').animation.resume();")
	setProperty('lavaSplash.visible', true)

	playAnim('impostor', 'thumbsup')
	setProperty('impostor.visible', false)
end

function onEvent(ev,v1,v2)
	if ev == '' then
		if v1 == 'redTurn' then
			playAnim('impostor', 'nervous', true)
		elseif v1 == 'hideGame' then
			runHaxeCode([[
				import psychlua.CustomFlxColor;
				FlxG.camera._fxFadeColor = CustomFlxColor.BLACK;
				FlxTween.tween(FlxG.camera, {_fxFadeAlpha: 1}, 0.5);
			]])
			doTweenAlpha('hudie', 'camHUD', 0, 0.5)
			setProperty('canReset', false)
		elseif v1 == 'hideGame2' then
			runHaxeCode("FlxTween.tween(FlxG.camera, {_fxFadeAlpha: 1}, 2);")
		elseif v1 == 'showEnd' then
			setProperty('dadGroup.visible', false)
			setProperty('boyfriendGroup.visible', false)
			setProperty('gfGroup.visible', false)

			setProperty('cutsceneAssets.visible', true)

			setProperty('redVoters.visible', false)
			setProperty('bfVoters.visible', false)

			setProperty('bg.alpha', 1)
			setProperty('stars.alpha', 1)
			setObjectOrder('bg', getObjectOrder('cliff'))
			setObjectOrder('stars', getObjectOrder('bg'))

			runHaxeCode("FlxTween.tween(FlxG.camera, {_fxFadeAlpha: 0}, 0.5);")

			setProperty('isCameraOnForcedPos', true)
			snapCamFollowToPos(getProperty('cliff.x') + 2000, getProperty('cliff.y') + 300)

			setProperty('camGame.zoom', 0.5)
			setProperty('defaultCamZoom', 0.5)
		elseif v1 == 'push' then
			push()
		end
	end
end