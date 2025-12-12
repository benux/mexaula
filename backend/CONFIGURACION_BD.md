# MexAula - Configuración de Base de Datos

## Requisitos Previos

- PostgreSQL 12 o superior instalado
- Usuario `postgres` con contraseña configurada
- Cliente `psql` disponible en el PATH del sistema

## Opción 1: Configuración Manual (Recomendado)

### Paso 1: Crear la Base de Datos

Abre una terminal y ejecuta:

```bash
psql -U postgres -c "CREATE DATABASE MexAula;"
```

Si la base de datos ya existe y quieres recrearla:

```bash
psql -U postgres -c "DROP DATABASE IF EXISTS MexAula;"
psql -U postgres -c "CREATE DATABASE MexAula;"
```

### Paso 2: Crear Tablas y Estructura

Ejecuta el script de schema que crea todas las tablas, índices, funciones y triggers:

```bash
psql -U postgres -d MexAula -f src/main/resources/schema.sql
```

Este script crea:
- ✅ 9 tablas principales (usuarios, roles, cursos, inscripciones, certificados, logros, tech_posts, etc.)
- ✅ Índices optimizados para búsquedas rápidas
- ✅ Funciones de base de datos
- ✅ Triggers para actualizaciones automáticas
- ✅ Constraints y validaciones

### Paso 3: Insertar Datos Iniciales (Opcional)

Carga usuarios y datos de prueba:

```bash
psql -U postgres -d MexAula -f src/main/resources/data.sql
```

Esto crea:
- 4 roles (ADMIN, MAESTRO, ALUMNO, PADRE)
- Usuarios de ejemplo para cada rol
- Cursos de muestra
- Inscripciones de ejemplo

### Paso 4: Migrar Formato de Etiquetas (Si ya tienes datos)

Si ya tenías datos previos y necesitas migrar el formato de etiquetas:

```bash
psql -U postgres -d MexAula -f src/main/resources/fix-etiquetas-format.sql
```

### Paso 5: Verificar Instalación

Verifica que las tablas se crearon correctamente:

```bash
psql -U postgres -d MexAula -c "\dt"
```

Deberías ver listadas todas las tablas:
- certificados
- cursos
- inscripciones
- logros
- logros_usuarios
- parental_controls
- roles
- tech_posts
- usuarios

## Opción 2: Configuración con Script de PostgreSQL

Puedes ejecutar todos los pasos en una sola sesión de psql:

```bash
psql -U postgres
```

Luego dentro de psql:

```sql
-- Crear base de datos
DROP DATABASE IF EXISTS MexAula;
CREATE DATABASE MexAula;

-- Conectar a la base de datos
\c MexAula

-- Ejecutar scripts
\i 'src/main/resources/schema.sql'
\i 'src/main/resources/data.sql'

-- Verificar tablas
\dt

-- Salir
\q
```

## Esquema de Base de Datos

### Tablas Principales

#### 1. roles
Roles del sistema (ADMIN, MAESTRO, ALUMNO, PADRE)

#### 2. usuarios
Información de usuarios del sistema
- Campos: id, nombre, apellido, email, password_hash, fecha_nacimiento, activo
- Relación: Cada usuario tiene uno o más roles

#### 3. cursos
Cursos disponibles en la plataforma
- Campos: id, titulo, descripcion, nivel, duracion_horas, imagen_url, activo, creador_id
- Relación: Creado por un usuario con rol MAESTRO o ADMIN

#### 4. inscripciones
Inscripciones de alumnos a cursos
- Campos: id, alumno_id, curso_id, fecha_inscripcion, progreso, fecha_completado
- Relación: Un alumno puede inscribirse en múltiples cursos

#### 5. certificados
Certificados emitidos al completar cursos
- Campos: id, inscripcion_id, codigo_verificacion, fecha_emision, url_archivo
- Relación: Uno por inscripción completada

#### 6. parental_controls
Relación entre padres e hijos
- Campos: id, padre_id, hijo_id, activo, puede_ver_progreso, notificaciones_email
- Relación: Permite a los padres monitorear el progreso de sus hijos

#### 7. logros (achievements)
Logros/insignias que los alumnos pueden obtener
- Campos: id, nombre, descripcion, icono_url, puntos, criterio, activo

#### 8. logros_usuarios
Registro de logros obtenidos por usuarios
- Campos: id, logro_id, alumno_id, fecha_obtenido, compartido_veces

#### 9. tech_posts
Posts educativos sobre tecnología y programación
- Campos: id, titulo, resumen, contenido_markdown, slug, categoria, etiquetas, estado, autor_id

### Índices Importantes

El schema incluye índices optimizados para:
- Búsquedas por email (usuarios)
- Filtrado por estado/nivel (cursos)
- Consultas de progreso (inscripciones)
- Verificación de certificados (código único)
- Búsqueda de posts por slug y categoría

### Triggers Automáticos

- **Actualización de timestamp**: Actualiza automáticamente el campo `actualizado_en` en tech_posts
- **Validaciones**: Asegura la integridad de los datos

## Configuración de Conexión

Edita `src/main/resources/application.properties`:

```properties
# Configuración de Base de Datos
spring.datasource.url=jdbc:postgresql://localhost:5432/MexAula
spring.datasource.username=postgres
spring.datasource.password=TU_CONTRASEÑA
spring.datasource.driver-class-name=org.postgresql.Driver

# Configuración JPA/Hibernate
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

### Modos de Hibernate DDL

- **`validate`** (Recomendado para producción): Solo valida que el schema coincida
- **`update`**: Actualiza el schema automáticamente (desarrollo)
- **`create`**: Recrea el schema cada vez (⚠️ borra datos)
- **`create-drop`**: Crea y elimina al cerrar (⚠️ solo para testing)

## Usuarios de Prueba

Después de ejecutar `data.sql`, estos usuarios estarán disponibles:

### Administrador
```
Email: admin@MexAula.com
Password: admin123
Rol: ADMIN
```

### Maestro
```
Email: carlos.lopez@MexAula.com
Password: maestro123
Rol: MAESTRO
```

### Alumno
```
Email: maria.garcia@MexAula.com
Password: alumno123
Rol: ALUMNO
```

### Padre/Madre
```
Email: juan.martinez@MexAula.com
Password: padre123
Rol: PADRE
```

⚠️ **IMPORTANTE:** Cambia estas contraseñas en producción.

## Backup y Restauración

### Crear Backup

```bash
pg_dump -U postgres -d MexAula -F c -f MexAula_backup.dump
```

### Restaurar desde Backup

```bash
pg_restore -U postgres -d MexAula -c MexAula_backup.dump
```

## Restablecer Base de Datos

Para resetear completamente la base de datos a su estado inicial:

```bash
# Eliminar base de datos existente
psql -U postgres -c "DROP DATABASE IF EXISTS MexAula;"

# Crear nueva base de datos
psql -U postgres -c "CREATE DATABASE MexAula;"

# Restaurar desde backup
psql -U postgres -d MexAula -f src/main/resources/backup.sql
```

Para limpiar solo los datos pero mantener las tablas:

```bash
psql -U postgres -d MexAula -f src/main/resources/cleanup.sql
```

## Solución de Problemas

### Error: database "MexAula" already exists
Si quieres recrearla, elimínala primero:
```bash
psql -U postgres -c "DROP DATABASE MexAula;"
```

### Error: psql command not found
Agrega PostgreSQL al PATH de Windows:
1. Panel de Control → Sistema → Configuración avanzada del sistema
2. Variables de entorno
3. Edita la variable PATH
4. Agrega: `C:\Program Files\PostgreSQL\[version]\bin`

### Error: password authentication failed
1. Verifica que estás usando la contraseña correcta de PostgreSQL
2. Revisa el archivo `pg_hba.conf` de PostgreSQL
3. Reinicia el servicio de PostgreSQL

### Error: permission denied for database
Asegúrate de que el usuario `postgres` tiene permisos completos o usa un superusuario.

### Verificar que PostgreSQL está corriendo

**Windows:**
```bash
# Verificar servicio
sc query postgresql-x64-[version]

# O buscar en Servicios (services.msc)
```

**Conectar manualmente para probar:**
```bash
psql -U postgres -h localhost -p 5432
```

## Información Adicional

### Puerto de PostgreSQL
Por defecto: `5432`

Para cambiar el puerto en la aplicación, edita `application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://localhost:NUEVO_PUERTO/MexAula
```

### Encoding de Base de Datos
La base de datos se crea con encoding UTF8 por defecto para soportar caracteres especiales (tildes, ñ, etc.).

### Timezone
PostgreSQL usa la timezone del sistema. Para verificar:
```sql
SHOW timezone;
```

## Mantenimiento

### Actualizar Estadísticas
```sql
ANALYZE;
```

### Verificar Integridad
```sql
SELECT table_name, constraint_name, constraint_type 
FROM information_schema.table_constraints 
WHERE table_schema = 'public';
```

### Ver Tablas y Tamaños
```sql
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

