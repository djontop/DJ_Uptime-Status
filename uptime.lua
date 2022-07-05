--------------------------------Server Uptime------------------------------------
------------------------https://github.com/djontop-------------------------------
Citizen.CreateThread(function()
	local uptimeMinute, uptimeHour, uptime = 0, 0, ''

	while true do
		Citizen.Wait(1000 * 60) -- every minute
		uptimeMinute = uptimeMinute + 1

		if uptimeMinute == 60 then
			uptimeMinute = 0
			uptimeHour = uptimeHour + 1
		end

		uptime = string.format("%02dh %02dm", uptimeHour, uptimeMinute)
		SetConvarServerInfo('DJ_Uptime-Status', uptime)


		TriggerClientEvent('DJ_Uptime-Status:tick', -1, uptime)
		TriggerEvent('DJ_Uptime-Status:tick', uptime)
	end
end)

--------------------------------Server Status------------------------------------
------------------------https://github.com/djontop-------------------------------
local locales = Config.Locales[Config.Locale]

Citizen.CreateThread(function()
    while true do
	if Config.MessageId ~= nil and Config.MessageId ~= '' then
		UpdateStatusMessage()
	else
		DeployStatusMessage()
		break
	end

	Citizen.Wait(Config.UpdateTime)
    end
end)


function DeployStatusMessage()
	local footer = nil

		footer = os.date(locales['date']..': %d/%m/%Y  |  '..locales['time']..': %I:%M %p')

	local embed = {
		{
			["color"] = Config.EmbedColor,
			["title"] = "** Deploying Status Message!**",
			["description"] = 'Copy this message id and put it into Config and restart script!',
			["footer"] = {
				["text"] = footer,
			},
		}
	}

	PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({
		embeds = embed, 
	}), { ['Content-Type'] = 'application/json' })
end


function UpdateStatusMessage()
	local players = #GetPlayers()
	local maxplayers = GetConvarInt('sv_maxclients', 0)
	local footer = nil

	footer = os.date(locales['date']..': %d/%m/%Y  |  '..locales['time']..': %I:%M %p')



	local message = json.encode({
		embeds = {
			{

				["color"] = Config.EmbedColor,
				["title"] = '**'..Config.ServerName..'**',
				["description"] = ':busts_in_silhouette: '..locales['players']..': `'..players..' / '..maxplayers..'`\n:desktop: IP: '..Config.JoinLink..'\n:timer: Uptime: `'..GetConvar('Uptime', 'NULL')..'`',
				["footer"] = {
					["text"] = footer,
				},
			}
		},

		components = {
			{
				["type"] = 1,
				["components"] = {
					{
						["type"] = 2,
						["label"] = locales['connect'],
						["style"] = 5,
						["url"] = Config.JoinLink,
					}
				},
			}
		}
	})

	PerformHttpRequest(Config.Webhook..'/messages/'..Config.MessageId, function(err, text, headers) 
	end, 'PATCH', message, { ['Content-Type'] = 'application/json' })
end
------------------------https://github.com/djontop-------------------------------
