extends RichTextLabel

func _ready():
	Rakugo.connect("say", self, "_on_say")


func _on_say(_character, _text, _parameters):
	if _character:
		modulate.a = 1
		self.bbcode_text = _character.get_composite_name("bbcode")
	else:
		modulate.a = 0
		# self.bbcode_text = Rakugo.Say.get_narrator().name
