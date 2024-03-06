require("model2")

function Init()
  
end

function Frame()
    -- for link, for master and slave
	I960_WriteDWord(0x005ec6b0,0x00000000);

	Model2_SetStretchAHigh(0);
	Model2_SetStretchBHigh(0);
	Model2_SetStretchALow(0);
	Model2_SetStretchBLow(0);
	Model2_SetWideScreen(0);
end