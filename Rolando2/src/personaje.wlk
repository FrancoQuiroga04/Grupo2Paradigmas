import artefactos.*
import hechizo.*
import armadura.*
 
class Personaje {

	var valorBaseDeHechiceria = 3
	var property hechizoPreferido
	var property valorBaseDeLucha = 1
	var property monedas = 100
	var artefactos = []

	method quitarUnArtefacto(unArtefacto) {
		artefactos.remove(unArtefacto)
	}

	method agregateVariosArtefactos(nuevosArtefactos) {
		artefactos.addAll(nuevosArtefactos)
	}

	method agregateUnArtefacto(unArtefacto) {
		artefactos.add(unArtefacto)
	}

	method eliminarArtefactos() = artefactos.clear()

	method artefactos() = artefactos

	method valorDeHechiceria() = (valorBaseDeHechiceria * hechizoPreferido.decimeTuPoder()) + fuerzaOscura.valor()

	method seCreePoderoso() = hechizoPreferido.esPoderoso()

	method decimeTuHabilidadParaLucha() = self.artefactos().sum({ artefacto => artefacto.decimeTuPoder() }) + self.valorBaseDeLucha()

	method tieneMasHabilidadQueNivelDeHechiceria() = self.decimeTuHabilidadParaLucha() > self.valorDeHechiceria()

	method decimeSiEstasCargado() = self.artefactos().size() >= 5

	method mejorArtefacto() = self.artefactos().max({ artefacto => artefacto.decimeTuPoder() })

	method cumpliUnObjetivo() {
		monedas += 10
	}

	method comprateUnArtefacto(artefacto) {
		if (self.monedas() >= artefacto.precioEnMonedas()) {
			self.agregateUnArtefacto(artefacto)
			self.monedas(self.monedas() - artefacto.precioEnMonedas())
		}
	}

	method canjeaTuHechizo(hechizoNuevo) {
		if (self.hechizoPreferido().precioEnMonedas() / 2 >= hechizoNuevo.precioEnMonedas()) {
			self.hechizoPreferido(hechizoNuevo)
		} else if (self.monedas() + ( self.hechizoPreferido().precioEnMonedas() / 2 ) >= hechizoNuevo.precioEnMonedas()) {
			self.monedas(self.monedas() - ( hechizoNuevo.precioEnMonedas() - self.hechizoPreferido().precioEnMonedas() ))
			self.hechizoPreferido(hechizoNuevo)
		}
	}

}

object fuerzaOscura {

	var property valor = 5

	method provocaUnEclipse() {
		valor = valor * 2
	}

}