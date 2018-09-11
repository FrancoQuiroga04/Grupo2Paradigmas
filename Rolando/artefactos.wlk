import rolando.*
import hechizo.*
import armadura.*

object espadaDelDestino{
 method sumaHabilidad()= 3
}

object collarDivino{
 var cantidadDePerlas = 5
 method cambiarCantidadDePerlas(cantidad){
 	cantidadDePerlas = cantidad
 }
 
 method sumaHabilidad()= cantidadDePerlas
}
 
object mascaraOscura{

 method sumaHabilidad()= (rolando.decimeTuValorDeFuerzaOscura() / 2).max(4)
} 

object armadura{
 var refuerzo
 
 method agregarRefuerzo(unRefuerzo){
  refuerzo = unRefuerzo
 } 

 method sumaHabilidad()= 2 + refuerzo.valor()

} 

object espejo{

 method sumaHabilidad()= if (rolando.artefactos() == [self]){
 	return 0
 	}else{
 		rolando.artefactos().filter({unArtefacto => unArtefacto == self}).map(
 			{unArtefacto => unArtefacto.sumaHabilidad()}).max()
 }
}

object libroDeHechizos{
 
 const hechizos = []

 method agregarHechizos(agregar){
  hechizos.addAll(agregar)
 } 
 
 method hechizos()= hechizos
 
 method filtrarPoderosos() = self.hechizos().filter({hechizo => hechizo.esPoderoso()})
 	
 method sumaHabilidad()= self.filtrarPoderosos().sum({hechizoPoderoso=>hechizoPoderoso.poder()})
 
}
