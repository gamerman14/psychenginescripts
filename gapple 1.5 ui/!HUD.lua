function onCreate()
    for i,lib in pairs{'ClientPrefs', 'Conductor', 'Math', 'Highscore', 'Type', 'BlendModeEffect', 'Main', 'Note'} do
        addHaxeLibrary(lib)
    end
    addHaxeLibrary('FlxStringUtil', 'flixel.util')
    addHaxeLibrary('FlxMath', 'flixel.math')
    addHaxeLibrary('FPS', 'openfl.display')
    addHaxeLibrary('System', 'openfl.system')
    setProperty('showCombo', true)
end
function onCreatePost() --time stuff
    setProperty('timeBarBG.visible', false)
    setProperty('timeBar.visible', false)
    makeLuaText('songName', songName, 0, 3)
    setProperty('songName.y', screenHeight - getProperty 'songName.height')
    setProperty('songName.borderSize', 1.25)
    addLuaText 'songName'
    
    setObjectOrder('healthBarBG', getObjectOrder 'healthBar')
    scaleObject('healthBar', 1.01, 1.49)
    updateHitbox 'healthBar'
    setProperty('healthBarBG.xAdd', 0)
    setProperty('healthBarBG.yAdd', 0)
    runHaxeCode([[
        iconP1 = new HealthIcon(game.boyfriend.healthIcon, true);
        iconP1.y = game.healthBar.y - 75;
        iconP1.visible = !ClientPrefs.hideHud;
        iconP1.alpha = ClientPrefs.healthBarAlpha;
        iconP1.cameras = [game.camHUD];
        iconP1.antialiasing = game.boyfriend.antialiasing;
        game.insert(game.members.indexOf(game.scoreTxt), iconP1);

        iconP2 = new HealthIcon(game.dad.healthIcon, false);
        iconP2.y = game.healthBar.y - 75;
        iconP2.visible = !ClientPrefs.hideHud;
        iconP2.alpha = ClientPrefs.healthBarAlpha;
        iconP2.cameras = [game.camHUD];
        iconP2.antialiasing = game.dad.antialiasing;
        game.insert(game.members.indexOf(game.scoreTxt), iconP2);
        game.iconP1.visible = false;
        game.iconP2.visible = false;
        if(!ClientPrefs.middleScroll) {
            for(strum in game.opponentStrums)
                strum.x -= 42;
            for(strum in game.playerStrums)
                strum.x += 32;
            for(strum in game.strumLineNotes)
                strum.y -= 2;
        }
        for(thing in [iconP1, iconP2, game.healthBar, game.scoreTxt]) {
            thing.y += 5;
            thing.x -= 2;
        }
        game.healthBar.y -= 3;
        game.scoreTxt.y += 6;
    ]])

    if checkFileExists ('data/'..songPath..'/credits.txt') then
        hasCredits = true
        makeLuaSprite ('creditsBox', '', -426)
        makeGraphic('creditsBox', 426, screenHeight, '0xFF000000')
        setObjectCamera('creditsBox', 'other')
        setProperty('creditsBox.alpha', 0.5)
        addLuaSprite('creditsBox', true)

        makeLuaText('creditsBoxTxt', getTextFromFile ('data/'..songPath..'/credits.txt'), 426)
        setProperty('creditsBoxTxt.alignment', 'center')
        setProperty('creditsBoxTxt.size', 32)
        setObjectCamera('creditsBoxTxt', 'other')
        runHaxeCode "game.getLuaObject('creditsBoxTxt').setBorderStyle(Type.resolveEnum('flixel.text.FlxTextBorderStyle').NONE);"
        addLuaText('creditsBoxTxt')
    end

    runHaxeCode 'Main.fpsVar.visible = false;'
    makeLuaText 'fpsTxt'
    setObjectCamera('fpsTxt', 'other')
    runHaxeCode "game.getLuaObject('fpsTxt').setBorderStyle(Type.resolveEnum('flixel.text.FlxTextBorderStyle').NONE);"
    setProperty('fpsTxt.x', 10)
    setProperty('fpsTxt.y', 3)
    setProperty('fpsTxt.size', 20)
    addLuaText 'fpsTxt'
    makeLuaText 'memTxt'
    setObjectCamera('memTxt', 'other')
    runHaxeCode "game.getLuaObject('memTxt').setBorderStyle(Type.resolveEnum('flixel.text.FlxTextBorderStyle').NONE);"
    setProperty('memTxt.x', 10)
    setProperty('memTxt.y', 35)
    addLuaText 'memTxt'
end
function onDestroy()
    runHaxeCode 'Main.fpsVar.visible = true;'
end
function onBeatHit()
    runHaxeCode([[
        if (game.curBeat % game.gfSpeed == 0) {
            var newTween = function(tag, tween){
                game.modchartTweens.set(tag, tween);
            }
			if(game.curBeat % (game.gfSpeed * 2) == 0) {
				iconP1.scale.set(1.1, 0.8);
				iconP2.scale.set(1.1, 1.3);

				newTween('_iconp1angle', FlxTween.angle(iconP1, -15, 0, Conductor.crochet / 1300 * game.gfSpeed, {ease: FlxEase.quadOut}));
				newTween('_iconp2angle', FlxTween.angle(iconP2, 15, 0, Conductor.crochet / 1300 * game.gfSpeed, {ease: FlxEase.quadOut}));
			} else {
				iconP1.scale.set(1.1, 1.3);
				iconP2.scale.set(1.1, 0.8);

				newTween('_iconp2angle', FlxTween.angle(iconP2, -15, 0, Conductor.crochet / 1300 * game.gfSpeed, {ease: FlxEase.quadOut}));
				newTween('_iconp1angle', FlxTween.angle(iconP1, 15, 0, Conductor.crochet / 1300 * game.gfSpeed, {ease: FlxEase.quadOut}));
			}
			iconP1.updateHitbox();
			iconP2.updateHitbox();
            iconP1.offset.x -= 150 - iconP1.width + 5;
            iconP2.offset.x -= 150 - iconP2.width + 5;
            iconP1.offset.y += (150 - iconP1.height)/2;
            iconP2.offset.y += (150 - iconP2.height)/2;
			newTween('_iconp1scale', FlxTween.tween(iconP1.scale, {x: 1, y: 1}, Conductor.crochet / 1250 * game.gfSpeed, {ease: FlxEase.quadOut}));
			newTween('_iconp2scale', FlxTween.tween(iconP2.scale, {x: 1, y: 1}, Conductor.crochet / 1250 * game.gfSpeed, {ease: FlxEase.quadOut}));
            newTween('_iconp1offset', FlxTween.tween(iconP1.offset, {x: 0, y: 0}, Conductor.crochet / 1250 * game.gfSpeed, {ease: FlxEase.quadOut}));
            newTween('_iconp2offset', FlxTween.tween(iconP2.offset, {x: 0, y: 0}, Conductor.crochet / 1250 * game.gfSpeed, {ease: FlxEase.quadOut}));
		}
    ]])
end
function onUpdate()
    runHaxeCode([[
        iconP1.x = game.iconP1.x;
        iconP1.x -= (150 * game.iconP1.scale.x - 150)/2;
        iconP2.x = game.iconP2.x;
        iconP2.x += (150 * game.iconP2.scale.x)/2 - (26*3);
    ]])
    if hasCredits then
        setProperty('creditsBoxTxt.x', getProperty 'creditsBox.x')
    end
end
function onUpdatePost()
    if not getProperty 'startingSong' and not getProperty 'paused' then
        runHaxeCode([[
            var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;

            var secondsTotal:Int = Math.floor(curTime / 1000);
            if(secondsTotal < 0) secondsTotal = 0;
            var theString:String = FlxStringUtil.formatTime(secondsTotal, false) + ' / ' + FlxStringUtil.formatTime(Math.floor(game.songLength / 1000), false);
            game.timeTxt.text = theString;
        ]])
    end
    local scoreSplit = stringSplit(getProperty 'scoreTxt.text', ' | ')
    scoreSplit[3] = tostring(math.floor(getProperty 'ratingPercent' * 10000)/100)..'%'
    setProperty('scoreTxt.text', table.concat(scoreSplit, ' | '))
    local fps = runHaxeCode 'return Main.fpsVar.currentFPS;'
    setProperty('fpsTxt.text', 'FPS: '..tostring(fps))
    setProperty('memTxt.text', 'RAM Used: '..tostring(runHaxeCode 'return Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));')..' MB')
end
function goodNoteHit(id, data, type, sus) --do wacky stuff with ratings
    if not sus then
        runHaxeCode([=[
            var nums = [for(i in 1...4) game.members[game.members.indexOf(game.strumLineNotes)-i]];
            for(num in nums){
                num.x += 150;
                num.y -= 25;
            }
            var all = [for(i in nums) i];
            var combo = game.members[game.members.indexOf(game.strumLineNotes)-4];
            combo.y -= combo.height;
            combo.x -= combo.width;
            all.push(combo);
            var rating = game.members[game.members.indexOf(game.strumLineNotes)-5];
            rating.y += rating.height;
            rating.x -= rating.width/2;
            all.push(rating);
            //example on what you can do :)
            var adder = FlxG.random.bool(50) ? 575 : 700;
            for(spr in all){
                spr.alpha = 0.5;
                spr.x -= ClientPrefs.comboOffset[0];
                spr.y += ClientPrefs.comboOffset[1];
                spr.x += adder;
                spr.y -= 30;
            }
            if(game.combo < 10) {
                for(spr in all)
                    spr.visible = false;
                rating.visible = true;
            }
            //game.addTextToDebug(all, 0xFFFFFFFF);
        ]=])
    end
end
function onUpdateScore(miss)
    runHaxeCode([[
        if(ClientPrefs.scoreZoom && !]]..tostring(miss)..[[) {
            if(game.scoreTxtTween != null) {
				game.scoreTxtTween.cancel();
			}
            var scale = 1.3;
			game.scoreTxt.scale.set(scale, scale);
			game.scoreTxtTween = FlxTween.tween(game.scoreTxt.scale, {x: 1, y: 1}, 0.4, {
				onComplete: function(twn:FlxTween) {
					scoreTxtTween = null;
				},
                ease: FlxEase.backOut
			});
        }
    ]])
end
function onCountdownTick(what)
    if what ~= 4 then
        cameraSetTarget(what % 2 == 0 and 'bf' or 'dad')
    end
    local scale = 1
    local funcs = {
        [1] = function()
            setObjectCamera('countdownReady', 'game')
            scaleObject('countdownReady', scale, scale)
            screenCenter 'countdownReady'
        end,
        [2] = function()
            setObjectCamera('countdownSet', 'game')
            scaleObject('countdownSet', scale, scale)
            screenCenter 'countdownSet'
            setProperty('countdownSet.y', getProperty 'countdownSet.y' + 50)
            setProperty('countdownSet.x', getProperty 'countdownSet.x' - 50)
        end,
        [3] = function()
            setObjectCamera('countdownGo', 'game')
            scale = 1.7
            scaleObject('countdownGo', 0.7 * scale, 0.7 * scale)
            screenCenter 'countdownGo'
            setProperty('countdownGo.y', getProperty 'countdownGo.y' + 50)
            timer(0.048, function()
                scaleObject('countdownGo', 1.1 * scale, 1.1 * scale)
                screenCenter 'countdownGo'
                setProperty('countdownGo.y', getProperty 'countdownGo.y' + 50)
                timer(0.048, function()
                    scaleObject('countdownGo', scale, scale)
                    screenCenter 'countdownGo'
                    setProperty('countdownGo.y', getProperty 'countdownGo.y' + 50)
                end)
            end)
        end,
        [4] = function()
            runHaxeCode 'game.moveCameraSection();'
            if hasCredits then
                doTweenX('klajshdfklhasdklfjhasd', 'creditsBox', 0, 0.4, 'backOut')
                timer(3.25, function()
                    doTweenX('klajshdfklhasdklfjhasd', 'creditsBox', -426, 0.4, 'backIn')
                    timer(0.4, function()
                        hasCredits = false
                        removeLuaSprite('creditsTxtBox', true)
                        removeLuaSprite('creditsBox', true)
                    end)
                end)
            end
        end
    }
    if funcs[what] then funcs[what]() end
end
--eztimer reborn!!!!
_timers = {count = 0}
function timer(time, callback)
    local taggy = _timers.count..'_SUPER AWESOIME TIMER'
    runTimer(taggy, time)
    _timers[taggy] = callback
    _timers.count = _timers.count + 1
end
function onTimerCompleted(tag)
    if _timers[tag] then
        _timers[tag]()
        _timers[tag] = nil
    end
end