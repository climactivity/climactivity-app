extends Spatial

func init_at(params = [Vector2(0,0)]): 
	if is_instance_valid(Logger): 
		Logger.print("Placed log at %s" % params, self)
	if params[0].x > 0 || params[0] == Vector2(-1,-1): 
		$Sprite3D.flip_h = true 
