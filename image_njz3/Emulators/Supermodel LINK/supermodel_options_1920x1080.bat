:: 1920x1080 16/9 widescreen
set VIDEO_OPTIONS=-res=1920,1080 -wide-bg -wide-screen -fullscreen

:: Add this for native ffb form supermodel: -force-feedback 
set SUPERMODEL_OPTIONS=%VIDEO_OPTIONS% -ppc-frequency=100 -no-throttle -show-fps -input-system=dinput -force-feedback -outputs=win


