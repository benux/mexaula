# MexAula - Frontend

Plataforma educativa con control parental, logros y contenido técnico. Desarrollada con Angular 21 y Tailwind CSS.

## 📚 Documentación

Para comenzar a trabajar con el proyecto, consulta estos archivos:

1. **[INSTALACION.md](INSTALACION.md)** - Guía completa de instalación del proyecto
2. **[INICIAR.md](INICIAR.md)** - Cómo iniciar y ejecutar el servidor de desarrollo
3. **[BASE_DE_DATOS.md](BASE_DE_DATOS.md)** - Estructura de la base de datos del backend

## 🚀 Inicio Rápido

```powershell
# 1. Instalar dependencias
npm install

# 2. Iniciar servidor de desarrollo
npm start

# 3. Build de producción
npm run build
```

La aplicación estará disponible en `http://localhost:4200`

## 🛠️ Tecnologías

- **Angular 18** - Framework principal (standalone components)
- **TypeScript** - Lenguaje de programación
- **Tailwind CSS** - Framework de estilos
- **RxJS** - Programación reactiva
- **HTTP Client** - Consumo de API REST
- **Angular Router** - Navegación y rutas
- **Reactive Forms** - Formularios reactivos

## 🎯 Características Principales

### Gestión de Usuarios
- Sistema de autenticación con JWT
- 4 roles: ADMIN, PADRE, MAESTRO, ALUMNO
- Perfil de usuario y configuración

### Cursos
- Listado y detalle de cursos
- Inscripción y seguimiento
- Niveles: BASICO, INTERMEDIO, AVANZADO
- Vista específica por rol (alumno/maestro/admin)

### Logros (Achievements)
- Sistema de logros gamificado
- 12 iconos SVG personalizados
- Compartir logros en redes sociales
- Vista de logros por alumno

### Información Técnica (Tech Posts)
- Artículos técnicos educativos
- Soporte para Markdown
- Categorías y etiquetas
- Estados: DRAFT/PUBLISHED

### Certificados
- Generación de certificados
- Verificación de certificados
- Vista de mis certificados

### Control Parental
- Seguimiento del progreso de hijos
- Configuración de restricciones
- Vista de actividades

## 👥 Roles y Permisos

### ADMIN
- Gestión completa de usuarios
- CRUD de cursos
- Gestión de logros
- Gestión de publicaciones técnicas

### MAESTRO
- Gestión de sus cursos
- Vista de alumnos inscritos
- Creación de publicaciones técnicas

### ALUMNO
- Vista y búsqueda de cursos
- Inscripción a cursos
- Vista de logros personales
- Acceso a certificados
- Lectura de información técnica

### PADRE
- Control parental de hijos
- Seguimiento de progreso
- Configuración de restricciones

## 📁 Estructura del Proyecto

```
src/
├── app/
│   ├── core/                    # Servicios y modelos core
│   │   ├── guards/             # Guards de autenticación y roles
│   │   ├── interceptors/       # HTTP interceptors
│   │   ├── models/             # Interfaces TypeScript
│   │   └── services/           # Servicios de negocio
│   ├── features/               # Módulos de funcionalidades
│   │   ├── achievements/       # Logros
│   │   ├── admin/             # Panel de administración
│   │   ├── auth/              # Autenticación
│   │   ├── certificates/      # Certificados
│   │   ├── courses/           # Cursos
│   │   ├── dashboard/         # Dashboard
│   │   ├── parental/          # Control parental
│   │   ├── tech-posts/        # Información técnica
│   │   └── users/             # Usuarios
│   ├── shared/                # Componentes compartidos
│   │   └── components/        # Navbar, Sidebar, Toast
│   └── environments/          # Configuración de entornos
├── public/                    # Recursos estáticos
│   └── icons/                # Iconos SVG de logros
└── styles.css                # Estilos globales

```

## 🎨 Iconos de Logros

El proyecto incluye 12 iconos SVG en `/public/icons/`:
- `first-completion.svg` - Primer curso completado
- `first-enrollment.svg` - Primera inscripción
- `three-courses.svg` - 3 cursos completados
- `ten-courses.svg` - 10 cursos completados
- `seven-day-streak.svg` - Racha de 7 días
- `perfectionist.svg` - Calificación perfecta
- `explorer.svg` - Explorador de categorías
- `speedrunner.svg` - Completar curso rápido
- `gold-certificate.svg` - Certificado de oro
- `collector.svg` - Coleccionista de logros
- `js-ninja.svg` - Maestro en JavaScript
- `scientist.svg` - Científico/Tecnología

## 🔐 Autenticación

El sistema usa JWT para autenticación:
- Token almacenado en localStorage
- Interceptor HTTP para agregar token a requests
- Guards para proteger rutas por rol
- Auto-logout en caso de token inválido

## 🌐 API Backend

La aplicación consume una API REST en `http://localhost:8080/api` con los siguientes endpoints:

- `/auth/*` - Autenticación y registro
- `/users/*` - Gestión de usuarios
- `/courses/*` - Cursos
- `/enrollments/*` - Inscripciones
- `/achievements/*` - Logros
- `/certificates/*` - Certificados
- `/tech-posts/*` - Publicaciones técnicas
- `/parental-control/*` - Control parental

## 📋 Requisitos

- **Node.js** 18+
- **npm** 9+
- **Backend** corriendo en `http://localhost:8080/api`

## 🚦 Scripts Disponibles

```powershell
npm start          # Servidor de desarrollo (puerto 4200)
npm run build      # Build de producción
npm test           # Ejecutar tests unitarios
npm run lint       # Linting del código
```

## 🎨 Estilos

El proyecto usa Tailwind CSS con la siguiente configuración:
- **Color primario**: Indigo (#6366F1)
- **Fuente**: Inter (system fonts)
- **Modo**: Solo modo claro (sin dark mode)
- **Responsive**: Mobile-first

## 🔧 Configuración

### Environment

Editar `src/environments/environment.ts`:

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api'
};
```

### Proxy (Opcional)

Si necesitas configurar un proxy, edita `proxy.conf.json`.

## 📖 Guías de Desarrollo

### Crear un Nuevo Componente

```powershell
ng generate component features/mi-feature/mi-componente --standalone
```

### Crear un Nuevo Servicio

```powershell
ng generate service core/services/mi-servicio
```

### Agregar una Nueva Ruta

Editar `src/app/app.routes.ts`:

```typescript
{
  path: 'mi-ruta',
  component: MiComponente,
  canActivate: [authGuard, roleGuard],
  data: { roles: ['ADMIN'] }
}
```

## 🐛 Solución de Problemas

### El servidor no inicia
```powershell
# Eliminar node_modules y reinstalar
Remove-Item node_modules -Recurse -Force
npm install
```

### Error de CORS
Verifica que el backend esté configurado para aceptar peticiones desde `http://localhost:4200`

### Errores de compilación
```powershell
# Limpiar caché y reconstruir
npm run build -- --delete-output-path
```

## 📝 Notas Importantes

- Todos los componentes son **standalone** (Angular 18+)
- Se usa control flow syntax nuevo de Angular: `@if`, `@for`, `@switch`
- Los estilos son **claros** (sin dark mode)
- Layout: Navbar + Sidebar + Content area
- Lazy loading habilitado en todas las rutas

## 🤝 Contribución

Para contribuir al proyecto:
1. Sigue la estructura de carpetas existente
2. Usa standalone components
3. Mantén los estilos consistentes (Tailwind + Indigo)
4. Documenta funcionalidades complejas
5. Realiza pruebas antes de commit

## 📄 Licencia

Proyecto educativo - MexAula

---

**Última actualización**: Diciembre 2025  
**Versión Angular**: 18  
**Node**: 18+

- `getMyCourses()` - Cursos del alumno
- `getMyTeacherCourses()` - Cursos del maestro
- `enroll(courseId)` - Inscribirse en curso
- `create(payload)` - Crear curso
- `update(id, payload)` - Actualizar curso
- `delete(id)` - Eliminar curso

### UserService
- `getMe()` - Obtener mi perfil
- `updateMe(payload)` - Actualizar mi perfil
- `changePassword(payload)` - Cambiar contraseña
- `getAll()` - Obtener todos los usuarios (ADMIN)
- `create(payload)` - Crear usuario (ADMIN)
- `update(id, payload)` - Actualizar usuario (ADMIN)
- `toggleStatus(id, activo)` - Activar/Desactivar usuario

### CertificateService
- `getMyCertificates()` - Obtener mis certificados
- `generate(courseId)` - Generar certificado
- `verify(code)` - Verificar certificado

### ParentalControlService
- `getChildren()` - Obtener lista de hijos
- `getChildProgress(childId)` - Progreso de un hijo
- `getSettings()` - Obtener configuración parental
- `updateSettings(payload)` - Actualizar configuración

## Guards

### AuthGuard
Protege rutas que requieren autenticación. Redirige a `/auth/login` si no está autenticado.

### RoleGuard
Protege rutas que requieren roles específicos. Usa `data.roles` en la definición de rutas.

Ejemplo:
```typescript
{
  path: 'admin/users',
  component: UserAdminListComponent,
  canActivate: [authGuard, roleGuard],
  data: { roles: ['ADMIN'] }
}
```

## Interceptores

### AuthInterceptor
Agrega automáticamente el token JWT en el header `Authorization: Bearer <token>` a todas las peticiones HTTP.

### ErrorInterceptor
Maneja errores HTTP:
- 401: Redirige a login
- 403: Muestra mensaje de "No autorizado"
- 404: Muestra mensaje de "No encontrado"
- 500: Muestra mensaje de error del servidor

## Modelos TypeScript

Los modelos están completamente tipados y alineados con los DTOs del backend:
- `User`, `Role`
- `Course`, `CourseLevel`
- `Enrollment`
- `Certificate`
- `ParentalLink`, `ParentalSettings`, `ChildProgress`

## Build de Producción

```bash
npm run build
```

Los archivos compilados estarán en `dist/frontend/`.

## Variables de Entorno

Edita `src/environments/environment.ts` para configurar:

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api'
};
```

## Integración con Backend

El frontend espera que el backend esté corriendo en `http://localhost:8080/api` con los siguientes endpoints:

- `/auth/login` - POST
- `/auth/register` - POST
- `/auth/me` - GET
- `/users/*` - CRUD de usuarios
- `/courses/*` - CRUD de cursos
- `/enrollments/*` - Gestión de inscripciones
- `/certificates/*` - Gestión de certificados
- `/parental/*` - Control parental

Todos los endpoints (excepto login y register) requieren autenticación con JWT.

## Próximos Pasos

1. Implementar backend con Spring Boot
2. Configurar base de datos PostgreSQL/MySQL
3. Implementar generación de PDFs para certificados
4. Agregar tests unitarios y e2e
5. Implementar sistema de notificaciones en tiempo real
6. Agregar analytics y métricas

## Soporte

Para más información sobre Angular: https://angular.dev
Para más información sobre Tailwind CSS: https://tailwindcss.com

