setScrollFactor('gf', 1, 1)

function onStartCountdown()
    playAnim('gf', 'idle-right')
    setProperty('gf.idleSuffix', '-right')
end

function onSectionHit()
    local direction = not mustHitSection and '-left' or '-right'

    if getProperty('gf.idleSuffix') ~= direction then
        playAnim('gf', 'turn'..direction, true)
        setProperty('gf.idleSuffix', direction)
        setProperty('gf.danced', false)
    end
end