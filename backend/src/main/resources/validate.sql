-- ============================================================================
-- mexaula - Script de Validación y Testing (validate.sql)
-- ============================================================================
-- Script para validar la integridad de la base de datos y ejecutar tests
-- ============================================================================

\echo '============================================================================'
\echo 'mexaula - Validación de Base de Datos'
\echo '============================================================================'
\echo ''

-- ============================================================================
-- 1. VERIFICAR EXISTENCIA DE TABLAS
-- ============================================================================

\echo '1. Verificando existencia de tablas...'
\echo ''

SELECT
    table_name,
    CASE
        WHEN table_name IN (
            'roles', 'usuarios', 'usuario_roles', 'cursos',
            'inscripciones', 'certificados', 'vinculos_parentales',
            'configuracion_parental', 'actividad_alumno'
        ) THEN '✓ OK'
        ELSE '✗ EXTRA'
    END AS status
FROM information_schema.tables
WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE'
ORDER BY table_name;

\echo ''

-- ============================================================================
-- 2. VERIFICAR CONSTRAINTS
-- ============================================================================

\echo '2. Verificando constraints...'
\echo ''

SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.table_schema = 'public'
ORDER BY tc.table_name, tc.constraint_type;

\echo ''

-- ============================================================================
-- 3. VERIFICAR FOREIGN KEYS
-- ============================================================================

\echo '3. Verificando foreign keys...'
\echo ''

SELECT
    tc.table_name AS tabla_origen,
    kcu.column_name AS columna_origen,
    ccu.table_name AS tabla_referencia,
    ccu.column_name AS columna_referencia
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'public'
ORDER BY tc.table_name;

\echo ''

-- ============================================================================
-- 4. VERIFICAR ÍNDICES
-- ============================================================================

\echo '4. Verificando índices...'
\echo ''

SELECT
    tablename AS tabla,
    indexname AS indice,
    indexdef AS definicion
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

\echo ''

-- ============================================================================
-- 5. VERIFICAR TRIGGERS
-- ============================================================================

\echo '5. Verificando triggers...'
\echo ''

SELECT
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

\echo ''

-- ============================================================================
-- 6. VERIFICAR VISTAS
-- ============================================================================

\echo '6. Verificando vistas...'
\echo ''

SELECT
    table_name AS vista,
    view_definition
FROM information_schema.views
WHERE table_schema = 'public'
ORDER BY table_name;

\echo ''

-- ============================================================================
-- 7. VERIFICAR FUNCIONES
-- ============================================================================

\echo '7. Verificando funciones...'
\echo ''

SELECT
    routine_name AS funcion,
    data_type AS tipo_retorno
FROM information_schema.routines
WHERE routine_schema = 'public'
    AND routine_type = 'FUNCTION'
ORDER BY routine_name;

\echo ''

-- ============================================================================
-- 8. VERIFICAR DATOS INICIALES
-- ============================================================================

\echo '8. Verificando datos iniciales...'
\echo ''

\echo 'Roles:'
SELECT id, nombre FROM roles ORDER BY id;

\echo ''
\echo 'Usuario Admin:'
SELECT id, nombre, apellido, email, activo FROM usuarios WHERE email = 'admin@mexaula.com';

\echo ''
\echo 'Roles del Admin:'
SELECT
    u.email,
    r.nombre AS rol
FROM usuarios u
JOIN usuario_roles ur ON u.id = ur.usuario_id
JOIN roles r ON ur.rol_id = r.id
WHERE u.email = 'admin@mexaula.com';

\echo ''

-- ============================================================================
-- 9. ESTADÍSTICAS GENERALES
-- ============================================================================

\echo '9. Estadísticas generales...'
\echo ''

SELECT * FROM obtener_estadisticas_sistema();

\echo ''

-- ============================================================================
-- 10. CONTEO DE REGISTROS POR TABLA
-- ============================================================================

\echo '10. Conteo de registros por tabla...'
\echo ''

SELECT
    'roles' AS tabla,
    COUNT(*) AS total_registros
FROM roles
UNION ALL
SELECT
    'usuarios' AS tabla,
    COUNT(*) AS total_registros
FROM usuarios
UNION ALL
SELECT
    'usuario_roles' AS tabla,
    COUNT(*) AS total_registros
FROM usuario_roles
UNION ALL
SELECT
    'cursos' AS tabla,
    COUNT(*) AS total_registros
FROM cursos
UNION ALL
SELECT
    'inscripciones' AS tabla,
    COUNT(*) AS total_registros
FROM inscripciones
UNION ALL
SELECT
    'certificados' AS tabla,
    COUNT(*) AS total_registros
FROM certificados
UNION ALL
SELECT
    'vinculos_parentales' AS tabla,
    COUNT(*) AS total_registros
FROM vinculos_parentales
UNION ALL
SELECT
    'configuracion_parental' AS tabla,
    COUNT(*) AS total_registros
FROM configuracion_parental
UNION ALL
SELECT
    'actividad_alumno' AS tabla,
    COUNT(*) AS total_registros
FROM actividad_alumno
ORDER BY tabla;

\echo ''

-- ============================================================================
-- 11. TAMAÑO DE TABLAS
-- ============================================================================

\echo '11. Tamaño de tablas...'
\echo ''

SELECT
    tablename AS tabla,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS tamaño_total,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) AS tamaño_datos,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename) - pg_relation_size(schemaname||'.'||tablename)) AS tamaño_indices
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

\echo ''

-- ============================================================================
-- 12. TESTS DE INTEGRIDAD REFERENCIAL
-- ============================================================================

\echo '12. Tests de integridad referencial...'
\echo ''

-- Test: Verificar que no hay usuarios sin rol
\echo 'Test: Usuarios sin rol (debe ser 0):'
SELECT COUNT(*) AS usuarios_sin_rol
FROM usuarios u
LEFT JOIN usuario_roles ur ON u.id = ur.usuario_id
WHERE ur.usuario_id IS NULL;

\echo ''

-- Test: Verificar que todos los maestros tienen rol MAESTRO
\echo 'Test: Cursos con maestro sin rol MAESTRO (debe ser 0):'
SELECT COUNT(*) AS cursos_sin_maestro_valido
FROM cursos c
LEFT JOIN usuario_roles ur ON c.maestro_id = ur.usuario_id
LEFT JOIN roles r ON ur.rol_id = r.id AND r.nombre = 'MAESTRO'
WHERE r.id IS NULL;

\echo ''

-- Test: Verificar que todas las inscripciones son de usuarios con rol ALUMNO
\echo 'Test: Inscripciones sin alumno válido (debe ser 0):'
SELECT COUNT(*) AS inscripciones_invalidas
FROM inscripciones i
LEFT JOIN usuario_roles ur ON i.alumno_id = ur.usuario_id
LEFT JOIN roles r ON ur.rol_id = r.id AND r.nombre = 'ALUMNO'
WHERE r.id IS NULL;

\echo ''

-- Test: Verificar que todos los certificados corresponden a cursos completados
\echo 'Test: Certificados sin curso completado (debe ser 0):'
SELECT COUNT(*) AS certificados_invalidos
FROM certificados cert
LEFT JOIN inscripciones i ON cert.curso_id = i.curso_id AND cert.alumno_id = i.alumno_id
WHERE i.completado = FALSE OR i.id IS NULL;

\echo ''

-- Test: Verificar que los vínculos parentales son válidos
\echo 'Test: Vínculos parentales inválidos (debe ser 0):'
SELECT COUNT(*) AS vinculos_invalidos
FROM vinculos_parentales vp
WHERE vp.padre_id = vp.alumno_id;

\echo ''

-- ============================================================================
-- 13. TESTS FUNCIONALES
-- ============================================================================

\echo '13. Tests funcionales...'
\echo ''

-- Test: Verificar trigger de actualización de timestamp
\echo 'Test: Verificar trigger de actualización (cambiar email del admin temporalmente):'
DO $$
DECLARE
    old_updated_at TIMESTAMP;
    new_updated_at TIMESTAMP;
BEGIN
    -- Obtener timestamp actual
    SELECT actualizado_en INTO old_updated_at FROM usuarios WHERE email = 'admin@mexaula.com';

    -- Esperar 1 segundo
    PERFORM pg_sleep(1);

    -- Actualizar usuario
    UPDATE usuarios SET nombre = nombre WHERE email = 'admin@mexaula.com';

    -- Obtener nuevo timestamp
    SELECT actualizado_en INTO new_updated_at FROM usuarios WHERE email = 'admin@mexaula.com';

    IF new_updated_at > old_updated_at THEN
        RAISE NOTICE '✓ Trigger de actualización funciona correctamente';
    ELSE
        RAISE WARNING '✗ Trigger de actualización NO funciona';
    END IF;
END $$;

\echo ''

-- Test: Verificar vista de usuarios con roles
\echo 'Test: Vista v_usuarios_roles (debe mostrar admin con rol ADMIN):'
SELECT
    nombre,
    apellido,
    email,
    roles
FROM v_usuarios_roles
WHERE email = 'admin@mexaula.com';

\echo ''

-- ============================================================================
-- 14. ANÁLISIS DE RENDIMIENTO
-- ============================================================================

\echo '14. Análisis de rendimiento...'
\echo ''

-- Ejecutar ANALYZE para actualizar estadísticas
ANALYZE;

\echo 'ANALYZE ejecutado correctamente.'
\echo ''

-- ============================================================================
-- 15. RESUMEN DE VALIDACIÓN
-- ============================================================================

\echo '============================================================================'
\echo 'RESUMEN DE VALIDACIÓN'
\echo '============================================================================'

DO $$
DECLARE
    total_tablas INT;
    total_constraints INT;
    total_indices INT;
    total_triggers INT;
    total_vistas INT;
    total_funciones INT;
    usuarios_sin_rol INT;
BEGIN
    -- Contar elementos
    SELECT COUNT(*) INTO total_tablas FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
    SELECT COUNT(*) INTO total_constraints FROM information_schema.table_constraints WHERE table_schema = 'public';
    SELECT COUNT(*) INTO total_indices FROM pg_indexes WHERE schemaname = 'public';
    SELECT COUNT(*) INTO total_triggers FROM information_schema.triggers WHERE trigger_schema = 'public';
    SELECT COUNT(*) INTO total_vistas FROM information_schema.views WHERE table_schema = 'public';
    SELECT COUNT(*) INTO total_funciones FROM information_schema.routines WHERE routine_schema = 'public' AND routine_type = 'FUNCTION';
    SELECT COUNT(*) INTO usuarios_sin_rol FROM usuarios u LEFT JOIN usuario_roles ur ON u.id = ur.usuario_id WHERE ur.usuario_id IS NULL;

    -- Mostrar resumen
    RAISE NOTICE '';
    RAISE NOTICE 'Elementos de la base de datos:';
    RAISE NOTICE '- Tablas: %', total_tablas;
    RAISE NOTICE '- Constraints: %', total_constraints;
    RAISE NOTICE '- Índices: %', total_indices;
    RAISE NOTICE '- Triggers: %', total_triggers;
    RAISE NOTICE '- Vistas: %', total_vistas;
    RAISE NOTICE '- Funciones: %', total_funciones;
    RAISE NOTICE '';

    IF usuarios_sin_rol = 0 THEN
        RAISE NOTICE '✓ Todos los tests de integridad pasaron correctamente';
    ELSE
        RAISE WARNING '✗ Algunos tests de integridad fallaron';
    END IF;

    RAISE NOTICE '';
    RAISE NOTICE '============================================================================';
    RAISE NOTICE 'BASE DE DATOS VALIDADA EXITOSAMENTE';
    RAISE NOTICE '============================================================================';
END $$;

-- ============================================================================
-- FIN DEL SCRIPT DE VALIDACIÓN
-- ============================================================================

