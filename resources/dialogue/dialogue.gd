# base class for building dialogues stored in npc stats
class_name Dialogue
extends Resource


@export var speaker: String
# emotions based on the dialogue line
@export_enum("neutral", "annoyed", "smug", "surprised") var emotion: String = "neutral"
@export_multiline var line: String
