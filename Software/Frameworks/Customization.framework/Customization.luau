--[[

    Copyright (C) 2025 Apple Inc. All rights reserved.

    This document is hereby free for public viewing, modification, and
    duplication, and is provided on an "AS IS" basis.

    To report any vulnerabilities, go the Project Alpine Community Server
    and make a "Bug Report" ticket.

    Made with 🤍 by Opuqide on 16 October 2025.

]]

local Customization = {}
Customization.__index = Customization

local SystemRoot = script:FindFirstAncestor("rootfs")

-- Other Frameworks

--[[
Note from Opuqide:

If we're using PrivateFrameworks, we gotta be very cautious about them!
PrivateFrameworks should never be used in YOUR own work, as they're very unstable
and can have their functions' structures, even their name at any given moment!

However, I heavily discourage you from using PrivateFrameworks in your own work
if they're used for a very bad purpose!—

Never mind, I'm gonna put some of these in the Frameworks folder, because
why not :3
]]
local Image4Framework = require(SystemRoot.System.Library.PrivateFrameworks["Image4.framework"].Image4)
local WallpaperKit = require(SystemRoot.System.Library.Frameworks["WallpaperKit.framework"].WallpaperKit)
local SpringBoard = require(SystemRoot.System.Library.Frameworks["SpringBoard.framework"].SpringBoard)

--[=[
Customization:CustomizationConvertToBootChime(file:Instance)

As its name suggests, this function converts a valid audio
file into a boot chime that you can flash.

@param file - Instance
The file to convert to a boot chime.

@return Instance - return false if failed.
]=]
function Customization:CustomizationConvertToBootChime(file:Instance)
	local Image4Config:Image4Framework.Image4Setup = {
		ITAG = "aubt",
		VERS = "AppleCustomizationAudio-1.0",
		PROD = true,
		FILE = file
	}

	if not file:HasTag("AppleAudioApproved") then
		print("File is not a valid audio file.")
		return false,"File is not a valid audio file."
	end

	local NewBootChime = Image4Framework.Image4ConvertToFile(Image4Config)

	if not NewBootChime then
		print("Failed to set up new boot chime.")
		return false,"Image4 framework failed to convert file to Image4."
	end

	return NewBootChime
end

--[=[
Customization:CustomizationFlashBootChime(chime:Instance)

Flash a valid boot chime to the system for the device to use.

@param chime - Instance
The chime to convert to a boot chime.

@return Instance - return false if failed.
]=]
function Customization:CustomizationFlashBootChime(chime:Instance)
	if not chime:HasTag("IMAGE_TYPE_CHIME") then
		print("File is not an image4 boot chime.")
		return false,"File is not an image4 boot chime."
	end
	
	print(chime)
	
	local result = Image4Framework:Image4FlashFileToSystem(chime)

	if not result then
		print("Failed to flash file.")
		return false,"Failed to flash file."
	end

	return true
end

return Customization
