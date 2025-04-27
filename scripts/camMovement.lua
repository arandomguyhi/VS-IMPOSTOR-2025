luaDebugMode = true

local str = 15

function goodNoteHit(_,d)
    if mustHitSection and not getProperty('isCameraOnForcedPos') then
        moveCam(d)
    end
end

function opponentNoteHit(_,d)
    if not mustHitSection and not getProperty('isCameraOnForcedPos') then
        moveCam(d)
    end
end

function moveCam(data)
    callMethod('camGame.targetOffset.set', {0,0})
    setProperty('camGame.targetOffset.'..(data%3==0 and 'x' or 'y'), str * (data%2==0 and -1 or 1))
    runTimer('reset', (crochet/1000)*2)
    onTimerCompleted = function(tag) if tag == 'reset' then
        callMethod('camGame.targetOffset.set', {0,0}) end
    end
end