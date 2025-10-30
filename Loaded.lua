local a = game.ReplicatedStorage
local b = "Check"
a[b].OnClientInvoke = function()
    local c = 1 + 1
    local d = c - 1
    return d == 1
end

local function getAncestors(instance)
	local ancestors = {}
	local parent = instance.Parent
	while parent do
		table.insert(ancestors, parent)
		parent = parent.Parent
	end
	return ancestors
end

local e = game:GetService("ReplicatedStorage")
local f = e:WaitForChild("CheckChildExists")

local g = {
	"FrameRateManager",
	"DeviceFeatureLevel",
	"DeviceShadingLanguage",
	"AverageQualityLevel",
	"AutoQuality",
	"NumberOfSettles",
	"AverageSwitches",
	"FramebufferWidth",
	"FramebufferHeight",
	"Batches",
	"Indices",
	"MaterialChanges",
	"VideoMemoryInMB",
	"AverageFPS",
	"FrameTimeVariance",
	"FrameSpikeCount",
	"RenderAverage",
	"PrepareAverage",
	"PerformAverage",
	"AveragePresent",
	"AverageGPU",
	"RenderThreadAverage",
	"TotalFrameWallAverage",
	"PerformVariance",
	"PresentVariance",
	"GpuVariance",
	"MsFrame0",
	"MsFrame1",
	"MsFrame2",
	"MsFrame3",
	"MsFrame4",
	"MsFrame5",
	"MsFrame6",
	"MsFrame7",
	"MsFrame8",
	"MsFrame9",
	"MsFrame10",
	"MsFrame11",
	"Render",
	"Memory",
	"Video",
	"CursorImage",
	"LanguageService",
	"Animator", -- Common legitimate instance
	"Humanoid", -- Common legitimate instance
	"Motor6D", -- Common legitimate instance
	"Weld", -- Common legitimate instance
	"WeldConstraint", -- Common legitimate instance
}

local function h(i)
	for _, j in ipairs(g) do
		if i == j then
			return true
		end
	end
	return false
end

-- Wait longer for game to fully load
task.wait(3)

game.DescendantAdded:Connect(function(k)
	-- Skip whitelisted instances
	if h(k.Name) then return end
	
	-- Skip if parent doesn't exist (instance might be destroyed)
	if not k.Parent then return end
	
	local success, l = pcall(function()
		return f:InvokeServer(k.Parent.Name, k.Name)
	end)
	
	-- If server call failed, skip this check
	if not success then return end
	
	local m = getAncestors(k)
	for _, n in ipairs(m) do
		if n.Name == "ReplicatedStorage" then
			e.AntiCheat:FireServer("???", "using exploit.")
			return
		end
	end
	
	local o = k:FindFirstChild("Key")
	local keySuccess, p = pcall(function()
		return e.GetKey:InvokeServer()
	end)
	
	-- If can't get key, skip check
	if not keySuccess then return end
	
	if o and l then
		if o.Value ~= p then
			e.AntiCheat:FireServer(k.Name, "adding instance with wrong key - exploit.")
		end
	elseif k.Name == "Key" then
		if k.Value then
			if k.Value ~= p then
				e.AntiCheat:FireServer(k.Name, "adding instance with wrong key - exploit.")
			end
		end
	elseif not o and not l then
		e.AntiCheat:FireServer(k.Name, "adding instance with exploit.")
	end
end)
