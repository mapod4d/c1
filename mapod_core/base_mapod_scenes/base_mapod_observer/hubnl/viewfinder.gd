# tool
tool

# class_name

# extends
extends Control

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# ----- remaining built-in virtual methods

func _draw():
	var cen = Vector2(0, 0)
	var side = 480
	var N = 8
	draw_regular_polygon(cen, side, N, 3.0, Color(0, 0, 0, 0.3))
	side = 40
	draw_cross(cen, side, 2.0, Color(1, 1, 1, 0.3), Color(0, 0, 0, 0.1))


# ----- public methods

func draw_regular_polygon(cen, side, N, width, color):
	if N >= 3:
		var ang
		var x
		var y
		var points = PoolVector2Array()
		#var colors = PoolColorArray()
		for i in range(N + 1):
			ang = i * (2 * PI / N)
			x = side * cos(ang)
			y = side * sin(ang)
			points.append(cen + Vector2(x, y))
		draw_polyline(points, color, width, true)


func draw_cross(cen, side, width, color, second_color):
	var points
	var shift = width / 2
	side = side / 2
	var antialiased = false
	
	# horizontal up
	points = PoolVector2Array()
	points.append(Vector2(cen.x - side, cen.y - shift))
	points.append(Vector2(cen.x + side, cen.y - shift))
	draw_polyline(points, second_color, width, antialiased)
	# horizontal center
	points = PoolVector2Array()
	points.append(Vector2(cen.x - side, cen.y))
	points.append(Vector2(cen.x + side, cen.y))
	draw_polyline(points, color, width, antialiased)
	# horizontal down
	points = PoolVector2Array()
	points.append(Vector2(cen.x - side, cen.y + shift))
	points.append(Vector2(cen.x + side, cen.y + shift))
	draw_polyline(points, second_color, width, antialiased)

	# vertical left
	points = PoolVector2Array()
	points.append(Vector2(cen.x - shift, cen.y - side))
	points.append(Vector2(cen.x - shift, cen.y + side))
	draw_polyline(points, second_color, width, antialiased)
	# vertical center
	points = PoolVector2Array()
	points.append(Vector2(cen.x, cen.y - side))
	points.append(Vector2(cen.x, cen.y + side))
	draw_polyline(points, color, width, antialiased)
	# vertical right
	points = PoolVector2Array()
	points.append(Vector2(cen.x + shift, cen.y - side))
	points.append(Vector2(cen.x + shift, cen.y + side))
	draw_polyline(points, second_color, width, antialiased)

# ----- private methods

