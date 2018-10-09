import personaje.*
import hechizo.*

class Arma {

	method decimeTuPoder() = 3

	method precioEnMonedas() = self.decimeTuPoder() * 5

}

object collarDivino {

	var property cantidadDePerlas = 5

	method precioEnMonedas() = self.cantidadDePerlas() * 2

	method decimeTuPoder() = cantidadDePerlas

}

object mascaraOscura {

	var property indiceDeOscuridad = 1
	var property minimoDePoder = 4

	method decimeTuPoder() = ((fuerzaOscura.valor() / 2) * (self.indiceDeOscuridad())).min(self.minimoDePoder())

}