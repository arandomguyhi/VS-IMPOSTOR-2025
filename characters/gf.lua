function onCreatePost()
    onSectionHit(0)
end

function onSectionHit(curSec)
    local suffix = (mustHitSection and '' or '-left')
    if getProperty('gf.idleSuffix') ~= suffix then
        playAnim('gf', 'turn'..suffix, true)
        setProperty('gf.idleSuffix', suffix)
        setProperty('gf.danced', false)
    end
end