/*
Grapple Dog (Released February 10, 2022)
ASL originally by Slask with major overhauals by CptBrian, v3 fix for Load Removal by Snuggles
Manifests (game updates) found from: https://steamdb.info/depot/1345861/manifests/ — AppID: 1345860 — DepotID: 1345861
v1.0.1 ManifestID: 7438861920071386857
v1.1.0 ManifestID: 8881523117921629362
Pointers utilizing "Grapple Dog.exe" in the base address don't need to specify that module below, because LiveSplit uses that module by default when one isn't specified
*/

state("Grapple Dog", "Unknown, Trying Latest"){ //Copy of addresses from whichever the most common or latest version is (Steam 1.1.0)
		int Continue : 0x43DE48, 0xC90, 0xC, 0x24, 0x10, 0x204, 0x4;
		int RexCannon : 0x43DE48, 0xAD0, 0xC, 0x24, 0x10, 0x594, 0x4;
	double Health : 0x6FCF38, 0x30, 0xA50, 0xD0;
	double Control : 0x6FCF38, 0x30, 0xA50, 0xA0;
	double Stage : 0x6FCF38, 0x30, 0x24, 0x170;
	byte Transition : 0x4DCCEC, 0x0, 0xB30, 0xC, 0x40;
	byte LoadFreeze : 0x4DCCEC, 0x0, 0x51C, 0xC, 0x40;
	byte Bell : 0x4DCCEC, 0x0, 0x9D0, 0xC, 0x40;
}
state("Grapple Dog", "Steam 1.0.1"){ //Process Name
	int Continue : 0x43DE48, 0xC90, 0xC, 0x24, 0x10, 0x204, 0x4; //The continue button appearing on result screens
	int RexCannon : 0x43DE48, 0xAD0, 0xC, 0x24, 0x10, 0x594, 0x4; //if this one isn't stable, change it to 0x6EF220, 0x128, 0xEC4, 0x20, 0x24, 0x10, 0x594, 0x4;
	double Health : 0x6FCF38, 0x30, 0x84, 0xD0; //Potentially useful in some circumstances
	double Control : 0x6FCF38, 0x30, 0x84, 0xA0; //IL Start timing won't work when restarting stage (must exit), but apparently a better address doesn't exist >:(
	double Stage : 0x6FCF38, 0x30, 0x150, 0x1A0; //ID doesn't change when exiting a level to the overworld
	byte Transition : 0x4DCCEC, 0x0, 0xAF0, 0xC, 0x40; //White screen transitions/loads
	byte LoadFreeze : 0x4DCCEC, 0x0, 0x4DC, 0xC, 0x40; //Likely true loads, when loads/transitions freeze
	byte Bell : 0x4DCCEC, 0x0, 0x990, 0xC, 0x40; //Bell Rings (counts up with each hit, resets at results)
}
state("Grapple Dog", "Steam 1.1.0"){
		int Continue : 0x43DE48, 0xC90, 0xC, 0x24, 0x10, 0x204, 0x4; //Broken. Should have same base address and similar offsets
		int RexCannon : 0x43DE48, 0xAD0, 0xC, 0x24, 0x10, 0x594, 0x4; //Broken. Should have same base address and similar offsets
	double Health : 0x6FCF38, 0x30, 0xA50, 0xD0;
	double Control : 0x6FCF38, 0x30, 0xA50, 0xA0;
	double Stage : 0x6FCF38, 0x30, 0x24, 0x170;
	byte Transition : 0x4DCCEC, 0x0, 0xB30, 0xC, 0x40;
	byte LoadFreeze : 0x4DCCEC, 0x0, 0x51C, 0xC, 0x40;
	byte Bell : 0x4DCCEC, 0x0, 0x9D0, 0xC, 0x40;
}

startup{
	vars.ASLVersion = "ASL Version 2.3 — March 9, 2022";
	vars.StartOptions = "Auto-Start Options";
	vars.SplitOptions = "Auto-Split Options";
	vars.LoadRemoval = "Load Removal v3 (compare against GAME time to see)";
	vars.LoadTester = "Test Loading durations (auto-negates other settings)";
	
	settings.Add(vars.ASLVersion, false);
	settings.Add("ILMode", false, "IL Mode (auto-negates other settings)");
		settings.Add("ControlInfo", false, "Must Exit between attempts for now (annoying)", "ILMode");
	settings.Add(vars.StartOptions, true, vars.StartOptions);
		settings.Add("TransitionStart", true, "Start upon any initiated transitions (Play Stage)", vars.StartOptions);
	settings.Add(vars.SplitOptions, true, vars.SplitOptions);
		settings.Add("ContinueSplit", true, "Split when Continue appears in results", vars.SplitOptions);
		settings.Add("BellSplit", false, "Split upon hitting bells", vars.SplitOptions);
		settings.Add("NewStageSplit", false, "Split upon entering a different stage (not 1-1)", vars.SplitOptions);
		settings.Add("RexCannonSplit", false, "Split upon landing in the red cannon before REX boss", vars.SplitOptions);
	settings.Add(vars.LoadRemoval, true);
	settings.Add(vars.LoadTester, false);
}

init{
	byte[] exeMD5HashBytes = new byte[0];
	using (var md5 = System.Security.Cryptography.MD5.Create()){
		using (var s = File.Open(modules.First().FileName.Substring(0, modules.First().FileName.Length-15) //Removes 15 characters of "Grapple Dog.exe" from the game's file path ending to change which file is checked, entered next:
		+ "data.win", FileMode.Open, FileAccess.Read, FileShare.ReadWrite)){
			exeMD5HashBytes = md5.ComputeHash(s);
		}
	}
	var MD5Hash = exeMD5HashBytes.Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
	print("Game's MD5Hash: " + MD5Hash.ToString()); //Lets DebugView show me the MD5Hash of the game's data.win file, because the executable isn't reliable for version identification

	if(MD5Hash == "90EA2CAF7DEFFF1E16940FCF4470C725") version = "Steam 1.0.1";
	else if(MD5Hash == "2A4B93B92F9CCFF20D39ADEF13C3A78C") version = "Steam 1.1.0";
	else version = "Unknown, Trying Latest";
}

update{

}

isLoading{ //Make sure to compare against GAME time in LiveSplit, or this won't work!
	if(settings[vars.LoadRemoval] && current.LoadFreeze == 1 && current.Transition == 1 && !settings[vars.LoadTester]){
		return true; //Pause timer when loading freezes, only during transitions (LoadFreeze sometimes triggers mid-level otherwise)
	}
	else if(settings[vars.LoadTester] && current.LoadFreeze == 0){
		return true; //Pause timer when NOT loading, to test the duration of loads
	}
	else{
		return false;
	}
}

start{
	if(settings["TransitionStart"] && old.Transition == 0 && current.Transition == 1 && !settings[vars.LoadTester] && !settings["ILMode"]){
		return true; //Start timer upon any initiated transitions (Play Stage)
	}
	else if(settings["ILMode"] && old.Control == 0 && current.Control == 1 && !settings[vars.LoadTester]){
		return true; //Start timer upon gaining control (currently global control instead of specifically player control, which doesn't appear to exist...)
	}
	else if(settings[vars.LoadTester] && old.LoadFreeze == 0 && current.LoadFreeze == 1 && current.Transition == 1){
		return true; //Start timer upon load freezes during transitions to test load durations
	}
	else{
		return false;
	}
}

split{

	if ((settings["RexCannonSplit"] || settings["ILMode"]) && old.RexCannon == 0x0 && current.RexCannon == 0x3FF00000 && !settings[vars.LoadTester]){
		return true; //Split upon entering the red cannon before REX boss (the exact frame the cannon becomes bigger, immediately upon entering)
	}
	else if(settings["ContinueSplit"] && old.Continue != 0x3FF00000 && current.Continue == 0x3FF00000 && !settings[vars.LoadTester] && !settings["ILMode"]){
		return true; //Split every time Continue appears (the exact frame)
	}
	else if((settings["BellSplit"] || settings["ILMode"]) && old.Bell == 0 && current.Bell > 0 && current.Bell < 5 && !settings[vars.LoadTester]){
		return true; //Split upon hitting a bell (fail-safe included for multiple hits potentially at the same time)
	}
	else if(settings["NewStageSplit"] && old.Stage != current.Stage && current.Stage > 1 && !settings[vars.LoadTester] && !settings["ILMode"]){
		return true; //Split upon entering a different stage (excluding 1-1)
	}
	else{
		return false;
	}
}

reset{
	if (settings["ILMode"] && old.Transition == 0 && current.Transition == 1 && !settings[vars.LoadTester]){
		return true; //Resets timer upon any transition when IL Mode is active
	}
	else{
		return false;
	}
}
