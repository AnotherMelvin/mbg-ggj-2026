extends Node

# Signal to let other parts of the game know when config is ready
signal config_updated

# 1. DEFINE DEFAULTS
# These values are used if the player is offline or the request fails
var _params: Dictionary = {
	"official_task_target_1": 3.0,
  	"official_task_target_2": 0.0,
  	"official_task_target_3": 0.0,
  	"official_task_target_4": 0.0,
  	"spy_task_target_1": 3.0,
  	"spy_task_target_2": 0.0,
  	"spy_task_target_3": 0.0,
  	"spy_task_target_4": 0.0,
  	"suspicion_limit_1": 0.0,
  	"suspicion_limit_2": 0.0,
  	"suspicion_limit_3": 0.0,
  	"suspicion_limit_4": 0.0,
	"time_limit_1": 60.0,
  	"time_limit_2": 0.0,
  	"time_limit_3": 0.0,
  	"time_limit_4": 0.0,
	"max_level": 1
}

# Replace this with your actual npoint.io URL
const REMOTE_URL = "https://api.npoint.io/49cf332352b80b5daa10"

func _ready():
	# Create the HTTPRequest node via code so you don't have to add it to the scene manually
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Connect the completion signal
	http_request.request_completed.connect(_on_request_completed)
	
	# Send the request
	var url_with_cache_buster = REMOTE_URL + "?t=" + str(Time.get_unix_time_from_system())
	print("Fetching: " + url_with_cache_buster)
	var error = http_request.request(url_with_cache_buster)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _on_request_completed(result, response_code, _headers, body):
	# Check if the request was successful (Result 0 = RESULT_SUCCESS, HTTP 200 = OK)
	if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		
		if parse_result == OK:
			var remote_data = json.data
			if remote_data is Dictionary:
				_apply_remote_config(remote_data)
				print("Remote config applied successfully.")
			else:
				push_error("Remote config was not a Dictionary.")
		else:
			push_error("JSON Parse Error: " + json.get_error_message())
	else:
		push_warning("Failed to fetch remote config. Status code: " + str(response_code))
	
	# Emit signal regardless of success (game continues with defaults if failed)
	config_updated.emit()

func _apply_remote_config(remote_data: Dictionary):
	# Merge remote data into our params
	# We only update keys that actually exist in our defaults to prevent garbage data
	for key in remote_data.keys():
		if _params.has(key):
			# Note: You might want type safety checks here (e.g., ensure it's a float/int)
			_params[key] = remote_data[key]

# Public function to get values safely
func get_value(key: String, default_override = null):
	if _params.has(key):
		return _params[key]
	return default_override
