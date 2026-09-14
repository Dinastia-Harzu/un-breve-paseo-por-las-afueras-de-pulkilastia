class_name PointCloud
extends Node

var points: Array[QPoint] = []
var gesture_name: String
var lut: PackedInt32Array = []

func _init(ps: Array[QPoint], n: String = "", l: PackedInt32Array = []) -> void:
	gesture_name = n
	points = normalise(ps)
	points = make_int_coords(points)
	lut = l if not l.is_empty() and l.size() == QDollarUtils.LUT_SIZE * QDollarUtils.LUT_SIZE else compute_lut(points)


func _to_string() -> String:
	return "PointCloud { points: %s, gesture_name: %s, lut: %s }" % [points, gesture_name, lut]


func normalise(ps: Array[QPoint]) -> Array[QPoint]:
	var normalised := resample(ps, QDollarUtils.NUM_POINTS)
	normalised = scale(normalised)
	normalised = translate2(normalised, Vector2.ZERO)
	return normalised


func resample(p: Array[QPoint], n: int) -> Array[QPoint]:
	var l := path_length(p) / (n - 1)
	var d := 0.
	var resampled: Array[QPoint] = [p[0]]
	var i := 1
	var np := p.size()
	while i < np:
		var p0 := p[i - 1]
		var p1 := p[i]
		if p0.in_same_stroke_as(p1):
			var d0 := p0.distance_to(p1)
			if d + d0 >= l:
				var t := (l - d) / d0
				assert(0. <= t and t <= 1.)
				var q := p1.new_in_same_stroke(p0.position * (1. - t) + p1.position * t)
				resampled.append(q)
				p.insert(i, q)
				np += 1
				d = 0.
			else: d += d0
		i += 1
	if resampled.size() == n - 1: resampled.append(p[-1])
	return resampled


func translate2(ps: Array[QPoint], c: Vector2) -> Array[QPoint]:
	for p in ps:
		c += p.position
	c /= ps.size()
	var translated: Array[QPoint] = []
	for p in ps:
		translated.append(p.new_in_same_stroke(p.position - c))
	return translated


func scale(ps: Array[QPoint]) -> Array[QPoint]:
	var v_min := Vector2.INF
	var v_max := -Vector2.INF
	for p in ps:
		v_min = v_min.min(p.position)
		v_max = v_max.max(p.position)
	var vdiff := v_max - v_min
	var s := maxf(vdiff.x, vdiff.y) # / (LUT_SIZE - 1)
	var scaled: Array[QPoint] = []
	for p in ps:
		scaled.append(p.new_in_same_stroke((p.position - v_min) / s))
	return scaled


func compute_lut(ps: Array[QPoint]) -> PackedInt32Array:
	const m := QDollarUtils.LUT_SIZE
	var new_lut: PackedInt32Array = []
	new_lut.resize(m * m)
	for x in m:
		for y in m:
			var b := INF
			var index := -1
			for i in ps.size():
				var p := ps[i]
				var d := (p.int_pos / QDollarUtils.LUT_SCALE_FACTOR).round().distance_squared_to(Vector2(x, y))
				if d < b:
					b = d
					index = i
			new_lut[x * m + y] = index
	return new_lut


func path_length(p: Array[QPoint]) -> float:
	var d := 0.
	var p0 := p[0]
	for i in p.size() - 1:
		var p1 := p[i + 1]
		if p0.in_same_stroke_as(p1):
			d = d + p0.distance_to(p1)
		p0 = p1
	return d


func make_int_coords(ps: Array[QPoint]) -> Array[QPoint]:
	var new_ps: Array[QPoint] = []
	for p in ps:
		p.int_pos = Vector2i(((p.position + Vector2.ONE) / 2. * (QDollarUtils.MAX_INT_COORD - 1)).round())
		new_ps.append(p)
	return new_ps
