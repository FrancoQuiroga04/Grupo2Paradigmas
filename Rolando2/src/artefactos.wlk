import personaje.*
import hechizo.*

class Artefacto{
	
	var property peso
	
	var property diasDesdeQueSeComproElArtefacto
	
	method pesoExtra(duenio)
	
	method precioEnMonedas(duenio)
	
	method desgaste() = (diasDesdeQueSeComproElArtefacto / 1000).min(1)
	
	method pesoTotal(duenio) = self.peso() + self.pesoExtra(duenio)
	method pesoConDesgaste(duenio) = self.pesoTotal(duenio) - self.desgaste()	
	
	method cualEsElTotalPara(unPersonaje) = self.precioEnMonedas(unPersonaje)
	
	method adquiridoPor(unPersonaje, unComerciante, importe){
		unPersonaje.agregateUnArtefacto(self)
		unPersonaje.monedas(unPersonaje.monedas() - self.precioEnMonedas(unPersonaje) - unComerciante.impuestoAPagar(importe))
	}
		
}

class Arma inherits Artefacto {

	method decimeTuPoder(duenio) = 3
	
	override method precioEnMonedas(duenio) = self.pesoTotal(duenio) * 5	
	
	override method pesoExtra(duenio) = 0
	

}

class CollarDivino inherits Artefacto{

	var property cantidadDePerlas = 5
	
	override method precioEnMonedas(duenio) = self.cantidadDePerlas() * 2
	
	method decimeTuPoder(duenio) = cantidadDePerlas
	
	override method pesoExtra(duenio) = self.cantidadDePerlas()
}

class MascaraOscura inherits Artefacto {

	var property indiceDeOscuridad = 1

	var property minimoDePoder = 4
	
	method decimeTuPoder(duenio) = ((fuerzaOscura.valor() / 2) * (self.indiceDeOscuridad())).min(self.minimoDePoder())	
	  
	override method pesoExtra(duenio) {
		if ((self.decimeTuPoder(duenio)) > 3){
			return self.decimeTuPoder(duenio) - 3
		} else{
			return 0
		}
	} 
	
	override method precioEnMonedas(duenio) = 10 * self.indiceDeOscuridad()
}
