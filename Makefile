clean: 
	find ./Network/Cache -name "*.res" -type f -delete
build_app: 
	godot --export "HTML5" ./build/HTML/index.html --no-window
rebuild_cache:
	godot --path . -s "BuildCache.gd" --no-window
	godot --export-pack "Bundle" ./build/bundle/cache-DE-DE.pck --no-window

all: build_app rebuild_cache
