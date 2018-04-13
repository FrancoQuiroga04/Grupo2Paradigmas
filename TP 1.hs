data Usuario = Usuario {
nombre :: String,
dinero :: Float
} deriving Show

nuevodinero monto usuario = usuario {dinero = monto}

deposito depositardinero usuario = nuevodinero (depositardinero + dinero usuario) usuario

extraer extraerdinero usuario = nuevodinero (dinero usuario - extraerdinero) usuario

extraccion extraerdinero usuario | extraerdinero >= dinero usuario = nuevodinero 0 usuario
                                 | otherwise = extraer extraerdinero usuario

upgrade usuario = nuevodinero (dinero usuario * 1.2) usuario

cierrecuenta usuario = nuevodinero 0 usuario

quedaigual usuario = nuevodinero (dinero usuario) usuario

pepe = Usuario "Jose" 10
lucho = Usuario "Luciano" 2

transaccion1 usuario | nombre usuario == "Luciano" = cierrecuenta usuario
                     | otherwise = quedaigual usuario

transaccion2 usuario | nombre usuario == "Jose" = deposito 5 usuario
                     | otherwise = quedaigual usuario

tocoymevoy usuario = (cierrecuenta . upgrade . deposito 15) usuario
ahorranteerrante usuario = (deposito 10 . upgrade . deposito 8 . extraccion 1 . deposito 2 . deposito 1) usuario

transaccion3 lucho = (cierrecuenta . upgrade . deposito 15) lucho

transaccion4 lucho = ahorranteerrante lucho

transacciondeunidades usuario | nombre usuario == "Luciano" = deposito 5 usuario
                            | nombre usuario == "Jose" = extraer 5 usuario
                            | otherwise = quedaigual usuario
