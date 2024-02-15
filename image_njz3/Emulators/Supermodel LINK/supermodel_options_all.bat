:: 1920x1080 16/9 widescreen
set VIDEO_OPTIONS=-res=1920,1080 -wide-bg -wide-screen -fullscreen

:: 640x480 4/3
::set VIDEO_OPTIONS=-res=640,480 -fullscreen

:: 1024x768 4/3
::set VIDEO_OPTIONS=-res=1024,768 -fullscreen

:: 1280x960 4/3
::set VIDEO_OPTIONS=-res=1280,960 -fullscreen

:: 1280x240 superwide 4x in 4/3
::set VIDEO_OPTIONS=-res=1280,240 -stretch -fullscreen

:: 1280x480 superwide 2x in 4/3
::set VIDEO_OPTIONS=-res=1280,480 -stretch -fullscreen

:: 1024x384p superwide 2x in 4/3
::set VIDEO_OPTIONS=-res=1024,384 -stretch -fullscreen

:: Add this for native ffb form supermodel: -force-feedback 
set SUPERMODEL_OPTIONS=%VIDEO_OPTIONS% -ppc-frequency=100 -no-throttle -show-fps -input-system=dinput -force-feedback -outputs=win


