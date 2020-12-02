extends Node

var hp_bar: ProgressBar
var mana_bar: ProgressBar
var build_bar: ProgressBar
var special_bar: ProgressBar

signal hp_update
signal mana_update
signal build_update
signal special_update

var mana = 0
var hp = 0
var build = 0 # able to build one tower
var special = 0.0 # Firewalls on all lanes for a few seconds

var score = 0

func add_hp(num: int):
	if is_at_or_below_cap(hp, num):
		hp += num
		hp_bar.value = hp
		emit_signal('hp_update', hp)
	
func subtract_hp(num: int):
	if is_at_or_above_zero(hp, num):
		hp -= num
		hp_bar.value = hp
		emit_signal('hp_update', hp)
	
func add_mana(num: int):
	if is_at_or_below_cap(mana, num):
		mana += num
		mana_bar.value = mana
		emit_signal('mana_update', mana)
	
func subtract_mana(num: int):
	if is_at_or_above_zero(mana, num):
		mana -= num
		mana_bar.value = mana
		emit_signal('mana_update', mana)
	
func add_build(num: int):
	if is_at_or_below_cap(build, num):
		build += num
		build_bar.value = build
		emit_signal('build_update', build)
	
func subtract_build(num: int):
	if is_at_or_above_zero(build, num):
		build -= num
		build_bar.value = build
		emit_signal('build_update', build)
	
func add_special(num: float):
	if is_at_or_below_cap(special, num):
		special += num
		special_bar.value = special
		emit_signal('special_update', special)
	
func subtract_special(num: float):
	if is_at_or_above_zero(special, num):
		special -= num
		special_bar.value = special
		emit_signal('special_update', special)

func is_at_or_below_cap(val, new_val):
	return val + new_val <= 100
	
func is_at_or_above_zero(val, new_val):
	return val - new_val >= 0
