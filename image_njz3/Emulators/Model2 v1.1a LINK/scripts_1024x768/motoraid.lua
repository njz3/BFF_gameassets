require("model2")

function Init()
  
end

function Frame()
    -- for link, for master and slave
    I960_WriteDWord(0x005195d4,0x00000000);

    Model2_SetWideScreen(0);
    Model2_SetStretchALow(0)	-- Stretch the bg tilemap (sky & clouds) when widescreen
    Model2_SetStretchBLow(0)	-- Stretch the bg tilemap (sky & clouds) when widescreen
    Model2_SetStretchAHigh(0)	-- Stretch the bg tilemap (sky & clouds) when widescreen
    Model2_SetStretchBHigh(0)	-- Stretch the bg tilemap (sky & clouds) when widescreen
end