require("model2")

function Init()
  
end

function Frame()
    -- for link, for master and slave
	I960_WriteDWord(0x005ec6b0,0x00000000);

	Model2_SetStretchAHigh(1);
	Model2_SetStretchBHigh(1);
	Model2_SetStretchALow(1);
	Model2_SetStretchBLow(1);
	Model2_SetWideScreen(0);
end