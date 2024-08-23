_G.xkcd = _G.xkcd or {}
xkcd.path = ModPath
xkcd.savefile = SavePath .. "xkcd.json"
xkcd.menu = xkcd.path .. "menu/settings.json"
xkcd.settings = {}

function xkcd:default()
	if not io.file_is_readable(self.menu) then return end

	local data = io.load_as_json(self.menu)
	for _, item in pairs(data.items) do
		self.settings[item.value] = item.default_value
	end
end
xkcd:default()


function xkcd:save()
	io.save_as_json(self.settings, self.savefile)
end

function xkcd:load()
	if not io.file_is_readable(self.savefile) then return end

	local data = io.load_as_json(self.savefile)
	for k, v in pairs(data) do self.settings[k] = v end
end


Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_xkcd", function(loc)
	loc:load_localization_file(xkcd.path .. "loc/english.txt", false)
end)

Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_xkcd", function( menu_manager )
	MenuCallbackHandler.xkcd_callback_save = function() xkcd:save() end

	MenuCallbackHandler.xkcd_callback = function(self, item)
		xkcd.settings[item:name()] = item:value()
	end

	xkcd:load()
	MenuHelper:LoadFromJsonFile( xkcd.menu, xkcd, xkcd.settings )
end )
