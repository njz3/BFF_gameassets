require("model2")

function Init()
  
end

function Frame()
  Model2_SetWideScreen(1);
  Model2_SetStretchALow(1)	-- Stretch the bg tilemap (sky & clouds) when widescreen
  Model2_SetStretchBLow(1)	-- Stretch the bg tilemap (sky & clouds) when widescreen
  Model2_SetStretchAHigh(1)	-- Stretch the bg tilemap (sky & clouds) when widescreen
  Model2_SetStretchBHigh(1)	-- Stretch the bg tilemap (sky & clouds) when widescreen
end