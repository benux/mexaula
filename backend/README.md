# MexAula Backend

Backend de la plataforma educativa MexAula desarrollado con Spring Boot 3.x, JWT y PostgreSQL.

## 🚀 Quick Start

### 1. Requisitos Previos
- Java 17+
- PostgreSQL 12+
- Maven 3.6+ (opcional, incluye Maven Wrapper)

### 2. Configuración Rápida

```bash
# 1. Crear base de datos
psql -U postgres -c "CREATE DATABASE MexAula;"

# 2. Ejecutar scripts SQL
psql -U postgres -d MexAula -f src/main/resources/schema.sql
psql -U postgres -d MexAula -f src/main/resources/data.sql

# 3. Configurar credenciales (editar application.properties o crear variables de entorno)
# DB_USER=postgres
# DB_PASSWORD=tu_contraseña

# 4. Compilar y ejecutar
./mvnw spring-boot:run
```

La aplicación estará en: **http://localhost:8080/api**

## 📚 Documentación Completa

- **[INSTALACION.md](INSTALACION.md)** - Guía detallada de instalación
- **[CONFIGURACION_BD.md](CONFIGURACION_BD.md)** - Configuración de base de datos

## 🛠️ Stack Tecnológico

- **Java 17** - Lenguaje de programación
- **Spring Boot 3.2.0** - Framework principal
- **Spring Security + JWT** - Autenticación y autorización
- **PostgreSQL** - Base de datos relacional
- **Hibernate/JPA** - ORM
- **Maven** - Gestión de dependencias
- **Lombok** - Reducción de boilerplate

## 📁 Estructura del Proyecto

```
backend/
├── src/main/java/com/MexAula/
│   ├── config/          # Configuración (SecurityConfig)
│   ├── controller/      # REST Controllers
│   ├── dto/            # Data Transfer Objects
│   ├── exception/      # Manejo de excepciones
│   ├── model/          # Entidades JPA
│   ├── repository/     # Repositorios Spring Data
│   ├── security/       # JWT (JwtService, JwtAuthenticationFilter)
│   ├── service/        # Lógica de negocio
│   └── util/           # Utilidades (DtoMapper, StringListConverter)
└── src/main/resources/
    ├── application.properties      # Configuración principal
    ├── backup.sql                 # Backup completo (estructura + datos)
    ├── schema.sql                 # Solo estructura (alternativo)
    ├── data.sql                   # Solo datos básicos (alternativo)
    └── fix-etiquetas-format.sql   # Script de migración
```

## 🔐 Credenciales de Prueba

Después de restaurar `backup.sql`:

| Rol | Email | Contraseña |
|-----|-------|-----------|
| ADMIN | admin@MexAula.com | admin123 |
| MAESTRO | carlos.lopez@MexAula.com | maestro123 |
| ALUMNO | maria.garcia@MexAula.com | alumno123 |
| PADRE | juan.martinez@MexAula.com | padre123 |

⚠️ **Cambiar en producción**

## 🌐 Endpoints Principales

### Autenticación (Público)
- `POST /api/auth/login` - Iniciar sesión
- `POST /api/auth/register` - Registrar usuario

### Usuarios
- `GET /api/users/me` - Perfil actual
- `PUT /api/users/me` - Actualizar perfil
- `POST /api/users/change-password` - Cambiar contraseña
- `GET /api/users` - Listar usuarios (ADMIN)
- `POST /api/users` - Crear usuario (ADMIN)

### Cursos
- `GET /api/courses` - Listar cursos (público)
- `GET /api/courses/{id}` - Ver curso (público)
- `GET /api/courses/my` - Mis cursos (ALUMNO)
- `POST /api/courses/{id}/enroll` - Inscribirse (ALUMNO)
- `POST /api/courses` - Crear curso (ADMIN/MAESTRO)

### Logros (Achievements)
- `GET /api/achievements/active` - Logros activos (público)
- `GET /api/achievements/my` - Mis logros (ALUMNO)
- `GET /api/achievements` - Gestionar logros (ADMIN)

### Tech Posts
- `GET /api/tech-posts` - Posts publicados (público)
- `GET /api/tech-posts/{id}` - Ver post (público)
- `GET /api/tech-posts/slug/{slug}` - Ver por slug (público)
- `GET /api/tech-posts/admin` - Todos los posts (ADMIN/MAESTRO)
- `POST /api/tech-posts` - Crear post (ADMIN/MAESTRO)

### Certificados
- `GET /api/certificates/verify/{codigo}` - Verificar certificado (público)

### Control Parental
- `GET /api/parental/children` - Mis hijos (PADRE)
- `GET /api/parental/children/{id}/progress` - Progreso del hijo (PADRE)

## ⚙️ Configuración

### application.properties

```properties
# Puerto del servidor
server.port=8080
server.servlet.context-path=/api

# Base de Datos
spring.datasource.url=jdbc:postgresql://localhost:5432/MexAula
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASSWORD}

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=true

# JWT
jwt.secret=tu_clave_secreta_base64
jwt.expiration=86400000

# Logs
logging.level.com.MexAula=DEBUG
```

## 🐛 Solución de Problemas

### Puerto 8080 ya en uso
```properties
# Cambiar en application.properties
server.port=8081
```

### Error de conexión a base de datos
1. Verifica que PostgreSQL esté corriendo
2. Confirma las credenciales en `application.properties`
3. Asegúrate de que la BD `MexAula` existe

### Error de versión de Java
```bash
# Verificar versión (debe ser 17+)
java -version
```

### Limpiar y recompilar
```bash
./mvnw clean install -U
```

## 📊 Base de Datos

### Tablas
- `usuarios` - Cuentas de usuario
- `roles` - Roles del sistema (ADMIN, MAESTRO, ALUMNO, PADRE)
- `cursos` - Cursos disponibles
- `inscripciones` - Inscripciones de alumnos
- `certificados` - Certificados de finalización
- `parental_controls` - Relaciones padre-hijo
- `logros` - Logros/insignias
- `logros_usuarios` - Logros obtenidos por usuarios
- `tech_posts` - Posts educativos

Ver **[CONFIGURACION_BD.md](CONFIGURACION_BD.md)** para detalles completos.

## 🔄 Migraciones

### Migrar formato de etiquetas (si tienes datos previos)
```bash
psql -U postgres -d MexAula -f src/main/resources/fix-etiquetas-format.sql
```

## 🧪 Testing

```bash
# Ejecutar tests
./mvnw test

# Ejecutar con coverage
./mvnw test jacoco:report
```

## 📦 Build para Producción

```bash
# Compilar JAR
./mvnw clean package -DskipTests

# Ejecutar JAR
java -jar target/MexAula-backend-0.0.1-SNAPSHOT.jar
```

## 🔒 Seguridad

- Autenticación basada en JWT
- Contraseñas encriptadas con BCrypt
- CORS configurado para `http://localhost:4200`
- Autorización basada en roles con `@PreAuthorize`
- Sesiones stateless

## 📝 Notas de Desarrollo

### Roles y Permisos
- **ADMIN**: Acceso completo al sistema
- **MAESTRO**: Crear/gestionar cursos y tech posts
- **ALUMNO**: Inscribirse en cursos, ver logros
- **PADRE**: Monitorear progreso de hijos

### Context Path
Todos los endpoints están bajo `/api`:
- Login: `http://localhost:8080/api/auth/login`
- Cursos: `http://localhost:8080/api/courses`

### Formato de Etiquetas
Los tech posts usan `List<String>` para etiquetas. El conversor `StringListConverter` maneja automáticamente la conversión a/desde JSON array en PostgreSQL.

## 📞 Soporte

Para problemas o dudas:
1. Revisa [INSTALACION.md](INSTALACION.md)
2. Consulta [CONFIGURACION_BD.md](CONFIGURACION_BD.md)
3. Revisa los logs de la aplicación
4. Documentación Spring Boot: https://spring.io/projects/spring-boot

---

**Versión:** 1.0.0  
**Última actualización:** Diciembre 2024

