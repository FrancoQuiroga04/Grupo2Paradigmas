import artefactos.*
import hechizo.*
import armadura.*
 
class Personaje {

	var valorBaseDeHechiceria = 3
	var property hechizoPreferido
	var property valorBaseDeLucha = 1
	var property monedas = 100
	var property capacidadDeCarga 
	var artefactos = []

	method quitarUnArtefacto(unArtefacto) {
		artefactos.remove(unArtefacto)
	}

	method agregateVariosArtefactos(nuevosArtefactos) {
		artefactos.addAll(nuevosArtefactos)
	}

	method agregateUnArtefacto(unArtefacto) {
		self.lanzaExcepcionSi(self.excedeLaCapacidadTotalCon(unArtefacto), "Excede la capacidad total")
		artefactos.add(unArtefacto)
	}
	
	method excedeLaCapacidadTotalCon(unArtefactoMas) = (self.cuantoEstasCargando() + unArtefactoMas.pesoTotal(self)) >= self.capacidadDeCarga()
	
	method cuantoEstasCargando() = self.artefactos().sum({artefacto => artefacto.pesoTotal(self)})

	method eliminarArtefactos() = artefactos.clear()

	method artefactos() = artefactos

	method valorDeHechiceria() = (valorBaseDeHechiceria * hechizoPreferido.decimeTuPoder(self)) + fuerzaOscura.valor()

	method seCreePoderoso() = hechizoPreferido.esPoderoso(self)

	method decimeTuHabilidadParaLucha() = self.artefactos().sum({ artefacto => artefacto.decimeTuPoder(self) }) + self.valorBaseDeLucha()

	method tieneMasHabilidadQueNivelDeHechiceria() = self.decimeTuHabilidadParaLucha() > self.valorDeHechiceria()

	method decimeSiEstasCargado() = self.artefactos().size() >= 5

	method mejorArtefacto() = self.artefactos().max({ artefacto => artefacto.decimeTuPoder() })
	
	method artefactosSin(unArtefacto) = self.artefactos().filter({ otroArtefacto => otroArtefacto != unArtefacto}).map({ otroArtefacto => otroArtefacto.decimeTuPoder(self)}) 

	method cumpliUnObjetivo() {
		monedas += 10
	}

	method comprar(unProducto, aUnComerciante){
		self.lanzaExcepcionSi(self.teAlcanzaParaComprar(unProducto).negate(), "No alcanza la plata para comprar producto")	
		unProducto.adquiridoPor(self, aUnComerciante, self.averiguarPrecioDelProducto(unProducto))
	}
		
	method averiguarPrecioDelProducto(unProducto) =  unProducto.cualEsElTotalPara(self)
	
	method teAlcanzaParaComprar(unProducto) = self.monedas() > self.averiguarPrecioDelProducto(unProducto)
	
	method lanzaExcepcionSi(condicion, descripcion){
		if (descripcion == "No alcanza la plata para comprar producto"){
			throw new NoSePuedeComprarError(descripcion)
		}else{
			if (descripcion == "Excede la capacidad total"){
				throw new ExcedeCapacidadError(descripcion)
			}
		}
	}
}

class NPC inherits Personaje{
	var property dificultad
	override method decimeTuHabilidadParaLucha() = super() * self.dificultad().valorMultiplo()
}

object nivelFacil{
	var property valorMultiplo = 1	
}

object nivelModerado{
	var property valorMultiplo = 2	
}

object nivelDificil{
	var property valorMultiplo = 4	
}

object fuerzaOscura {

	var property valor = 5

	method provocaUnEclipse() {
		valor = valor * 2
	}

}

class NoSePuedeComprarError inherits Exception {}
class ExcedeCapacidadError inherits Exception {}