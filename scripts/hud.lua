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
end