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

deposito billetera depositardinero  = billetera + depositardinero

extraccion :: Evento

extraccion extraerdinero billetera = max 0 (billetera - extraerdinero)

upgrade :: EventoB

--- ver que hacer con esto
upgrade billetera  = billetera * 1.2

cierrecuenta :: EventoB

cierrecuenta billetera = 0

quedaigual :: EventoB

quedaigual billetera = id billetera

pepe = Usuario "Jose" 10
lucho = Usuario "Luciano" 2
pepe2 = Usuario "Jose" 20

type Transaccion = Evento -> Billetera -> Usuario -> String -> Billetera

transaccion :: Transaccion

transaccion nombreTransaccion cantidadDinero usuario nombreaComparar |  nombre usuario == nombreaComparar = nombreTransaccion (dinero usuario) cantidadDinero
                                                                     |  otherwise = id (dinero usuario)


transaccioncierre :: Usuario -> String -> Billetera

transaccioncierre usuario nombreaComparar | nombre usuario == nombreaComparar = cierrecuenta (dinero usuario)
                                          | otherwise = id (dinero usuario)

type TransacciondePrueba = Usuario -> Billetera

transaccion1 :: TransacciondePrueba

transaccion1 usuario = transaccioncierre usuario "Luciano"

transaccion2 :: TransacciondePrueba

transaccion2 usuario = transaccion deposito 5 usuario "Jose"

tocoymevoy usuario | nombre usuario == "Luciano" = (cierrecuenta . upgrade . deposito 15) (dinero usuario)
                   | otherwise = id dinero usuario

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

transaccion5aux :: TransacciondePrueba
transaccion5aux usuario = transacciondeunidades 7 pepe lucho usuario

estadoLuegoDe transaccion usuario = usuario { dinero = transaccion usuario }

estadoTransacciones transaccion1 transaccion2 usuario = usuario { dinero = transaccion1 ((estadoLuegoDe transaccion2) usuario) }

-- bloque + user

bloque1 =  ( estadoLuegoDe transaccion3 . estadoLuegoDe transaccion5aux . estadoLuegoDe transaccion4 . estadoLuegoDe transaccion3 . estadoLuegoDe transaccion2 . estadoLuegoDe transaccion2 . estadoLuegoDe transaccion2 . estadoLuegoDe transaccion1)

--mayoresaN n lista = filter ( < n) (dinero (bloque1 usuario ))

bloque2 =  ( estadoLuegoDe transaccion2 . estadoLuegoDe transaccion2 . estadoLuegoDe transaccion2 . estadoLuegoDe transaccion2 . estadoLuegoDe transaccion2)

blockchain = bloque1 . bloque1 . bloque1 . bloque1 . bloque1 . bloque1 . bloque1 . bloque1 . bloque1 . bloque1 . bloque2




testeo = hspec $ do
describe "Eventos sobre billetera de 10 monedas" $ do
it "Depositar 10 a una billetera de 10 monedas" $ deposito 10 10 `shouldBe` 20
it "Extraer 3 a una billetera de 10 monedas" $ extraccion 3 10 `shouldBe` 7
it "Extraer 15 a una billetera de 10 monedas" $ extraccion 15 10 `shouldBe` 0
it "Upgrade a una billetera de 10 monedas" $ upgrade 10 `shouldBe` 12
it "Cierre de cuenta a una billetera de 10 monedas" $ cierrecuenta 10 `shouldBe` 0
it "Queda igual a una billetera de 10 monedas" $ quedaigual 10 `shouldBe` 10
it "Depositar 1000 y tener un Upgrade a una billetera de 10 monedas" $ ((upgrade . deposito 1000) 10) `shouldBe` 1212

describe "Usuarios" $ do
it "Consulto la billetera de pepe" $ (dinero pepe) `shouldBe` 10
it "Cual es la billetera de pepe luego de un cierre de cuenta" $ cierrecuenta (dinero pepe) `shouldBe` 0
it "¿Cómo quedaría la billetera de Pepe si le depositan 15 monedas, extrae 2, y tiene un Upgrade?" $ ((upgrade . extraccion 2 . deposito 15)(dinero pepe)) `shouldBe` 27.6

describe "Transacciones" $ do
it "Aplicar la transaccion 1 a Pepe" $ transaccion1 pepe `shouldBe` 10
it "Aplicar la transaccion 2 a Pepe" $ transaccion2 pepe `shouldBe` 15
it "Aplicar la transaccion 2 a Pepe 2" $ transaccion2 pepe2 `shouldBe` 25
it "Aplicar la transaccion 2 a una billetera de 50 monedas" $ transaccion2 (Usuario "Jose" 50) `shouldBe` 55

describe "Nuevos eventos" $ do
it "Aplicar la transaccion 3 a Lucho" $ transaccion3 lucho `shouldBe` 0
it "Aplicar la transaccion 4 a Lucho" $ transaccion4 lucho `shouldBe` 24.400002
it "Aplicar la transaccion 3 a una billetera inicial de 10 monedas" $ transaccion3 (Usuario "Testing" 10) `shouldBe` 0
it "Aplicar la transaccion 4 a una billetera inicial de 10 monedas" $ transaccion4 (Usuario "Testing" 10) `shouldBe` 34

describe "Pagos entre usuarios" $ do
it "Aplicar la transaccion 5 a Pepe" $ transaccion5 pepe lucho pepe `shouldBe` 3
it "Aplicar la transaccion 5 de una billetera de 10 monedas a lucho, sobre la billetera de 10 monedas" $ transaccion5 (Usuario "Testing" 10) lucho (Usuario "Testing" 10)  `shouldBe` 3
it "Aplicar la transaccion 5 a Lucho" $ transaccion5 pepe lucho lucho `shouldBe` 9
it "Aplicar la transaccion 5 de pepe a una billetera de 10 monedas" $ transaccion5 pepe (Usuario "Testing" 10) (Usuario "Testing" 10) `shouldBe` 17
