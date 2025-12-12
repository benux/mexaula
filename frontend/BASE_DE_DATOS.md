# Configuración de Base de Datos - AulaBase

## Información General

AulaBase utiliza una base de datos relacional para almacenar toda la información del sistema. El backend (Spring Boot) se conecta a la base de datos, mientras que el frontend (Angular) consume la API REST del backend.

## Base de Datos Recomendada

El sistema es compatible con las siguientes bases de datos:

- **MySQL** 8.0+ (Recomendado)
- **PostgreSQL** 13+
- **H2** (Para desarrollo y pruebas)

## Opción 1: MySQL (Recomendado para Producción)

### Paso 1: Instalar MySQL

1. Descarga MySQL desde: https://dev.mysql.com/downloads/mysql/
2. Ejecuta el instalador
3. Durante la instalación, configura:
   - Puerto: `3306` (predeterminado)
   - Usuario root y contraseña

### Paso 2: Crear la Base de Datos

Abre MySQL Workbench o la línea de comandos de MySQL:

```sql
-- Crear la base de datos
CREATE DATABASE aulabase CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Crear usuario para la aplicación (opcional pero recomendado)
CREATE USER 'aulabase_user'@'localhost' IDENTIFIED BY 'aulabase_password';

-- Otorgar permisos
GRANT ALL PRIVILEGES ON aulabase.* TO 'aulabase_user'@'localhost';

-- Aplicar cambios
FLUSH PRIVILEGES;
```

### Paso 3: Configurar el Backend

Edita el archivo `application.properties` o `application.yml` en el backend:

**application.properties:**
```properties
# Configuración de Base de Datos MySQL
spring.datasource.url=jdbc:mysql://localhost:3306/aulabase?useSSL=false&serverTimezone=UTC
spring.datasource.username=aulabase_user
spring.datasource.password=aulabase_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.properties.hibernate.format_sql=true
```

## Opción 2: PostgreSQL

### Paso 1: Instalar PostgreSQL

1. Descarga PostgreSQL desde: https://www.postgresql.org/download/
2. Ejecuta el instalador
3. Configura el puerto (predeterminado: `5432`) y contraseña para el usuario `postgres`

### Paso 2: Crear la Base de Datos

Abre pgAdmin o psql:

```sql
-- Crear la base de datos
CREATE DATABASE aulabase WITH ENCODING 'UTF8';

-- Crear usuario (opcional)
CREATE USER aulabase_user WITH PASSWORD 'aulabase_password';

-- Otorgar permisos
GRANT ALL PRIVILEGES ON DATABASE aulabase TO aulabase_user;
```

### Paso 3: Configurar el Backend

**application.properties:**
```properties
# Configuración de Base de Datos PostgreSQL
spring.datasource.url=jdbc:postgresql://localhost:5432/aulabase
spring.datasource.username=aulabase_user
spring.datasource.password=aulabase_password
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.properties.hibernate.format_sql=true
```

## Opción 3: H2 (Solo para Desarrollo)

H2 es una base de datos en memoria, perfecta para pruebas rápidas.

### Configurar el Backend

**application.properties:**
```properties
# Configuración de Base de Datos H2
spring.datasource.url=jdbc:h2:mem:aulabase
spring.datasource.username=sa
spring.datasource.password=
spring.datasource.driver-class-name=org.h2.Driver

# H2 Console (para ver la BD en http://localhost:8080/h2-console)
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.H2Dialect
```

**Nota:** Con H2, los datos se pierden al reiniciar la aplicación.

## Estructura de la Base de Datos

El backend de Spring Boot creará automáticamente las siguientes tablas con la opción `spring.jpa.hibernate.ddl-auto=update`:

### Tablas Principales

#### 1. **users** - Usuarios del sistema
Columnas:
- `id` (BIGINT, PK, AUTO_INCREMENT)
- `email` (VARCHAR(100), UNIQUE, NOT NULL)
- `password` (VARCHAR(255), NOT NULL) - Hash BCrypt
- `nombre` (VARCHAR(100), NOT NULL)
- `apellido` (VARCHAR(100), NOT NULL)
- `roles` (VARCHAR(50), NOT NULL) - ADMIN, MAESTRO, PADRE, ALUMNO
- `activo` (BOOLEAN, DEFAULT true)
- `creado_en` (TIMESTAMP)
- `actualizado_en` (TIMESTAMP)

#### 2. **courses** - Cursos disponibles
Columnas:
- `id` (BIGINT, PK, AUTO_INCREMENT)
- `titulo` (VARCHAR(200), NOT NULL)
- `descripcion` (TEXT)
- `nivel` (VARCHAR(50)) - BASICO, INTERMEDIO, AVANZADO
- `maestro_id` (BIGINT, FK → users)
- `maestro_nombre` (VARCHAR(200)) - Desnormalizado para queries
- `publicado` (BOOLEAN, DEFAULT false)
- `creado_en` (TIMESTAMP)
- `actualizado_en` (TIMESTAMP)

#### 3. **enrollments** - Inscripciones de alumnos a cursos
Columnas:
- `id` (BIGINT, PK, AUTO_INCREMENT)
- `alumno_id` (BIGINT, FK → users, NOT NULL)
- `curso_id` (BIGINT, FK → courses, NOT NULL)
- `fecha_inscripcion` (TIMESTAMP, NOT NULL)
- `progreso` (DECIMAL(5,2), DEFAULT 0.00) - Porcentaje 0-100
- `estado` (VARCHAR(50)) - ACTIVO, COMPLETADO, ABANDONADO
- `calificacion` (DECIMAL(5,2)) - Nota final

Índices:
- UNIQUE(alumno_id, curso_id) - Un alumno solo puede inscribirse una vez

#### 4. **certificates** - Certificados emitidos
Columnas:
- `id` (BIGINT, PK, AUTO_INCREMENT)
- `alumno_id` (BIGINT, FK → users, NOT NULL)
- `curso_id` (BIGINT, FK → courses, NOT NULL)
- `codigo_verificacion` (VARCHAR(100), UNIQUE, NOT NULL)
- `fecha_emision` (TIMESTAMP, NOT NULL)
- `url_pdf` (VARCHAR(500))

#### 5. **parental_controls** - Control parental (relaciones padre-hijo)
Columnas:
- `id` (BIGINT, PK, AUTO_INCREMENT)
- `padre_id` (BIGINT, FK → users, NOT NULL)
- `hijo_id` (BIGINT, FK → users, NOT NULL)
- `puede_inscribirse` (BOOLEAN, DEFAULT true)
- `limite_diario_minutos` (INT) - NULL = sin límite
- `notificaciones_activas` (BOOLEAN, DEFAULT true)
- `creado_en` (TIMESTAMP)

Índices:
- UNIQUE(padre_id, hijo_id)

#### 6. **progress_logs** - Registro de progreso y actividad
Columnas:
- `id` (BIGINT, PK, AUTO_INCREMENT)
- `alumno_id` (BIGINT, FK → users, NOT NULL)
- `curso_id` (BIGINT, FK → courses, NOT NULL)
- `fecha` (DATE, NOT NULL)
- `minutos_estudiados` (INT, DEFAULT 0)
- `actividades_completadas` (INT, DEFAULT 0)

#### 7. **logros** (achievements) - Logros del sistema
Columnas:
- `id` (BIGINT, PK, AUTO_INCREMENT)
- `titulo` (VARCHAR(100), NOT NULL)
- `descripcion` (TEXT, NOT NULL)
- `icono_url` (VARCHAR(255)) - Ruta al icono SVG, ej: /icons/first-completion.svg
- `tipo` (VARCHAR(20), NOT NULL) - SYSTEM, CUSTOM
- `criterio_codigo` (VARCHAR(50), UNIQUE, NOT NULL) - Código único del criterio
- `puntos` (INT, DEFAULT 0)
- `activo` (BOOLEAN, DEFAULT true)
- `creado_en` (TIMESTAMP)
- `actualizado_en` (TIMESTAMP)

Ejemplos de criterios:
- `COMPLETE_FIRST_COURSE` → /icons/first-completion.svg
- `ENROLL_FIRST_COURSE` → /icons/first-enrollment.svg
- `SEVEN_DAY_STREAK` → /icons/seven-day-streak.svg

#### 8. **user_achievements** - Logros obtenidos por usuarios
Columnas:
- `id` (BIGINT, PK, AUTO_INCREMENT)
- `logro_id` (BIGINT, FK → logros, NOT NULL)
- `alumno_id` (BIGINT, FK → users, NOT NULL)
- `fecha_obtenido` (TIMESTAMP, NOT NULL)
- `compartido_veces` (INT, DEFAULT 0) - Contador de compartidos en redes

Índices:
- UNIQUE(logro_id, alumno_id) - Un logro solo se obtiene una vez

#### 9. **tech_posts** - Publicaciones técnicas educativas
Columnas:
- `id` (BIGINT, PK, AUTO_INCREMENT)
- `titulo` (VARCHAR(200), NOT NULL)
- `resumen` (TEXT, NOT NULL)
- `contenido_markdown` (TEXT, NOT NULL) - Contenido en formato Markdown
- `slug` (VARCHAR(250), UNIQUE, NOT NULL) - URL amigable
- `categoria` (VARCHAR(100)) - Frontend, Backend, DevOps, etc.
- `etiquetas` (JSON o TEXT) - Array de tags
- `estado` (VARCHAR(20), NOT NULL) - DRAFT, PUBLISHED
- `autor_id` (BIGINT, FK → users, NOT NULL)
- `autor_nombre` (VARCHAR(200)) - Desnormalizado
- `creado_en` (TIMESTAMP)
- `actualizado_en` (TIMESTAMP)

### Relaciones entre Tablas

```
users (1) ←→ (N) courses (maestro_id)
users (1) ←→ (N) enrollments (alumno_id)
courses (1) ←→ (N) enrollments (curso_id)
users (1) ←→ (N) certificates (alumno_id)
courses (1) ←→ (N) certificates (curso_id)
users (1) ←→ (N) parental_controls (padre_id)
users (1) ←→ (N) parental_controls (hijo_id)
users (1) ←→ (N) logros (autor_id para CUSTOM)
logros (1) ←→ (N) user_achievements (logro_id)
users (1) ←→ (N) user_achievements (alumno_id)
users (1) ←→ (N) tech_posts (autor_id)
```

## Inicializar Datos de Prueba

El backend puede incluir datos de prueba al iniciar. Busca o crea un archivo `data.sql` o `import.sql` en `src/main/resources/`:

```sql
-- ============================================
-- USUARIOS DE PRUEBA
-- ============================================
-- Nota: Las contraseñas deben estar hasheadas con BCrypt
-- Password para todos: "password123"
-- Hash BCrypt: $2a$10$8K1p/a0dL3.MUBH/CpHTH.Vb1L1J.XlNv.p1pHsQ7fQ7m7L6M9Bm.

INSERT INTO users (email, password, nombre, apellido, roles, activo, creado_en) VALUES 
('admin@mexaula.com', '$2a$10$8K1p/a0dL3.MUBH/CpHTH.Vb1L1J.XlNv.p1pHsQ7fQ7m7L6M9Bm.', 'Admin', 'Sistema', 'ADMIN', true, NOW()),
('maestro@mexaula.com', '$2a$10$8K1p/a0dL3.MUBH/CpHTH.Vb1L1J.XlNv.p1pHsQ7fQ7m7L6M9Bm.', 'Juan', 'Pérez', 'MAESTRO', true, NOW()),
('padre@mexaula.com', '$2a$10$8K1p/a0dL3.MUBH/CpHTH.Vb1L1J.XlNv.p1pHsQ7fQ7m7L6M9Bm.', 'María', 'García', 'PADRE', true, NOW()),
('alumno@mexaula.com', '$2a$10$8K1p/a0dL3.MUBH/CpHTH.Vb1L1J.XlNv.p1pHsQ7fQ7m7L6M9Bm.', 'Pedro', 'López', 'ALUMNO', true, NOW()),
('alumno2@mexaula.com', '$2a$10$8K1p/a0dL3.MUBH/CpHTH.Vb1L1J.XlNv.p1pHsQ7fQ7m7L6M9Bm.', 'Ana', 'Martínez', 'ALUMNO', true, NOW());

-- ============================================
-- CURSOS DE PRUEBA
-- ============================================
INSERT INTO courses (titulo, descripcion, nivel, maestro_id, maestro_nombre, publicado, creado_en) VALUES 
('Introducción a JavaScript', 'Aprende los fundamentos de JavaScript desde cero', 'BASICO', 2, 'Juan Pérez', true, NOW()),
('Angular Avanzado', 'Domina Angular con componentes standalone y RxJS', 'AVANZADO', 2, 'Juan Pérez', true, NOW()),
('Bases de Datos SQL', 'MySQL y PostgreSQL para principiantes', 'INTERMEDIO', 2, 'Juan Pérez', true, NOW()),
('HTML y CSS Básico', 'Crea páginas web con HTML5 y CSS3', 'BASICO', 2, 'Juan Pérez', true, NOW());

-- ============================================
-- LOGROS DEL SISTEMA
-- ============================================
INSERT INTO logros (titulo, descripcion, icono_url, tipo, criterio_codigo, puntos, activo, creado_en) VALUES 
('Primera Inscripción', 'Te inscribiste en tu primer curso', '/icons/first-enrollment.svg', 'SYSTEM', 'ENROLL_FIRST_COURSE', 10, true, NOW()),
('Primer Curso Completado', 'Completaste tu primer curso con éxito', '/icons/first-completion.svg', 'SYSTEM', 'COMPLETE_FIRST_COURSE', 50, true, NOW()),
('Tres Cursos', 'Has completado 3 cursos', '/icons/three-courses.svg', 'SYSTEM', 'COMPLETE_THREE_COURSES', 100, true, NOW()),
('Diez Cursos', 'Completaste 10 cursos - ¡Increíble!', '/icons/ten-courses.svg', 'SYSTEM', 'COMPLETE_TEN_COURSES', 500, true, NOW()),
('Racha de 7 Días', 'Estudiaste durante 7 días consecutivos', '/icons/seven-day-streak.svg', 'SYSTEM', 'SEVEN_DAY_STREAK', 75, true, NOW()),
('Perfeccionista', 'Obtuviste calificación perfecta (100%)', '/icons/perfectionist.svg', 'SYSTEM', 'PERFECT_SCORE', 100, true, NOW()),
('Explorador', 'Tomaste cursos de 3 categorías diferentes', '/icons/explorer.svg', 'SYSTEM', 'EXPLORE_CATEGORIES', 150, true, NOW()),
('Velocista', 'Completaste un curso en menos de 1 semana', '/icons/speedrunner.svg', 'SYSTEM', 'SPEED_COMPLETION', 80, true, NOW()),
('Certificado de Oro', 'Obtuviste un certificado con distinción', '/icons/gold-certificate.svg', 'SYSTEM', 'GOLD_CERTIFICATE', 200, true, NOW()),
('Coleccionista', 'Obtuviste 10 logros diferentes', '/icons/collector.svg', 'SYSTEM', 'COLLECT_ACHIEVEMENTS', 250, true, NOW()),
('Ninja de JavaScript', 'Completaste el curso avanzado de JavaScript', '/icons/js-ninja.svg', 'CUSTOM', 'JAVASCRIPT_MASTER', 150, true, NOW()),
('Científico', 'Completaste 5 cursos de tecnología o ciencias', '/icons/scientist.svg', 'SYSTEM', 'SCIENCE_COMPLETION', 200, true, NOW());

-- ============================================
-- PUBLICACIONES TÉCNICAS DE EJEMPLO
-- ============================================
INSERT INTO tech_posts (titulo, resumen, contenido_markdown, slug, categoria, etiquetas, estado, autor_id, autor_nombre, creado_en) VALUES 
(
  'Introducción a Angular 18',
  'Aprende las nuevas características de Angular 18 incluyendo standalone components y control flow syntax',
  '# Angular 18\n\nAngular 18 trae grandes mejoras...\n\n## Standalone Components\n\nYa no necesitas módulos...',
  'introduccion-angular-18',
  'Frontend',
  '["angular", "typescript", "frontend"]',
  'PUBLISHED',
  2,
  'Juan Pérez',
  NOW()
),
(
  'Guía de Tailwind CSS',
  'Todo lo que necesitas saber sobre Tailwind CSS para crear interfaces modernas',
  '# Tailwind CSS\n\nTailwind es un framework utility-first...',
  'guia-tailwind-css',
  'Frontend',
  '["tailwind", "css", "diseño"]',
  'PUBLISHED',
  2,
  'Juan Pérez',
  NOW()
);

-- ============================================
-- INSCRIPCIONES DE PRUEBA
-- ============================================
INSERT INTO enrollments (alumno_id, curso_id, fecha_inscripcion, progreso, estado) VALUES 
(4, 1, NOW(), 45.50, 'ACTIVO'),
(4, 4, NOW(), 100.00, 'COMPLETADO'),
(5, 1, NOW(), 20.00, 'ACTIVO');

-- ============================================
-- CONTROL PARENTAL DE PRUEBA
-- ============================================
INSERT INTO parental_controls (padre_id, hijo_id, puede_inscribirse, limite_diario_minutos, notificaciones_activas, creado_en) VALUES 
(3, 4, true, 120, true, NOW()),
(3, 5, true, 90, true, NOW());

-- ============================================
-- LOGROS OBTENIDOS DE PRUEBA
-- ============================================
INSERT INTO user_achievements (logro_id, alumno_id, fecha_obtenido, compartido_veces) VALUES 
(1, 4, NOW(), 2),  -- Primera inscripción
(2, 4, NOW(), 1);  -- Primer curso completado
```

### Notas sobre los datos de prueba:

1. **Contraseñas**: Todas las cuentas de prueba usan la contraseña `password123`
2. **IDs**: Los IDs pueden variar según la configuración de auto-increment
3. **Etiquetas**: En PostgreSQL, usa tipo JSONB para `etiquetas`
4. **Timestamps**: Usa `NOW()` para generar timestamps actuales

## Migración y Respaldos

### Crear Respaldo (MySQL)

```powershell
mysqldump -u aulabase_user -p aulabase > backup_aulabase.sql
```

### Restaurar Respaldo (MySQL)

```powershell
mysql -u aulabase_user -p aulabase < backup_aulabase.sql
```

### Crear Respaldo (PostgreSQL)

```powershell
pg_dump -U aulabase_user aulabase > backup_aulabase.sql
```

### Restaurar Respaldo (PostgreSQL)

```powershell
psql -U aulabase_user aulabase < backup_aulabase.sql
```

## Verificar Conexión

Una vez configurada la base de datos:

1. Inicia el backend de Spring Boot
2. Revisa los logs, deberías ver:
   ```
   Hibernate: create table users ...
   Hibernate: create table courses ...
   ```
3. Si todo está bien, verás: `Application started successfully`

## Solución de Problemas

### Error: "Access denied for user"

- Verifica el usuario y contraseña en `application.properties`
- Asegúrate de que el usuario tenga permisos en la base de datos

### Error: "Unknown database"

- Verifica que hayas creado la base de datos: `CREATE DATABASE aulabase;`
- Revisa el nombre de la BD en la URL de conexión

### Error: "Communications link failure"

- Verifica que MySQL/PostgreSQL esté corriendo
- Revisa el puerto en la configuración (3306 para MySQL, 5432 para PostgreSQL)
- Verifica el firewall de Windows

### Las tablas no se crean

- Verifica que `spring.jpa.hibernate.ddl-auto=update` esté configurado
- Revisa los logs del backend para ver errores específicos
- Asegúrate de que el dialecto de Hibernate sea correcto

## Notas de Seguridad

⚠️ **Importante:**

- Nunca uses contraseñas simples en producción
- Cambia las credenciales predeterminadas
- No incluyas `application.properties` con credenciales en el control de versiones
- Usa variables de entorno para credenciales sensibles
- Realiza respaldos periódicos de la base de datos

