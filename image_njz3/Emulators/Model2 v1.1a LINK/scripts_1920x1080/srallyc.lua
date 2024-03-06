require("model2")

function Init()
    --only for slave machines !
	--Patch_DisableMaster();
end

function Patch_DisableMaster()
	Romset_PatchDWord(0, 0x0000C7A4, 0x5CA81E00); -- mov g5,0x00
end

function Frame()
	local state = I960_ReadByte(0x202098);
	local state2 = I960_ReadByte(0x20209C);
	local state3 = I960_ReadByte(0x2020AC);

	if state==3 and state2==5 and state3==1 then	
		Model2_SetWideScreen(0)
	else
		Model2_SetWideScreen(1)
	end

end
