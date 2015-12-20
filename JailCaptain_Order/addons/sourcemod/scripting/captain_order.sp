#include <sourcemod>
#include <sdktools>
#include <captain>

#define MAX_ORDER 192

new String:Order_name[65][192];
new String:Order_do[MAX_ORDER][192];

new repeticion;

public Plugin:myinfo =
{
	name = "Captain Order",
	author = "Franc1sco Steam: franug",
	description = "Captain order for jail captain",
	version = "1.0",
	url = "www.uea-clan.com"
};


public OnPluginStart()
{
	LoadTranslations ("captain.phrases");
	RegConsoleCmd("sm_order",DOMenu);

}


public OnMapStart()
{
	Load();
}



Load()
{
	new Handle:kv = CreateKeyValues("captain_order");
	if (!FileToKeyValues(kv,"cfg/sourcemod/captain_order.txt"))
	{
		SetFailState("File cfg/sourcemod/captain_order.txt not found");
	}

	repeticion = 0;


	if(KvGotoFirstSubKey(kv))
	{
		do
		{
			KvGetSectionName(kv, Order_name[repeticion], 192);
			KvGetString(kv, "order", Order_do[repeticion], 192);
			++repeticion;

		} while (KvGotoNextKey(kv));
	}
	KvRewind(kv);
}


public Action:DOMenu(client,args)
{
	if(client == JC_GetCaptain())
		DID(client);
	else
		PrintToChat(client, "\x04[Jail_Captain] \x03%t","You are not the captain!");

	return Plugin_Handled;
}

public Action:DID(clientId) 
{
    new Handle:menu = CreateMenu(DIDMenuHandler);
    SetMenuTitle(menu, "Jail Order");

    decl String:item_numero[4];
    for (new i = 0; i < repeticion; i++)
    {
	Format(item_numero, sizeof(item_numero), "%i", i);
	AddMenuItem(menu, item_numero, Order_name[i]);
    }

    SetMenuExitButton(menu, true);
    DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
    
    
}

public DIDMenuHandler(Handle:menu, MenuAction:action, client, param2) 
{
    if ( action == MenuAction_Select ) 
    {
        	new String:info[11];
		GetMenuItem(menu, param2, info, sizeof(info));
		new valor = StringToInt(info);

		FakeClientCommand(client, "say %s",Order_do[valor]);
		DID(client);
    }
		
    else if (action == MenuAction_Cancel) 
    { 
		PrintToServer("Client %d's menu was cancelled.  Reason: %d", client, param2); 
    } 

    else if (action == MenuAction_End)
    {
		CloseHandle(menu);
    }
}