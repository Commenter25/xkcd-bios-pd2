-- import antigravity
-- wait, shit. this isnt python.

local function snippet(gender, enemy)
	local snippets = {
		"SUB once built a treehouse.",
		"SUB has BNUM unread emails that SUB was hoping to get to tonight.",
		"Today was POS first day on the job.",
		"Today was POS last day on the job.",
		"Tomorrow was POS last day on the job.",
		"POS birthday was in NUM days.",
		"SUB volunteered at homeless shelters.",
		"SUB was a single parent with NUM children.",
		"SUB was responsible for picking up POS daughter from daycare.",
		"SUB once won a talent show.",
		"SUB has NUM pets.",
		"POS son suffers from leukemia.",
		"SUB just got engaged.",
		"POS family lives below the poverty line.",
		"SUB was a war veteran.",
		"SUB collected action figures.",
		"SUB frequently bought meals for the poor.",
		"SUB has a blind relative.",
		"SUB was mentally handicapped.",
		"SUB actually donated to Wikipedia.",
		"POS pets frequently run away.",
		"SUB once donated $NUM to PETA.",
		"SUB preferred tea over coffee.",
		"SUB preferred coffee over tea.",
		"SUB ate POS pizza with a spoon.",
		"SUB ate POS pizza with a fork.",
		"SUB has never eaten a sandwich.",
		"SUB planned to wash POS car in NUM days.",
		"SUB teached children on POS days off.",
		"SUB liked to spend POS time picking up trash.",
		"SUB sent letters to POS parents every night.",
		"SUB was a foster parent.",
		"SUB was the last remaining member in POS family.",
		"SUB was still a virgin.",
		"SUB entertained children in hospitals every weekend.",
		"SUB liked to conserve paper.",
		"SUB liked to conserve water.",
		"SUB was computer illiterate.",
		"SUB read to the elderly.",
		"SUB frequently donated toys to the animal shelter.",
		"SUB was always the designated driver.",
		"SUB was an organ donor.",
		"SUB liked to plant trees in the forest.",
		"SUB once saved a kitten from a tree.",
		"SUB always donated POS extra clothes to the homeless.",
		"SUB always paid POS taxes on time.",
		"SUB donated POS extra change to food banks.",
		"POS hobby was to write comics.",
		"SUB just applied for POS dream job.",
		"SUB considered calling in sick today.",
		"SUB never graduated high school.",
		"SUB was LNUM monthNUMS from getting POS degree.",
		"SUB does not have life insurance.",
		"SUB was LNUM monthNUMS off from paying off POS car.",
		"SUB was LNUM monthNUMS off from paying off POS house.",
		"SUB hadn't paid POS $BNUM traffic ticket.",
		"SUB bought kids meals for OBJself.",
		"SUB just came out of the closet.",
		"SUB had almost finished POS plushie collection.",
		"SUB had almost finished POS comic book collection.",
		"SUB had almost finished POS video game collection.",
		"SUB survived a plane crash.",
		"SUB was multilingual.",
		"SUB was a gambling addict.",
		"SUB was lactose intolerant.",
		"SUB trolled online forums in POS spare time.",
		"SUB dreamed of hitting a home run.",
		"SUB just scheduled a therapy appointment.",
		"SUB was colorblind.",
		"SUB changed the air purifier filter exactly every 6 months.",
		"SUB always bought store brand groceries.",
		"POS new laptop arrives today.",
		"POS new phone arrives today.",
		"SUB just got out of debt.",
		"SUB just got approved for a full-tuition scholarship.",
		"SUB loved to drink and drive.",
		"SUB ate mud sometimes.",
		"SUB ate paper sometimes.",
		"SUB always tried to make the world a bit kinder.",
		"SUB just started thinking things were turning around.",
		"SUB was excited to watch the new season of POS favorite show.",
		"SUB just hit a year sober.",
		"SUB memorized every U.S. president for a bet.",
		"SUB had two rain gauges to see if they differed.",
		"SUB has never seen an Indiana Jones movie.",
		"SUB never learned to swim.",
		"SUB never learned to ride a bike.",
		"SUB has never tried soda.",
		"SUB was almost late today.",
		"SUB did community service for fun.",
		"POS EP was going to drop tonight."
	}

	local snippets_civilian = {
		"SUB applied to be a guard here.",
		"SUB dreamed of being a cop.",
		"SUB was a firefighter."
	}

	local snippets_enemy = {
		"SUB was the only one who took care of the plants back at base.",
		"SUB was the only one who cleaned the bathrooms back at base.",
		"SUB nearly failed POS last fitness test.",
		"Nobody noticed SUB replaced the flickering lightbulb back at base.",
		"Nobody noticed SUB sharpened everyone's pencils back at base.",
		"SUB was about to come home from deployment."
	}

	local output = ""

	local bonus_table = enemy and snippets_enemy or snippets_civilian
	local total = #snippets + #bonus_table
	local index = math.random(1, total)

	if index > #snippets then
		index = index - #snippets
		output = bonus_table[index]
	else
		output = snippets[index]
	end

	local pronouns = {
		["male"] = {"he", "him", "his"},
		["female"] = {"she", "her", "her"},
		["neutral"] = {"they", "them", "their"}
	}
	local subject, object, possess = unpack( pronouns[gender] )

	if gender == "neutral" then
		output = string.gsub(output, "SUB was ", "SUB were ")
		output = string.gsub(output, "SUB has ", "SUB have ")
		output = string.gsub(output, "SUB does ", "SUB do ")
	end

	output = string.gsub(output, "SUB", subject)
	output = string.gsub(output, "OBJ", object)
	output = string.gsub(output, "POS", possess)

	local lnum = math.random(1, 3)
	if lnum == 1 then
		output = string.gsub(output, "NUMS", "")
	else
		output = string.gsub(output, "NUMS", "s")
	end
	output = string.gsub(output, "LNUM", tostring(lnum))

	output = string.gsub(output, "BNUM", tostring(math.random(50, 150)))
	output = string.gsub(output, "NUM", tostring(math.random(2, 8)))

	return output
end



local original = CopDamage._comment_death
function CopDamage:_comment_death(attacker, victim, special_comment)
	original(self, attacker, victim, special_comment)
	if attacker ~= managers.player:player_unit() then return end


	local settings = xkcd.settings
	if settings.duration == 0 then return end
	local mode = settings.mode


	-- check if mode allows snippets in loud
	local loud = not managers.groupai:state():whisper_mode()
	if mode < 3 and loud then return end


	local victim = victim:base()._char_tweak

	-- check if civilian
	local enemy = true
	for _, v in pairs(victim.tags) do
		if v == "civilian" then
			enemy = false
			break
		end
	end

	-- return if civs only mode
	if enemy then
		if loud and mode == 3 then return end
		if mode == 4 or mode == 1 then return end
	end


	local gender = "male"
	if math.random() <= 0.02 then -- 2% enby chance
		gender = "neutral"
	elseif victim.female then
		gender = "female"
	end


	managers.hud:show_hint({
		text = snippet(gender, enemy),
		time = settings.duration
	})
end
