luaDebugMode = true

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

    makeLuaText('rateText', 'SUS!', getProperty('rateText.width'), defaultOpponentStrumX3 + 160, defaultOpponentStrumY3 + 25)
    setTextFont('rateText', 'pixel.ttf')
    setTextSize('rateText', 56)
    addLuaText('rateText')

    makeAnimatedLuaSprite('cardBar', 'hud/healthBarFG', 0, screenHeight + getProperty('cardBar.width'))
    addAnimationByPrefix('cardBar', 'idle', 'healthbar', 24, true)
    playAnim('cardBar', 'idle')
    scaleObject('cardBar', 0.5, 0.5)
    setObjectCamera('cardBar', 'hud')
    screenCenter('cardBar', 'X')
    addLuaSprite('cardBar')
end