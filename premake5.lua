workspace "GEngine"
	startproject "Breakout"
	architecture "x64"

	configurations
	{
		"Debug",
		"Release"
	}

tdir = "bin/%{cfg.buildcfg}/%{prj.name}"
odir = "bin-int/%{cfg.buildcfg}/%{prj.name}"


-- External Dependencies
externals = {}
externals["sdl2"] = "external/sdl2"
externals["spdlog"] = "external/spdlog"
externals["glad"] = "external/glad"
externals["tbb"] = "external/tbb"
externals["rttr"] = "external/rttr"
externals["reflection"] = "external/reflection"
externals["entt"] = "external/entt"
externals["assimp"] = "external/assimp"
externals["fmod"] = "external/fmod"
--externals["imguizmo"] = "external/imguizmo"


include "external/glad"

--process glad before anything

project "GEngine"
	location "GEngine"
	kind "StaticLib"
	language "C++"
	cppdialect "C++20"
	staticruntime "on"

	targetdir(tdir)
	objdir(odir)

	pchheader "gepch.h"
	pchsource "%{prj.name}/src/gepch.cpp"


	files
	{
		"%{prj.name}/include/**.h",
		"%{prj.name}/include/**.cpp",
		"%{prj.name}/include/**.hpp",
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/**.natvis"
		--"%{externals.imguizmo}/include/ImGuizmo.h",
		--"%{externals.imguizmo}/include/ImGuizmo.cpp"
	}

	sysincludedirs
	{
		"%{prj.name}/include/%{prj.name}",
		"%{prj.name}/include/external",
		"%{externals.sdl2}/include",
		"%{externals.spdlog}/include",
		"%{externals.glad}/include",
		"%{externals.tbb}/include",
		"%{externals.rttr}/include",
		"%{externals.reflection}/include",
		"%{externals.entt}/include",
		"%{externals.assimp}/include",
		"%{externals.fmod}/include"
		--"%{externals.imguizmo}/include"
		--"%{prj.name}/src"

	}


	defines
	{
		--Ensures glad doesn't include glfw
		"GLFW_INCLUDE_NONE"
	}

	-- Windows
	filter
	{
		"system:windows",
		"configurations:*"
	}



	buildoptions "/MTd"


	systemversion "lastest"

	defines
	{
		"GENGINE_PLATFORM_WINDOWS",
		"GENGINE_WINDOW_SDL",
		"_SILENCE_CXX23_ALIGNED_STORAGE_DEPRECATION_WARNING"
	}

	filter "files:GEngine/include/external/imguizmo/**.cpp"
	flags {"NoPCH"}

	-- Linux
	filter
	{
		"system:linux",
		"configurations:*"
	}

		defines
		{
			"GENGINE_PLATFORM_LINUX"
		}


	-- MACOS
	filter
	{
		"system:macosx",
		"configurations:*"
	}

		xcodebuildsettings
		{
			["MACOSX_DEPLOYMENT_TARGET"] = "10.15",
			["UseModernBuildSystem"] = "NO"

		}

		defines
		{
			"GENGINE_PLATFORM_MAC"
		}

	-- DEBUG
	filter "configurations:Debug"
		defines
		{
			"GENGINE_CONFIG_DEBUG"
		}

		runtime "Debug"
		symbols "on"

	-- RELEASE
	filter "configurations:Release"
		defines
		{
			"GENGINE_CONFIG_RELEASE"
		}

		runtime "Release"
		symbols "off"
		optimize "on"



project "GEngineEditor"
	location "GEngineEditor"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++20"
	staticruntime "on"
	links "GEngine"

	targetdir(tdir)
	objdir(odir)



	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	
	sysincludedirs
	{
		
		"%{externals.rttr}/include",
		"%{externals.tbb}/include",
		"GEngine/include",
		"GEngine/include/external",
		"GEngine/include/GEngine",
		"%{externals.reflection}/include",
		"%{externals.spdlog}/include",
		"%{externals.entt}/include",
		"%{externals.assimp}/include",
		"%{externals.fmod}/include"
		--"%{externals.imguizmo}/include"
		--"%{externals.tbb}/include"
		--"%{externals.glad}/include"

	}

	
	postbuildcommands
	{
		"python " .. path.getabsolute("%{prj.name}") .. "/postbuild.py config=%{cfg.buildcfg} prj=%{prj.name}"
	}

	-- Windows
	filter
	{
		"system:windows",
		"configurations:*"
	}

	buildoptions "/MTd"

	systemversion "10.0"

	defines
	{
		"GENGINE_PLATFORM_WINDOWS",
		"_SILENCE_CXX23_ALIGNED_STORAGE_DEPRECATION_WARNING"
	}

	libdirs
	{
		"%{externals.sdl2}/lib",
		"%{externals.tbb}/lib",
		"%{externals.rttr}/lib",
		"%{externals.assimp}/lib",
		"%{externals.fmod}/lib"
	}

	links
	{
		"SDL2main",
		"SDL2",
		"SDL2test",
		"glad",
		"tbb12",
		"tbb12_debug",
		"tbb",
		"tbb_debug",
		"SDL2_ttf",
		"assimp",
		"fmod64_vc",
		"fmodL64_vc",
		"fmodstudio64_vc",
		"fmodstudioL64_vc"
		--"assimp-vc143-mtd",
		--"assimp-vc143-mt",
		

	}

	-- Linux
	filter
	{
		"system:linux",
		"configurations:*"
	}

		defines
		{
			"GENGINE_PLATFORM_LINUX"
		}

		links
		{
			"SDL2",
			"glad"
		}

	-- MACOS
	filter
	{
		"system:macosx",
		"configurations:*"
	}

		xcodebuildsettings
		{
			["MACOSX_DEPLOYMENT_TARGET"] = "10.15",
			["UseModernBuildSystem"] = "NO"

		}

		defines
		{
			"GENGINE_PLATFORM_MAC"
		}

		links
		{
			"SDL2.framework",
			"glad"
		}

	filter "configurations:Debug"
		defines
		{
			"GENGINE_CONFIG_DEBUG"
		}
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines
		{
			"GENGINE_CONFIG_RELEASE"
		}
		runtime "Release"
		symbols "off"
		optimize "on"



project "Breakout"
	location "Breakout"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++20"
	staticruntime "on"
	links "GEngine"

	targetdir(tdir)
	objdir(odir)



	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/include/**.h"
	}

	
	sysincludedirs
	{
		
		"%{externals.rttr}/include",
		"%{externals.tbb}/include",
		"GEngine/include",
		"GEngine/include/external",
		"GEngine/include/GEngine",
		"%{externals.reflection}/include",
		"%{externals.spdlog}/include",
		"%{externals.entt}/include",
		"%{externals.assimp}/include",
		"%{externals.fmod}/include",
		"%{prj.name}/include"

		--"%{externals.imguizmo}/include"
		--"%{externals.tbb}/include"
		--"%{externals.glad}/include"

	}

	
	postbuildcommands
	{
		"python " .. path.getabsolute("%{prj.name}") .. "/postbuild.py config=%{cfg.buildcfg} prj=%{prj.name}"
	}

	-- Windows
	filter
	{
		"system:windows",
		"configurations:*"
	}

	buildoptions "/MTd"

	systemversion "10.0"

	defines
	{
		"GENGINE_PLATFORM_WINDOWS",
		"_SILENCE_CXX23_ALIGNED_STORAGE_DEPRECATION_WARNING"
	}

	libdirs
	{
		"%{externals.sdl2}/lib",
		"%{externals.tbb}/lib",
		"%{externals.rttr}/lib",
		"%{externals.assimp}/lib",
		"%{externals.fmod}/lib"
	}

	links
	{
		"SDL2main",
		"SDL2",
		"SDL2test",
		"glad",
		"tbb12",
		"tbb12_debug",
		"tbb",
		"tbb_debug",
		"SDL2_ttf",
		"assimp",
		"fmod64_vc",
		"fmodL64_vc",
		"fmodstudio64_vc",
		"fmodstudioL64_vc"
		--"assimp-vc143-mtd",
		--"assimp-vc143-mt",
		

	}

	-- Linux
	filter
	{
		"system:linux",
		"configurations:*"
	}

		defines
		{
			"GENGINE_PLATFORM_LINUX"
		}

		links
		{
			"SDL2",
			"glad"
		}

	-- MACOS
	filter
	{
		"system:macosx",
		"configurations:*"
	}

		xcodebuildsettings
		{
			["MACOSX_DEPLOYMENT_TARGET"] = "10.15",
			["UseModernBuildSystem"] = "NO"

		}

		defines
		{
			"GENGINE_PLATFORM_MAC"
		}

		links
		{
			"SDL2.framework",
			"glad"
		}

	filter "configurations:Debug"
		defines
		{
			"GENGINE_CONFIG_DEBUG"
		}
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines
		{
			"GENGINE_CONFIG_RELEASE"
		}
		runtime "Release"
		symbols "off"
		optimize "on"


	project "RayTracing"
	location "RayTracing"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++20"
	staticruntime "on"
	links "GEngine"

	targetdir(tdir)
	objdir(odir)



	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/include/**.h"
	}

	
	sysincludedirs
	{
		
		"%{externals.rttr}/include",
		"%{externals.tbb}/include",
		"GEngine/include",
		"GEngine/include/external",
		"GEngine/include/GEngine",
		"%{externals.reflection}/include",
		"%{externals.spdlog}/include",
		"%{externals.entt}/include",
		"%{externals.assimp}/include",
		"%{externals.fmod}/include",
		"%{prj.name}/include"

		--"%{externals.imguizmo}/include"
		--"%{externals.tbb}/include"
		--"%{externals.glad}/include"

	}

	
	postbuildcommands
	{
		"python " .. path.getabsolute("%{prj.name}") .. "/postbuild.py config=%{cfg.buildcfg} prj=%{prj.name}"
	}

	-- Windows
	filter
	{
		"system:windows",
		"configurations:*"
	}

	buildoptions "/MTd"

	systemversion "10.0"

	defines
	{
		"GENGINE_PLATFORM_WINDOWS",
		"_SILENCE_CXX23_ALIGNED_STORAGE_DEPRECATION_WARNING"
	}

	libdirs
	{
		"%{externals.sdl2}/lib",
		"%{externals.tbb}/lib",
		"%{externals.rttr}/lib",
		"%{externals.assimp}/lib",
		"%{externals.fmod}/lib"
	}

	links
	{
		"SDL2main",
		"SDL2",
		"SDL2test",
		"glad",
		"tbb12",
		"tbb12_debug",
		"tbb",
		"tbb_debug",
		"SDL2_ttf",
		"assimp",
		"fmod64_vc",
		"fmodL64_vc",
		"fmodstudio64_vc",
		"fmodstudioL64_vc"
		--"assimp-vc143-mtd",
		--"assimp-vc143-mt",
		

	}

	-- Linux
	filter
	{
		"system:linux",
		"configurations:*"
	}

		defines
		{
			"GENGINE_PLATFORM_LINUX"
		}

		links
		{
			"SDL2",
			"glad"
		}

	-- MACOS
	filter
	{
		"system:macosx",
		"configurations:*"
	}

		xcodebuildsettings
		{
			["MACOSX_DEPLOYMENT_TARGET"] = "10.15",
			["UseModernBuildSystem"] = "NO"

		}

		defines
		{
			"GENGINE_PLATFORM_MAC"
		}

		links
		{
			"SDL2.framework",
			"glad"
		}

	filter "configurations:Debug"
		defines
		{
			"GENGINE_CONFIG_DEBUG"
		}
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines
		{
			"GENGINE_CONFIG_RELEASE"
		}
		runtime "Release"
		symbols "off"
		optimize "on"
		
		
		
		
		
		
		
	project "RigidBodySimulation"
	location "RigidBodySimulation"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++20"
	staticruntime "on"
	links "GEngine"

	targetdir(tdir)
	objdir(odir)



	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/include/**.h"
	}

	
	sysincludedirs
	{
		
		"%{externals.rttr}/include",
		"%{externals.tbb}/include",
		"GEngine/include",
		"GEngine/include/external",
		"GEngine/include/GEngine",
		"%{externals.reflection}/include",
		"%{externals.spdlog}/include",
		"%{externals.entt}/include",
		"%{externals.assimp}/include",
		"%{externals.fmod}/include",
		"%{prj.name}/include"

		--"%{externals.imguizmo}/include"
		--"%{externals.tbb}/include"
		--"%{externals.glad}/include"

	}

	
	postbuildcommands
	{
		"python " .. path.getabsolute("%{prj.name}") .. "/postbuild.py config=%{cfg.buildcfg} prj=%{prj.name}"
	}

	-- Windows
	filter
	{
		"system:windows",
		"configurations:*"
	}

	buildoptions "/MTd"

	systemversion "10.0"

	defines
	{
		"GENGINE_PLATFORM_WINDOWS",
		"_SILENCE_CXX23_ALIGNED_STORAGE_DEPRECATION_WARNING"
	}

	libdirs
	{
		"%{externals.sdl2}/lib",
		"%{externals.tbb}/lib",
		"%{externals.rttr}/lib",
		"%{externals.assimp}/lib",
		"%{externals.fmod}/lib"
	}

	links
	{
		"SDL2main",
		"SDL2",
		"SDL2test",
		"glad",
		"tbb12",
		"tbb12_debug",
		"tbb",
		"tbb_debug",
		"SDL2_ttf",
		"assimp",
		"fmod64_vc",
		"fmodL64_vc",
		"fmodstudio64_vc",
		"fmodstudioL64_vc"
		--"assimp-vc143-mtd",
		--"assimp-vc143-mt",
		

	}

	-- Linux
	filter
	{
		"system:linux",
		"configurations:*"
	}

		defines
		{
			"GENGINE_PLATFORM_LINUX"
		}

		links
		{
			"SDL2",
			"glad"
		}

	-- MACOS
	filter
	{
		"system:macosx",
		"configurations:*"
	}

		xcodebuildsettings
		{
			["MACOSX_DEPLOYMENT_TARGET"] = "10.15",
			["UseModernBuildSystem"] = "NO"

		}

		defines
		{
			"GENGINE_PLATFORM_MAC"
		}

		links
		{
			"SDL2.framework",
			"glad"
		}

	filter "configurations:Debug"
		defines
		{
			"GENGINE_CONFIG_DEBUG"
		}
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines
		{
			"GENGINE_CONFIG_RELEASE"
		}
		runtime "Release"
		symbols "off"
		optimize "on"