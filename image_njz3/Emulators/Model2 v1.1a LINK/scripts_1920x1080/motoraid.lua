require("model2")

function Init()
  
end

function Frame()
    -- for link, for master and slave
    I960_WriteDWord(0x005195d4,0x00000000);
	
    Model2_SetWideScreen(1);
end