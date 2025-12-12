# Cómo Iniciar el Proyecto - MexAula Frontend

## Inicio Rápido

Para iniciar el servidor de desarrollo, ejecuta:

```powershell
npm start
```

El servidor se iniciará automáticamente y la aplicación estará disponible en:
```
http://localhost:4200
```

Tu navegador se abrirá automáticamente con la aplicación.

## Verificaciones Previas

Antes de iniciar, asegúrate de que:

1. ✅ Has ejecutado `npm install` (ver `INSTALACION.md`)
2. ✅ El backend está corriendo en `http://localhost:8080/api`
3. ✅ La base de datos está configurada correctamente (ver `BASE_DE_DATOS.md`)

## Comandos Disponibles

### Iniciar Servidor de Desarrollo
```powershell
npm start
```
- Inicia el servidor en `http://localhost:4200`
- Recarga automáticamente al detectar cambios
- Muestra errores de compilación en tiempo real

### Compilar para Producción
```powershell
npm run build
```
- Genera archivos optimizados en la carpeta `dist/`
- Minifica el código
- Optimiza recursos

### Compilar y Observar Cambios
```powershell
npm run watch
```
- Compila y observa cambios sin servidor de desarrollo

### Ejecutar Pruebas
```powershell
npm test
```
- Ejecuta las pruebas unitarias con Karma

## Usuarios de Prueba

Una vez que el sistema esté corriendo, puedes iniciar sesión con estos usuarios de prueba (si los has cargado en la BD):

### Administrador
- **Email:** admin@aulabase.com
- **Contraseña:** password123
- **Rol:** ADMIN
- **Permisos:** Acceso total al sistema

### Maestro
- **Email:** maestro@aulabase.com
- **Contraseña:** password123
- **Rol:** MAESTRO
- **Permisos:** Gestión de cursos y publicaciones

### Padre
- **Email:** padre@aulabase.com
- **Contraseña:** password123
- **Rol:** PADRE
- **Permisos:** Control parental de hijos

### Alumno
- **Email:** alumno@mexaula.com
- **Contraseña:** password123
- **Rol:** ALUMNO
- **Permisos:** Cursos, logros, certificados

**Nota:** Estas credenciales asumen que has ejecutado el script SQL de prueba (ver `BASE_DE_DATOS.md`)

## Estructura de la Aplicación

### Rutas Principales

#### Autenticación
- `/auth/login` - Inicio de sesión
- `/auth/register` - Registro de nuevos usuarios

#### Dashboard
- `/dashboard` - Panel principal (varía según el rol del usuario)

#### Cursos
- `/courses` - Catálogo de cursos disponibles
- `/courses/:id` - Detalle de un curso específico
- `/alumno/courses` - Mis inscripciones (ALUMNO)
- `/alumno/courses/:id` - Detalle de mi inscripción (ALUMNO)
- `/maestro/courses` - Mis cursos (MAESTRO)
- `/maestro/courses/:id` - Detalle de mi curso (MAESTRO)
- `/admin/courses` - Administración de cursos (ADMIN)
- `/admin/courses/new` - Crear nuevo curso (ADMIN)
- `/admin/courses/:id/edit` - Editar curso (ADMIN)

#### Usuarios
- `/admin/users` - Gestión de usuarios (ADMIN)
- `/admin/users/new` - Crear nuevo usuario (ADMIN)
- `/admin/users/:id/edit` - Editar usuario (ADMIN)
- `/users/profile` - Mi perfil

#### Logros (Achievements)
- `/alumno/achievements` - Mis logros obtenidos (ALUMNO)
- `/admin/achievements` - Administración de logros (ADMIN)
- `/admin/achievements/new` - Crear nuevo logro (ADMIN)
- `/admin/achievements/:id/edit` - Editar logro (ADMIN)

#### Información Técnica (Tech Posts)
- `/tech` - Lista de artículos técnicos (Público)
- `/tech/:slug` - Detalle de artículo técnico (Público)
- `/admin/tech-posts` - Administración de publicaciones (ADMIN/MAESTRO)
- `/admin/tech-posts/new` - Crear nueva publicación (ADMIN/MAESTRO)
- `/admin/tech-posts/:id/edit` - Editar publicación (ADMIN/MAESTRO)

#### Certificados
- `/certificates/my` - Mis certificados (ALUMNO)
- `/certificates/verify` - Verificar certificado (Público)
- `/certificates/verify/:code` - Verificar código específico (Público)

#### Control Parental
- `/parental/progress` - Progreso de hijos (PADRE)
- `/parental/settings` - Configuración de control (PADRE)

## Desarrollo y Hot Reload

El servidor de desarrollo de Angular incluye **live reload**:

- ✅ Los cambios en TypeScript se recompilan automáticamente
- ✅ Los cambios en HTML/CSS se reflejan instantáneamente
- ✅ Los errores de compilación se muestran en la terminal y en el navegador
- ✅ No necesitas reiniciar el servidor manualmente

### Estructura de Carpetas Durante Desarrollo

```
frontend/
├── src/               # Código fuente (editas aquí)
├── .angular/          # Cache de compilación (no editar)
├── node_modules/      # Dependencias (no editar)
└── dist/              # Solo se genera con npm run build
```

## Solución de Problemas

### El servidor no inicia

1. Verifica que no haya otro proceso usando el puerto 4200:
   ```powershell
   netstat -ano | findstr :4200
   ```

2. Si hay un proceso, finalízalo o inicia en otro puerto:
   ```powershell
   ng serve --port 4300
   ```

### Error "No se puede conectar al backend"

1. Verifica que el backend esté corriendo:
   - Debe estar en `http://localhost:8080/api`

2. Verifica la configuración en `src/environments/environment.ts`

3. Revisa la consola del navegador (F12) para ver errores específicos

### Errores de compilación

Si ves errores de TypeScript:

1. Asegúrate de que todas las dependencias estén instaladas:
   ```powershell
   npm install
   ```

2. Limpia y reconstruye:
   ```powershell
   Remove-Item -Recurse -Force .angular
   npm start
   ```

### La página se muestra en blanco

1. Abre la consola del navegador (F12) para ver errores
2. Verifica que no haya errores de red al conectar con el backend
3. Asegúrate de que el backend esté respondiendo correctamente

## Detener el Servidor

Para detener el servidor de desarrollo:

1. Ve a la terminal donde está corriendo
2. Presiona `Ctrl + C`
3. Confirma con `S` (Sí) cuando te lo solicite

## Notas Adicionales

- El servidor de desarrollo usa **hot reload**, los cambios en el código se reflejan automáticamente
- Los archivos compilados se guardan en memoria, no se genera carpeta `dist/` en modo desarrollo
- Para producción, siempre usa `npm run build` antes de desplegar

## 🎯 Consejos Útiles

### Durante el Desarrollo

1. **Mantén el backend corriendo**: El frontend necesita el backend activo
2. **Revisa la consola**: Los errores de compilación aparecen en la terminal
3. **Usa las DevTools**: F12 en el navegador para ver errores de red y consola
4. **Hard Refresh**: Si los cambios no se reflejan, usa `Ctrl + Shift + R`

### Para Depuración

```powershell
# Ver logs detallados de Angular
npm start -- --verbose

# Iniciar en modo debug
npm start -- --source-map

# Abrir automáticamente en navegador
npm start -- --open
```

### Atajos de Teclado Útiles

- `Ctrl + C` - Detener servidor
- `Ctrl + Shift + R` - Hard refresh del navegador
- `F12` - Abrir DevTools
- `Ctrl + Shift + I` - Abrir DevTools (alternativo)

## 📚 Recursos Adicionales

- **Documentación Angular**: https://angular.io/docs
- **Tailwind CSS**: https://tailwindcss.com/docs
- **RxJS**: https://rxjs.dev/

## ✅ Checklist Antes de Iniciar

Antes de ejecutar `npm start`, verifica:

- ✅ Backend corriendo en `http://localhost:8080`
- ✅ Base de datos configurada y accesible
- ✅ `npm install` ejecutado sin errores
- ✅ Puerto 4200 disponible (o especifica otro)
- ✅ Variables de entorno configuradas

## 🎉 ¡Listo para Desarrollar!

Si el servidor inició correctamente, verás algo como:

```
** Angular Live Development Server is listening on localhost:4200, 
   open your browser on http://localhost:4200/ **

✔ Compiled successfully.
```

¡Ya puedes empezar a desarrollar! 🚀

---

**Última actualización**: Diciembre 2025  
**Versión**: Angular 18

