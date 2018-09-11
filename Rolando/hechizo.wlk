object espectroMalefico {
	
	var nombre = "Espectro maléfico"
	method poder() = nombre.size()
	method esPoderoso() = nombre.size() > 15

method cambiarNombre(nuevoNombre) {
		nombre = nuevoNombre
	}	
}

object hechizoBasico {
	
	method poder() = 10	
	method esPoderoso() = false
}