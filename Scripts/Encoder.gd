@tool
extends Node

@export_multiline var input : String
@export var do_convert : bool:
  set(value):
    input = input.to_utf8_buffer().hex_encode()
