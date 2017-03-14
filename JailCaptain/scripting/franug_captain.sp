/*  SM Franug Captain
 *
 *  Copyright (C) 2017 Francisco 'Franc1sco' García
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#include <sourcemod>
#include <sdktools>
#include <basecomm>

#undef REQUIRE_PLUGIN
#include <voiceannounce_ex>
#define REQUIRE_PLUGIN

#pragma semicolon 1


#define DATA "4.4"


new commander;


public Plugin:myinfo =
{
	name = "SM Franug Captain",
	author = "Franc1sco Steam: franug",
	description = "Be a captain for jail",
	version = DATA,
	url = "http://steamcommunity.com/id/franug"
};

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
    CreateNative("JC_GetCaptain", Native_Obtener);
    
    return APLRes_Success;
}

public Native_Obtener(Handle:plugin, argc)
{    
    	return commander;
}

public OnPluginStart()
{

	LoadTranslations ("captain.phrases");

	CreateConVar("sm_FranugCaptain_version", DATA, "version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

	RegAdminCmd("sm_removecaptain", command_removecaptain, ADMFLAG_GENERIC);
        RegConsoleCmd("sm_captain", Co);
        RegConsoleCmd("sm_c", Co);
        RegConsoleCmd("sm_nocaptain", unCo);
        RegConsoleCmd("sm_noc", unCo);

	HookEvent("round_start", roundStart);
	HookEvent("player_death", playerDeath);
	HookEvent("player_disconnect", playerDisconnect);


}

#if defined _voiceannounceex_included_
public bool:OnClientSpeakingEx(client)
{
	if(!IsValidClient(commander) && !BaseComm_IsClientMuted(client) && GetClientTeam(client) == 3 && IsPlayerAlive(client))
	{
		commander = client;
		NombradoC(client);
	}

	else if(commander == client)
	{
		decl String:nombre[32];
		GetClientName(client, nombre, sizeof(nombre));
		PrintHintTextToAll("%t", "voice chat", nombre);
	}
		
}
#endif

public Action:command_removecaptain(client, args)
{
	if(IsValidClient(commander))
	{
		PrintToChatAll("\x04[Jail_Captain] \x03%t", "Captain has been removed by an administrator. You can now choose a new one");
		commander = -1;
		return Plugin_Handled;
	}

	PrintToChat(client, "\x04[Jail_Captain] \x03%t", "Captain still not exist!");

	return Plugin_Handled;
}

public Action:Co(client,args)
{
	if(!client)
		return Plugin_Handled;

	if(!IsValidClient(commander))
	{
		if(IsValidClient(client) && GetClientTeam(client) == 3 && IsPlayerAlive(client))
		{
           		NombradoC(client);
           		//SetEntityRenderColor(client, 255, 150, 0, 255);
           		commander = client;
       		}
		else
		{
			PrintToChat(client, "\x04[Jail_Captain] \x03%t", "You must be alive or be a CT for be a captain!");
		}
	}
	else
	{
		PrintToChat(client, "\x04[Jail_Captain] \x03%t", "Captain already exist!");
	}

	return Plugin_Handled;
}

public Action:unCo(client,args)
{
    if(commander == client)
    {
           DesNombradoC(client);
           //SetEntityRenderColor(client, 255, 255, 255, 255);
           commander = -1;
    }
    else
    {
       PrintToChat(client, "\x04[Jail_Captain] \x03%t", "You are not the captain!");
    }
}

public Action:roundStart(Handle:event, const String:name[], bool:dontBroadcast) 
{
	commander = -1;
}



public Action:playerDisconnect(Handle:event, const String:name[], bool:dontBroadcast) 
{
        new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(client == commander)
        {
	   DesNombradoC(client);
	   commander = -1;
        }
}

public Action:playerDeath(Handle:event, const String:name[], bool:dontBroadcast) 
{
        new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(client == commander)
        {
	   DesNombradoC(client);
	   commander = -1;
        }
}

NombradoC(any:client)
{
	CreateTimer(0.1, MensajeC, client);
	CreateTimer(0.5, MensajeC, client);
	//CreateTimer(0.5, MensajeC, client);
	//CreateTimer(0.7, MensajeC, client);
	//CreateTimer(0.9, MensajeC, client);
	//CreateTimer(1.1, MensajeC, client);
	//CreateTimer(1.3, MensajeC, client);
	//CreateTimer(1.5, MensajeC, client);
	//CreateTimer(1.7, MensajeC, client);
	//CreateTimer(2.0, MensajeC, client);


}

DesNombradoC(client)
{
	decl String:nombre[32];
	GetClientName(client, nombre, sizeof(nombre));
	PrintToChatAll("\x04[Jail_Captain] \x03%t", "no longer", nombre);
}

public Action:MensajeC(Handle:timer, any:client)
{
	if(client == commander)
        {
		decl String:nombre[32];
		GetClientName(client, nombre, sizeof(nombre));
		PrintToChatAll("\x04[Jail_Captain] \x03%t", "obey", nombre);
        }
}






public IsValidClient( client ) 
{ 
    if ( !( 1 <= client <= MaxClients ) || !IsClientInGame(client) ) 
        return false; 
     
    return true; 
}