extends Node

const GRID_CELL_SIZE = 32
const GRID_HALF_CELL_SIZE = GRID_CELL_SIZE / 2
const GRID_WIDTH = 10
const GRID_HEIGHT = 20

const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

const BULLET_SPEED = 1000

const ROCK_BLOCK = 0
const WOOD_BLOCK = 1
const STEEL_BLOCK = 2
const OBSIDIAN_BLOCK = 3

enum Weapon {
	LAZER,
	DEFAULT
}