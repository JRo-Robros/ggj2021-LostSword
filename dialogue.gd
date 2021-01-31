extends Node2D


func _ready():
	$textscroll.play("scroll")


func _on_textscroll_animation_finished(anim_name):
	yield(get_tree().create_timer(5),"timeout")
	get_tree().change_scene("res://HordeLevel.tscn")


func _on_Button_pressed():
	get_tree().change_scene("res://HordeLevel.tscn")


func _on_Button_button_down():
	get_tree().change_scene("res://HordeLevel.tscn")
