# Web service central

## Instalación

NODE JS: 
1.- Se instala la paqueteria de node, descargada desde la siguiente liga: 

https://nodejs.org/es/


2.- Guardar el archivo .msi que te genera


3.- Dar next en la primera pantalla de instalación

4.-Aceptar los terminos y condiciones y dar “next”


5.-Asignar la ubicación del archivo y dar click en “Next”

6.-Custom setup, dejar la instalación predeterminada, y dar click en “next”

7.- Instalar si se requiere los modulos npm, dar click en “next”

8.- Una vez terminada la instalación dar click en “finish”


9.-Presionar cualquier tecla para finalizar la instalación en el sistema


10.-Extraer el archivo .rar WS_DB_Central en el directorio donde se desea correr el web service


11.-Abrir la carpeta con tu editor de texto, en este caso yo utilizo visual studio code


12.- Asignar las credenciales de acceso requeridas para acceder a la base de datos en el archivo .env

```.env
DB_HOST=localhost
DB_USER=postgres
DB_PASS=josecarlos123
DB=db_central
PORT=5434
HTTP_PORT=3000
```




12.-Checar la versión de node, esté instalada y se la versión 12.8.0
```cmd
D:\Users\ADMIN\Desktop\Kiotech\WS_DB_Central>node -v
v12.8.0
```

13.-Iniciar el web service con el comando “node index.js”

```cmd
D:\Users\ADMIN\Desktop\Kiotech\WS_DB_Central>node index.js
```
14.-Listo, el web service ya estará a la escucha de nuevas peticiones. 
```cmd
D:\Users\ADMIN\Desktop\Kiotech\WS_DB_Central>node index.js
Web service escuchando por puerto 3000
```

# Restaurar base de datos

## Procedimiento

Paso 1.- Creamos una nueva base de datos en el servidor en el que estamos trabajando

Paso 2.- Nombramos nuestra base de datos en la que haremos nuestra restauración de nuestra base de datos.

Paso 3.- Damos click derecho la base de datos creada y seleccionamos “CREATE SCRIPT”

Paso 4.- Una vez en la consola de queries, seleccionamos el icono de la carpeta en la esquina superior izquierda para seleccionar el archivo backup.backup

Paso 5.- En la ventana de explorador de  archivos seleccionamos en el filtro “All files” que se encuentra en la esquina inferior derecha para que aparezca nuestro archivo “backup.backup”

Paso 6.- Así se verá nuestro archivo en la consola de queries

Paso 7.- Seleccionamos en el icono del rayo que se encuentra en la barra de herramientas de nuestro "Query tool"

Paso 8.- Una vez ejecutado debería de salir ese mensaje en la consola de resultados
  
```cmd
  GRANT
  QUERY RETURNED SUCCESSFULLY

```

Paso 9.- Listo, la base de datos ha sido restaurada con éxito. 


