--[[
	Copyright (c) 2025 Apple Inc. All rights reserved.
	
	@APPLE_LICENSE_HEADER_START@
	
	The contents of this file constitute Original Code as defined in and
	are subject to the Apple Public Source License Version 1.1 (the 
	"License").  You may not use this file except in compliance with the
	License.  Please obtain a copy of the License at
	https://www.apple.com/publicsource and read it before using this file.
	
	The Original Code and all software distributed under this License are
	distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, EITHER
	EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
	INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT.  	Please see the 
	License for the specific language governing rights and limitations
	under the License.
	
	@APPLE_LICENSE_HEADER_END@
]]

--[[

	MobileDevice.framework
	
	MobileDevice is a framework that allows the communication between iOS devices and a Mac.
	This lets you run an XPC & lockdownd connection on the device from either Wi-Fi or USB.
	
	In Roblox logic, you can simply find the device in any directory, as long as the proper
	files are on that device.

]]

local MobileDevice = {}
MobileDevice.__index = {}

--[[
	AMDeviceUpdateWithPackageBundlePath(restore_path:Folder):number
	
	Updates the connected (and valid) device using the provided iTunes Update Package.
	
	The device is placed in Recovery Mode, and then into iBoot Upgrade Mode using the
	`upgrade` command. The structure of the packaged, however, must be checked before
	the software update can be installed.
]]
function MobileDevice:AMDeviceUpdateWithPackageBundlePath(restore_path:Folder):number
	if not self.Device then
		print("AMDeviceUpdateWithPackageBundlePath: Unable to locate device. Is the device connected?")
		return -1
	end
	
	if not restore_path:HasTag("iTunesUpdatePkg") then
		print("AMDeviceUpdateWithPackageBundlePath: Unable to install with update package. Package is not a valid iTunes Software Update.")
		return -1
	end
	
	print("AMDeviceUpdateWithPackageBundlePath: updating device with package "..restore_path:GetFullName())
	
	self.iBoot:reboot({Autoboot = false,BootCommand = ""},"iBootStage2")
	-- we also need to jump to iBootStage2 so we can perform the upgrade
	self.iBoot:JumpIntoSisterImage("iBootStage2")
	
	-- now, we gotta get the ramdisk and upload it
	local ramdisk = restore_path:FindFirstChild("ramdisk.dmg",true)
	if ramdisk ~= nil then
		self.iBoot:UploadRamdisk(ramdisk)
	end
	
	-- send the update contents to the ramdisk at /Library/Caches/MobileDeviceUpdateResources
	local UpdateContent = restore_path:FindFirstChild("updatepkgcontent",true)
	self.iBoot:UploadContentToRamdisk(UpdateContent,"MobileDeviceUpdateResources")
	local ASR_CMD = self.iBoot:GetFileFromRamdisk("asr")
	
	if not ASR_CMD then
		print("AMDeviceUpdateWithPackageBundlePath: ASR ramdisk command not found: No such file or directory")
		self.iBoot:RemoveCurrentRamdisk(true)
		
		self.iBoot:reboot({Autoboot = true,BootCommand = "fsboot"},"iBoot")
		return -1
	end
end

--[[
	MobileDevice.new(device:SurfaceGui)
	
	Creates a new MobileDevice session.
]]
MobileDevice.new = function(device:SurfaceGui)
	local self = setmetatable({},MobileDevice)
	
	if not device:HasTag("iPhoneOSDevice") then
		print("AppleMobileDevice: device "..device.Name.." is not a valid device.")
		return nil
	end
	
	print("AppleMobileDevice: Setting up MobileDevice connection with device "..device.Name)
	
	self.Device = device
	self.iBoot = require(self.Device.iPhone.boot["iBoot"]).new()
	self.DevRoot = self.Device.iPhone.rootfs
	
	return self
end

return MobileDevice
