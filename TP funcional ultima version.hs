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

type BloqueUsuario = [Usuario -> Evento] -> Usuario -> Usuario
type Bloque = [Usuario -> Evento]

--bloque bloque1 pepe
bloque :: BloqueUsuario
bloque lista usuario  = foldr estadoUsuarioLuegoDe usuario lista

bloque1 :: Bloque
bloque1 = [transaccion3 , transaccion5 , transaccion4 ,  transaccion3 , transaccion2 , transaccion2 , transaccion2, transaccion1]

bloque2 :: Bloque
bloque2  =  [transaccion2, transaccion2, transaccion2, transaccion2, transaccion2]

--mayoresaN 12 bloque1 [pepe, lucho]
mayoresaN :: Float -> Bloque -> [Usuario] -> [Usuario]
mayoresaN n transacciones = filter ((> n) . billetera . bloque transacciones)

--mayor bloque1 [pepe, lucho]
aplicarCadena bloqueaAplicar usuarios = map (bloque bloqueaAplicar) usuarios
mayor bloqueaAplicar usuarios = maximum (map billetera (aplicarCadena bloqueaAplicar usuarios))
menor bloqueaAplicar usuarios = minimum (map billetera (aplicarCadena bloqueaAplicar usuarios))

--determinarUsuario mayor bloque1 [pepe, lucho, pepe2]
determinarUsuario :: (Bloque -> [Usuario] -> Billetera ) -> Bloque -> [Usuario] -> Usuario
determinarUsuario criterio bloqueaAplicar usuarios = fromJust (find ( ((==) (criterio bloqueaAplicar usuarios )) . billetera . bloque bloqueaAplicar ) usuarios)

--blockchain [bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque2] pepe
type BlockChain = [Bloque] -> Usuario -> Usuario
blockchain :: BlockChain
blockchain lista usuario = foldr bloque usuario lista

type Cadenaejemplo = [Bloque]
blockchain1 :: Cadenaejemplo
blockchain1  = [bloque2, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1]

--cadenaUsuarios blockchain1 [pepe, lucho]
cadenaUsuarios :: [Bloque] -> [Usuario] -> [Usuario]
cadenaUsuarios cadenabloques = map (blockchain cadenabloques)

peorBloque [x] usuario = billetera (blockchain [x] usuario)
peorBloque (x:y) usuario  = min (billetera (blockchain [x] usuario) ) (peorBloque (y) usuario)

-- con : no compila
-- chainInfinita [bloque1]
type ChainInfinita = Cadenaejemplo -> [Cadenaejemplo]
chainInfinita :: ChainInfinita
chainInfinita bloque= [bloque] ++ (chainInfinita (bloque ++ bloque))

-- recorrerCadenaInfinita (chainInfinita [bloque1]) pepe 11
recorrerCadenaInfinita (x:y) usuario cantidadNecesaria = take cantidadNecesaria (blockchain x usuario : recorrerCadenaInfinita y usuario cantidadNecesaria)
listadeBilleteras (x:y) usuario cantidadNecesaria= maximum (map (billetera) (recorrerCadenaInfinita (x:y) usuario cantidadNecesaria))

--cantidadCreditos (chainInfinita [bloque1]) pepe 5 0
cantidadCreditos cadenaInfinita usuario creditosaComparar i | (listadeBilleteras cadenaInfinita usuario (i+1) ) <= creditosaComparar =  cantidadCreditos cadenaInfinita usuario creditosaComparar (i+1)
                                                            | otherwise = i

--saldoHistoria 3 [bloque1, bloque1, bloque1, bloque1] pepe
saldoHistoria :: Int -> [Bloque] -> Usuario -> Billetera
infinitaUsuario n (x:xs) usuario  = take n (billetera (blockchain [x] usuario) : infinitaUsuario n xs usuario)
saldoHistoria primerosN cadenaBloques usuario = sum (infinitaUsuario primerosN cadenaBloques usuario)

sumatoria n bloque usuario = saldoHistoria n bloque usuario
