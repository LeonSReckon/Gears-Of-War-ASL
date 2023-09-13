// Gears Of War AutoSplitter/Load-Remover Version 3.0.0 09/14/2023
// Supports LRT/RTA
// Supports All Difficulties
// Supports SinglePlayer && MultiPlayer!
// Main Script & Pointers <by> ||LeonSReckon||
// Huge Thanks to "TheDementedSalad" && "Gabriel_Dornelles/House_of_Evil" for Help Whenever I had a Question or a Problem

state("Wargame-G4WLive", "1.03")
{
    float FPos    : 0x17A1F60, 0x4CC, 0x8F0, 0x1F0, 0x60, 0xC8, 0x10, 0x128;
    float Pos     : 0x17A1F84, 0x0, 0x28, 0x48, 0x0, 0x4C, 0x128;
	float RAAM    : 0x179F10C;
    byte  Po      : 0x17A1F84, 0x0, 0x28, 0x48, 0x0, 0x4C, 0x128;
    byte  COG     : 0x17A1F60, 0x4C0, 0x18, 0x8, 0x68, 0x14, 0x2A4;
    byte  lvl     : 0x179ED48, 0x4, 0x4, 0x28, 0x3C, 0x1C, 0x2BC;
    byte  Load    : 0x114C420, 0xFFC;
}

startup
{

    // Options
	settings.Add("Start", true, "When Do You Want To Start");
	settings.CurrentDefaultParent = "Start";
	settings.Add("Immediately", true, "Immediately");
	settings.Add("After Restarting CheckPoint", false, "After Restarting CheckPoint");
	settings.CurrentDefaultParent = null;

    // ACTs Splits
	settings.Add("ACTS", true, "ACTS");
	settings.CurrentDefaultParent = "ACTS";
	settings.Add("ACT 1", true, "ACT 1: Ashes");
	settings.Add("ACT 2", true, "ACT 2: NightFall");
	settings.Add("ACT 3", true, "ACT 3: Belly Of The Beast");
	settings.Add("ACT 4", true, "ACT 4: The Long Road Home");
	settings.Add("ACT 5", true, "ACT 5: Desperation");
	settings.CurrentDefaultParent = null;

	settings.CurrentDefaultParent = "ACT 1";
	settings.Add("0", false, "14 Years After E-Day");
	settings.Add("1", false, "Trial By Fire");
	settings.Add("2", false, "Fish In A Barrel");
	settings.Add("3", false, "Fork In The Road");
	settings.Add("4", false, "Knock Knock");
	settings.Add("5", false, "Hammer");
	settings.Add("6", false, "Wrath");
	settings.Add("7", false, "China Chop");
	settings.CurrentDefaultParent = null;

	settings.CurrentDefaultParent = "ACT 2";
	settings.Add("8", false, "Tick Tick Boom");
	settings.Add("9", false, "Grist");
	settings.Add("10", false, "Outpost");
	settings.Add("11", false, "Lethal Dusk");
	settings.Add("12", false, "Dark Labyrinth");
	settings.Add("13", false, "Powder Keg");
	settings.Add("14", false, "Burnt Rubber");
	settings.Add("15", false, "Last Stand");
	settings.CurrentDefaultParent = null;

	settings.CurrentDefaultParent = "ACT 3";
	settings.Add("16", false, "DownPour");
	settings.Add("17", false, "Evolution");
	settings.Add("18", false, "Coalition Cargo");
	settings.Add("19", false, "Darkest Before Dawn");
	settings.Add("20", false, "Angry Titan");
	settings.Add("21", false, "Tip Of The Iceberg");
	settings.CurrentDefaultParent = null;

	settings.CurrentDefaultParent = "ACT 4";
	settings.Add("22", false, "Campus Grinder");
	settings.Add("23", false, "Bad To Worse");
	settings.Add("24", false, "Hazing");
	settings.Add("25", false, "Close To Home");
	settings.Add("26", false, "Imaginary Place");
	settings.Add("27", false, "Ethrenched");
	settings.CurrentDefaultParent = null;

	settings.CurrentDefaultParent = "ACT 5";
	settings.Add("28", false, "Impasse");
	settings.Add("29", false, "Comedy Of Errors");
	settings.Add("30", false, "Window Shopping");
	settings.Add("31", false, "Powers That Be");
	settings.Add("32", false, "Jurassic Proportions");
	settings.Add("33", false, "Special Delivery");
	settings.Add("34", false, "Train Wreck");
	settings.Add("35", false, "Pale Horse");
	settings.CurrentDefaultParent = null;

    // Collectibles Splits
	settings.Add("All COG Tags", false, "All COG Tags");

    // Tool Tips
	settings.SetToolTip("Start", "Are You Playing Solo Or Coop");
    settings.SetToolTip("Immediately", "Check If You Are Running Singleplayer Category");
    settings.SetToolTip("After Restarting CheckPoint", "Check If You Are Running Multiplayer Category");
    settings.SetToolTip("All COG Tags", "Check If You Want To Run All Cog Tags Category");

    // vars
	vars.completedSplits = new List<string>();

}

update
{
    if (timer.CurrentPhase == TimerPhase.NotRunning)
    {
		vars.completedSplits.Clear();
		vars.totalGameTime = 0;
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
	    if(current.lvl == 0 && current.Pos > 0 && old.Pos < 0 || current.lvl == 8 && current.Pos > 1000 && old.Pos < 1000 || current.lvl == 16 && current.Pos > 0 && old.Pos < 0 && old.Load == 0 || current.lvl == 22 && current.Pos > 20000 && old.Pos < 20000 && old.Pos > 0 || current.lvl == 28 && current.Po == 12 && old.Po == 130){
            return true;
        }
	}
}

split
{
	if(current.lvl == 35 && current.RAAM == 0 && old.RAAM > 0 && current.Load == 1){
		return true;
		}

	if(settings ["All COG TAGS"]){
	if(current.COG > old.COG && current.COG > 0){
		return true;
		}
	}
	
	if(settings ["ACT 1"] || settings ["ACT 2"] || settings ["ACT 3"] || settings ["ACT 4"] || settings ["ACT 5"]){
		vars.hashString = current.lvl.ToString();

    if(current.lvl > old.lvl){
			if (settings[vars.hashString] && !vars.completedSplits.Contains(vars.hashString))
			{
				vars.completedSplits.Add(vars.hashString);
				return true;
			}
		}
    }
}

isLoading 
{
    return current.Pos == current.FPos && current.lvl != 14 || current.Load == 0 || old.Pos == current.FPos && current.lvl != 14 || current.lvl == 14 && current.Pos == current.FPos && current.Pos > 0;
}

//reset
//{
//    return current.Load == 0 && current.lvl == 0 && current.FPos == current.Pos && current.Pos == 0;
//}
