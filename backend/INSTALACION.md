# MexAula Backend - Guía de Instalación

## Requisitos Previos

Antes de instalar MexAula Backend, asegúrate de tener instalado:

### 1. Java Development Kit (JDK) 17 o superior
- **Descargar:** https://adoptium.net/
- **Verificar instalación:**
  ```bash
  java -version
  ```
  Debe mostrar versión 17 o superior

### 2. PostgreSQL 12 o superior
- **Descargar:** https://www.postgresql.org/download/
- **Configuración por defecto:**
  - Usuario: `postgres`
  - Contraseña: La que configures durante la instalación
  - Puerto: `5432`

### 3. Maven 3.6+ (Opcional - el proyecto incluye Maven Wrapper)
- **Descargar:** https://maven.apache.org/download.cgi
- **Verificar instalación:**
  ```bash
  mvn -version
  ```

## Pasos de Instalación

### 1. Obtener el Proyecto

Asegúrate de tener el proyecto en tu directorio local:
```
C:\Users\[tu-usuario]\IdeaProjects\MexAula\backend
```

### 2. Configurar Variables de Entorno para Base de Datos

Crea las siguientes variables de entorno en tu sistema:

**Windows:**
1. Abre "Variables de entorno" desde el Panel de Control
2. Crea las siguientes variables de usuario:
   - `DB_USER` = `postgres`
   - `DB_PASSWORD` = `tu_contraseña_postgresql`

**O edita directamente** el archivo `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/MexAula
spring.datasource.username=postgres
spring.datasource.password=TU_CONTRASEÑA_AQUI
```

### 3. Configurar la Base de Datos

Ver el archivo **`CONFIGURACION_BD.md`** para instrucciones detalladas.

**Método rápido usando psql:**

```bash
# 1. Crear la base de datos
psql -U postgres -c "CREATE DATABASE MexAula;"

# 2. Ejecutar el schema (crear tablas)
psql -U postgres -d MexAula -f src/main/resources/schema.sql

# 3. Insertar datos iniciales (opcional - incluye usuarios de prueba)
psql -U postgres -d MexAula -f src/main/resources/data.sql
```

### 4. Compilar el Proyecto

Desde el directorio `backend/`, ejecuta:

**Con Maven Wrapper (recomendado):**
```bash
./mvnw clean install
```

**Con Maven instalado:**
```bash
mvn clean install
```

Esto:
- Descarga todas las dependencias
- Compila el código Java
- Ejecuta las pruebas
- Crea el archivo JAR ejecutable en `target/`

### 5. Iniciar la Aplicación

**Opción 1 - Maven Wrapper:**
```bash
./mvnw spring-boot:run
```

**Opción 2 - Maven instalado:**
```bash
mvn spring-boot:run
```

**Opción 3 - Ejecutar JAR directamente:**
```bash
java -jar target/MexAula-backend-0.0.1-SNAPSHOT.jar
```

La aplicación estará disponible en: **http://localhost:8080/api**

### 6. Verificar Instalación

Accede a los siguientes endpoints para verificar:

**Health Check:**
```bash
curl http://localhost:8080/api/auth/login
```

**Login con usuario de prueba (si cargaste data.sql):**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@MexAula.com",
    "password": "admin123"
  }'
```

Si recibes un token JWT, ¡la instalación fue exitosa! ✅

## Credenciales de Prueba

Si restauraste el `backup.sql`, estos usuarios están disponibles:

| Rol | Email | Contraseña |
|-----|-------|-----------|
| ADMIN | admin@MexAula.com | admin123 |
| MAESTRO | carlos.lopez@MexAula.com | maestro123 |
| ALUMNO | maria.garcia@MexAula.com | alumno123 |
| PADRE | juan.martinez@MexAula.com | padre123 |

⚠️ **IMPORTANTE:** Cambia estas contraseñas en producción.

## Solución de Problemas

### Error: Java version not compatible
Asegúrate de usar Java 17 o superior:
```bash
java -version
```

### Error: Could not connect to database
1. Verifica que PostgreSQL esté ejecutándose
2. Revisa las credenciales en `application.properties`
3. Asegúrate de que la base de datos `MexAula` existe

### Error: Port 8080 already in use
Cambia el puerto en `application.properties`:
```properties
server.port=8081
```

### Error: mvn/mvnw command not found
- Para `mvn`: Instala Maven y agrégalo al PATH
- Para `mvnw`: Asegúrate de tener los archivos `.mvn/` en el proyecto

### Problemas de compilación
Limpia y recompila:
```bash
./mvnw clean install -U
```

## Estructura del Proyecto

```
backend/
├── src/main/java/com/MexAula/
│   ├── config/          # Configuración de seguridad
│   ├── controller/      # REST Controllers
│   ├── dto/            # Data Transfer Objects
│   ├── exception/      # Manejo de excepciones
│   ├── model/          # Entidades JPA
│   ├── repository/     # Repositorios Spring Data
│   ├── security/       # Componentes de seguridad JWT
│   ├── service/        # Lógica de negocio
│   └── util/           # Utilidades (mappers, convertidores)
└── src/main/resources/
    ├── application.properties  # Configuración principal
    ├── schema.sql             # Script DDL (crear tablas)
    ├── data.sql               # Datos iniciales
    └── fix-etiquetas-format.sql  # Script de migración

```

## Tecnologías Utilizadas

- **Java 17** - Lenguaje de programación
- **Spring Boot 3.2.0** - Framework principal
- **Spring Security** - Autenticación y autorización
- **JWT (JSON Web Tokens)** - Tokens de sesión
- **PostgreSQL** - Base de datos relacional
- **Hibernate/JPA** - ORM (Object-Relational Mapping)
- **Maven** - Gestión de dependencias
- **Lombok** - Reducción de código boilerplate

## Próximos Pasos

1. Revisa la documentación de la base de datos en `CONFIGURACION_BD.md`
2. Explora los endpoints disponibles probándolos con Postman o curl
3. Personaliza la configuración según tus necesidades
4. Lee el código fuente para entender la arquitectura

## Soporte

Para problemas o preguntas:
1. Revisa esta guía de instalación
2. Verifica los logs de la aplicación
3. Consulta la documentación de Spring Boot: https://spring.io/projects/spring-boot

