#include <sourcemod>
#include <sdktools>
#include <captain>

new String:mensajeCapi[512];

new bool:Norma;

new Handle:cvar_orden = INVALID_HANDLE;

public Plugin:myinfo =
{
	name = "Captain Messages",
	author = "Franc1sco Steam: franug",
	description = "Captain messages for jail captain",
	version = "1.0",
	url = "www.uea-clan.com"
};

public OnPluginStart()
{
	LoadTranslations ("captain.phrases");

	RegConsoleCmd("say",HookSay);

	HookEvent("round_start", roundStart);

	cvar_orden = CreateConVar("sm_captain_order", "1", "Enable/disable show last order of captain");
}


public OnMapStart()
{
	PrecacheSound("buttons/button18.wav");
	CreateTimer(1.0, Temporizador, _,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action:Temporizador(Handle:timer)
{
	if(!GetConVarBool(cvar_orden) || !Norma)
		return;

	decl String:NormaD[512];
	for (new i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && IsPlayerAlive(i))
		{
			Format(NormaD, sizeof(NormaD), "%T", "last order", i, mensajeCapi);

			// Send our message
			new Handle:hBuffer = StartMessageOne("KeyHintText", i); 
			BfWriteByte(hBuffer, 1); 
			BfWriteString(hBuffer, NormaD); 
			EndMessage();
		}
	}
}

public Action:roundStart(Handle:event, const String:name[], bool:dontBroadcast) 
{
	Norma = false;
}


public Action:HookSay(id,args)
{
      if(id == JC_GetCaptain())
      {
	decl String:SayText[512];
	GetCmdArgString(SayText,sizeof(SayText));
	
	StripQuotes(SayText);
	
	if(SayText[0] == '@' || SayText[0] == '/' || SayText[0] == '!' || !SayText[0])
		return Plugin_Continue;
	
	

        PrintCenterTextAll("%t", "Captain say", SayText);

    	new String:este[512];
    	Format(este, 512, "%c", SayText[0]);

	new bool:may = false;

        if (IsCharAlpha(SayText[0]))
        {
		if(IsCharUpper(SayText[0]))
		{
           		Format(este, sizeof(este), "\x07ff0011%c", SayText[0]);
			may = true;
		}
        	else
		{
            		Format(este, sizeof(este), "%c", SayText[0]);
		}
        }
        else
	{
            	Format(este, sizeof(este), "%c", SayText[0]);
	}


    	for (new i=1; i < strlen(SayText); i++)
    	{    
        	if (IsCharAlpha(SayText[i]))
        	{
			if(IsCharUpper(SayText[i]))
			{
				if(may)
           	 			Format(este, sizeof(este), "%s%c", este,SayText[i]);
				else
				{
           	 			Format(este, sizeof(este), "%s\x07ff0011%c", este,SayText[i]);
					may = true;
				}
			}
        		else
			{
				if(may)
				{
           	 			Format(este, sizeof(este), "%s\x07ff00cc%c", este,SayText[i]);
					may = false;
				}
				else
				{
           	 			Format(este, sizeof(este), "%s%c", este,SayText[i]);
				}
			}
		}
		else
			Format(este, sizeof(este), "%s%c", este,SayText[i]);


        	//PrintToChatAll("letter %i: %c", i,SayText[i]);
    	}

	strcopy(SayText, 512, este);

    	//PrintToChatAll("Full msg: %s", SayText); 

	
	PrintToChatAll("\x0700ffdd(CAPTAIN) \x070000ff%N:\x07ff00cc %s",id,SayText);


        EmitSoundToAll("buttons/button18.wav");

	GetCmdArgString(mensajeCapi,sizeof(mensajeCapi));
	StripQuotes(mensajeCapi);
	Norma = true;
	
	return Plugin_Handled;
      }
      return Plugin_Continue;
}