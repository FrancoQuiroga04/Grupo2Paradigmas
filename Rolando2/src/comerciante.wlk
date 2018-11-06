import artefactos.*
import hechizo.*

class Comerciante{
	const property nombre
	var property comision
	var property tipoDeComerciante
		
	method cambiarTipoDeComerciante(tipo){
		tipoDeComerciante = tipo
	}

}

class ComercianteIndependiente inherits Comerciante {
	
	method impuestoAPagar(importe) = self.comision()
	method recategorizar(unComerciante){
		self.comision(comision * 2)
	} 
	
}

class ComercianteRegistrado inherits Comerciante {
	method impuestoAPagar(importe) =  0.21 * importe
	method recategorizar(unComerciante){
		unComerciante.cambiarTipoDeComerciante(new ComercianteConImpuestoALasGanancias())
	} 
	
}

class ComercianteConImpuestoALasGanancias inherits Comerciante {

	var property minimoNoImponible
	method impuestoAPagar(importe) {
		
		if (importe < self.minimoNoImponible() ){
			return 0
			}else{
				return (importe - self.minimoNoImponible()) * 0.35
				}
		}
		
		method recategorizar(unComerciante){
	} 
		
}
	
