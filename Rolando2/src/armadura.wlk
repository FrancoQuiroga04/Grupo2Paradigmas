import personaje.*
import hechizo.*
import artefactos.*

class Armadura inherits Artefacto{

	var property refuerzo
	var property valorBase = 5

	method decimeTuPoder(duenio) = if (self.refuerzo() == null) {
		return 0
	} else {
		return self.refuerzo().decimeTuPoder(duenio)
	}
	
	override method precioEnMonedas(duenio) = self.refuerzo().precioEnMonedas()
	override method pesoExtra(duenio) = self.refuerzo().pesoExtra(duenio)
}

object ningunRefuerzo inherits Artefacto{
	
	method decimeTuPoder(duenio) = 0
	override method precioEnMonedas(duenio)= 2
	override method pesoExtra(duenio) = 0

}

class CotaDeMalla inherits Artefacto  {

	var property poder
	method decimeTuPoder(duenio) = poder

	override method precioEnMonedas(duenio) = self.decimeTuPoder(duenio) / 2
	override method pesoExtra(duenio) = 1

}

class Bendicion inherits Artefacto {
	
	var property armadura
	method decimeTuPoder(duenio) = duenio.valorDeHechiceria()	
	override method precioEnMonedas(duenio) = self.armadura().valorBase() 
	override method pesoExtra(duenio) = 0

}

class Espejo inherits Artefacto {
	
	method decimeTuPoder(duenio) = if (duenio.artefactos() == [self]) {
		return 0
	} else {
		duenio.artefactos().filter({ unArtefacto => unArtefacto != self}).map({ unArtefacto => unArtefacto.decimeTuPoder(duenio)}).max()
	}
	override method precioEnMonedas(duenio) = 90
	override method pesoExtra(duenio) = 0
}
