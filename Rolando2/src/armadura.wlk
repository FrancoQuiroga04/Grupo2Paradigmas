import personaje.*
import hechizo.*

class Armadura {

	var property refuerzo
	var property duenio

	method decimeTuPoder() = if (self.refuerzo() == null) {
		return 0
	} else {
		return self.refuerzo().decimeTuPoder()
	}
	
	method precioEnMonedas() = if (self.refuerzo() == null) {
		return 2
	}else{
		return self.refuerzo().precioEnMonedas()
	}

}

class Refuerzo {

	var property armaduraCorrespondiente
	var property duenio

}

class CotaDeMalla inherits Refuerzo {

	var property decimeTuPoder
	method precioEnMonedas() = self.decimeTuPoder() / 2

}

class Bendicion inherits Refuerzo {

	method decimeTuPoder() = self.duenio().valorDeHechiceria()
	method precioEnMonedas() = self.armaduraCorrespondiente().valorBase() 

}

class Espejo inherits Refuerzo {

	method decimeTuPoder() = if (self.duenio().artefactos() == [ self ]) {
		return 0
	} else {
		self.duenio().artefactos().filter({ unArtefacto => unArtefacto != self}).map({ unArtefacto => unArtefacto.decimeTuPoder()}).max()
	}
	
	method precioEnMonedas() = 90

}