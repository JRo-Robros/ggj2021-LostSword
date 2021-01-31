extends Node2D

func _on_Background_Music_finished():
	$"Background Music".play()
	
func show_tut5():
	$TextureRect5.visible = true

func _on_Player_lost_sword(pos, initialVel):
	show_tut5()


func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://dialogue.tscn")


func _on_Button_button_down():
	$env/TextureRect3.visible = true
