{-# LANGUAGE NoMonomorphismRestriction #-}
import Text.Show.Functions
import Data.List
import Data.Maybe
import Test.Hspec

type Nombre = String
type Dinero = Float
type Billetera = Float
type Evento = Dinero -> Billetera -> Billetera
type EventoB = Billetera -> Billetera

data Usuario = Usuario {
nombre :: Nombre,
dinero :: Dinero
} deriving (Show, Eq)

deposito :: Evento

deposito billetera = (+) billetera

extraccion :: Evento

extraccion extraerdinero billetera  = max 0 (billetera - extraerdinero)

upgrade :: EventoB

--- ver que hacer con esto
upgrade billetera  = billetera * 1.2

cierrecuenta :: Evento

cierrecuenta billetera dinero = 0

quedaigual :: Evento

quedaigual billetera dinero = id billetera

pepe = Usuario "Jose" 10
semilla = Usuario "semilla" 0
--de prueba para ver si funca al aplicar bloque1
prueba = Usuario "prueba" 20
lucho = Usuario "Luciano" 2
pepe2 = Usuario "Jose" 20

type Transaccion = Evento -> Billetera -> Usuario -> String -> Billetera

transaccion :: Transaccion

transaccion nombreTransaccion cantidadDinero usuario nombreaComparar |  nombre usuario == nombreaComparar = nombreTransaccion (dinero usuario) cantidadDinero
                                                                     |  otherwise = id (dinero usuario)


transaccioncierre :: Usuario -> String -> Billetera

transaccioncierre usuario nombreaComparar | nombre usuario == nombreaComparar = cierrecuenta (dinero usuario) 0
                                          | otherwise = id (dinero usuario)

type TransacciondePrueba = Usuario -> Billetera

transaccion1 :: TransacciondePrueba

transaccion1 usuario = transaccioncierre usuario "Luciano"

transaccion2 :: TransacciondePrueba

transaccion2 usuario = transaccion deposito 5 usuario "Jose"


--esto estaba como aplicacion parcial sin guardas, pero para que funcione el bloque, no queda otra que poner guardas..
tocoymevoy usuario | nombre usuario == "Luciano" = (cierrecuenta 0 . upgrade . deposito 15) (dinero usuario)
                   | otherwise = id dinero usuario

--lo mismo acá
ahorranteerrante usuario | nombre usuario == "Luciano" = (deposito 10 . upgrade . deposito 8 . extraccion 1 . deposito 2 . deposito 1) (dinero usuario)
                         | otherwise= id dinero usuario


transaccion3 :: TransacciondePrueba

transaccion3 usuario= tocoymevoy usuario

transaccion4 :: TransacciondePrueba

transaccion4 usuario= ahorranteerrante (usuario)

transacciondeunidades cantidad deusuario1 ausuario2 usuarioaComparar | nombre usuarioaComparar == nombre ausuario2 = deposito cantidad (dinero usuarioaComparar)
                                                              | nombre usuarioaComparar == nombre deusuario1 = extraccion cantidad (dinero usuarioaComparar)
                                                              | otherwise = id (dinero usuarioaComparar)

transaccion5 deusuario1 ausuario2 usuarioaComparar = transacciondeunidades 7 deusuario1 ausuario2 usuarioaComparar

--Para que sea del mismo tipo que el resto hago esta transaccion5aux, pero para que cumpla con el enunciado y las verificaciones que pide la primera parte, la estructura debería ser la otra, ver que hacer con esto
transaccion5aux :: TransacciondePrueba
transaccion5aux usuario = transacciondeunidades 7 pepe lucho usuario

--funcionan al aplicarse las 3 transacciones, falta codear la verificacion y el tipo
estadoLuegoDe transaccion usuario = usuario { dinero = transaccion usuario }

estadoTransacciones transaccion1 transaccion2 usuario = usuario { dinero = transaccion1 ((estadoLuegoDe transaccion2) usuario) }

-- bloque + user aplicacion parcial

--funciona, bloque1 pepe da 17, falta codear la verificacion y el tipo

--recibe transacciones como lista

--bloque [estadoLuegoDe transaccion2, estadoLuegoDe transaccion2] pepe
bloque = foldr (.) id

--- bloque 1 usuario, y bloque lista usuario
bloque1 =  bloque [estadoLuegoDe transaccion3, estadoLuegoDe transaccion5aux, estadoLuegoDe transaccion4,  estadoLuegoDe transaccion3, estadoLuegoDe transaccion2, estadoLuegoDe transaccion2, estadoLuegoDe transaccion2, estadoLuegoDe transaccion1 ]

---- funciona con pepe lucho, tira pepe; pasa lista por ap. parcial
mayoresaN n = filter ((> n) . dinero . bloque1)


--funciona, falta codear la verificacion y el tipo
-- bloque 2 usuario: y bloque lista usuario
bloque2  =  bloque [estadoLuegoDe transaccion2, estadoLuegoDe transaccion2, estadoLuegoDe transaccion2,  estadoLuegoDe transaccion2, estadoLuegoDe transaccion2]

--funciona, da el mismo numero que dice en la parte de verificar, falta codear la verificacion y el tipo

--blockchain [bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque2] pepe
blockchain  = foldr (.) id

--estadoBilletera 3 [bloque2, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1] pepe
estadoBilletera n lista =  foldr (.) id (take n lista)


--pepe 115
blockchain1  = blockchain [bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque2]

--cadenaUsuarios [pepe, lucho] blockchain1
cadenaUsuarios lista nrodeblockchain= map nrodeblockchain lista



--funciona tipo : mayor bloque1 [pepe,lucho]

menor nrodebloque [x] = dinero (nrodebloque x)
menor nrodebloque (x:y:xs)  = min (dinero (nrodebloque x)) (menor nrodebloque (y:xs))
menosAdinerado nrodebloque lista = filter ( ((==) (menor nrodebloque lista )) . (dinero) . nrodebloque ) lista


--peorBloque [x] usuario = dinero (nrodebloque x)


--peorBloque (x:y:xs) usuario  = min (x usuario) (peorBloque (y:xs) usuario)

peorBloque [x] usuario = dinero (x usuario)
--peorBloque [bloque1, bloque2] pepe
peorBloque (x:y:xs) usuario  = min (dinero (x usuario) ) (peorBloque (y:xs) usuario)


--esto creo que no tendria logica porque nunca se guarda el nombre del bloque, entonces es imposible; elpeorBloque listadebloques usuario = filter  ((==) (peorBloque listadebloques usuario) . (dinero) . usuario ) listadebloques
--menosAdinerado nrodebloque lista = filter ( ((==) (menor nrodebloque lista )) . (dinero) . nrodebloque )  lista


mayor nrodebloque [x]  = dinero (nrodebloque x)
mayor nrodebloque (x:y:xs)  = max (dinero (nrodebloque x)) (mayor nrodebloque (y:xs) )
--masAdinerado bloque1 [pepe, lucho]
masAdinerado nrodebloque lista = filter ( ((==) (mayor nrodebloque lista )) . (dinero) . nrodebloque ) lista

guita usuario bloque = dinero (bloque usuario)



--tomar n usuario bloques =

testeo = hspec $ do
describe "Eventos sobre billetera de 10 monedas" $ do
it "Depositar 10 a una billetera de 10 monedas" $ deposito 10 10 `shouldBe` 20
it "Extraer 3 a una billetera de 10 monedas" $ extraccion 3 10 `shouldBe` 7
it "Extraer 15 a una billetera de 10 monedas" $ extraccion 15 10 `shouldBe` 0
it "Upgrade a una billetera de 10 monedas" $ upgrade 10 `shouldBe` 12
it "Cierre de cuenta a una billetera de 10 monedas" $ cierrecuenta 10 0 `shouldBe` 0
it "Queda igual a una billetera de 10 monedas" $ quedaigual 10 0 `shouldBe` 10
it "Depositar 1000 y tener un Upgrade a una billetera de 10 monedas" $ ((upgrade . deposito 1000) 10) `shouldBe` 1212

describe "Usuarios" $ do
it "Consulto la billetera de pepe" $ (dinero pepe) `shouldBe` 10
it "Cual es la billetera de pepe luego de un cierre de cuenta" $ cierrecuenta (dinero pepe) 0 `shouldBe` 0
it "¿Cómo quedaría la billetera de Pepe si le depositan 15 monedas, extrae 2, y tiene un Upgrade?" $ ((upgrade . extraccion 2 . deposito 15)(dinero pepe)) `shouldBe` 27.6

describe "Transacciones" $ do
it "Aplicar la transaccion 1 a Pepe" $ transaccion1 pepe `shouldBe` 10
it "Aplicar la transaccion 2 a Pepe" $ transaccion2 pepe `shouldBe` 15
it "Aplicar la transaccion 2 a Pepe 2" $ transaccion2 pepe2 `shouldBe` 25
it "Aplicar la transaccion 2 a una billetera de 50 monedas" $ transaccion2 (Usuario "Jose" 50) `shouldBe` 55

describe "Nuevos eventos" $ do
it "Aplicar la transaccion 3 a Lucho" $ transaccion3 lucho `shouldBe` 0
it "Aplicar la transaccion 4 a Lucho" $ transaccion4 lucho `shouldBe` 24.400002
it "Aplicar la transaccion 3 a una billetera inicial de 10 monedas" $ transaccion3 (Usuario "Testing" 10) `shouldBe` 10
it "Aplicar la transaccion 4 a una billetera inicial de 10 monedas" $ transaccion4 (Usuario "Testing" 10) `shouldBe` 10

describe "Pagos entre usuarios" $ do
it "Aplicar la transaccion 5 a Pepe" $ transaccion5 pepe lucho pepe `shouldBe` 3
it "Aplicar la transaccion 5 de una billetera de 10 monedas a lucho, sobre la billetera de 10 monedas" $ transaccion5 (Usuario "Testing" 10) lucho (Usuario "Testing" 10)  `shouldBe` 3
it "Aplicar la transaccion 5 a Lucho" $ transaccion5 pepe lucho lucho `shouldBe` 9
it "Aplicar la transaccion 5 de pepe a una billetera de 10 monedas" $ transaccion5 pepe (Usuario "Testing" 10) (Usuario "Testing" 10) `shouldBe` 17
