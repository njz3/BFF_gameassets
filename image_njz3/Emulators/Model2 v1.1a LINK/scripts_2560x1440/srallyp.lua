require("model2")

function Init()
    --only for slave machines !
	--Patch_DisableMaster();
end

function Patch_DisableMaster()
	Romset_PatchDWord(0, 0x0000C7A4, 0x5CA81E00); -- mov g5,0x00
end

function Frame()
  Model2_SetWideScreen(1);
end