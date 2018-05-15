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
billetera :: Billetera
} deriving (Show, Eq)


deposito :: Evento
deposito billetera = (+) billetera


extraccion :: Evento
extraccion dineroAextraer billetera  = max 0 (billetera - dineroAextraer)


upgrade :: EventoB
upgrade billetera = billetera * 1.2


cierrecuenta :: Evento
cierrecuenta billetera dinero = 0


quedaigual :: Evento
quedaigual billetera dinero = id billetera

pepe = Usuario "Jose" 10
lucho = Usuario "Luciano" 2
pepe2 = Usuario "Jose" 20

type Transaccion = Evento -> Dinero -> Usuario -> String -> Billetera

transaccion :: Transaccion
transaccion nombreTransaccion cantidadDinero usuario nombreaComparar |  nombre usuario == nombreaComparar = nombreTransaccion (billetera usuario) cantidadDinero
                                                                     |  otherwise = id (billetera usuario)


type TransacciondePrueba = Usuario -> Billetera

transaccion1 :: TransacciondePrueba
transaccion1 usuario = transaccion cierrecuenta 0 usuario "Luciano"


transaccion2 :: TransacciondePrueba
transaccion2 usuario = transaccion deposito 5 usuario "Jose"


tocoymevoy usuario | nombre usuario == "Luciano" = (cierrecuenta 0 . upgrade . deposito 15) (billetera usuario)
                   | otherwise = id billetera usuario


ahorranteerrante usuario | nombre usuario == "Luciano" = (deposito 10 . upgrade . deposito 8 . extraccion 1 . deposito 2 . deposito 1) (billetera usuario)
                         | otherwise= id billetera usuario


transaccion3 :: TransacciondePrueba

transaccion3 usuario = tocoymevoy usuario

transaccion4 :: TransacciondePrueba

transaccion4 usuario = ahorranteerrante (usuario)

transacciondeunidades cantidad deusuario1 ausuario2 usuarioaComparar | nombre usuarioaComparar == nombre ausuario2 = deposito cantidad (billetera usuarioaComparar)
                                                              | nombre usuarioaComparar == nombre deusuario1 = extraccion cantidad (billetera usuarioaComparar)
                                                              | otherwise = id (billetera usuarioaComparar)



transaccion5 :: TransacciondePrueba
transaccion5 usuario = transacciondeunidades 7 pepe lucho usuario

estadoLuegoDe :: TransacciondePrueba -> Usuario -> Usuario

estadoLuegoDe transaccion usuario = usuario { billetera = transaccion usuario }

estadoTransacciones :: TransacciondePrueba ->  TransacciondePrueba -> Usuario -> Usuario

estadoTransacciones transaccion1 transaccion2 usuario = usuario { billetera = transaccion1 ((estadoLuegoDe transaccion2) usuario) }

--bloque [estadoLuegoDe transaccion2, estadoLuegoDe transaccion2] pepe

type Bloque = [Usuario -> Usuario] -> Usuario ->  Usuario
bloque :: Bloque
bloque = foldr (.) id


--bloque1 pepe da 17
bloque1 :: Usuario -> Usuario
bloque1 =  bloque [estadoLuegoDe transaccion3, estadoLuegoDe transaccion5, estadoLuegoDe transaccion4,  estadoLuegoDe transaccion3, estadoLuegoDe transaccion2, estadoLuegoDe transaccion2, estadoLuegoDe transaccion2, estadoLuegoDe transaccion1]

bloque2 :: Usuario -> Usuario
bloque2  =  bloque [estadoLuegoDe transaccion2, estadoLuegoDe transaccion2, estadoLuegoDe transaccion2,  estadoLuegoDe transaccion2, estadoLuegoDe transaccion2]

---- funciona con pepe lucho, tira pepe; pasa lista por ap. parcial

mayoresaN :: Float -> [Usuario] -> [Usuario]
mayoresaN n = filter ((> n) . billetera . bloque1)

--funciona, da el mismo numero que dice en la parte de verificar, falta codear la verificacion y el tipo
--blockchain [bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque2] pepe

type Blockchain = [Usuario -> Usuario] -> Usuario -> Usuario
blockchain :: Blockchain
blockchain  = foldr (.) id

--estadoBilletera 3 [bloque2, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1] pepe
estadoBilletera :: Int -> [Usuario -> Usuario] -> Usuario -> Usuario
estadoBilletera n lista =  foldr (.) id (take n lista)

--pepe 115
type Cadenaejemplo = Usuario -> Usuario
blockchain1 :: Cadenaejemplo
blockchain1  = blockchain [bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque2]

--cadenaUsuarios blockchain1 [pepe, lucho]
cadenaUsuarios nrodeblockchain lista = map nrodeblockchain lista

--mayor bloque1 [pepe,lucho]

menor nrodebloque [x] = billetera (nrodebloque x)
menor nrodebloque (x:y:xs)  = min (billetera (nrodebloque x)) (menor nrodebloque (y:xs))
menosAdinerado nrodebloque lista = filter ( ((==) (menor nrodebloque lista )) . (billetera) . nrodebloque ) lista

--peorBloque [bloque1, bloque2] pepe
peorBloque [x] usuario = billetera (x usuario)
peorBloque (x:y:xs) usuario  = min (billetera (x usuario) ) (peorBloque (y:xs) usuario)

mayor nrodebloque [x]  = billetera (nrodebloque x)
mayor nrodebloque (x:y:xs)  = max (billetera (nrodebloque x)) (mayor nrodebloque (y:xs) )

--masAdinerado bloque1 [pepe, lucho]
masAdinerado nrodebloque lista = filter ( ((==) (mayor nrodebloque lista )) . (billetera) . nrodebloque ) lista

type ChainInfinita = [Usuario -> Usuario] -> [[Usuario -> Usuario]]

chainInfinita :: ChainInfinita
chainInfinita bloque= [bloque] ++ chainInfinita (bloque ++ bloque)

infinitaUsuario n (x:xs) usuario  = take n (billetera (foldr (.) id x usuario) : infinitaUsuario n xs usuario)

listaUsuario n bloque usuario = last (infinitaUsuario n (chainInfinita bloque) usuario)

-- cantidadCreditos 10000 0 [bloque1] pepe
cantidadCreditos :: Billetera -> Int -> [Usuario -> Usuario] -> Usuario -> Int
cantidadCreditos n i bloque usuario  | (listaUsuario (i+1) bloque usuario) <  n =  cantidadCreditos n (i+1) bloque usuario
                                     | otherwise= i

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
it "Consulto la billetera de pepe" $ (billetera pepe) `shouldBe` 10
it "Cual es la billetera de pepe luego de un cierre de cuenta" $ cierrecuenta (billetera pepe) 0 `shouldBe` 0
it "¿Cómo quedaría la billetera de Pepe si le depositan 15 monedas, extrae 2, y tiene un Upgrade?" $ ((upgrade . extraccion 2 . deposito 15)(billetera pepe)) `shouldBe` 27.6

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
it "Aplicar la transaccion 5 a Pepe" $ transaccion5 pepe `shouldBe` 3
--it "Aplicar la transaccion 5 de una billetera de 10 monedas a lucho, sobre la billetera de 10 monedas" $ transaccion5 (Usuario "Testing" 10) lucho (Usuario "Testing" 10)  `shouldBe` 3
it "Aplicar la transaccion 5 a Lucho" $ transaccion5 pepe `shouldBe` 3
--it "Aplicar la transaccion 5 de pepe a una billetera de 10 monedas" $ transaccion5 pepe (Usuario "Testing" 10) (Usuario "Testing" 10) `shouldBe` 17

describe "Impacto de transacciones" $ do
it "Impactar la transacción 1 a Pepe" $ estadoLuegoDe transaccion1 pepe `shouldBe`  Usuario {nombre = "Jose", billetera = 10.0}
it "Impactar la transacción 5 a Lucho" $ estadoLuegoDe transaccion5 lucho `shouldBe`  Usuario {nombre = "Luciano", billetera = 9.0}
it "Impactar la transacción 5 y luego la 2 a Pepe" $ estadoTransacciones transaccion5 transaccion2 pepe `shouldBe`  Usuario {nombre = "Jose", billetera = 8.0}

describe "Bloques" $ do
it "Aplicar el bloque1 a Pepe" $ bloque1 pepe `shouldBe`  Usuario {nombre = "Jose", billetera = 18.0}
it "Mayor bloque según usuarios" $ mayor bloque1 [pepe,lucho] `shouldBe`  18.0
it "Determinar el mas adinerado de cierto bloque" $ masAdinerado bloque1 [pepe, lucho] `shouldBe`  [Usuario {nombre = "Jose", billetera = 10.0}]
it "Determinar el menos adinerado de cierto bloque" $ menosAdinerado bloque1 [pepe, lucho] `shouldBe`  [Usuario {nombre = "Luciano", billetera = 2.0}]


describe "Block chain" $ do
it "Determinar cual fue el peor bloque que obtuvo un usuario" $ peorBloque [bloque1, bloque2] pepe `shouldBe` 18
it "Aplicar la blockchain1 a pepe" $ blockchain1 pepe `shouldBe` Usuario {nombre = "Jose", billetera = 115.0}
it "Como estaba la billetera en cierto punto de la historia" $ estadoBilletera 3 [bloque2, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1] pepe `shouldBe` Usuario {nombre = "Jose", billetera = 51.0}
it "Conjunto de usuarios afectados por una blockchain" $ cadenaUsuarios blockchain1 [pepe, lucho] `shouldBe` [Usuario {nombre = "Jose", billetera = 115.0},Usuario {nombre = "Luciano", billetera = 0.0}]

describe "ChainInfinita" $ do
it "Cuantos bloques son necesarios para que Pepe pueda tener 10000 creditos" $ cantidadCreditos 10000 0 [bloque1] pepe `shouldBe`  11
