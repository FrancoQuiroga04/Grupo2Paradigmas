{-# LANGUAGE NoMonomorphismRestriction #-}
import Text.Show.Functions
import Data.List
import Data.Maybe


type Nombre = String
type Dinero = Float
type Billetera = Float
type Evento = Billetera -> Billetera


data Usuario = Usuario {
nombre :: Nombre,
billetera :: Billetera
} deriving (Show, Eq)

--Tengo mis dudas con deposito, esta bien definida, pero se supone que tiene que ser de tipo evento SOLAMENTE y no se me ocurre como hacer para que
--quede de esa forma. Igualmente compila todo, tendriamos que arreglar los tests y ver si en serio hace lo que queremos.
deposito :: Dinero -> Evento
deposito = (+)

--Lo mismo aca
extraccion :: Dinero -> Evento
extraccion dineroAextraer billetera  = max 0 (billetera - dineroAextraer)


upgrade :: Evento
upgrade billetera = billetera * 1.2


cierrecuenta :: Evento
cierrecuenta billetera = 0


quedaigual :: Evento
quedaigual = id

pepe = Usuario "Jose" 10
lucho = Usuario "Luciano" 2
pepe2 = Usuario "Jose" 20

--Esta funcion sirve para comparar usuarios, sea cual sea el dato por el cual se los compare.
funcionComparaUsuarios :: Eq a => ( Usuario -> a ) -> Usuario -> Usuario -> Bool
funcionComparaUsuarios funcionQueObtieneDatoDelUsuario usuario1 usuario2 = funcionQueObtieneDatoDelUsuario usuario1 == funcionQueObtieneDatoDelUsuario usuario2

type Transaccion = Usuario -> Evento
transaccion :: Evento -> Usuario -> Usuario -> Evento
transaccion evento usuario usuarioAcomparar |  funcionComparaUsuarios nombre usuario usuarioAcomparar = evento
                                            |  otherwise = quedaigual



transaccion1 :: Transaccion
transaccion1 usuario = transaccion cierrecuenta usuario lucho

transaccion2 :: Transaccion
transaccion2 usuario = transaccion (deposito 5) usuario pepe


tocoYmeVoy :: Evento
tocoYmeVoy = (cierrecuenta. upgrade . (deposito 15))

ahorranteErrante :: Evento
ahorranteErrante = ((deposito 10) . upgrade . (deposito 8) . (extraccion 1) . (deposito 2) . (deposito 1))


transaccion3 :: Transaccion
transaccion3 usuario = transaccion tocoYmeVoy usuario lucho

transaccion4 :: Transaccion
transaccion4 usuario = transaccion ahorranteErrante usuario lucho


transaccionDeTransferencia :: Dinero -> Usuario -> Usuario -> Usuario -> Evento
transaccionDeTransferencia cantidad deUsuario1 aUsuario2 usuarioAlQueSeLeAplica | funcionComparaUsuarios nombre usuarioAlQueSeLeAplica aUsuario2 = deposito cantidad
                                                              | funcionComparaUsuarios nombre usuarioAlQueSeLeAplica deUsuario1 = extraccion cantidad
                                                              | otherwise = quedaigual



transaccion5 :: Transaccion
transaccion5 usuarioAlQueSeLeAplica = transaccionDeTransferencia 7 pepe lucho usuarioAlQueSeLeAplica


--Con esta funcion, se crea el evento y se aplica a la billetera del usuario, y ahi funciona con todos los casos de la parte 1 y te muestra como queda el usuario con la billetera

estadoUsuarioLuegoDe :: Transaccion -> Usuario -> Usuario
estadoUsuarioLuegoDe transaccion usuario = usuario { billetera = (transaccion usuario) (billetera usuario) }


--Como se hace la cadena de transacciones ahora?

--Esto teniamos antes

--bloque = foldr (.) id

-- aca lo que hacia es que cada transaccion te devolvía una billetera; y despues con estadoLuegoDe te tira el usuario completo; y cuando terminaba el boque te devolvía el usuario con la billetera modificada
--bloque1 :: Usuario -> Usuario
--bloque1 =  bloque [estadoLuegoDe transaccion3, estadoLuegoDe transaccion5, estadoLuegoDe transaccion4,  estadoLuegoDe transaccion3, estadoLuegoDe transaccion2, estadoLuegoDe transaccion2, estadoLuegoDe transaccion2, estadoLuegoDe transaccion1]

-- pero ahora cada transacccion devuelve un evento; y lo del estadoLuegoDe el profe dijo que tenia que ser nada mas las transacciones;

bloque1 =  [transaccion3, transaccion5, transaccion4,  transaccion3, transaccion2, transaccion2, transaccion2, transaccion1]
