extends Node2D


func _ready():
	yield(get_tree().create_timer(2), "timeout")
	$AnimationPlayer.play("default")


func _on_Button_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_Button_button_down():
	get_tree().change_scene("res://Main.tscn")
