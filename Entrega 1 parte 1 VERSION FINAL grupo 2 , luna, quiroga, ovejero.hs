{-# LANGUAGE NoMonomorphismRestriction #-}
import Text.Show.Functions
import Data.List
import Data.Maybe
import Test.Hspec


data Usuario = Usuario {
nombre :: String,
dinero :: Float
} deriving (Show, Eq)

nuevodinero monto usuario = usuario {dinero = monto}

deposito depositardinero usuario = nuevodinero (depositardinero + dinero usuario) usuario

extraer extraerdinero usuario = nuevodinero (dinero usuario - extraerdinero) usuario

extraccion extraerdinero usuario | extraerdinero < dinero usuario = extraer extraerdinero usuario
                                 | otherwise = cierrecuenta usuario

upgrade usuario | dinero usuario * 0.2 <= 10 = nuevodinero (dinero usuario * 1.2) usuario
                | otherwise = quedaigual usuario

cierrecuenta usuario = nuevodinero 0 usuario

quedaigual usuario = nuevodinero (dinero usuario) usuario

crearusuario nuevonombre billeterainicial = Usuario nuevonombre billeterainicial
pepe = Usuario "Jose" 10
lucho = Usuario "Luciano" 2
pepe2 = Usuario "Jose" 20

transaccion1 usuario | nombre usuario == "Luciano" = cierrecuenta usuario
                     | otherwise = quedaigual usuario

transaccion2 usuario | nombre usuario == "Jose" = deposito 5 usuario
                     | otherwise = quedaigual usuario

tocoymevoy usuario = (cierrecuenta . upgrade . deposito 15) usuario
ahorranteerrante usuario = (deposito 10 . upgrade . deposito 8 . extraccion 1 . deposito 2 . deposito 1) usuario

transaccion3 lucho = tocoymevoy lucho

transaccion4 lucho = ahorranteerrante lucho

transacciondeunidades deusuario1 ausuario2 efectosobreusuario | nombre efectosobreusuario == nombre ausuario2 = deposito 5 efectosobreusuario
                            | nombre efectosobreusuario == nombre deusuario1 = extraer 5 efectosobreusuario
                            | otherwise = quedaigual efectosobreusuario

transaccion5 pepe lucho efectosobreusuario | nombre efectosobreusuario == nombre lucho = deposito 7 efectosobreusuario
                                                        | nombre efectosobreusuario == nombre pepe = extraer 7 efectosobreusuario
                                                        | otherwise = quedaigual efectosobreusuario
testeo = hspec $ do
describe "Eventos sobre billetera de 10 monedas" $ do
it "Depositar 10 a una billetera de 10 monedas" $ deposito 10 (Usuario "Testing" 10) `shouldBe` (Usuario "Testing" 10) {dinero = 20}
it "Extraer 3 a una billetera de 10 monedas" $ extraer 3 (Usuario "Testing" 10) `shouldBe` (Usuario "Testing" 10) {dinero = 7}
it "Extraer 15 a una billetera de 10 monedas" $ extraccion 15 (Usuario "Testing" 10) `shouldBe` (Usuario "Testing" 10) {dinero = 0}
it "Upgrade a una billetera de 10 monedas" $ upgrade (Usuario "Testing" 10) `shouldBe` (Usuario "Testing" 10) {dinero = 12}
it "Cierre de cuenta a una billetera de 10 monedas" $ cierrecuenta (Usuario "Testing" 10) `shouldBe` (Usuario "Testing" 10) {dinero = 0}
it "Queda igual a una billetera de 10 monedas" $ quedaigual (Usuario "Testing" 10) `shouldBe` (Usuario "Testing" 10) {dinero = 10}
it "Depositar 1000 y tener un Upgrade a una billetera de 10 monedas" $ ((upgrade . deposito 1000) (Usuario "Testing" 10)) `shouldBe` (Usuario "Testing" 10) {dinero = 1010}

describe "Usuarios" $ do
it "Consulto la billetera de pepe" $ pepe `shouldBe` pepe {dinero = 10}
it "Cual es la billetera de pepe luego de un cierre de cuenta" $ cierrecuenta pepe `shouldBe` pepe {dinero = 0}
it "¿Cómo quedaría la billetera de Pepe si le depositan 15 monedas, extrae 2, y tiene un Upgrade?" $ ((upgrade . extraer 2 . deposito 15)pepe) `shouldBe` pepe {dinero = 27.6}

describe "Transacciones" $ do
it "Aplicar la transaccion 1 a Pepe" $ transaccion1 pepe `shouldBe` pepe {dinero = 10}
it "Aplicar la transaccion 2 a Pepe" $ transaccion2 pepe `shouldBe` pepe {dinero = 15}
it "Aplicar la transaccion 2 a Pepe 2" $ transaccion2 pepe2 `shouldBe` pepe {dinero = 25}
it "Aplicar la transaccion 2 a una billetera de 50 monedas" $ transaccion2 (Usuario "Jose" 50) `shouldBe` (Usuario "Jose" 50) {dinero = 55}

describe "Nuevos eventos" $ do
it "Aplicar la transaccion 3 a Lucho" $ transaccion3 lucho `shouldBe` lucho {dinero = 0}
it "Aplicar la transaccion 4 a Lucho" $ transaccion4 lucho `shouldBe` lucho {dinero = 24.400002}
it "Aplicar la transaccion 3 a una billetera inicial de 10 monedas" $ transaccion3 (Usuario "Testing" 10) `shouldBe` (Usuario "Testing" 10) {dinero = 0}
it "Aplicar la transaccion 4 a una billetera inicial de 10 monedas" $ transaccion4 (Usuario "Testing" 10) `shouldBe` (Usuario "Testing" 10) {dinero = 34}

describe "Pagos entre usuarios" $ do
it "Aplicar la transaccion 5 a Pepe" $ transaccion5 pepe lucho pepe `shouldBe` pepe {dinero = 3}
it "Aplicar la transaccion 5 de una billetera de 10 monedas a lucho, sobre la billetera de 10 monedas" $ transaccion5 (Usuario "Testing" 10) lucho (Usuario "Testing" 10) `shouldBe` (Usuario "Testing" 10) {dinero = 3}
it "Aplicar la transaccion 5 a Lucho" $ transaccion5 pepe lucho lucho `shouldBe` lucho {dinero = 9}
it "Aplicar la transaccion 5 de pepe a una billetera de 10 monedas" $ transaccion5 pepe (Usuario "Testing" 10) (Usuario "Testing" 10) `shouldBe` (Usuario "Testing" 10) {dinero = 17}
