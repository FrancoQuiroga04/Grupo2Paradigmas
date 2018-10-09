import personaje.*

class Hechizo {

	var property nombre

}

class HechizoDeLogos inherits Hechizo {

	var property valorMultiplo = 1

	method precioEnMonedas() = self.decimeTuPoder()

	method decimeTuPoder() = self.nombre().size() * self.valorMultiplo()

	method esPoderoso() = self.decimeTuPoder() > 15

}

class HechizoBasico inherits Hechizo {

	const property precioEnMonedas = 10

	method decimeTuPoder() = 10

	method esPoderoso() = false

}

object libroDeHechizos {

	var property hechizos = []

	method agregarHechizos(agregar) {
		hechizos.addAll(agregar)
	}

	method filtrarPoderosos() = self.hechizos().filter({ hechizo => hechizo.esPoderoso() })

	method decimeTuPoder() = self.hechizos().sum({ hechizo => hechizo.decimeTuPoder() })

	method precioEnMonedas() = self.hechizos().size() * 10 + self.filtrarPoderosos().sum({ hechizoPoderoso => hechizoPoderoso.decimeTuPoder() })

}