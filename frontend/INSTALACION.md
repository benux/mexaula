# Guía de Instalación - MexAula Frontend

Esta guía te llevará paso a paso para instalar y configurar el proyecto frontend de MexAula.

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

1. **Node.js** versión 18 o superior
   - Descarga: https://nodejs.org/
   - Verifica la instalación: `node --version`

2. **npm** versión 9 o superior (incluido con Node.js)
   - Verifica la instalación: `npm --version`

3. **Git** (opcional, para clonar el repositorio)
   - Descarga: https://git-scm.com/

4. **Editor de código** (recomendado: VS Code)
   - Descarga: https://code.visualstudio.com/

## 🚀 Instalación

### Paso 1: Obtener el Código

#### Opción A: Clonar con Git
```powershell
git clone <url-del-repositorio>
cd aulabase/frontend
```

#### Opción B: Descargar ZIP
1. Descarga el archivo ZIP del proyecto
2. Extrae el contenido
3. Abre PowerShell en la carpeta `frontend`

### Paso 2: Instalar Dependencias

Ejecuta en PowerShell:

```powershell
npm install
```

Este comando instalará todas las dependencias necesarias del proyecto:
- Angular 18
- Tailwind CSS
- TypeScript
- RxJS
- Y todas las demás librerías necesarias

**Tiempo estimado**: 2-5 minutos dependiendo de tu conexión

### Paso 3: Configurar Variables de Entorno

El archivo `src/environments/environment.ts` ya está configurado para desarrollo:

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api'
};
```

**Nota**: Si tu backend corre en un puerto diferente, actualiza la URL aquí.

### Paso 4: Verificar la Instalación

Ejecuta el siguiente comando para verificar que todo está correcto:

```powershell
npm run build
```

Si el build se completa sin errores, ¡la instalación fue exitosa! ✅

## ⚙️ Configuración del Backend

**IMPORTANTE**: El frontend requiere que el backend esté corriendo antes de poder funcionar.

1. Consulta la documentación del backend para instalarlo
2. Configura la base de datos (ver `BASE_DE_DATOS.md`)
3. Inicia el backend en `http://localhost:8080`
4. Verifica que la API responda: `http://localhost:8080/api/auth/test`

## 🔧 Configuración Adicional

### Configurar Proxy (Opcional)

Si necesitas evitar problemas de CORS, puedes configurar un proxy.

Crea o edita `proxy.conf.json` en la raíz del proyecto:

```json
{
  "/api": {
    "target": "http://localhost:8080",
    "secure": false,
    "changeOrigin": true
  }
}
```

Luego actualiza `angular.json`:

```json
"serve": {
  "options": {
    "proxyConfig": "proxy.conf.json"
  }
}
```

### Extensiones Recomendadas para VS Code

- Angular Language Service
- Tailwind CSS IntelliSense
- ESLint
- Prettier

## ⚠️ Solución de Problemas

### Error: "npm no se reconoce como comando"

**Solución**:
- Verifica que Node.js esté instalado correctamente
- Reinicia tu terminal después de instalar Node.js
- Asegúrate de que Node.js esté en el PATH del sistema

### Error durante `npm install`

**Solución**:

1. Elimina caché y archivos previos:
```powershell
Remove-Item package-lock.json -ErrorAction SilentlyContinue
Remove-Item node_modules -Recurse -Force -ErrorAction SilentlyContinue
```

2. Limpia la caché de npm:
```powershell
npm cache clean --force
```

3. Intenta instalar nuevamente:
```powershell
npm install
```

### Problemas con Permisos en Windows

Si encuentras errores de permisos en PowerShell:

1. Ejecuta PowerShell como **Administrador**
2. Ejecuta el siguiente comando:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
3. Vuelve a intentar `npm install`

### Error de Versión de Node.js

Si ves un error sobre la versión de Node.js:

```powershell
# Verificar versión actual
node --version

# Debe ser >= 18.0.0
# Si es menor, descarga la versión más reciente de nodejs.org
```

### Puerto 4200 en Uso

Si el puerto 4200 ya está ocupado:

```powershell
# Opción 1: Cambiar el puerto en package.json
"start": "ng serve --port 4300"

# Opción 2: Matar el proceso en el puerto 4200
netstat -ano | findstr :4200
taskkill /PID <PID> /F
```

### Errores de TypeScript

Si ves errores de compilación de TypeScript:

```powershell
# Reinstalar TypeScript
npm install typescript@latest --save-dev
```

## ✅ Verificación Final

Después de la instalación, verifica:

1. ✅ Node.js >= 18 instalado
2. ✅ `npm install` completado sin errores
3. ✅ Carpeta `node_modules` creada
4. ✅ Backend configurado y corriendo
5. ✅ Base de datos creada (ver `BASE_DE_DATOS.md`)

## 📖 Próximos Pasos

Una vez completada la instalación:

1. ✅ Consulta `INICIAR.md` para ejecutar el servidor de desarrollo
2. ✅ Consulta `BASE_DE_DATOS.md` para configurar la base de datos del backend
3. ✅ Asegúrate de que el backend esté en ejecución antes de iniciar el frontend

## 📞 Soporte

Si encuentras problemas durante la instalación:

1. Revisa esta guía nuevamente
2. Verifica los requisitos previos
3. Consulta la documentación de errores comunes
4. Busca el error específico en Google/Stack Overflow

## 🎉 ¡Listo!

Si llegaste hasta aquí sin errores, la instalación está completa. 

**Siguiente paso**: Lee `INICIAR.md` para aprender a ejecutar el servidor de desarrollo.

---

**Última actualización**: Diciembre 2025  
**Versión**: Angular 18


```
src/environments/environment.ts
```
Si necesitas cambiar esta URL, edita el archivo:

El frontend está configurado para conectarse al backend en `http://localhost:8080/api`.

### Configurar la URL del Backend

## Configuración del Entorno

```
npm list --depth=0
```powershell

Una vez completada la instalación, verifica que todo esté correcto:

### Paso 3: Verificar la Instalación

- Otras dependencias del proyecto
- TypeScript
- RxJS
- Tailwind CSS
- Angular 21
Este proceso puede tardar varios minutos. Se instalarán:

```
npm install
```powershell

Ejecuta el siguiente comando para instalar todas las dependencias necesarias:

### Paso 2: Instalar Dependencias

```
cd C:\Users\benux\IdeaProjects\mexaula\frontend
```powershell

### Paso 1: Navegar al Directorio del Proyecto

## Instalación del Frontend

Si no tienes Node.js instalado, descárgalo desde: https://nodejs.org/

```
npm --version
node --version
```powershell

Ejecuta estos comandos para verificar las versiones instaladas:

### Verificar Versiones

- **Git** (opcional, para clonar el repositorio)
- **npm** versión 9 o superior
- **Node.js** versión 18 o superior

Antes de instalar el proyecto, asegúrate de tener instalado:

## Requisitos Previos


