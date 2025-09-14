extends Node

@warning_ignore_start("unused_signal")
# combat signals
signal start_combat(enemy: Enemy)
signal end_combat()

# dialogue signals
signal entered_dialogue_area(npc: NPC)
signal exited_dialogue_area()
