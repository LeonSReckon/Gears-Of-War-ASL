// Gears Of War AutoSplitter/Load-Remover Version 4.0.0 09/14/2023
// Supports LRT/RTA
// Supports All Difficulties
// Supports SinglePlayer && MultiPlayer!
// Main Script & Pointers <by> ||LeonSReckon||
// Huge Thanks to "TheDementedSalad" && "Gabriel_Dornelles/House_of_Evil" for Help Whenever I had a Question or a Problem

state("Wargame-G4WLive", "1.03")
{
    float FPos    : 0x17A1F60, 0x4CC, 0x8F0, 0x1F0, 0x60, 0xC8, 0x10, 0x128;  // Changes when Player moves but doesn't display number till you pause the game
    float Pos     : 0x17A1F84, 0x0, 0x28, 0x48, 0x0, 0x4C, 0x128;             // Changes when Player moves
    float HP      : 0x17E52DC, 0x14, 0xE0, 0x60, 0x48, 0x10, 0x4C, 0x2A0;     // Player 1 HP
	float RAAM    : 0x179F10C;                                                // In the final level it's 0.5 and turns 0 when you kill RAAM
    byte  Obj     : 0x17A1F84, 0x0, 0x28, 0x48, 0x18, 0x4C, 0x60, 0x520;      // Changes when you finish Objectives, but 70% unreliable
    byte  Gun     : 0x17A1F84, 0x0, 0x28, 0x48, 0x18, 0x28, 0x90, 0x4C;       // Changes when you change the gun
    byte  COG     : 0x17A1F60, 0x4C0, 0x18, 0x8, 0x68, 0x14, 0x2A4;           // Number of COG tags collected
    byte  lvl     : 0x179ED48, 0x4, 0x4, 0x28, 0x3C, 0x1C, 0x2BC;             // Number of the level that's being played
    byte  Load    : 0x114C420, 0xFFC;                                         // 0 on Loads, 1 everywhere else
}

startup
{

    // Options
	settings.Add("Start", true, "When Do You Want To Start");
	settings.CurrentDefaultParent = "Start";
	settings.Add("Immediately", true, "Immediately");
	settings.Add("After Restarting CheckPoint", false, "After Restarting CheckPoint");
	settings.CurrentDefaultParent = null;

    // Splits
	settings.Add("Split Type", true, "Split Type");
	settings.CurrentDefaultParent = "Split Type";
	settings.Add("ACTS Split", true, "ACTS Split");
	settings.Add("Sub-ACTS Split", true, "Sub-ACTS Split");
	settings.Add("All COG Tags", false, "All COG Tags");
	settings.CurrentDefaultParent = null;

    // Tool Tips
	settings.SetToolTip("Start", "Are You Playing Solo Or Coop");
    settings.SetToolTip("Immediately", "Check If You Are Running Singleplayer Category");
    settings.SetToolTip("After Restarting CheckPoint", "Check If You Are Running Multiplayer Category");
    settings.SetToolTip("Split Type", "Where do you want to split");
	settings.SetToolTip("ACTS Split", "Requires 4 Splits for each ACT");
	settings.SetToolTip("Sub-ACTS Split", "Requires 31 Splits for each level in each ACT but doesn't split on ACTS");
	settings.SetToolTip("All COG Tags", "Requires 33 Splits for each Cog Tag Collected");

    // vars
	vars.cutscenes_count  = 0;
	vars.act              = new List<byte>()
	{0,1,2,3,4,5,6,7,9,10,11,12,13,14,15,17,18,19,20,21,23,24,25,26,27,29,30,31,32,33,34,35};
	vars.sact             = new List<byte>()
	{8,16,22,28};

    // actions
    Action reset_vars = () => {
    vars.cutscenes_count = 0;
    };
	
	vars.reset_vars = reset_vars;
	
}

update
{
    if (timer.CurrentPhase == TimerPhase.NotRunning)
    {
	vars.act     = new List<byte>()
	{0,1,2,3,4,5,6,7,9,10,11,12,13,14,15,17,18,19,20,21,23,24,25,26,27,29,30,31,32,33,34,35};
	vars.sact    = new List<byte>()
	{8,16,22,28};
    }
}

start
{
	if(settings ["Immediately"]){
		if(old.Load == 0 && current.Load == 1 && current.Pos != current.FPos){
            return true;
        }
	}
	
	if(settings ["After Restarting CheckPoint"]){
        if(current.lvl == 0 || current.lvl == 8 || current.lvl == 16 || current.lvl == 22 || current.lvl == 28)
        {
        // update cutscenes_count
        if(current.Load == 1 && old.Load == 0) vars.cutscenes_count++;

        // final split
        if(vars.cutscenes_count >= 1 && current.Load == 1) { vars.reset_vars(); return true; }
	    }
    }
}

split
{
	//Final Split in the game always active
	if(current.lvl == 35 && current.RAAM == 0 && old.RAAM > 0 && current.Load == 1){
		return true;
	}

	//ACT 1 Final Split For IL, still in development
	//if(current.lvl == 7 && current.Obj == 0 && old.Obj > 0 && current.Load == 1){
		//return true;
	//}

	if(settings ["All COG TAGS"]){
		if(current.COG > old.COG && current.COG > 0){
		return true;
		}
	}

	if(settings ["ACTS Split"]){
		if(current.lvl > old.lvl && !vars.act.Contains(current.lvl)){
		return true;
		}
	}

	if(settings ["Sub-ACTS Split"]){
    	if(current.lvl > old.lvl && !vars.sact.Contains(current.lvl)){
			{
				vars.sact.Add(current.lvl); 
				return true;
			}
		}
	}
}

isLoading 
{
    return current.Pos == current.FPos && current.lvl != 14 || current.Load == 0 || old.Pos == current.FPos && current.lvl != 14 || current.lvl == 14 && current.Pos == current.FPos && current.Pos > 0;
}

onReset
{
    vars.reset_vars();
}

reset
{
    return current.FPos == 0 && current.Pos == 0 && current.COG == 0 && current.lvl == 0 && current.Load == 1 && current.RAAM == 0 && current.Obj == 0 && current.HP == 0 && current.Gun == 0;
}
