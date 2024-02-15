:: 1024x384p superwide 2x in 4/3
set VIDEO_OPTIONS=-res=1024,384 -stretch -fullscreen

:: Add this for native ffb form supermodel: -force-feedback 
set SUPERMODEL_OPTIONS=%VIDEO_OPTIONS% -ppc-frequency=100 -no-throttle -show-fps -input-system=dinput -force-feedback -outputs=win


