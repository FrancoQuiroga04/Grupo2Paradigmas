{-# LANGUAGE NoMonomorphismRestriction #-}
import Text.Show.Functions
import Data.List
import Data.Maybe
import Test.Hspec

type Nombre = String
type Dinero = Float
type Billetera = Float
type Evento = Billetera -> Billetera


data Usuario = Usuario {
nombre :: Nombre,
billetera :: Billetera
} deriving (Show, Eq)


deposito :: Dinero -> Evento
deposito = (+)


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


----------------------------------------------------------------------FIN DE LA PARTE 1--------------------------------------------------------------------------------------


estadoUsuarioDespuesDeTransaccion :: Transaccion -> Usuario -> Usuario
estadoUsuarioDespuesDeTransaccion transaccion usuario = usuario { billetera = (transaccion usuario) (billetera usuario) }


type Bloque = [Transaccion]
bloque1 :: Bloque
bloque1 = [transaccion1, transaccion2, transaccion2, transaccion2, transaccion3, transaccion4, transaccion5, transaccion3]

aplicarBloqueAusuario :: Bloque -> Usuario -> Usuario
aplicarBloqueAusuario bloque usuario = foldr estadoUsuarioDespuesDeTransaccion usuario bloque


type Credito = Float
usuariosConMasDeNcreditos :: Credito -> Bloque -> [Usuario] -> [Usuario]
usuariosConMasDeNcreditos creditosN bloque = filter ((> creditosN) . billetera . (aplicarBloqueAusuario bloque))



aplicarBloqueAlistaDeUsuarios :: Bloque -> [Usuario] -> [Usuario]
aplicarBloqueAlistaDeUsuarios bloque usuarios = map (aplicarBloqueAusuario bloque) usuarios



mayorBilletera :: Bloque -> [Usuario] -> Billetera
mayorBilletera bloque usuarios = maximum (map billetera (aplicarBloqueAlistaDeUsuarios bloque usuarios))

menorBilletera :: Bloque -> [Usuario] -> Billetera
menorBilletera bloque usuarios = minimum (map billetera (aplicarBloqueAlistaDeUsuarios bloque usuarios))

masOmenosAdinerado :: (Bloque -> [Usuario] -> Billetera) -> Bloque -> [Usuario] -> Usuario
masOmenosAdinerado mayorOmenorBilletera bloque usuarios = fromJust (find ( ((==)(mayorOmenorBilletera bloque usuarios)) . billetera . aplicarBloqueAusuario bloque) usuarios)



bloque2 :: Bloque
bloque2 = [transaccion2, transaccion2, transaccion2, transaccion2, transaccion2]



type BlockChain = [Bloque]
blockChain1 :: BlockChain
blockChain1 = [bloque2, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1, bloque1]



peorBilleteraPosible :: BlockChain -> Usuario -> Billetera
peorBilleteraPosible (cabezaBlockChain : [ ]) usuario = billetera (aplicarBlockChainAusuario [cabezaBlockChain] usuario)
peorBilleteraPosible (cabezaBlockChain : colaBlockChain) usuario  = min (billetera (aplicarBloqueAusuario cabezaBlockChain usuario) ) (peorBilleteraPosible colaBlockChain usuario)

peorBloque :: BlockChain -> Usuario -> Bloque
peorBloque (cabezaBlockChain : colaBlockChain) usuario | peorBilleteraPosible (cabezaBlockChain : colaBlockChain) usuario == billetera (aplicarBloqueAusuario cabezaBlockChain usuario) = cabezaBlockChain
                                                       | otherwise = peorBloque colaBlockChain usuario

aplicarBlockChainAusuario :: BlockChain -> Usuario -> Usuario
aplicarBlockChainAusuario blockChain usuario = foldr aplicarBloqueAusuario usuario blockChain


saldoHastaNbloques :: BlockChain -> Usuario -> Int -> Usuario
saldoHastaNbloques blockChain usuario cantidadN | cantidadN < length blockChain = aplicarBlockChainAusuario (take cantidadN blockChain) usuario
                                                | otherwise = aplicarBlockChainAusuario blockChain usuario


aplicarBlockChainAlistaDeUsuarios :: [Usuario] -> BlockChain -> [Usuario]
aplicarBlockChainAlistaDeUsuarios usuarios blockChain = map (aplicarBlockChainAusuario blockChain) usuarios




type BlockChainInfinita = Bloque -> BlockChain
creadoraDeBlockChainInfinita :: BlockChainInfinita
creadoraDeBlockChainInfinita bloque = [bloque] ++ (creadoraDeBlockChainInfinita (bloque ++ bloque))

-- Ejemplo: recorrerCadenaInfinita (chainInfinita [bloque1]) pepe 11
recorrerCadenaInfinita :: BlockChain -> Usuario -> Int -> [Usuario]
recorrerCadenaInfinita (cabezaBlockChainInfinita : colaBlockChainInfinita) usuario cantidadNecesaria = take cantidadNecesaria (aplicarBloqueAusuario cabezaBlockChainInfinita usuario : recorrerCadenaInfinita colaBlockChainInfinita usuario cantidadNecesaria)

listaDeBilleteras :: BlockChain -> Usuario -> Int -> Billetera
listaDeBilleteras blockChainInfinita usuario cantidadNecesaria= maximum (map (billetera) (recorrerCadenaInfinita blockChainInfinita usuario cantidadNecesaria))

--cantidadBloquesParaLlegarAnCreditos (chainInfinita [bloque1]) pepe 5 0
cantidadBloquesParaLlegarAnCreditos :: BlockChain -> Usuario -> Float -> Int -> Int
cantidadBloquesParaLlegarAnCreditos blockChainInfinita usuario nCreditos i | (listaDeBilleteras blockChainInfinita usuario (i+1) ) <= nCreditos =  cantidadBloquesParaLlegarAnCreditos blockChainInfinita usuario nCreditos (i+1)
                                                                           | otherwise = i





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
it "Consulto la billetera de pepe" $ (billetera pepe) `shouldBe` 10
it "Cual es la billetera de pepe luego de un cierre de cuenta" $ cierrecuenta (billetera pepe) `shouldBe` 0
it "¿Cómo quedaría la billetera de Pepe si le depositan 15 monedas, extrae 2, y tiene un Upgrade?" $ ((upgrade . extraccion 2 . deposito 15)(billetera pepe)) `shouldBe` 27.6

describe "Transacciones" $ do
it "Aplicar la transaccion 1 a Pepe" $ (transaccion1 pepe) 20 `shouldBe` 20
it "Aplicar la transaccion 2 a Pepe" $ (transaccion2 pepe) 10 `shouldBe` 15
it "Aplicar la transaccion 2 a Pepe 2" $ (transaccion2 pepe2) 50 `shouldBe` 55

describe "Nuevos eventos" $ do
it "Aplicar la transaccion 3 a Lucho" $ (transaccion3 lucho) 10 `shouldBe` 0
it "Aplicar la transaccion 4 a Lucho" $ (transaccion4 lucho) 10 `shouldBe` 34

describe "Pagos entre usuarios" $ do
it "Aplicar la transaccion 5 a Pepe" $ (transaccion5 pepe) (billetera pepe) `shouldBe` 3
it "Aplicar la transaccion 5 a Lucho" $ (transaccion5 lucho) (billetera lucho) `shouldBe` 9

describe "Impacto de transacciones" $ do
it "Impactar la transacción 1 a Pepe" $ estadoUsuarioDespuesDeTransaccion transaccion1 pepe `shouldBe` pepe
it "Impactar la transacción 5 a Lucho" $ estadoUsuarioDespuesDeTransaccion transaccion5 lucho `shouldBe`  Usuario {nombre = "Luciano", billetera = 9.0}
it "Impactar la transacción 5 y luego la 2 a Pepe" $ aplicarBloqueAusuario [transaccion5, transaccion2] pepe `shouldBe`  Usuario {nombre = "Jose", billetera = 8.0}

describe "Bloques" $ do
it "Aplicar el bloque1 a Pepe" $ aplicarBloqueAusuario bloque1 pepe `shouldBe`  Usuario {nombre = "Jose", billetera = 18.0}
it "Usuario/s con mas de 10 creditos dado el bloque1 y la lista [pepe,lucho] : " $ usuariosConMasDeNcreditos 10 bloque1 [pepe,lucho] `shouldBe` [pepe]
it "Determinar el mas adinerado de cierto bloque" $ masOmenosAdinerado mayorBilletera bloque1 [pepe, lucho] `shouldBe`  pepe
it "Determinar el menos adinerado de cierto bloque" $ masOmenosAdinerado menorBilletera bloque1 [pepe, lucho] `shouldBe`  lucho


describe "Block chain" $ do
it "Determinar cual fue el peor bloque que obtuvo un usuario" $ aplicarBloqueAusuario (peorBloque blockChain1 pepe) pepe `shouldBe` Usuario {nombre = "Jose", billetera = 18.0}
it "Aplicar la blockchain1 a pepe" $ aplicarBlockChainAusuario blockChain1 pepe `shouldBe` Usuario {nombre = "Jose", billetera = 115.0}
it "Como estaba la billetera en cierto punto de la historia" $ saldoHastaNbloques blockChain1 pepe 3 `shouldBe` Usuario {nombre = "Jose", billetera = 51.0}
it "Conjunto de usuarios afectados por una blockchain" $ aplicarBlockChainAlistaDeUsuarios [pepe, lucho] blockChain1 `shouldBe` [Usuario {nombre = "Jose", billetera = 115.0},Usuario {nombre = "Luciano", billetera = 0.0}]

describe "ChainInfinita" $ do
it "Cuantos bloques son necesarios para que Pepe pueda tener 10000 creditos" $ cantidadBloquesParaLlegarAnCreditos (creadoraDeBlockChainInfinita bloque1) pepe 10000 0 `shouldBe`  11
