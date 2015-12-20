#include <sourcemod>
#include <sdktools>
#include <captain>


new g_BeamSprite;
new g_HaloSprite;


public OnMapStart()
{
	g_BeamSprite = PrecacheModel("materials/sprites/laser.vmt");
	g_HaloSprite = PrecacheModel("materials/sprites/halo01.vmt");

	CreateTimer(0.1, Temporizador, _,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action:Temporizador(Handle:timer)
{
	new captain = JC_GetCaptain();

	for (new i = 1; i <= MaxClients; i++)
		if(i == captain)
			SetupBeacon(i);
}

SetupBeacon(client)
{
	new Float:vec[3];
	GetClientAbsOrigin(client, vec);
	vec[2] += 10;
	TE_SetupBeamRingPoint(vec, 50.0, 60.0, g_BeamSprite, g_HaloSprite, 0, 15, 0.1, 10.0, 0.0, {255, 150, 0, 255}, 10, 0);
	TE_SendToAll();
}