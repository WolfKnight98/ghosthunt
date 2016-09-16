if ( CLIENT ) then
	SWEP.PrintName     = "Hands"
	SWEP.Slot          = 1
	SWEP.SlotPos       = 1
	SWEP.DrawAmmo      = false
	SWEP.DrawCrosshair = false
end

SWEP.Author       = "WolfKnight"
SWEP.Instructions = "Nothing, just hands."
SWEP.Contact      = "WolfKnight on Steam"
SWEP.Purpose      = ""

SWEP.ViewModelFOV  = 62
SWEP.ViewModelFlip = false 
SWEP.AnimPrefix	   = "rpg"

SWEP.Spawnable           = false
SWEP.AdminSpawnable      = true

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = ""

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = ""

SWEP.ViewModel  = "models/weapons/c_arms_animations.mdl"
SWEP.WorldModel = ""

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:PrimaryAttack()
	return false
end 

function SWEP:SecondaryAttack()
	return false
end 