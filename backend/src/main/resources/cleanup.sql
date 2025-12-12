-- ============================================================================
-- mexaula - Script de Limpieza (cleanup.sql)
-- ============================================================================
-- Script para limpiar/resetear la base de datos
-- ¡USAR CON PRECAUCIÓN! Este script elimina TODOS los datos
-- ============================================================================

\echo '============================================================================'
\echo 'mexaula - Limpieza de Base de Datos'
\echo '============================================================================'
\echo ''
\echo 'ADVERTENCIA: Este script eliminará TODOS los datos de la base de datos.'
\echo 'Solo debe usarse en entornos de desarrollo/testing.'
\echo ''
\prompt 'Presiona Enter para continuar o Ctrl+C para cancelar...' confirm
\echo ''

-- ============================================================================
-- OPCIÓN 1: ELIMINAR SOLO DATOS (mantener estructura)
-- ============================================================================

\echo 'Eliminando datos de todas las tablas...'
\echo ''

-- Desactivar triggers temporalmente para evitar restricciones
SET session_replication_role = replica;

-- Eliminar datos en orden para respetar foreign keys
TRUNCATE TABLE actividad_alumno CASCADE;
TRUNCATE TABLE configuracion_parental CASCADE;
TRUNCATE TABLE vinculos_parentales CASCADE;
TRUNCATE TABLE certificados CASCADE;
TRUNCATE TABLE inscripciones CASCADE;
TRUNCATE TABLE cursos CASCADE;
TRUNCATE TABLE usuario_roles CASCADE;
TRUNCATE TABLE usuarios CASCADE;
TRUNCATE TABLE roles CASCADE;

-- Reactivar triggers
SET session_replication_role = DEFAULT;

\echo '✓ Datos eliminados correctamente.'
\echo ''

-- ============================================================================
-- REINSERTAR DATOS INICIALES
-- ============================================================================

\echo 'Reinsertando datos iniciales (roles y admin)...'
\echo ''

-- Insertar roles básicos
INSERT INTO roles (nombre) VALUES
    ('ADMIN'),
    ('PADRE'),
    ('MAESTRO'),
    ('ALUMNO');

-- Usuario administrador inicial
INSERT INTO usuarios (nombre, apellido, email, password_hash, activo)
VALUES (
    'Admin',
    'Sistema',
    'admin@mexaula.com',
    '$2a$10$8K1p/a0dL3.XG8p8rX8Kcu.5V0hLq2yMqVqCmQlQYqQh0I1BkL8cq',
    TRUE
);

-- Asignar rol ADMIN al usuario administrador
INSERT INTO usuario_roles (usuario_id, rol_id)
SELECT u.id, r.id
FROM usuarios u, roles r
WHERE u.email = 'admin@mexaula.com' AND r.nombre = 'ADMIN';

\echo '✓ Datos iniciales reinsertados.'
\echo ''

-- ============================================================================
-- RESETEAR SECUENCIAS
-- ============================================================================

\echo 'Reseteando secuencias de IDs...'
\echo ''

SELECT setval('roles_id_seq', (SELECT MAX(id) FROM roles));
SELECT setval('usuarios_id_seq', (SELECT MAX(id) FROM usuarios));
SELECT setval('cursos_id_seq', 1, false);
SELECT setval('inscripciones_id_seq', 1, false);
SELECT setval('certificados_id_seq', 1, false);
SELECT setval('vinculos_parentales_id_seq', 1, false);
SELECT setval('configuracion_parental_id_seq', 1, false);
SELECT setval('actividad_alumno_id_seq', 1, false);

\echo '✓ Secuencias reseteadas.'
\echo ''

-- ============================================================================
-- VERIFICAR LIMPIEZA
-- ============================================================================

\echo 'Verificando limpieza...'
\echo ''

SELECT
    'roles' AS tabla,
    COUNT(*) AS registros
FROM roles
UNION ALL
SELECT
    'usuarios' AS tabla,
    COUNT(*) AS registros
FROM usuarios
UNION ALL
SELECT
    'usuario_roles' AS tabla,
    COUNT(*) AS registros
FROM usuario_roles
UNION ALL
SELECT
    'cursos' AS tabla,
    COUNT(*) AS registros
FROM cursos
UNION ALL
SELECT
    'inscripciones' AS tabla,
    COUNT(*) AS registros
FROM inscripciones
UNION ALL
SELECT
    'certificados' AS tabla,
    COUNT(*) AS registros
FROM certificados
UNION ALL
SELECT
    'vinculos_parentales' AS tabla,
    COUNT(*) AS registros
FROM vinculos_parentales
UNION ALL
SELECT
    'configuracion_parental' AS tabla,
    COUNT(*) AS registros
FROM configuracion_parental
UNION ALL
SELECT
    'actividad_alumno' AS tabla,
    COUNT(*) AS registros
FROM actividad_alumno
ORDER BY tabla;

\echo ''

-- ============================================================================
-- EJECUTAR ANALYZE
-- ============================================================================

\echo 'Optimizando base de datos...'
\echo ''

VACUUM ANALYZE;

\echo '✓ Optimización completada.'
\echo ''

-- ============================================================================
-- RESUMEN
-- ============================================================================

\echo '============================================================================'
\echo 'LIMPIEZA COMPLETADA'
\echo '============================================================================'
\echo ''
\echo 'Estado actual:'
\echo '- Roles: 4 (ADMIN, PADRE, MAESTRO, ALUMNO)'
\echo '- Usuarios: 1 (admin@mexaula.com)'
\echo '- Cursos: 0'
\echo '- Inscripciones: 0'
\echo '- Certificados: 0'
\echo ''
\echo 'Credenciales del administrador:'
\echo '- Email: admin@mexaula.com'
\echo '- Password: admin123'
\echo ''
\echo 'Para cargar datos de ejemplo, ejecuta:'
\echo 'psql -U postgres -d plataforma -f data.sql'
\echo ''
\echo '============================================================================'

-- ============================================================================
-- FIN DEL SCRIPT DE LIMPIEZA
-- ============================================================================

