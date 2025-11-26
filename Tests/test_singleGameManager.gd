extends "res://addons/gut/test.gd"

func test_add_points_incrementa_contadores_y_devuelve_array() -> void:
	var SGM = load("res://Scripts/SingleGameManager.gd")
	var sgm = SGM.new()

	# Estado inicial
	sgm.points_total = 0
	sgm.points_level = 0

	var result: Array[int] = sgm.add_points()

	assert_eq(sgm.points_total, 1, "points_total debe incrementarse en 1")
	assert_eq(sgm.points_level, 1, "points_level debe incrementarse en 1")
	assert_eq(result, [1, 1], "La función debe devolver [1, 1]")


func test_add_points_da_vida_extra_al_llegar_a_10() -> void:
	var SGM = load("res://Scripts/SingleGameManager.gd")
	var sgm = SGM.new()

	# Preparamos el estado para que al sumar 1 llegue a 10
	sgm.points_total = 9
	sgm.points_level = 9

	var result: Array[int] = sgm.add_points()

	# Ahora debería tener 10 puntos totales y de nivel
	assert_eq(sgm.points_total, 10, "points_total debería ser 10")
	assert_eq(sgm.points_level, 10, "points_level debería ser 10")

	# Y el retorno debe coincidir
	assert_eq(result, [10, 10], "El valor devuelto debe ser [10, 10]")
