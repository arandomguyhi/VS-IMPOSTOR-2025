-- pretty simple one, maybe getting this better later

local defScale = 0.6
local curSel = 0

function onPause()
    openCustomSubstate('ImpostorPause', true)
    return Function_Stop
end

function onCustomSubstateCreate(name)
    if name == 'ImpostorPause' then
        playSound('../music/pause_theme', 0, 'pauseSong')
        soundFadeIn('pauseSong', 0.5, 0, 0.7)

        makeLuaSprite('blackBg') makeGraphic('blackBg', screenWidth, screenHeight, '000000')
        pauseCam('blackBg')
        insertToCustomSubstate('blackBg')
        setProperty('blackBg.alpha', 0.4)

        makeAnimatedLuaSprite('frame', 'menu/pause/pause_assets')
        addAnimationByPrefix('frame', 'idle', 'pause box mustaaaarrrrdddd', 0, false)
        scaleObject('frame', defScale, defScale)
        insertToCustomSubstate('frame')
        pauseCam('frame')
        screenCenter('frame')

        makeAnimatedLuaSprite('paused', 'menu/pause/pause_assets', 0, 100)
        addAnimationByPrefix('paused', 'idle', 'paused text', 0)
        scaleObject('paused', defScale, defScale)
        pauseCam('paused')
        centerOn('paused', 'frame', 'X')
        insertToCustomSubstate('paused')

        createInstance('buttons', 'flixel.group.FlxTypedSpriteGroup', {})
        insertToCustomSubstate('buttons')

        newButton(0, getProperty('paused.y') + getProperty('paused.height') + 20, 'resume')
        callMethod('buttons.add', {instanceArg('resumeButton')})
        centerOn('resumeButton', 'frame', 'X')

        newButton(getProperty('resumeButton.x'), getProperty('resumeButton.y') + getProperty('resumeButton.height'), 'restart')
        callMethod('buttons.add', {instanceArg('restartButton')})

        newButton(getProperty('resumeButton.x'), getProperty('restartButton.y') + getProperty('restartButton.height'), 'option')
        callMethod('buttons.add', {instanceArg('optionButton')})

        newButton(getProperty('resumeButton.x'), getProperty('optionButton.y') + getProperty('optionButton.height'), 'exit')
        callMethod('buttons.add', {instanceArg('exitButton')})

        changeSel()
    end
end

function onCustomSubstateUpdatePost(name, elapsed)
    if name == 'ImpostorPause' then
        centerOn('resume', 'resumeButton', 'XY')
        centerOn('restart', 'restartButton', 'XY')
        centerOn('option', 'optionButton', 'XY')
        centerOn('exit', 'exitButton', 'XY')

        if keyJustPressed('down') then changeSel(1)
        elseif keyJustPressed('up') then changeSel(-1) end

        if getProperty('controls.ACCEPT') then
            if curSel == 0 then
                closeCustomSubstate()
            elseif curSel == 1 then
                restartSong()
            elseif curSel == 2 then
                runHaxeCode([[
                    import backend.MusicBeatState;
                    import options.OptionsState;
                    MusicBeatState.switchState(new OptionsState());
                    OptionsState.onPlayState = true;
                ]])
            elseif curSel == 3 then
                exitSong()
            end
        end
    end
end

function changeSel(diff)
    if diff == nil then diff = 0 end

    playSound('scrollMenu', 0.4)

    callMethod('buttons.members['..curSel..'].playAnim', {'button blank'})
    curSel = callMethodFromClass('flixel.math.FlxMath', 'wrap', {curSel + diff, 0, getProperty('buttons.length')-1})
    callMethod('buttons.members['..curSel..'].playAnim', {'button select'})
end

function onCustomSubstateDestroy(name)
    if name == 'ImpostorPause' then
        callMethod('buttons.kill', {''})
        removeInstance('buttons')
        stopSound('pauseSong')
    end
end

function newButton(x, y, text)
    makeAnimatedLuaSprite(text..'Button', 'menu/pause/pause_assets', x, y)
    addAnimationByPrefix(text..'Button', 'button blank', 'button blank', 0)
    addAnimationByPrefix(text..'Button', 'button select', 'button select', 0)
    scaleObject(text..'Button', defScale, defScale)

    makeAnimatedLuaSprite(text, 'menu/pause/pause_assets')
    addAnimationByPrefix(text, 'idle', text..' txt', 0)
    scaleObject(text, defScale, defScale)
    pauseCam(text)
    insertToCustomSubstate(text)
end

function pauseCam(obj)
    runHaxeCode("game.getLuaObject('"..obj.."').camera = getVar('camPause');")
end

function centerOn(obj, target, pos)
    if pos == 'X' then
        setProperty(obj..'.x', getProperty(target..'.x') + (getProperty(target..'.width') - getProperty(obj..'.width')) / 2)
    elseif pos == 'Y' then
        setProperty(obj..'.y', getProperty(target..'.y') + (getProperty(target..'.height') - getProperty(obj..'.height')) / 2)
    elseif pos == 'XY' then
        centerOn(obj,target,'X') centerOn(obj,target,'Y')
    end
end

function removeInstance(tag)
    callMethod('variables.remove', {tag})
    callMethod(tag..'.kill', {''})
    callMethod('remove', {instanceArg(tag)})
    callMethod(tag..'.destroy', {''})
end