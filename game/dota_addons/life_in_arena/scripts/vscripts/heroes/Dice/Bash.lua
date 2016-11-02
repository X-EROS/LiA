function Bash(event)
	local caster = event.caster
	local ability = event.ability

	if caster:IsIllusion() then
		return
	end

	local modifier = caster:FindModifierByNameAndAbility("modifier_dice_bash",ability)

	if IsActiveBash(modifier) then

		local damageTable = {
						 	victim = event.target, 
						 	attacker = caster, 
						 	damage = ability:GetSpecialValueFor("bash_damage"), 
						 	damage_type = DAMAGE_TYPE_MAGICAL,
						 	ability = ability
						}

		ability:ApplyDataDrivenModifier(caster, event.target, "modifier_stunned", {duration = ability:GetSpecialValueFor("bash_stun")})
	
		event.target:EmitSound("Roshan.Bash")
	end

end

function IsActiveBash(modifier)
	local bResult = true
	local ability = modifier:GetAbility()
	local bashChance = ability:GetSpecialValueFor("bash_chance")

	for _,mod in pairs(ability:GetCaster():FindAllModifiers()) do
		local modAbility = mod:GetAbility()

		if modAbility and modAbility ~= ability and modAbility:GetSpecialValueFor("bash_chance") then
			local modBashChance = modAbility:GetSpecialValueFor("bash_chance")

			if bashChance < modBashChance then
				return false
			elseif bashChance == modBashChance then
				if modifier:GetCreationTime() < mod:GetCreationTime() then
					bResult = false
				end
			end
		end
	end
	return bResult
end
