tauren_champion_accumulated_rage = class({})
LinkLuaModifier("modifier_tauren_champion_accumulated_rage","heroes/TaurenChampion/tauren_champion_accumulated_rage.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tauren_champion_accumulated_rage_damage","heroes/TaurenChampion/tauren_champion_accumulated_rage.lua",LUA_MODIFIER_MOTION_NONE)

function tauren_champion_accumulated_rage:GetIntrinsicModifierName()
	return "modifier_tauren_champion_accumulated_rage"
end

function tauren_champion_accumulated_rage:OnSpellStart() 
	if IsServer() then
		self.duration = self:GetSpecialValueFor("duration")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tauren_champion_accumulated_rage", {duration = self.duration})
	end
end

-------------------------------------------------------------------------------

modifier_tauren_champion_accumulated_rage = class({})

function modifier_tauren_champion_accumulated_rage:IsHidden()
	return false
end

function modifier_tauren_champion_accumulated_rage:IsPurgable()
	return true
end

function modifier_tauren_champion_accumulated_rage:OnCreated(kv)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.attacks_count = self:GetAbility():GetSpecialValueFor("attacks_count")
	self.cleave_damage_percent = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
	self.cleave_starting_width = self:GetAbility():GetSpecialValueFor("cleave_starting_width")
	self.cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.cleave_distance = self:GetAbility():GetSpecialValueFor("cleave_distance")
	if IsServer() then
		self:SetStackCount(self.attacks_count)
	end
end

function modifier_tauren_champion_accumulated_rage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_tauren_champion_accumulated_rage:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_tauren_champion_accumulated_rage:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if params.target ~= nil and params.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local cleaveDamage = ( self.cleave_percent * params.damage ) / 100.0
				DoCleaveAttack( self:GetParent(), params.target, self:GetAbility(), cleaveDamage, self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf" )
				self:DecrementStackCount()
				if self:GetStackCount() == 0 then
					self:GetParent():RemoveModifierByName("modifier_tauren_champion_accumulated_rage")
				end
			end
		end
	end
end


