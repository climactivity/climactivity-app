tool 
extends PanelContainer

export var data = {} setget on_data
var image 
var tex = null
var paragraph = null

func on_data(new_data:Dictionary):
	if !self.is_inside_tree(): 
		paragraph = new_data
		print("Deferred image loading... ") 
		return 
	if new_data.size() == 0: 
		return
	data = new_data
	var attrs = data["attrs"]
	var http_error = $HTTPRequest.request(attrs["src"])
	if http_error != OK:
		print("Could not load %s"% attrs["src"])

func _ready():
	if paragraph != null: 
		on_data(paragraph)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	image = Image.new()
	var image_error = image.load_png_from_buffer(body)
	if image_error != OK: 
		print("Image not loaded!")
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$TextureRect.texture = texture
	$Panel.visible = false
	$TextureRect.visible = true
