# MexAula 🎓

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Angular](https://img.shields.io/badge/Angular-21.0-red.svg)](https://angular.io/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-green.svg)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-12%2B-blue.svg)](https://www.postgresql.org/)

**MexAula** es una plataforma educativa integral de código abierto diseñada para entornos de aprendizaje modernos. Construida con Angular 21 y Spring Boot 3, proporciona una solución completa para estudiantes, maestros, padres y administradores para gestionar cursos, rastrear logros y monitorear el progreso de aprendizaje.

## ✨ Características Principales

### 👥 Sistema Multi-Rol
- **Estudiantes (ALUMNO)**: Inscribirse en cursos, obtener logros, rastrear progreso
- **Maestros (MAESTRO)**: Crear y gestionar cursos, monitorear el rendimiento de los estudiantes
- **Padres (PADRE)**: Control parental, monitorear el progreso de los hijos
- **Administradores (ADMIN)**: Gestión completa del sistema y configuración

### 📚 Gestión de Cursos
- Catálogo completo de cursos con múltiples niveles de dificultad (BASICO, INTERMEDIO, AVANZADO)
- Inscripción en cursos y seguimiento del progreso
- Certificados de finalización para estudiantes
- Monitoreo del progreso en tiempo real

### 🏆 Sistema de Logros
- Desbloqueo automático de logros basado en el progreso del estudiante
- Creación de logros personalizados para maestros y administradores
- Características sociales y compartir logros
- Sistema de recompensas basado en puntos
- Logros predefinidos:
  - Primera Inscripción
  - Primera Finalización
  - Hito de Tres Cursos
  - Hito de Diez Cursos
  - Racha de Siete Días
  - Puntuación Perfecta (Perfeccionista)
  - Finalización Rápida
  - ¡Y más!

### 👨‍👩‍👧‍👦 Control Parental
- Vincular cuentas de padres con cuentas de estudiantes
- Establecer niveles máximos de dificultad de contenido
- Configurar límites de tiempo diario
- Monitorear el progreso y finalización de cursos de los hijos
- Seguimiento de actividad en tiempo real

### 📝 Blog Técnico y Contenido Educativo
- Publicaciones técnicas basadas en Markdown
- Organización por categorías y etiquetas
- Gestión de estado borrador y publicado
- Creación de contenido por maestros y administradores

### 🔐 Seguridad
- Autenticación basada en JWT
- Control de acceso basado en roles (RBAC)
- Interceptores HTTP para llamadas seguras a la API
- Encriptación y validación de contraseñas
- Rutas protegidas con guardias de autenticación

### 🎨 UI/UX Moderno
- Diseño responsivo con Tailwind CSS
- Interfaz limpia e intuitiva
- Soporte de modo oscuro
- Diseños amigables para móviles

## 🏗️ Arquitectura

### Frontend (Angular 21)
```
frontend/
├── src/app/
│   ├── core/                    # Servicios principales y modelos
│   │   ├── guards/              # Protección de rutas
│   │   ├── interceptors/        # Interceptores HTTP
│   │   ├── models/              # Interfaces TypeScript
│   │   └── services/            # Servicios de lógica de negocio
│   ├── features/                # Módulos de características
│   │   ├── achievements/        # Gestión de logros
│   │   ├── admin/               # Panel de administración
│   │   ├── auth/                # Autenticación
│   │   ├── certificates/        # Generación de certificados
│   │   ├── courses/             # Gestión de cursos
│   │   ├── dashboard/           # Tableros de usuario
│   │   ├── parental/            # Controles parentales
│   │   ├── tech-posts/          # Publicaciones de blog
│   │   └── users/               # Gestión de usuarios
│   └── shared/                  # Componentes compartidos
```

### Backend (Spring Boot 3)
```
backend/
├── src/main/java/com/aulabase/
│   ├── config/                  # Configuración de aplicación
│   ├── controller/              # Endpoints REST API
│   ├── dto/                     # Objetos de Transferencia de Datos
│   ├── exception/               # Manejo de errores
│   ├── model/                   # Entidades JPA
│   ├── repository/              # Capa de acceso a datos
│   ├── security/                # Configuración JWT y Seguridad
│   ├── service/                 # Lógica de negocio
│   └── util/                    # Clases de utilidad
└── src/main/resources/
    ├── schema.sql               # Esquema de base de datos
    ├── data.sql                 # Datos iniciales
    └── application.properties   # Configuración
```

## 🚀 Inicio Rápido

### Requisitos Previos
- **Java 17+** - [Descargar](https://adoptium.net/)
- **Node.js 18+** - [Descargar](https://nodejs.org/)
- **PostgreSQL 12+** - [Descargar](https://www.postgresql.org/download/)
- **Maven 3.6+** (opcional, incluye Maven Wrapper)
- **npm 9+** (incluido con Node.js)

### Configuración del Backend

1. **Crear Base de Datos**
   ```bash
   psql -U postgres -c "CREATE DATABASE MexAula;"
   ```

2. **Inicializar Base de Datos**
   ```bash
   cd backend
   psql -U postgres -d MexAula -f src/main/resources/schema.sql
   psql -U postgres -d MexAula -f src/main/resources/data.sql
   ```

3. **Configurar Conexión a Base de Datos**
   
   Opción A - Variables de Entorno (Recomendado):
   ```bash
   # Windows
   setx DB_USER "postgres"
   setx DB_PASSWORD "tu_contraseña"
   
   # Linux/Mac
   export DB_USER=postgres
   export DB_PASSWORD=tu_contraseña
   ```
   
   Opción B - Editar `application.properties`:
   ```properties
   spring.datasource.username=postgres
   spring.datasource.password=tu_contraseña
   ```

4. **Ejecutar Backend**
   ```bash
   # Usando Maven Wrapper (recomendado)
   ./mvnw spring-boot:run
   
   # O usando Maven instalado
   mvn spring-boot:run
   ```

   API Backend disponible en: `http://localhost:8080/api`

### Configuración del Frontend

1. **Instalar Dependencias**
   ```bash
   cd frontend
   npm install
   ```

2. **Iniciar Servidor de Desarrollo**
   ```bash
   npm start
   ```

   Frontend disponible en: `http://localhost:4200`

3. **Compilar para Producción**
   ```bash
   npm run build
   ```

## 📖 Documentación

La documentación detallada está disponible en los siguientes archivos:

### Backend
- [Guía de Instalación del Backend](backend/INSTALACION.md) - Instrucciones completas de configuración del backend
- [Configuración de Base de Datos](backend/CONFIGURACION_BD.md) - Configuración e instalación de la base de datos
- [README del Backend](backend/README.md) - Información específica del backend

### Frontend
- [Guía de Instalación del Frontend](frontend/INSTALACION.md) - Instrucciones completas de configuración del frontend
- [Primeros Pasos](frontend/INICIAR.md) - Cómo ejecutar el servidor de desarrollo
- [Estructura de Base de Datos](frontend/BASE_DE_DATOS.md) - Entendiendo el modelo de datos
- [README del Frontend](frontend/README.md) - Información específica del frontend

## 🛠️ Stack Tecnológico

### Frontend
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| Angular | 21.0 | Framework frontend |
| TypeScript | 5.9 | Lenguaje de programación |
| Tailwind CSS | 3.4 | Framework de estilos |
| RxJS | 7.8 | Programación reactiva |
| Angular Router | 21.0 | Navegación |

### Backend
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| Java | 17 | Lenguaje de programación |
| Spring Boot | 3.2.0 | Framework backend |
| Spring Security | 3.2.0 | Autenticación y Autorización |
| Spring Data JPA | 3.2.0 | Persistencia de datos |
| PostgreSQL | 12+ | Base de datos |
| JWT | - | Autenticación basada en tokens |
| Lombok | - | Generación de código |
| Hibernate | - | ORM |

## 🎯 Endpoints de la API

### Autenticación
- `POST /api/auth/login` - Inicio de sesión de usuario
- `POST /api/auth/register` - Registro de usuario
- `POST /api/auth/change-password` - Cambiar contraseña

### Cursos
- `GET /api/courses` - Listar todos los cursos
- `GET /api/courses/{id}` - Obtener detalles del curso
- `POST /api/courses` - Crear curso (ADMIN/MAESTRO)
- `PUT /api/courses/{id}` - Actualizar curso (ADMIN/MAESTRO)
- `DELETE /api/courses/{id}` - Eliminar curso (ADMIN)

### Inscripciones
- `POST /api/enrollments` - Inscribirse en un curso
- `GET /api/enrollments/student/{id}` - Obtener inscripciones del estudiante
- `PUT /api/enrollments/{id}/progress` - Actualizar progreso

### Logros
- `GET /api/achievements` - Listar todos los logros
- `GET /api/achievements/student/{id}` - Obtener logros del estudiante
- `POST /api/achievements` - Crear logro (ADMIN/MAESTRO)

### Control Parental
- `POST /api/parental/link` - Vincular padre con hijo
- `GET /api/parental/children` - Obtener hijos vinculados
- `PUT /api/parental/settings` - Actualizar configuración parental
- `GET /api/parental/progress/{childId}` - Obtener progreso del hijo

### Certificados
- `GET /api/certificates/student/{id}` - Obtener certificados del estudiante
- `POST /api/certificates/generate` - Generar certificado

### Publicaciones Técnicas
- `GET /api/tech-posts` - Listar publicaciones publicadas
- `GET /api/tech-posts/{slug}` - Obtener publicación por slug
- `POST /api/tech-posts` - Crear publicación (MAESTRO/ADMIN)
- `PUT /api/tech-posts/{id}` - Actualizar publicación
- `DELETE /api/tech-posts/{id}` - Eliminar publicación

## 👤 Usuarios por Defecto

Después de ejecutar `data.sql`, los siguientes usuarios de prueba están disponibles:

| Rol | Email | Contraseña | Descripción |
|------|-------|----------|-------------|
| ADMIN | admin@mexaula.com | admin123 | Administrador del sistema |
| MAESTRO | maestro@mexaula.com | maestro123 | Cuenta de maestro |
| ALUMNO | alumno@mexaula.com | alumno123 | Cuenta de estudiante |
| PADRE | padre@mexaula.com | padre123 | Cuenta de padre |

**⚠️ Importante:** ¡Cambia estas contraseñas en producción!

## 🧪 Pruebas

### Pruebas del Backend
```bash
cd backend
./mvnw test
```

### Pruebas del Frontend
```bash
cd frontend
npm test
```

## 🚢 Despliegue

### Despliegue del Backend
1. Construir el archivo JAR:
   ```bash
   ./mvnw clean package
   ```

2. Ejecutar el JAR:
   ```bash
   java -jar target/backend-1.0.0.jar
   ```

### Despliegue del Frontend
1. Compilar para producción:
   ```bash
   npm run build
   ```

2. Desplegar la carpeta `dist/` en tu servidor web (Nginx, Apache, etc.)

### Variables de Entorno
Configura estas para producción:
```
DB_USER=tu_usuario_db
DB_PASSWORD=tu_contraseña_db
JWT_SECRET=tu_secreto_jwt
CORS_ORIGINS=https://tudominio.com
```

## 🤝 Contribuciones

¡Damos la bienvenida a contribuciones! Por favor sigue estos pasos:

1. Haz un fork del repositorio
2. Crea una rama de características (`git checkout -b feature/CaracteristicaIncreible`)
3. Haz commit de tus cambios (`git commit -m 'Agregar alguna CaracteristicaIncreible'`)
4. Haz push a la rama (`git push origin feature/CaracteristicaIncreible`)
5. Abre un Pull Request

### Estándares de Código
- Sigue la guía de estilo de Angular para el frontend
- Sigue las mejores prácticas de Spring Boot para el backend
- Escribe mensajes de commit significativos
- Incluye pruebas para nuevas características
- Actualiza la documentación según sea necesario

## 🐛 Reportes de Bugs

¿Encontraste un bug? Por favor abre un issue con:
- Descripción clara del problema
- Pasos para reproducir
- Comportamiento esperado vs comportamiento actual
- Capturas de pantalla (si aplica)
- Detalles del entorno (SO, navegador, versiones)

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia Pública General de GNU v3.0 - consulta el archivo [LICENSE](LICENSE) para más detalles.

Esto significa que puedes:
- ✅ Usar comercialmente
- ✅ Modificar
- ✅ Distribuir
- ✅ Uso de patentes
- ✅ Uso privado

Bajo las siguientes condiciones:
- 📝 Divulgar código fuente
- 📝 Aviso de licencia y derechos de autor
- 📝 Misma licencia
- 📝 Declarar cambios

## 🙏 Agradecimientos

- Equipo de Angular por el increíble framework
- Equipo de Spring Boot por el robusto framework backend
- Comunidad de PostgreSQL
- Equipo de Tailwind CSS
- Todos los contribuidores y usuarios de MexAula

## 📧 Contacto

Para preguntas, sugerencias o soporte, por favor abre un issue en GitHub.

---

Hecho con ❤️ por el Equipo de MexAula | © 2025

**¡Feliz Aprendizaje! 📚✨**

