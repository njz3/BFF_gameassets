:: Define video options according to current monitor
CALL supermodel_video_options.bat

:: Add this for native ffb form supermodel: -force-feedback 
set SUPERMODEL_OPTIONS=%VIDEO_OPTIONS% -no-throttle -show-fps -input-system=dinput -force-feedback -outputs=win


