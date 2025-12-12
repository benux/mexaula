-- ============================================================================
-- mexaula - Esquema de Base de Datos PostgreSQL
-- ============================================================================
-- Plataforma educativa con gestión de usuarios, cursos, inscripciones,
-- certificados y control parental.
--
-- Convenciones:
--   - Nombres de tablas y columnas en snake_case
--   - BIGSERIAL para claves primarias
--   - Tipos: VARCHAR, TEXT, TIMESTAMP, BOOLEAN, NUMERIC
--   - Claves foráneas con ON DELETE apropiado
--   - Constraints CHECK para valores de dominio
--
-- Roles: ADMIN, PADRE, MAESTRO, ALUMNO
-- Niveles de cursos: BASICO, INTERMEDIO, AVANZADO
--
-- Versión: 1.0
-- Fecha: 10 de diciembre de 2025
-- ============================================================================

-- ============================================================================
-- NOTA: Para crear la base de datos, ejecutar en psql:
-- CREATE DATABASE mexaula;
-- \c mexaula
-- ============================================================================

-- ============================================================================
-- 1. TABLA: roles
-- ============================================================================
-- Roles disponibles en el sistema con restricción de valores válidos
-- ============================================================================

DROP TABLE IF EXISTS roles CASCADE;

CREATE TABLE roles (
    id          BIGSERIAL PRIMARY KEY,
    nombre      VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT chk_roles_nombre CHECK (nombre IN ('ADMIN', 'PADRE', 'MAESTRO', 'ALUMNO'))
);

COMMENT ON TABLE roles IS 'Roles disponibles en el sistema';
COMMENT ON COLUMN roles.nombre IS 'Nombre del rol: ADMIN, PADRE, MAESTRO, ALUMNO';

-- ============================================================================
-- 2. TABLA: usuarios
-- ============================================================================
-- Usuarios del sistema con información básica y estado
-- ============================================================================

DROP TABLE IF EXISTS usuarios CASCADE;

CREATE TABLE usuarios (
    id              BIGSERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    apellido        VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    activo          BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en  TIMESTAMP NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE usuarios IS 'Usuarios del sistema (admin, padres, maestros, alumnos)';
COMMENT ON COLUMN usuarios.password_hash IS 'Contraseña encriptada con BCrypt';
COMMENT ON COLUMN usuarios.activo IS 'Indica si el usuario puede acceder al sistema';

-- Índice para búsquedas rápidas por email
CREATE INDEX idx_usuarios_email ON usuarios(email);

-- ============================================================================
-- 3. TABLA: usuario_roles
-- ============================================================================
-- Relación muchos-a-muchos entre usuarios y roles
-- Un usuario puede tener múltiples roles
-- ============================================================================

DROP TABLE IF EXISTS usuario_roles CASCADE;

CREATE TABLE usuario_roles (
    usuario_id  BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    rol_id      BIGINT NOT NULL REFERENCES roles(id) ON DELETE RESTRICT,
    PRIMARY KEY (usuario_id, rol_id)
);

COMMENT ON TABLE usuario_roles IS 'Relación muchos-a-muchos entre usuarios y roles';

-- Índices para mejorar el rendimiento de consultas
CREATE INDEX idx_usuario_roles_usuario ON usuario_roles(usuario_id);
CREATE INDEX idx_usuario_roles_rol ON usuario_roles(rol_id);

-- ============================================================================
-- 4. TABLA: cursos
-- ============================================================================
-- Información de los cursos ofrecidos en la plataforma
-- ============================================================================

DROP TABLE IF EXISTS cursos CASCADE;

CREATE TABLE cursos (
    id              BIGSERIAL PRIMARY KEY,
    titulo          VARCHAR(200) NOT NULL,
    descripcion     TEXT,
    nivel           VARCHAR(20) NOT NULL,
    publicado       BOOLEAN NOT NULL DEFAULT FALSE,
    maestro_id      BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE RESTRICT,
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en  TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_cursos_nivel CHECK (nivel IN ('BASICO', 'INTERMEDIO', 'AVANZADO'))
);

COMMENT ON TABLE cursos IS 'Cursos disponibles en la plataforma';
COMMENT ON COLUMN cursos.nivel IS 'Nivel de dificultad: BASICO, INTERMEDIO, AVANZADO';
COMMENT ON COLUMN cursos.publicado IS 'Indica si el curso está visible para los alumnos';
COMMENT ON COLUMN cursos.maestro_id IS 'Usuario con rol MAESTRO que imparte el curso';

-- Índice para consultas de cursos por maestro
CREATE INDEX idx_cursos_maestro ON cursos(maestro_id);
-- Índice para filtrar cursos publicados
CREATE INDEX idx_cursos_publicado ON cursos(publicado);
-- Índice para búsquedas por nivel
CREATE INDEX idx_cursos_nivel ON cursos(nivel);

-- ============================================================================
-- 5. TABLA: inscripciones
-- ============================================================================
-- Inscripciones de alumnos a cursos con seguimiento de progreso
-- ============================================================================

DROP TABLE IF EXISTS inscripciones CASCADE;

CREATE TABLE inscripciones (
    id                      BIGSERIAL PRIMARY KEY,
    curso_id                BIGINT NOT NULL REFERENCES cursos(id) ON DELETE CASCADE,
    alumno_id               BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    progreso_porcentaje     NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (progreso_porcentaje >= 0 AND progreso_porcentaje <= 100),
    completado              BOOLEAN NOT NULL DEFAULT FALSE,
    inscrito_en             TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en          TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_inscripciones_curso_alumno UNIQUE (curso_id, alumno_id)
);

COMMENT ON TABLE inscripciones IS 'Inscripciones de alumnos a cursos con progreso';
COMMENT ON COLUMN inscripciones.progreso_porcentaje IS 'Porcentaje de avance del curso (0-100)';
COMMENT ON COLUMN inscripciones.completado IS 'TRUE cuando progreso_porcentaje alcanza 100';
COMMENT ON COLUMN inscripciones.alumno_id IS 'Usuario con rol ALUMNO inscrito al curso';

-- Índices para consultas frecuentes
CREATE INDEX idx_inscripciones_alumno ON inscripciones(alumno_id);
CREATE INDEX idx_inscripciones_curso ON inscripciones(curso_id);
CREATE INDEX idx_inscripciones_completado ON inscripciones(completado);

-- ============================================================================
-- 6. TABLA: certificados
-- ============================================================================
-- Certificados emitidos cuando un alumno completa un curso
-- ============================================================================

DROP TABLE IF EXISTS certificados CASCADE;

CREATE TABLE certificados (
    id                      BIGSERIAL PRIMARY KEY,
    alumno_id               BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE RESTRICT,
    curso_id                BIGINT NOT NULL REFERENCES cursos(id) ON DELETE RESTRICT,
    codigo_verificacion     VARCHAR(100) NOT NULL UNIQUE,
    fecha_emision           TIMESTAMP NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE certificados IS 'Certificados emitidos al completar cursos';
COMMENT ON COLUMN certificados.codigo_verificacion IS 'Código único para verificación pública del certificado';
COMMENT ON COLUMN certificados.alumno_id IS 'Usuario que obtuvo el certificado';

-- Índices para búsquedas
CREATE INDEX idx_certificados_alumno ON certificados(alumno_id);
CREATE INDEX idx_certificados_curso ON certificados(curso_id);
CREATE INDEX idx_certificados_codigo ON certificados(codigo_verificacion);

-- ============================================================================
-- 7. TABLA: vinculos_parentales
-- ============================================================================
-- Relaciones padre-hijo para control parental
-- ============================================================================

DROP TABLE IF EXISTS vinculos_parentales CASCADE;

CREATE TABLE vinculos_parentales (
    id          BIGSERIAL PRIMARY KEY,
    padre_id    BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    alumno_id   BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    creado_en   TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_vinculos_parentales UNIQUE (padre_id, alumno_id),
    CONSTRAINT chk_vinculos_diferente_usuario CHECK (padre_id != alumno_id)
);

COMMENT ON TABLE vinculos_parentales IS 'Relaciones padre-hijo para control parental';
COMMENT ON COLUMN vinculos_parentales.padre_id IS 'Usuario con rol PADRE';
COMMENT ON COLUMN vinculos_parentales.alumno_id IS 'Usuario con rol ALUMNO (hijo)';

-- Índices para consultas frecuentes
CREATE INDEX idx_vinculos_parentales_padre ON vinculos_parentales(padre_id);
CREATE INDEX idx_vinculos_parentales_alumno ON vinculos_parentales(alumno_id);

-- ============================================================================
-- 8. TABLA: configuracion_parental
-- ============================================================================
-- Configuración de controles parentales por padre
-- ============================================================================

DROP TABLE IF EXISTS configuracion_parental CASCADE;

CREATE TABLE configuracion_parental (
    id                          BIGSERIAL PRIMARY KEY,
    padre_id                    BIGINT NOT NULL UNIQUE REFERENCES usuarios(id) ON DELETE CASCADE,
    nivel_maximo_contenido      VARCHAR(20),
    tiempo_maximo_diario_min    INT CHECK (tiempo_maximo_diario_min IS NULL OR tiempo_maximo_diario_min > 0),
    creado_en                   TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en              TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_config_nivel_max CHECK (
        nivel_maximo_contenido IS NULL OR
        nivel_maximo_contenido IN ('BASICO', 'INTERMEDIO', 'AVANZADO')
    )
);

COMMENT ON TABLE configuracion_parental IS 'Configuración de controles parentales';
COMMENT ON COLUMN configuracion_parental.padre_id IS 'Usuario con rol PADRE (uno por padre)';
COMMENT ON COLUMN configuracion_parental.nivel_maximo_contenido IS 'Nivel máximo de cursos que pueden ver los hijos';
COMMENT ON COLUMN configuracion_parental.tiempo_maximo_diario_min IS 'Tiempo máximo diario en minutos (opcional)';

-- Índice para búsquedas por padre
CREATE INDEX idx_configuracion_parental_padre ON configuracion_parental(padre_id);

-- ============================================================================
-- 9. TABLA OPCIONAL: actividad_alumno
-- ============================================================================
-- Registro de actividad de alumnos para reportes detallados
-- ============================================================================

DROP TABLE IF EXISTS actividad_alumno CASCADE;

CREATE TABLE actividad_alumno (
    id          BIGSERIAL PRIMARY KEY,
    alumno_id   BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    curso_id    BIGINT REFERENCES cursos(id) ON DELETE SET NULL,
    tipo        VARCHAR(50) NOT NULL,
    descripcion TEXT,
    creado_en   TIMESTAMP NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE actividad_alumno IS 'Registro de actividad de alumnos para reportes';
COMMENT ON COLUMN actividad_alumno.tipo IS 'Tipo de actividad: LOGIN, INSCRIPCION, PROGRESO, CERTIFICADO, etc.';

-- Índices para consultas de actividad
CREATE INDEX idx_actividad_alumno_alumno ON actividad_alumno(alumno_id);
CREATE INDEX idx_actividad_alumno_curso ON actividad_alumno(curso_id);
CREATE INDEX idx_actividad_alumno_fecha ON actividad_alumno(creado_en);

-- ============================================================================
-- 10. TABLA: logros
-- ============================================================================
-- Sistema de logros/insignias para gamificación
-- ============================================================================

DROP TABLE IF EXISTS logros CASCADE;

CREATE TABLE logros (
    id                  BIGSERIAL PRIMARY KEY,
    titulo              VARCHAR(200) NOT NULL,
    descripcion         TEXT NOT NULL,
    icono_url           VARCHAR(500),
    tipo                VARCHAR(20) NOT NULL,
    criterio_codigo     VARCHAR(100) NOT NULL,
    puntos              INT NOT NULL DEFAULT 0,
    activo              BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en           TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en      TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_logros_tipo CHECK (tipo IN ('SYSTEM', 'CUSTOM')),
    CONSTRAINT uq_logros_criterio UNIQUE (criterio_codigo)
);

COMMENT ON TABLE logros IS 'Sistema de logros/insignias para gamificación';
COMMENT ON COLUMN logros.tipo IS 'Tipo de logro: SYSTEM (predefinido), CUSTOM (personalizado por admin)';
COMMENT ON COLUMN logros.criterio_codigo IS 'Código único que identifica el criterio de obtención del logro';
COMMENT ON COLUMN logros.puntos IS 'Puntos otorgados al obtener el logro';
COMMENT ON COLUMN logros.activo IS 'Indica si el logro está disponible para ser obtenido';

-- Índices para búsquedas
CREATE INDEX idx_logros_tipo ON logros(tipo);
CREATE INDEX idx_logros_activo ON logros(activo);
CREATE INDEX idx_logros_criterio ON logros(criterio_codigo);

-- ============================================================================
-- 11. TABLA: logros_usuarios
-- ============================================================================
-- Logros obtenidos por cada alumno
-- ============================================================================

DROP TABLE IF EXISTS logros_usuarios CASCADE;

CREATE TABLE logros_usuarios (
    id                  BIGSERIAL PRIMARY KEY,
    logro_id            BIGINT NOT NULL REFERENCES logros(id) ON DELETE CASCADE,
    alumno_id           BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    fecha_obtenido      TIMESTAMP NOT NULL DEFAULT NOW(),
    compartido_veces    INT NOT NULL DEFAULT 0,
    CONSTRAINT uq_logro_usuario UNIQUE (logro_id, alumno_id)
);

COMMENT ON TABLE logros_usuarios IS 'Logros obtenidos por cada alumno';
COMMENT ON COLUMN logros_usuarios.alumno_id IS 'Usuario con rol ALUMNO que obtuvo el logro';
COMMENT ON COLUMN logros_usuarios.compartido_veces IS 'Número de veces que el alumno compartió este logro';

-- Índices para consultas frecuentes
CREATE INDEX idx_logros_usuarios_alumno ON logros_usuarios(alumno_id);
CREATE INDEX idx_logros_usuarios_logro ON logros_usuarios(logro_id);
CREATE INDEX idx_logros_usuarios_fecha ON logros_usuarios(fecha_obtenido);

-- ============================================================================
-- 12. TABLA: tech_posts
-- ============================================================================
-- Posts de información técnica/educativa sobre programación
-- ============================================================================

DROP TABLE IF EXISTS tech_posts CASCADE;

CREATE TABLE tech_posts (
    id                      BIGSERIAL PRIMARY KEY,
    titulo                  VARCHAR(200) NOT NULL,
    resumen                 VARCHAR(500) NOT NULL,
    contenido_markdown      TEXT NOT NULL,
    slug                    VARCHAR(200) NOT NULL UNIQUE,
    categoria               VARCHAR(100),
    etiquetas               TEXT,
    estado                  VARCHAR(20) NOT NULL,
    autor_id                BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE RESTRICT,
    creado_en               TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en          TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_tech_posts_estado CHECK (estado IN ('DRAFT', 'PUBLISHED'))
);

COMMENT ON TABLE tech_posts IS 'Posts de información técnica/educativa sobre programación';
COMMENT ON COLUMN tech_posts.contenido_markdown IS 'Contenido del post en formato Markdown';
COMMENT ON COLUMN tech_posts.slug IS 'URL-friendly identifier único para el post';
COMMENT ON COLUMN tech_posts.etiquetas IS 'Tags separados por comas para categorización';
COMMENT ON COLUMN tech_posts.estado IS 'Estado: DRAFT (borrador), PUBLISHED (publicado)';
COMMENT ON COLUMN tech_posts.autor_id IS 'Usuario con rol ADMIN o MAESTRO que creó el post';

-- Índices para búsquedas y filtros
CREATE INDEX idx_tech_posts_autor ON tech_posts(autor_id);
CREATE INDEX idx_tech_posts_estado ON tech_posts(estado);
CREATE INDEX idx_tech_posts_categoria ON tech_posts(categoria);
CREATE INDEX idx_tech_posts_slug ON tech_posts(slug);

-- ============================================================================
-- FUNCIÓN: actualizar timestamp automáticamente
-- ============================================================================

CREATE OR REPLACE FUNCTION actualizar_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.actualizado_en = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION actualizar_timestamp() IS 'Actualiza automáticamente el campo actualizado_en';

-- ============================================================================
-- TRIGGERS: Actualizar timestamps automáticamente
-- ============================================================================

CREATE TRIGGER trg_usuarios_actualizado
    BEFORE UPDATE ON usuarios
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trg_cursos_actualizado
    BEFORE UPDATE ON cursos
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trg_inscripciones_actualizado
    BEFORE UPDATE ON inscripciones
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trg_configuracion_parental_actualizado
    BEFORE UPDATE ON configuracion_parental
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trg_logros_actualizado
    BEFORE UPDATE ON logros
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trg_tech_posts_actualizado
    BEFORE UPDATE ON tech_posts
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

-- ============================================================================
-- FUNCIÓN: Validar que el curso esté completado antes de generar certificado
-- ============================================================================

CREATE OR REPLACE FUNCTION validar_certificado()
RETURNS TRIGGER AS $$
DECLARE
    esta_completado BOOLEAN;
BEGIN
    SELECT completado INTO esta_completado
    FROM inscripciones
    WHERE curso_id = NEW.curso_id AND alumno_id = NEW.alumno_id;

    IF NOT FOUND OR esta_completado = FALSE THEN
        RAISE EXCEPTION 'El alumno debe completar el curso antes de obtener un certificado';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION validar_certificado() IS 'Valida que el curso esté completado antes de emitir certificado';

-- Trigger para validar certificados
CREATE TRIGGER trg_validar_certificado
    BEFORE INSERT ON certificados
    FOR EACH ROW
    EXECUTE FUNCTION validar_certificado();

-- ============================================================================
-- DATOS INICIALES
-- ============================================================================

-- Insertar roles básicos
INSERT INTO roles (nombre) VALUES
    ('ADMIN'),
    ('PADRE'),
    ('MAESTRO'),
    ('ALUMNO')
ON CONFLICT (nombre) DO NOTHING;

-- Usuario administrador inicial
-- Password: admin123 (hash BCrypt)
-- IMPORTANTE: Cambiar esta contraseña en producción
INSERT INTO usuarios (nombre, apellido, email, password_hash, activo)
VALUES (
    'Admin',
    'Sistema',
    'admin@mexaula.com',
    '$2a$10$8K1p/a0dL3.XG8p8rX8Kcu.5V0hLq2yMqVqCmQlQYqQh0I1BkL8cq',
    TRUE
)
ON CONFLICT (email) DO NOTHING;

-- Asignar rol ADMIN al usuario administrador
INSERT INTO usuario_roles (usuario_id, rol_id)
SELECT u.id, r.id
FROM usuarios u, roles r
WHERE u.email = 'admin@mexaula.com' AND r.nombre = 'ADMIN'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- VISTAS ÚTILES
-- ============================================================================

-- Vista: Usuarios con sus roles
CREATE OR REPLACE VIEW v_usuarios_roles AS
SELECT
    u.id,
    u.nombre,
    u.apellido,
    u.email,
    u.activo,
    ARRAY_AGG(r.nombre ORDER BY r.nombre) AS roles,
    u.creado_en,
    u.actualizado_en
FROM usuarios u
LEFT JOIN usuario_roles ur ON u.id = ur.usuario_id
LEFT JOIN roles r ON ur.rol_id = r.id
GROUP BY u.id, u.nombre, u.apellido, u.email, u.activo, u.creado_en, u.actualizado_en;

COMMENT ON VIEW v_usuarios_roles IS 'Vista de usuarios con sus roles agregados';

-- Vista: Cursos con información del maestro
CREATE OR REPLACE VIEW v_cursos_completos AS
SELECT
    c.id,
    c.titulo,
    c.descripcion,
    c.nivel,
    c.publicado,
    c.maestro_id,
    u.nombre || ' ' || u.apellido AS maestro_nombre,
    u.email AS maestro_email,
    c.creado_en,
    c.actualizado_en,
    COUNT(i.id) AS total_inscritos
FROM cursos c
JOIN usuarios u ON c.maestro_id = u.id
LEFT JOIN inscripciones i ON c.id = i.curso_id
GROUP BY c.id, c.titulo, c.descripcion, c.nivel, c.publicado,
         c.maestro_id, u.nombre, u.apellido, u.email, c.creado_en, c.actualizado_en;

COMMENT ON VIEW v_cursos_completos IS 'Vista de cursos con información del maestro y total de inscritos';

-- Vista: Progreso de alumnos
CREATE OR REPLACE VIEW v_progreso_alumnos AS
SELECT
    i.id AS inscripcion_id,
    u.id AS alumno_id,
    u.nombre || ' ' || u.apellido AS alumno_nombre,
    u.email AS alumno_email,
    c.id AS curso_id,
    c.titulo AS curso_titulo,
    c.nivel AS curso_nivel,
    i.progreso_porcentaje,
    i.completado,
    i.inscrito_en,
    i.actualizado_en
FROM inscripciones i
JOIN usuarios u ON i.alumno_id = u.id
JOIN cursos c ON i.curso_id = c.id;

COMMENT ON VIEW v_progreso_alumnos IS 'Vista de progreso de alumnos en sus cursos';

-- Vista: Certificados con detalles
CREATE OR REPLACE VIEW v_certificados_completos AS
SELECT
    cert.id,
    cert.codigo_verificacion,
    cert.fecha_emision,
    u.id AS alumno_id,
    u.nombre || ' ' || u.apellido AS alumno_nombre,
    u.email AS alumno_email,
    c.id AS curso_id,
    c.titulo AS curso_titulo,
    c.nivel AS curso_nivel,
    m.nombre || ' ' || m.apellido AS maestro_nombre
FROM certificados cert
JOIN usuarios u ON cert.alumno_id = u.id
JOIN cursos c ON cert.curso_id = c.id
JOIN usuarios m ON c.maestro_id = m.id;

COMMENT ON VIEW v_certificados_completos IS 'Vista de certificados con información completa';

-- ============================================================================
-- ESTADÍSTICAS Y CONSULTAS ÚTILES
-- ============================================================================

-- Función: Obtener estadísticas generales del sistema
CREATE OR REPLACE FUNCTION obtener_estadisticas_sistema()
RETURNS TABLE (
    total_usuarios BIGINT,
    total_cursos BIGINT,
    total_inscripciones BIGINT,
    total_certificados BIGINT,
    cursos_publicados BIGINT,
    alumnos_activos BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        (SELECT COUNT(*) FROM usuarios)::BIGINT,
        (SELECT COUNT(*) FROM cursos)::BIGINT,
        (SELECT COUNT(*) FROM inscripciones)::BIGINT,
        (SELECT COUNT(*) FROM certificados)::BIGINT,
        (SELECT COUNT(*) FROM cursos WHERE publicado = TRUE)::BIGINT,
        (SELECT COUNT(DISTINCT u.id)
         FROM usuarios u
         JOIN usuario_roles ur ON u.id = ur.usuario_id
         JOIN roles r ON ur.rol_id = r.id
         WHERE r.nombre = 'ALUMNO' AND u.activo = TRUE)::BIGINT;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION obtener_estadisticas_sistema() IS 'Obtiene estadísticas generales del sistema';

-- ============================================================================
-- 10. TABLA: logros
-- ============================================================================
-- Sistema de logros/achievements para gamificación
-- ============================================================================

DROP TABLE IF EXISTS logros CASCADE;

CREATE TABLE logros (
    id BIGSERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT NOT NULL,
    icono_url VARCHAR(500),
    tipo VARCHAR(20) NOT NULL,
    criterio_codigo VARCHAR(100) NOT NULL,
    puntos INT NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_logros_tipo CHECK (tipo IN ('SYSTEM', 'CUSTOM')),
    CONSTRAINT uq_logros_criterio UNIQUE (criterio_codigo)
);

COMMENT ON TABLE logros IS 'Logros disponibles en el sistema para gamificación';
COMMENT ON COLUMN logros.tipo IS 'Tipo de logro: SYSTEM (predefinido) o CUSTOM (personalizado)';
COMMENT ON COLUMN logros.criterio_codigo IS 'Código único que identifica el criterio del logro';
COMMENT ON COLUMN logros.puntos IS 'Puntos que otorga el logro al desbloquearlo';
COMMENT ON COLUMN logros.activo IS 'Indica si el logro está activo y puede ser obtenido';

-- Índices para logros
CREATE INDEX idx_logros_criterio ON logros(criterio_codigo);
CREATE INDEX idx_logros_activo ON logros(activo);
CREATE INDEX idx_logros_tipo ON logros(tipo);

-- ============================================================================
-- 11. TABLA: logros_usuarios
-- ============================================================================
-- Registro de logros obtenidos por alumnos
-- ============================================================================

DROP TABLE IF EXISTS logros_usuarios CASCADE;

CREATE TABLE logros_usuarios (
    id BIGSERIAL PRIMARY KEY,
    logro_id BIGINT NOT NULL REFERENCES logros(id) ON DELETE CASCADE,
    alumno_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    fecha_obtenido TIMESTAMP NOT NULL DEFAULT NOW(),
    compartido_veces INT NOT NULL DEFAULT 0,
    CONSTRAINT uq_logro_usuario UNIQUE (logro_id, alumno_id)
);

COMMENT ON TABLE logros_usuarios IS 'Logros obtenidos por alumnos';
COMMENT ON COLUMN logros_usuarios.fecha_obtenido IS 'Fecha en que el alumno desbloqueó el logro';
COMMENT ON COLUMN logros_usuarios.compartido_veces IS 'Contador de veces que el alumno ha compartido este logro';

-- Índices para consultas de logros de usuarios
CREATE INDEX idx_logros_usuarios_alumno ON logros_usuarios(alumno_id);
CREATE INDEX idx_logros_usuarios_logro ON logros_usuarios(logro_id);
CREATE INDEX idx_logros_usuarios_fecha ON logros_usuarios(fecha_obtenido);

-- ============================================================================
-- 12. TABLA: tech_posts
-- ============================================================================
-- Información técnica y artículos educativos (tech blog)
-- ============================================================================

DROP TABLE IF EXISTS tech_posts CASCADE;

CREATE TABLE tech_posts (
    id BIGSERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    resumen VARCHAR(500) NOT NULL,
    contenido_markdown TEXT NOT NULL,
    slug VARCHAR(200) NOT NULL UNIQUE,
    categoria VARCHAR(100),
    etiquetas TEXT,
    estado VARCHAR(20) NOT NULL,
    autor_id BIGINT NOT NULL REFERENCES usuarios(id),
    creado_en TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_tech_posts_estado CHECK (estado IN ('DRAFT', 'PUBLISHED'))
);

COMMENT ON TABLE tech_posts IS 'Artículos técnicos y contenido educativo del blog';
COMMENT ON COLUMN tech_posts.slug IS 'URL amigable única para el artículo';
COMMENT ON COLUMN tech_posts.contenido_markdown IS 'Contenido completo del artículo en formato Markdown';
COMMENT ON COLUMN tech_posts.estado IS 'Estado del artículo: DRAFT (borrador) o PUBLISHED (publicado)';
COMMENT ON COLUMN tech_posts.etiquetas IS 'Etiquetas separadas por coma para clasificación';
COMMENT ON COLUMN tech_posts.autor_id IS 'Usuario que creó el artículo (ADMIN o MAESTRO)';

-- Índices para tech posts
CREATE INDEX idx_tech_posts_slug ON tech_posts(slug);
CREATE INDEX idx_tech_posts_estado ON tech_posts(estado);
CREATE INDEX idx_tech_posts_autor ON tech_posts(autor_id);
CREATE INDEX idx_tech_posts_categoria ON tech_posts(categoria);
CREATE INDEX idx_tech_posts_fecha ON tech_posts(creado_en);

-- ============================================================================
-- TRIGGERS adicionales: Actualizar timestamps en nuevas tablas
-- ============================================================================

CREATE TRIGGER trg_logros_actualizado
    BEFORE UPDATE ON logros
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trg_tech_posts_actualizado
    BEFORE UPDATE ON tech_posts
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

-- ============================================================================
-- PERMISOS (EJEMPLO)
-- ============================================================================

-- Crear rol de aplicación (ajustar según necesidades)
-- CREATE ROLE mexaula_app WITH LOGIN PASSWORD 'secure_password';
-- GRANT CONNECT ON DATABASE plataforma TO mexaula_app;
-- GRANT USAGE ON SCHEMA public TO mexaula_app;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO mexaula_app;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO mexaula_app;

-- ============================================================================
-- FIN DEL ESQUEMA
-- ============================================================================

-- Para verificar la creación:
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;

