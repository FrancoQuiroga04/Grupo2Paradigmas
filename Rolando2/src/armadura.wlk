import personaje.*
import hechizo.*
import artefactos.*

class Armadura inherits Artefacto{

	var property refuerzo
	var property valorBase = 5

	method decimeTuPoder(duenio) = self.refuerzo().decimeTuPoder(duenio)
	
	override method precioEnMonedas(duenio) = self.refuerzo().precioEnMonedas()
	override method pesoExtra(duenio) = self.refuerzo().pesoExtra(duenio) + self.peso()
}

object ningunRefuerzo inherits Artefacto{
	
	method decimeTuPoder(duenio) = 0
	override method precioEnMonedas(duenio)= 2
	override method pesoExtra(duenio) = 0

}

class CotaDeMalla   {

	var property poder
	method decimeTuPoder(duenio) = poder

	method precioEnMonedas(duenio) = self.decimeTuPoder(duenio) / 2
	method pesoExtra(duenio) = 1

}

class Bendicion  {
	
	var property armadura
	method decimeTuPoder(duenio) = duenio.valorDeHechiceria()	
	method precioEnMonedas(duenio) = self.armadura().valorBase() 
	method pesoExtra(duenio) = 0

}

class Espejo  {
	
	method decimeTuPoder(duenio) = if (duenio.artefactos() == [self]) {
		return 0
	} else {
		duenio.artefactosSin(self).max()
	}
	method precioEnMonedas(duenio) = 90
	method pesoExtra(duenio) = 0
}
