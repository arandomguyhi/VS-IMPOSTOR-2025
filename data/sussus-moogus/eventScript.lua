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
        setObjectOrder('redCutscene', 6)
        addLuaSprite('redCutscene')

        makeAnimatedLuaSprite('gunshot', 'stage/polus/sabotagecutscene/gunshot', getProperty('redCutscene.x')+515, getProperty('redCutscene.y')+90)
        addAnimationByPrefix('gunshot', 'shot', 'stupid impact0', 24, false)
        scaleObject('gunshot', 0.9, 0.9, false)
        setProperty('gunshot.visible', false)
        setObjectOrder('gunshot', 2000)
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

--[[function sabotageCutscene1stHalf()
{
	isCameraOnForcedPos = true;
	camZooming = false;
	dadGroup.visible = false;
	redCutscene.visible = true;
	FlxTween.tween(camFollow, {x: 1025, y: 500}, 2, {ease: FlxEase.expoOut});
	FlxTween.tween(FlxG.camera, {zoom: 0.65}, 2, {ease: FlxEase.expoOut});
	FlxTween.tween(camHUD, {alpha: 0}, 0.75, {ease: FlxEase.expoOut});
	FlxG.sound.play(Paths.sound('moogusCutscene'), 1);
	redCutscene.animation.play('mad');
	redCutscene.animation.onFinish.add((mad)->{
		var blackSprite = global.get('blackSprite');
		blackSprite.alpha = 1;
		blackSprite.cameras = [camGame];
		blackSprite.zIndex = 1900;
		blackSprite.scale.set(3000, 2000);
		refreshZ();
		gunshot.visible = true;
		gunshot.animation.play('shot');
		gunshot.animation.onFinish.add((mad)->{
			gunshot.visible = false;
		});
		new FlxTimer().start(2, function(tmr:FlxTimer) {
			endSong();
			FlxTransitionableState.skipNextTransOut = true;
		});
	});
}]]