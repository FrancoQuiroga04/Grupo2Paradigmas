import personaje.*

class Hechizo {

	var property nombre
	
	method valorMultiplo()
	method criterioLongitudNombre()
	method decimeTuPoder(duenio) = self.criterioLongitudNombre() * self.valorMultiplo()
		
	method esPoderoso(duenio) = self.decimeTuPoder(duenio) > 15
	
	method cualEsElTotalPara(unPersonaje) {
		if (unPersonaje.hechizoPreferido().precioEnMonedas(unPersonaje) / 2 >= self.precioEnMonedas(unPersonaje)) {
			return 0
			} else{
		return self.precioEnMonedas(unPersonaje)
		}
	}
	
	method adquiridoPor(unPersonaje, aUnComerciante, importe){	
		if (unPersonaje.hechizoPreferido().precioEnMonedas() / 2 >= self.precioEnMonedas(unPersonaje)) {
			unPersonaje.hechizoPreferido(self)
		} else if (unPersonaje.monedas() + ( unPersonaje.hechizoPreferido().precioEnMonedas() / 2 ) >= self.precioEnMonedas(unPersonaje)) {
			unPersonaje.monedas(unPersonaje.monedas() - ( self.precioEnMonedas(unPersonaje) - unPersonaje.hechizoPreferido().precioEnMonedas() - aUnComerciante.impuestoAPagar(importe)))
			unPersonaje.hechizoPreferido(self)
		}	
	}
	
	method pesoExtra(duenio) {
		if ((self.decimeTuPoder(duenio)) % 2){
			return 2}
			else{	
		} return 0
	}
	method precioEnMonedas(duenio) = self.decimeTuPoder(duenio)
}

class HechizoDeLogos inherits Hechizo {

	override method valorMultiplo() = 1
	
	override method criterioLongitudNombre() = self.nombre().size() 

}

class HechizoBasico inherits Hechizo  {
	override method criterioLongitudNombre() = 10
	override method valorMultiplo() = 1
	override method esPoderoso(duenio) = false

}

class HechizoComercial inherits Hechizo{
	
	
	method nuevoNombre(nombre) = self.nombre(nombre)
	
	override method valorMultiplo() = 2
	
	override method criterioLongitudNombre() = (self.nombre().size() / 100) * self.nombre().size()
	
}
	

object libroDeHechizos {

	var property hechizos = []

	method agregarHechizos(agregar) {
		hechizos.addAll(agregar)
	}

	method filtrarPoderosos() = self.hechizos().filter({ hechizo => hechizo.esPoderoso() })

	method decimeTuPoder(duenio) = self.hechizos().sum({ hechizo => hechizo.decimeTuPoder(duenio)}) 
}
