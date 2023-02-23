#pragma semicolon 1

#include <KnockbackRestrict>

#define PLUGIN_NAME "KbRestrict_Discord"

#include <relay_helper>

#tryinclude <sourcebanschecker>
#tryinclude <sourcecomms>

#pragma newdecls required

Global_Stuffs g_Kban;

public Plugin myinfo =
{
	name 		= PLUGIN_NAME,
	author 		= ".Rushaway, Dolly, koen",
	version 	= "1.0",
	description = "Send KbRestrict Ban/Unban notifications to discord",
	url 		= "https://nide.gg"
};

public void OnPluginStart() {
	g_Kban.enable 	= CreateConVar("kban_discord_enable", "1", "Toggle kban notification system", _, true, 0.0, true, 1.0);
	g_Kban.webhook 	= CreateConVar("kban_discord", "", "The webhook URL of your Discord channel. (Kban)", FCVAR_PROTECTED);
	g_Kban.website	= CreateConVar("kban_website", "", "The Kbans Website for your server (that sends the user to bans list page)", FCVAR_PROTECTED);
	
	RelayHelper_PluginStart();
	
	AutoExecConfig(true, PLUGIN_NAME);
}

public void OnClientPostAdminCheck(int client) {
	if(IsFakeClient(client) || IsClientSourceTV(client)) {
		return;
	}
	
	GetClientSteamAvatar(client);
}

public void OnClientDisconnect(int client) {
	g_sClientAvatar[client][0] = '\0';
}

public void KB_OnClientKbanned(int target, int admin, int length, const char[] reason, int kbansNumber)
{
	if(!g_Kban.enable.BoolValue) {
		return;
	}
	
	if(admin < 1) {
		return;
	}
	
	SendDiscordMessage(g_Kban, Message_Type_Kban, admin, target, length, reason, kbansNumber, 0, _, g_sClientAvatar[target]);
}

public void KB_OnClientKunbanned(int target, int admin, const char[] reason, int kbansNumber)
{
    if(!g_Kban.enable.BoolValue) {
    	return;
    }
    
    if(admin < 1) {
		return;
	}
	
    SendDiscordMessage(g_Kban, Message_Type_Kunban, admin, target, -1, reason, kbansNumber, 0, _, g_sClientAvatar[target]);  
}
