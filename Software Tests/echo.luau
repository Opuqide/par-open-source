--[[
	
	(C) Copyright 2025, Apple Inc. All rights reserved.
	
	Permission is hereby granted to any person obtaining a copy of this
	document to use the computer program and associated documentation files (the "Software"),
	to deal in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies.
	
	THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER.
	
	This program is created on behalf of the Apple Informational Systems & Technology team.
	
]]

--[[

	The following file is a sample and/or testing file designed for specifically
	for quality assurance and testing purposes. It will be deleted if its use and
	its purpose has been served.
	
	If there are plans to use this file in the future, then it will be saved to storage
	for other engineers to look at.
	
	For more information, please contact your IS&T Head Engineer.
	
	Signed, Opuqide
	Head Engineer
	
	Apple Inc, Apple Informational Systems & Technology, Software Engineering & Production
	
	TM & (C) Apple Inc 2025, all rights reserved.

]]

local echo_cmd = {}

echo_cmd.main = function(line:string)
	local line_list = {}

	for arg in line:gmatch("%S+") do 
		table.insert(line_list,arg)
	end
	
	print(line:gsub("echo ",""))
	
	return 0
end

return echo_cmd