clean: 
	rm -r ./Network/Cache/*
build_app: 
	godot --export "HTML5" ./build/HTML/index.html --no-window