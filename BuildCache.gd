#!/usr/bin/env -S godot -s
extends SceneTree

##
# Prefetches and prepares resource files for content managed on the cms side 
# TBD generate pck file for ota updates
# run with godot --path . -s "BuildCache.gd" --no-window
# If run as part of CI it should run _before_ building standalone application
# bundles so the generated .res are included in the build 
# requires that the backend is reachable to load data 


var cc = load("res://Network/CacheController.gd")

func _init():
	if (is_instance_valid(root.get_node("/root/Api"))): 
		root.get_node("/root/Api").connect("finished_cache", self, "quit")

	
