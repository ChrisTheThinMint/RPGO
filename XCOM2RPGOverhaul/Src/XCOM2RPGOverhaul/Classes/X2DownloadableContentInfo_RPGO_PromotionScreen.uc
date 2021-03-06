class X2DownloadableContentInfo_RPGO_PromotionScreen extends X2DownloadableContentInfo;


// Error Messages
var localized string	strNoUnitSelected;
var localized string	strClassNotFound;
var localized string	strIncorrectCharacterTemplate;
var localized string	strIncorrectRankValue;
var localized string	strCantRespecRookie;
var localized string	strInvalidCombatInt;
var localized string	strNoValidUnit;
// Success Messages
var localized string	strRankSet;
var localized string	strClassSet;
var localized string	strComIntSet;
// Note Messages
var localized string	strCappingRank;


// 	0 = eComInt_Standard,
// 	1 = eComInt_AboveAverage,e,
// 	2 = eComInt_Gifted,
// 	3 = eComInt_Genius,
// 	4 = eComInt_Savant,
exec function RPGO_SetCombatIntelligence(int NewComInt)
{
	local XComGameStateHistory				History;
	local UIArmory							Armory;
	local XComGameState_Unit				UnitState;
	local XComGameState						NewGameState;
	local int								OldComInt, Index;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("RPGO_SetCombatIntelligence");

	Armory = GetArmory();
	UnitState = GetSelectedUnit();

	if (UnitState == none || Armory == none)
		return;

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));

	OldComInt = UnitState.ComInt;

	// Retroactively give AP if combat intelligence was improved
	if (OldComInt < NewComInt)
	{
		for (Index = 0; Index < (NewComInt - OldComInt); Index++)
		{
			UnitState.ImproveCombatIntelligence();
		}
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
	
	Armory.PopulateData();
}


// 0 = eNaturalAptitude_Standard,
// 1 = eNaturalAptitude_AboveAverage,
// 2 = eNaturalAptitude_Gifted,
// 3 = eNaturalAptitude_Genius,
// 4 = eNaturalAptitude_Savant,
exec function RPGO_SetNaturalAptitude(int NewNaturalAptitude)
{
	local XComGameStateHistory				History;
	local UIArmory							Armory;
	local XComGameState_Unit				UnitState;
	local XComGameState						NewGameState;
	local int								OldNaturalAptitude, Index;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("RPGO_SetNaturalAptitude");

	Armory = GetArmory();
	UnitState = GetSelectedUnit();

	if (UnitState == none || Armory == none)
		return;

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
	OldNaturalAptitude = int(class'StatUIHelper'.static.GetNaturalAptitude(UnitState));

	// Retroactively give SP if natural aptitude was improved
	if (OldNaturalAptitude < NewNaturalAptitude)
	{
		for (Index = 0; Index < (NewNaturalAptitude - OldNaturalAptitude); Index++)
		{
			class'StatUIHelper'.static.ImproveNaturalAptitude(UnitState);
		}
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
	
	Armory.PopulateData();
}

exec function RPGO_GiveAbiltiyPoints(int AbilityPoints)
{
	local XComGameStateHistory				History;
	local UIArmory							Armory;
	local XComGameState_Unit				UnitState;
	local XComGameState						NewGameState;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("RPGO_GiveAbiltiyPoints");

	Armory = GetArmory();
	UnitState = GetSelectedUnit();

	if (UnitState == none || Armory == none)
		return;

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));

	UnitState.AbilityPoints += AbilityPoints;

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
	
	Armory.PopulateData();
}

exec function RPGO_GiveStatPoints(int StatPoints)
{
	local XComGameStateHistory				History;
	local UIArmory							Armory;
	local XComGameState_Unit				UnitState;
	local XComGameState						NewGameState;
	local int								CurrentSP;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("RPGO_SetNaturalAptitude");

	Armory = GetArmory();
	UnitState = GetSelectedUnit();

	if (UnitState == none || Armory == none)
		return;

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));

	CurrentSP = class'StatUIHelper'.static.GetSoldierSP(UnitState);

	UnitState.SetUnitFloatValue('StatPoints', float(CurrentSP + StatPoints), eCleanUp_Never);

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
	
	Armory.PopulateData();
}

exec function RPGO_AssignSquaddieAbilities(optional name OPTIONAL_Ability1 = '', optional name OPTIONAL_Ability2 = '', optional name OPTIONAL_Ability3 = '', optional name OPTIONAL_Ability4 = '')
{
	local XComGameStateHistory				History;
	local UIArmory							Armory;
	local XComGameState_Unit				UnitState;
	local XComGameState						NewGameState;
	local array<name>						AbilityNames;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("RPGO_AssignSquaddieAbilities");

	Armory = GetArmory();
	UnitState = GetSelectedUnit();

	if (UnitState == none || Armory == none)
		return;

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));

	AbilityNames.AddItem(OPTIONAL_Ability1);
	AbilityNames.AddItem(OPTIONAL_Ability2);
	AbilityNames.AddItem(OPTIONAL_Ability3);
	AbilityNames.AddItem(OPTIONAL_Ability4);

	SetSquaddieAbilites(NewGameState, UnitState, AbilityNames);

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
	
	Armory.PopulateData();
}

private function SetSquaddieAbilites(XComGameState NewGameState, XComGameState_Unit UnitState, array<name> Abilities)
{
	local array<SCATProgression>			SoldierProgressionAbilties;
	local SCATProgression					AbilityProgression;
	local SoldierClassAbilityType			AbilityType;
	local name								Ability;
	local int								i;

	UnitState.AbilityTree[0].Abilities.Length = 0;

	// Reset the squaddie abilities
	SoldierProgressionAbilties = UnitState.m_SoldierProgressionAbilties;
	for (i = SoldierProgressionAbilties.Length - 1; i >= 0; i--)
	{
		`LOG("Rank:" @ SoldierProgressionAbilties[i].iRank @ "Branch:" @ SoldierProgressionAbilties[i].iBranch,, 'RPG');
		`LOG("------------------------------------------------------------------------------------------",, 'RPG');
		if (SoldierProgressionAbilties[i].iRank == 0)
		{
			SoldierProgressionAbilties.Remove(i, 1);
		}
	}

	UnitState.SetSoldierProgression(SoldierProgressionAbilties);

	// Assign the new abilities
	foreach Abilities(Ability)
	{
		if (Ability != '' && ValidateAbility(Ability))
		{
			AbilityType.AbilityName = Ability;
			UnitState.AbilityTree[0].Abilities.Additem(AbilityType);

			AbilityProgression = UnitState.GetSCATProgressionForAbility(Ability);

			`LOG("Buy new squaddie ability" @ Ability @ "Rank:" @ AbilityProgression.iRank @ "Branch:" @ AbilityProgression.iBranch,, 'RPG');

			UnitState.BuySoldierProgressionAbility(NewGameState, AbilityProgression.iRank, AbilityProgression.iBranch);
		}
	}
}


// Refresh a soldier's ability tree and XCOM abilities from the armory screen, with the option to
// change their class and rank. Specifiying a class for a rookie will rank them up to Squaddie.
// Like the Training Center respec, you will lose any XCOM AP spent, but not soldier AP.
exec function RPGO_RebuildSelectedSoldier(
	optional bool OPTIONAL_PreserveSquaddiePerks = true,
	optional bool OPTIONAL_PreserveSpecializations = true,
	optional int OPTIONAL_SetRankTo = 0,
	optional name OPTIONAL_ChangeClassTo = ''
)
{
	local XComGameStateHistory				History;
	local UIArmory							Armory;
	local XComGameState_Unit				UnitState;
	local XComGameState						NewGameState;
	local XComGameState_HeadquartersXCom	XComHQ;
	local X2SoldierClassTemplateManager		ClassTemplateManager;
	local X2SoldierClassTemplate			ClassTemplate;
	local name								ClassName;
	local array<SoldierClassAbilityType>	SquaddieAbilities;
	local SoldierClassAbilityType			SquaddieAbility;
	local array<name>						SquaddieAbilityNames;
	local bool								bChangeClass;
	local int								i, NumRanks, iXP;
	local array<SCATProgression>			SoldierProgressionAbilties;
	local array<XComGameState_Item>			PCSItemStates;
	local array<int>						PreviousSpecs;
	
	History = `XCOMHISTORY;

	Armory = GetArmory();
	UnitState = GetSelectedUnit();

	`LOG(UnitState @ UnitState.ObjectID);

	if (UnitState == none || Armory == none)
		return;
	
	ClassName = UnitState.GetSoldierClassTemplateName();
	ClassTemplateManager = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	if (OPTIONAL_ChangeClassTo != '')
	{
		if (OPTIONAL_ChangeClassTo == 'Random')
		{
			class'Helpers'.static.OutputMsg(Repl(default.strClassSet, "'<ClassName/>'", OPTIONAL_ChangeClassTo));
			ClassName = OPTIONAL_ChangeClassTo;
			bChangeClass = true;
		}
		else
		{
			ClassTemplate = ClassTemplateManager.FindSoldierClassTemplate(OPTIONAL_ChangeClassTo);
			if (ClassTemplate == none)
			{
				class'Helpers'.static.OutputMsg(Repl(default.strClassNotFound, "<ClassName/>", OPTIONAL_ChangeClassTo));
			}
			else if (ClassTemplate.AcceptedCharacterTemplates.Length != 0 && ClassTemplate.AcceptedCharacterTemplates.Find(UnitState.GetSoldierClassTemplateName()) == Index_None)
			{
				class'Helpers'.static.OutputMsg(Repl(default.strIncorrectCharacterTemplate, "<ClassName/>", OPTIONAL_ChangeClassTo));
			}
			else
			{
				class'Helpers'.static.OutputMsg(Repl(default.strClassSet, "<ClassName/>", OPTIONAL_ChangeClassTo));
				ClassName = OPTIONAL_ChangeClassTo;
				bChangeClass = true;
	}	}	}
	
	if (OPTIONAL_SetRankTo < 0)
	{
		class'Helpers'.static.OutputMsg(default.strIncorrectRankValue);
	}

	NumRanks = UnitState.GetRank();
	if (OPTIONAL_SetRankTo > 0)
	{
		NumRanks = OPTIONAL_SetRankTo;
		if (NumRanks > class'X2ExperienceConfig'.static.GetMaxRank())
		{
			class'Helpers'.static.OutputMsg(default.strCappingRank);
			NumRanks = class'X2ExperienceConfig'.static.GetMaxRank();
		}
			
		class'Helpers'.static.OutputMsg(Repl(default.strRankSet, "<RankLevel/>", NumRanks));
	}
	
	// If the UnitState is a rookie and the class is being set, rank them up to 1, otherwise exit (can't respec a rookie)
	if (NumRanks == 0)
	{
		if (bChangeClass)
		{
			NumRanks = 1;
		}
		else
		{
			class'Helpers'.static.OutputMsg(default.strCantRespecRookie);
			return;
		}
	}
	
	iXP = UnitState.GetXPValue();
	iXP -= class'X2ExperienceConfig'.static.GetRequiredXp(NumRanks);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("RPGO Respec Soldier");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
	
	if (ClassName == 'Random' || ClassName == 'Rookie')
	{
		ClassName = XComHQ.SelectNextSoldierClass();
	}

	// Remove and return to inventory any equipped PCS chips
	PCSItemStates = UnitState.GetAllItemsInSlot(eInvSlot_CombatSim);
	for (i = 0; i < PCSItemStates.Length; ++i)
	{
		if (UnitState.RemoveItemFromInventory(PCSItemStates[i], NewGameState)) 
		{
			XComHQ.PutItemInInventory(NewGameState, PCSItemStates[i]);
			class'Helpers'.static.OutputMsg("Removing PCS" @ PCSItemStates[i].GetMyTemplateName());
		}
	}

	UnitState.SetUnitFloatValue('StatPoints', 0, eCleanup_Never);
	UnitState.SetUnitFloatValue('SpentStatPoints', 0, eCleanup_Never);
	
	if (!OPTIONAL_PreserveSquaddiePerks)
	{
		UnitState.SetUnitFloatValue('RPGO_RebuildSelectedSoldierPreserveAbilities', 0, eCleanup_Never);
		UnitState.SetUnitFloatValue('SecondWaveCommandersChoiceAbilityChosen', 0, eCleanup_Never);
		class'Helpers'.static.OutputMsg("Reset Ability Choice");
	}
	else
	{
		UnitState.SetUnitFloatValue('RPGO_RebuildSelectedSoldierPreserveAbilities', 1, eCleanup_Never);
	}

	if (!OPTIONAL_PreserveSpecializations)
	{
		UnitState.SetUnitFloatValue('RPGO_RebuildSelectedSoldierPreserveSpecs', 0, eCleanup_Never);
		UnitState.SetUnitFloatValue('SecondWaveCommandersChoiceSpecChosen', 0, eCleanup_Never);
		UnitState.SetUnitFloatValue('SecondWaveSpecRouletteAddedRandomSpecs', 0, eCleanup_Never);
		UnitState.SetUnitFloatValue('SpecsAssigned', 0, eCleanup_Never);
		class'Helpers'.static.OutputMsg("Reset Specializations Choice");
	}
	else
	{
		UnitState.SetUnitFloatValue('RPGO_RebuildSelectedSoldierPreserveSpecs', 1, eCleanup_Never);
		PreviousSpecs = class'X2SoldierClassTemplatePlugin'.static.GetAssignedSpecializationsIndices(UnitState);
	}

	SquaddieAbilities = UnitState.GetRankAbilities(0);

	UnitState.AbilityPoints = 0; // Reset Ability Points
	UnitState.SpentAbilityPoints = 0; // And reset the spent AP tracker
	UnitState.ResetSoldierRank(); // Clear their rank
	UnitState.ResetSoldierAbilities(); // Clear their current abilities

	for (i = 0; i < NumRanks; ++i) // Rank soldier back up to previous level
	{
		UnitState.RankUpSoldier(NewGameState, ClassName);
	}
	
	// Restore the squaddie abilities
	if (OPTIONAL_PreserveSquaddiePerks)
	{
		foreach SquaddieAbilities(SquaddieAbility)
		{
			SquaddieAbilityNames.AddItem(SquaddieAbility.AbilityName);
		}
		SetSquaddieAbilites(NewGameState, UnitState, SquaddieAbilityNames);
	}
	// Remove squaddie abilites if origins was selected
	else if (`SecondWaveEnabled('RPGOOrigins'))
	{
		UnitState.ResetSoldierAbilities();
		SoldierProgressionAbilties = UnitState.m_SoldierProgressionAbilties;
		for (i = SoldierProgressionAbilties.Length; i >= 0; i--)
		{
			`LOG(GetFuncName() @ "Remove Rank:" @ SoldierProgressionAbilties[i].iRank @ "Branch:" @ SoldierProgressionAbilties[i].iBranch,, 'RPGO-Promotion');
			`LOG(GetFuncName() @ "------------------------------------------------------------------------------------------",, 'RPGO-Promotion');
			if (SoldierProgressionAbilties[i].iRank == 0)
			{
				SoldierProgressionAbilties.Remove(i, 1);
			}
		}
		UnitState.SetSoldierProgression(SoldierProgressionAbilties);
	}

	UnitState.ApplySquaddieLoadout(NewGameState, XComHQ);

	// Reapply Stat Modifiers (Beta Strike HP, etc.)
	UnitState.bEverAppliedFirstTimeStatModifiers = false;
	if (UnitState.GetMyTemplate().OnStatAssignmentCompleteFn != none)
	{
		UnitState.GetMyTemplate().OnStatAssignmentCompleteFn(UnitState);
	}
	UnitState.ApplyFirstTimeStatModifiers();

	// Restore any partial XP the soldier had
	if (iXP > 0)
	{
		UnitState.AddXp(iXP);
	}

	// Skip AWC for classes that are excluded (the RollForTrainingCenterAbilities function does no such checks internally)
	if (class'CHHelpers'.default.ClassesExcludedFromAWCRoll.Find(ClassName) == Index_None || !UnitState.GetSoldierClassTemplate().bAllowAWCAbilities)
	{
		UnitState.bRolledForAWCAbility = false;
		UnitState.RollForTrainingCenterAbilities(); // Reroll XCOM abilities
	}

	if (OPTIONAL_PreserveSpecializations)
	{
		class'X2SecondWaveConfigOptions'.static.BuildSpecAbilityTree(UnitState, PreviousSpecs, true, `SecondWaveEnabled('RPGOTrainingRoulette'));
		`XEVENTMGR.TriggerEvent('RPGOSpecializationsAssigned', UnitState, UnitState, NewGameState);
	}

	`XEVENTMGR.TriggerEvent('CompleteRespecSoldier', none, UnitState, NewGameState);
	`XEVENTMGR.TriggerEvent('PromotionEvent', UnitState, UnitState, NewGameState);

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}

	Armory.PopulateData();
	UpdatePromotionScreen();
}

private function UIArmory GetArmory()
{
	local UIArmory Armory;

	Armory = UIArmory(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory'));

	if (Armory == none)
	{
		class'Helpers'.static.OutputMsg(default.strNoUnitSelected);
	}

	return Armory;
}

private function UpdatePromotionScreen()
{
	local UIArmory_PromotionHero Promotion;

	Promotion = UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory_PromotionHero'));

	if (Promotion != none)
	{
		Promotion.CycleToSoldier(Promotion.GetUnit().GetReference());
	}
}


private function XComGameState_Unit GetSelectedUnit()
{
	local XComGameStateHistory				History;
	local UIArmory							Armory;
	local XComGameState_Unit				UnitState;
	local StateObjectReference				UnitRef;

	History = `XCOMHISTORY;

	Armory = UIArmory(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory'));
	if (Armory == none)
	{
		class'Helpers'.static.OutputMsg(default.strNoUnitSelected);
		return none;
	}

	UnitRef = Armory.GetUnitRef();
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

	if (UnitState == none)
	{
		class'Helpers'.static.OutputMsg(default.strNoUnitSelected);
	}

	return UnitState;
}

private function bool ValidateAbility(name AbilityName)
{
	local X2AbilityTemplateManager		TemplateManager;
	local X2AbilityTemplate				Template;

	TemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = TemplateManager.FindAbilityTemplate(AbilityName);

	return (Template != none);
}


exec function PSSetXoffsetBG(int AdjustXOffset)
{
	local RPGO_UIArmory_PromotionHero UI;
	
	UI = RPGO_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'RPGO_UIArmory_PromotionHero'));
	UI.MC.ChildSetNum("bg", "_x", AdjustXOffset);
}

exec function PSSetWidth(int Width)
{
	local RPGO_UIArmory_PromotionHero UI;
	
	UI = RPGO_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'RPGO_UIArmory_PromotionHero'));
	UI.MC.SetNum("_width", Width);
}

exec function PSSetXOffset(int AdjustXOffset)
{
	local RPGO_UIArmory_PromotionHero UI;
	
	UI = RPGO_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'RPGO_UIArmory_PromotionHero'));
	UI.MC.SetNum("_x", UI.MC.GetNum("_x") + AdjustXOffset);
}

exec function PSSetColumnWidth(int Offset = 200, int Width = 120)
{
	local RPGO_UIArmory_PromotionHero UI;
	local int i;

	UI = RPGO_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'RPGO_UIArmory_PromotionHero'));
	for (i = 0; i < UI.Columns.Length; i++)
	{
		if (i == 5 || i ==6)
			UI.Columns[i].MC.SetNum("_width", Width);
		//UI.Columns[i].SetX(Offset + (i * Width));
		
	}
}

exec function PSScrollBarSetPos(int X, int Y, int Anchor = -1)
{
	local RPGO_UIArmory_PromotionHero UI;
	UI = RPGO_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'RPGO_UIArmory_PromotionHero'));

	UI.Scrollbar.SetX(X);
	UI.Scrollbar.SetY(Y);

	if (Anchor > -1)
	{
		UI.Scrollbar.SetAnchor(Anchor);
	}
}

exec function PSScrollBarSetSize(int Width = 0, int Height = 0)
{
	local RPGO_UIArmory_PromotionHero UI;
	UI = RPGO_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'RPGO_UIArmory_PromotionHero'));

	if (Width > 0)
	{
		UI.Scrollbar.SetWidth(Width);
	}

	if (Height > 0)
	{
		UI.Scrollbar.SetHeight(Height);
	}
}