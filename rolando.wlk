import artefactos.*
import hechizo.*
 
object rolando {

    var valorDeFuerzaOscura= 5
    var valorBaseDeHechiceria = 3
    var hechizoPreferido = espectroMalefico
    var valorBaseDeLucha = 1
    var artefactos = [collarDivino, espadaDelDestino, mascaraOscura]
    
    method cambiarValorBase(nuevoValor){
    	valorBaseDeLucha = nuevoValor
    }
    
    method decimeTuValorDeFuerzaOscura() = valorDeFuerzaOscura
    
        	method eclipse() { 
		valorDeFuerzaOscura = valorDeFuerzaOscura * 2 
	}
    
    	method cambiaTuHechizoPreferido(hechizo) {
		hechizoPreferido = hechizo
	}
	
	   method modificarValorBaseDeLucha(cantidad){
    	valorBaseDeLucha = cantidad	
    }
    
    method quitarUnArtefacto(unArtefacto) {
    	artefactos.remove(unArtefacto)
    }
 
	method agregarArtefactos(nuevosArtefactos){
    	artefactos.clear()
    	artefactos.addAll(nuevosArtefactos)
    }
    
    method agregarArtefacto(unArtefacto) {
    	artefactos.add(unArtefacto)
    }
    
    method eliminarArtefactos()= artefactos.clear()

    method artefactos() = artefactos
    
	method nivelHechiceria() = (valorBaseDeHechiceria * hechizoPreferido.poder()) + valorDeFuerzaOscura  
	
	method seCreePoderoso() = hechizoPreferido.esPoderoso()
	
	method habilidadLucha() = self.artefactos().sum({artefacto=>artefacto.sumaHabilidad()}) + valorBaseDeLucha 
	
	method tieneMasHabilidadQueNivelDeHechiceria() = self.habilidadLucha() > self.nivelHechiceria()
	
	method estaCargado()= self.artefactos().size() >= 5 

	method mejorArtefacto() = self.artefactos().max({artefacto => artefacto.sumaHabilidad()})
	
}
