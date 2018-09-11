import rolando.*
import hechizo.*

object cotaDeMalla {
	method valor()= 1
	
}

object bendicion {
	method valor()= rolando.nivelHechiceria()
}

object hechizoRefuerzo {
	
	var hechizoPreferido 
	
	method agregarHechizo(hechizo) {
		hechizoPreferido = hechizo
	}
	
	method valor() = hechizoPreferido.poder()
	
}


