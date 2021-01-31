extends Node2D


func _ready():
	$AnimationPlayer.play('die')


func _on_Button_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_Button_button_down():
	get_tree().change_scene("res://Main.tscn")
