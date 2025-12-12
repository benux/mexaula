-- ============================================================================
-- mexaula - Datos de Ejemplo (data.sql)
-- ============================================================================
-- Script para poblar la base de datos con datos de prueba
-- USAR SOLO EN DESARROLLO / TESTING
-- ============================================================================

-- ============================================================================
-- USUARIOS DE EJEMPLO
-- ============================================================================

-- Maestros de ejemplo (password: maestro123)
INSERT INTO usuarios (nombre, apellido, email, password_hash, activo) VALUES
    ('Carlos', 'López', 'carlos.lopez@mexaula.com', '$2a$10$e1MKh6Bq9Xp.HQx8m5fWJ.TZvD9gF8xLqQw2kN5pR7sU4tV6wX8yK', TRUE),
    ('Ana', 'Martínez', 'ana.martinez@mexaula.com', '$2a$10$e1MKh6Bq9Xp.HQx8m5fWJ.TZvD9gF8xLqQw2kN5pR7sU4tV6wX8yK', TRUE),
    ('Roberto', 'García', 'roberto.garcia@mexaula.com', '$2a$10$e1MKh6Bq9Xp.HQx8m5fWJ.TZvD9gF8xLqQw2kN5pR7sU4tV6wX8yK', TRUE)
ON CONFLICT (email) DO NOTHING;

-- Padres de ejemplo (password: padre123)
INSERT INTO usuarios (nombre, apellido, email, password_hash, activo) VALUES
    ('María', 'González', 'maria.gonzalez@mexaula.com', '$2a$10$f2NLi7Cr0Yq.IQy9n6gXK.UAwE0hG9yMrRx3lO6qS8tV5uW7xY9zL', TRUE),
    ('Juan', 'Rodríguez', 'juan.rodriguez@mexaula.com', '$2a$10$f2NLi7Cr0Yq.IQy9n6gXK.UAwE0hG9yMrRx3lO6qS8tV5uW7xY9zL', TRUE)
ON CONFLICT (email) DO NOTHING;

-- Alumnos de ejemplo (password: alumno123)
INSERT INTO usuarios (nombre, apellido, email, password_hash, activo) VALUES
    ('Pedro', 'Sánchez', 'pedro.sanchez@mexaula.com', '$2a$10$g3OMj8Ds1Zr.JRz0o7hYL.VBxF1iH0zNsSy4mP7rT9uW6vX8yZ0aM', TRUE),
    ('Laura', 'Fernández', 'laura.fernandez@mexaula.com', '$2a$10$g3OMj8Ds1Zr.JRz0o7hYL.VBxF1iH0zNsSy4mP7rT9uW6vX8yZ0aM', TRUE),
    ('Diego', 'Torres', 'diego.torres@mexaula.com', '$2a$10$g3OMj8Ds1Zr.JRz0o7hYL.VBxF1iH0zNsSy4mP7rT9uW6vX8yZ0aM', TRUE),
    ('Sofia', 'Ramírez', 'sofia.ramirez@mexaula.com', '$2a$10$g3OMj8Ds1Zr.JRz0o7hYL.VBxF1iH0zNsSy4mP7rT9uW6vX8yZ0aM', TRUE),
    ('Miguel', 'Vargas', 'miguel.vargas@mexaula.com', '$2a$10$g3OMj8Ds1Zr.JRz0o7hYL.VBxF1iH0zNsSy4mP7rT9uW6vX8yZ0aM', TRUE),
    ('Carmen', 'Luna', 'carmen.luna@mexaula.com', '$2a$10$g3OMj8Ds1Zr.JRz0o7hYL.VBxF1iH0zNsSy4mP7rT9uW6vX8yZ0aM', TRUE)
ON CONFLICT (email) DO NOTHING;

-- ============================================================================
-- ASIGNAR ROLES A USUARIOS
-- ============================================================================

-- Asignar rol MAESTRO
INSERT INTO usuario_roles (usuario_id, rol_id)
SELECT u.id, r.id
FROM usuarios u, roles r
WHERE u.email IN ('carlos.lopez@mexaula.com', 'ana.martinez@mexaula.com', 'roberto.garcia@mexaula.com')
AND r.nombre = 'MAESTRO'
ON CONFLICT DO NOTHING;

-- Asignar rol PADRE
INSERT INTO usuario_roles (usuario_id, rol_id)
SELECT u.id, r.id
FROM usuarios u, roles r
WHERE u.email IN ('maria.gonzalez@mexaula.com', 'juan.rodriguez@mexaula.com')
AND r.nombre = 'PADRE'
ON CONFLICT DO NOTHING;

-- Asignar rol ALUMNO
INSERT INTO usuario_roles (usuario_id, rol_id)
SELECT u.id, r.id
FROM usuarios u, roles r
WHERE u.email IN (
    'pedro.sanchez@mexaula.com',
    'laura.fernandez@mexaula.com',
    'diego.torres@mexaula.com',
    'sofia.ramirez@mexaula.com',
    'miguel.vargas@mexaula.com',
    'carmen.luna@mexaula.com'
)
AND r.nombre = 'ALUMNO'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- CURSOS DE EJEMPLO
-- ============================================================================

-- Cursos de Carlos López (Programación)
INSERT INTO cursos (titulo, descripcion, nivel, publicado, maestro_id) VALUES
    (
        'Introducción a JavaScript',
        'Aprende los fundamentos de JavaScript desde cero. Este curso cubre variables, funciones, arrays, objetos y manipulación del DOM.',
        'BASICO',
        TRUE,
        (SELECT id FROM usuarios WHERE email = 'carlos.lopez@mexaula.com')
    ),
    (
        'JavaScript Avanzado y ES6+',
        'Domina características avanzadas de JavaScript: Promises, Async/Await, Destructuring, Spread Operator y más.',
        'AVANZADO',
        TRUE,
        (SELECT id FROM usuarios WHERE email = 'carlos.lopez@mexaula.com')
    ),
    (
        'Desarrollo Web con React',
        'Crea aplicaciones web modernas con React. Aprende componentes, hooks, estado y routing.',
        'INTERMEDIO',
        TRUE,
        (SELECT id FROM usuarios WHERE email = 'carlos.lopez@mexaula.com')
    );

-- Cursos de Ana Martínez (Matemáticas)
INSERT INTO cursos (titulo, descripcion, nivel, publicado, maestro_id) VALUES
    (
        'Álgebra Básica',
        'Fundamentos de álgebra: ecuaciones lineales, sistemas de ecuaciones y factorización.',
        'BASICO',
        TRUE,
        (SELECT id FROM usuarios WHERE email = 'ana.martinez@mexaula.com')
    ),
    (
        'Cálculo Diferencial',
        'Introducción al cálculo: límites, derivadas y aplicaciones en problemas reales.',
        'INTERMEDIO',
        TRUE,
        (SELECT id FROM usuarios WHERE email = 'ana.martinez@mexaula.com')
    ),
    (
        'Geometría Analítica',
        'Estudio de figuras geométricas usando coordenadas y ecuaciones.',
        'INTERMEDIO',
        FALSE,
        (SELECT id FROM usuarios WHERE email = 'ana.martinez@mexaula.com')
    );

-- Cursos de Roberto García (Ciencias)
INSERT INTO cursos (titulo, descripcion, nivel, publicado, maestro_id) VALUES
    (
        'Física para Principiantes',
        'Conceptos básicos de física: movimiento, fuerza, energía y trabajo.',
        'BASICO',
        TRUE,
        (SELECT id FROM usuarios WHERE email = 'roberto.garcia@mexaula.com')
    ),
    (
        'Química General',
        'Introducción a la química: átomos, enlaces químicos, reacciones y estequiometría.',
        'BASICO',
        TRUE,
        (SELECT id FROM usuarios WHERE email = 'roberto.garcia@mexaula.com')
    ),
    (
        'Biología Molecular',
        'Estudio de los procesos biológicos a nivel molecular: ADN, proteínas y células.',
        'AVANZADO',
        TRUE,
        (SELECT id FROM usuarios WHERE email = 'roberto.garcia@mexaula.com')
    );

-- ============================================================================
-- INSCRIPCIONES DE EJEMPLO
-- ============================================================================

-- Pedro Sánchez inscrito en varios cursos con diferentes progresos
INSERT INTO inscripciones (curso_id, alumno_id, progreso_porcentaje, completado) VALUES
    (
        (SELECT id FROM cursos WHERE titulo = 'Introducción a JavaScript'),
        (SELECT id FROM usuarios WHERE email = 'pedro.sanchez@mexaula.com'),
        100,
        TRUE
    ),
    (
        (SELECT id FROM cursos WHERE titulo = 'JavaScript Avanzado y ES6+'),
        (SELECT id FROM usuarios WHERE email = 'pedro.sanchez@mexaula.com'),
        45.50,
        FALSE
    ),
    (
        (SELECT id FROM cursos WHERE titulo = 'Álgebra Básica'),
        (SELECT id FROM usuarios WHERE email = 'pedro.sanchez@mexaula.com'),
        100,
        TRUE
    );

-- Laura Fernández inscrita en cursos
INSERT INTO inscripciones (curso_id, alumno_id, progreso_porcentaje, completado) VALUES
    (
        (SELECT id FROM cursos WHERE titulo = 'Introducción a JavaScript'),
        (SELECT id FROM usuarios WHERE email = 'laura.fernandez@mexaula.com'),
        75.20,
        FALSE
    ),
    (
        (SELECT id FROM cursos WHERE titulo = 'Física para Principiantes'),
        (SELECT id FROM usuarios WHERE email = 'laura.fernandez@mexaula.com'),
        100,
        TRUE
    ),
    (
        (SELECT id FROM cursos WHERE titulo = 'Química General'),
        (SELECT id FROM usuarios WHERE email = 'laura.fernandez@mexaula.com'),
        30,
        FALSE
    );

-- Diego Torres inscrito en cursos
INSERT INTO inscripciones (curso_id, alumno_id, progreso_porcentaje, completado) VALUES
    (
        (SELECT id FROM cursos WHERE titulo = 'Desarrollo Web con React'),
        (SELECT id FROM usuarios WHERE email = 'diego.torres@mexaula.com'),
        60,
        FALSE
    ),
    (
        (SELECT id FROM cursos WHERE titulo = 'Cálculo Diferencial'),
        (SELECT id FROM usuarios WHERE email = 'diego.torres@mexaula.com'),
        100,
        TRUE
    );

-- Sofia Ramírez inscrita en cursos
INSERT INTO inscripciones (curso_id, alumno_id, progreso_porcentaje, completado) VALUES
    (
        (SELECT id FROM cursos WHERE titulo = 'Álgebra Básica'),
        (SELECT id FROM usuarios WHERE email = 'sofia.ramirez@mexaula.com'),
        100,
        TRUE
    ),
    (
        (SELECT id FROM cursos WHERE titulo = 'Cálculo Diferencial'),
        (SELECT id FROM usuarios WHERE email = 'sofia.ramirez@mexaula.com'),
        85,
        FALSE
    ),
    (
        (SELECT id FROM cursos WHERE titulo = 'Química General'),
        (SELECT id FROM usuarios WHERE email = 'sofia.ramirez@mexaula.com'),
        100,
        TRUE
    );

-- Miguel Vargas inscrito en cursos
INSERT INTO inscripciones (curso_id, alumno_id, progreso_porcentaje, completado) VALUES
    (
        (SELECT id FROM cursos WHERE titulo = 'Física para Principiantes'),
        (SELECT id FROM usuarios WHERE email = 'miguel.vargas@mexaula.com'),
        50,
        FALSE
    ),
    (
        (SELECT id FROM cursos WHERE titulo = 'Introducción a JavaScript'),
        (SELECT id FROM usuarios WHERE email = 'miguel.vargas@mexaula.com'),
        100,
        TRUE
    );

-- Carmen Luna inscrita en cursos
INSERT INTO inscripciones (curso_id, alumno_id, progreso_porcentaje, completado) VALUES
    (
        (SELECT id FROM cursos WHERE titulo = 'Biología Molecular'),
        (SELECT id FROM usuarios WHERE email = 'carmen.luna@mexaula.com'),
        100,
        TRUE
    ),
    (
        (SELECT id FROM cursos WHERE titulo = 'Química General'),
        (SELECT id FROM usuarios WHERE email = 'carmen.luna@mexaula.com'),
        90,
        FALSE
    );

-- ============================================================================
-- CERTIFICADOS DE EJEMPLO
-- ============================================================================

-- Certificados para cursos completados
INSERT INTO certificados (alumno_id, curso_id, codigo_verificacion) VALUES
    (
        (SELECT id FROM usuarios WHERE email = 'pedro.sanchez@mexaula.com'),
        (SELECT id FROM cursos WHERE titulo = 'Introducción a JavaScript'),
        'CERT-JS-' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 12))
    ),
    (
        (SELECT id FROM usuarios WHERE email = 'pedro.sanchez@mexaula.com'),
        (SELECT id FROM cursos WHERE titulo = 'Álgebra Básica'),
        'CERT-ALG-' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 12))
    ),
    (
        (SELECT id FROM usuarios WHERE email = 'laura.fernandez@mexaula.com'),
        (SELECT id FROM cursos WHERE titulo = 'Física para Principiantes'),
        'CERT-FIS-' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 12))
    ),
    (
        (SELECT id FROM usuarios WHERE email = 'diego.torres@mexaula.com'),
        (SELECT id FROM cursos WHERE titulo = 'Cálculo Diferencial'),
        'CERT-CALC-' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 12))
    ),
    (
        (SELECT id FROM usuarios WHERE email = 'sofia.ramirez@mexaula.com'),
        (SELECT id FROM cursos WHERE titulo = 'Álgebra Básica'),
        'CERT-ALG-' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 12))
    ),
    (
        (SELECT id FROM usuarios WHERE email = 'sofia.ramirez@mexaula.com'),
        (SELECT id FROM cursos WHERE titulo = 'Química General'),
        'CERT-QUIM-' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 12))
    ),
    (
        (SELECT id FROM usuarios WHERE email = 'miguel.vargas@mexaula.com'),
        (SELECT id FROM cursos WHERE titulo = 'Introducción a JavaScript'),
        'CERT-JS-' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 12))
    ),
    (
        (SELECT id FROM usuarios WHERE email = 'carmen.luna@mexaula.com'),
        (SELECT id FROM cursos WHERE titulo = 'Biología Molecular'),
        'CERT-BIO-' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 12))
    );

-- ============================================================================
-- VÍNCULOS PARENTALES DE EJEMPLO
-- ============================================================================

-- María González como madre de Pedro y Laura
INSERT INTO vinculos_parentales (padre_id, alumno_id) VALUES
    (
        (SELECT id FROM usuarios WHERE email = 'maria.gonzalez@mexaula.com'),
        (SELECT id FROM usuarios WHERE email = 'pedro.sanchez@mexaula.com')
    ),
    (
        (SELECT id FROM usuarios WHERE email = 'maria.gonzalez@mexaula.com'),
        (SELECT id FROM usuarios WHERE email = 'laura.fernandez@mexaula.com')
    );

-- Juan Rodríguez como padre de Diego y Sofia
INSERT INTO vinculos_parentales (padre_id, alumno_id) VALUES
    (
        (SELECT id FROM usuarios WHERE email = 'juan.rodriguez@mexaula.com'),
        (SELECT id FROM usuarios WHERE email = 'diego.torres@mexaula.com')
    ),
    (
        (SELECT id FROM usuarios WHERE email = 'juan.rodriguez@mexaula.com'),
        (SELECT id FROM usuarios WHERE email = 'sofia.ramirez@mexaula.com')
    );

-- ============================================================================
-- CONFIGURACIÓN PARENTAL DE EJEMPLO
-- ============================================================================

-- Configuración para María González
INSERT INTO configuracion_parental (padre_id, nivel_maximo_contenido, tiempo_maximo_diario_min) VALUES
    (
        (SELECT id FROM usuarios WHERE email = 'maria.gonzalez@mexaula.com'),
        'INTERMEDIO',
        120
    );

-- Configuración para Juan Rodríguez
INSERT INTO configuracion_parental (padre_id, nivel_maximo_contenido, tiempo_maximo_diario_min) VALUES
    (
        (SELECT id FROM usuarios WHERE email = 'juan.rodriguez@mexaula.com'),
        'AVANZADO',
        180
    );

-- ============================================================================
-- LOGROS DE EJEMPLO (ACHIEVEMENTS)
-- ============================================================================

-- Logros del sistema
INSERT INTO logros (titulo, descripcion, icono_url, tipo, criterio_codigo, puntos, activo) VALUES
    ('Primer Paso', 'Completa tu primera inscripción a un curso', '/icons/first-enrollment.svg', 'SYSTEM', 'FIRST_ENROLLMENT', 10, TRUE),
    ('Estudiante Dedicado', 'Completa tu primer curso', '/icons/first-completion.svg', 'SYSTEM', 'FIRST_COURSE_COMPLETE', 50, TRUE),
    ('Aprendiz Destacado', 'Completa 3 cursos', '/icons/three-courses.svg', 'SYSTEM', 'THREE_COURSES_COMPLETE', 100, TRUE),
    ('Maestro del Conocimiento', 'Completa 10 cursos', '/icons/ten-courses.svg', 'SYSTEM', 'TEN_COURSES_COMPLETE', 500, TRUE),
    ('Racha de 7 Días', 'Estudia durante 7 días consecutivos', '/icons/seven-day-streak.svg', 'SYSTEM', 'SEVEN_DAY_STREAK', 75, TRUE),
    ('Perfeccionista', 'Completa un curso con 100% de progreso', '/icons/perfectionist.svg', 'SYSTEM', 'PERFECT_COMPLETION', 30, TRUE),
    ('Explorador', 'Inscríbete en 5 cursos diferentes', '/icons/explorer.svg', 'SYSTEM', 'FIVE_ENROLLMENTS', 40, TRUE),
    ('Velocista', 'Completa un curso en menos de 7 días', '/icons/speedrunner.svg', 'SYSTEM', 'COURSE_IN_WEEK', 80, TRUE),
    ('Certificado de Oro', 'Obtén tu primer certificado', '/icons/gold-certificate.svg', 'SYSTEM', 'FIRST_CERTIFICATE', 60, TRUE),
    ('Coleccionista', 'Obtén 5 certificados', '/icons/collector.svg', 'SYSTEM', 'FIVE_CERTIFICATES', 200, TRUE),
    ('JavaScript Ninja', 'Completa todos los cursos de JavaScript', '/icons/js-ninja.svg', 'CUSTOM', 'JS_MASTER', 150, TRUE),
    ('Científico Junior', 'Completa cursos de Física, Química y Biología', '/icons/scientist.svg', 'CUSTOM', 'SCIENCE_MASTER', 250, TRUE);

-- Otorgar algunos logros a los alumnos de ejemplo
INSERT INTO logros_usuarios (logro_id, alumno_id, compartido_veces) VALUES
    -- Pedro Sánchez
    (
        (SELECT id FROM logros WHERE criterio_codigo = 'FIRST_ENROLLMENT'),
        (SELECT id FROM usuarios WHERE email = 'pedro.sanchez@mexaula.com'),
        0
    ),
    (
        (SELECT id FROM logros WHERE criterio_codigo = 'FIRST_COURSE_COMPLETE'),
        (SELECT id FROM usuarios WHERE email = 'pedro.sanchez@mexaula.com'),
        2
    ),
    (
        (SELECT id FROM logros WHERE criterio_codigo = 'FIRST_CERTIFICATE'),
        (SELECT id FROM usuarios WHERE email = 'pedro.sanchez@mexaula.com'),
        1
    ),
    -- Laura Fernández
    (
        (SELECT id FROM logros WHERE criterio_codigo = 'FIRST_ENROLLMENT'),
        (SELECT id FROM usuarios WHERE email = 'laura.fernandez@mexaula.com'),
        0
    ),
    (
        (SELECT id FROM logros WHERE criterio_codigo = 'FIRST_COURSE_COMPLETE'),
        (SELECT id FROM usuarios WHERE email = 'laura.fernandez@mexaula.com'),
        1
    ),
    (
        (SELECT id FROM logros WHERE criterio_codigo = 'FIRST_CERTIFICATE'),
        (SELECT id FROM usuarios WHERE email = 'laura.fernandez@mexaula.com'),
        0
    ),
    -- Sofia Ramírez
    (
        (SELECT id FROM logros WHERE criterio_codigo = 'FIRST_ENROLLMENT'),
        (SELECT id FROM usuarios WHERE email = 'sofia.ramirez@mexaula.com'),
        0
    ),
    (
        (SELECT id FROM logros WHERE criterio_codigo = 'FIRST_COURSE_COMPLETE'),
        (SELECT id FROM usuarios WHERE email = 'sofia.ramirez@mexaula.com'),
        3
    ),
    (
        (SELECT id FROM logros WHERE criterio_codigo = 'THREE_COURSES_COMPLETE'),
        (SELECT id FROM usuarios WHERE email = 'sofia.ramirez@mexaula.com'),
        1
    ),
    (
        (SELECT id FROM logros WHERE criterio_codigo = 'FIRST_CERTIFICATE'),
        (SELECT id FROM usuarios WHERE email = 'sofia.ramirez@mexaula.com'),
        2
    ),
    (
        (SELECT id FROM logros WHERE criterio_codigo = 'PERFECCIONISTA'),
        (SELECT id FROM usuarios WHERE email = 'sofia.ramirez@mexaula.com'),
        0
    );

-- ============================================================================
-- TECH POSTS DE EJEMPLO (BLOG TÉCNICO)
-- ============================================================================

-- Posts publicados
INSERT INTO tech_posts (titulo, resumen, contenido_markdown, slug, categoria, etiquetas, estado, autor_id) VALUES
    (
        '¿Qué es JavaScript y por qué aprenderlo?',
        'Descubre el lenguaje de programación más popular para desarrollo web y sus aplicaciones modernas.',
        '# ¿Qué es JavaScript?

JavaScript es un lenguaje de programación de alto nivel, interpretado y orientado a objetos. Es uno de los tres pilares fundamentales del desarrollo web moderno, junto con HTML y CSS.

## ¿Por qué aprender JavaScript?

1. **Versatilidad**: Puedes usarlo tanto en el frontend como en el backend (Node.js)
2. **Demanda laboral**: Es uno de los lenguajes más solicitados en el mercado
3. **Comunidad activa**: Miles de desarrolladores y recursos disponibles
4. **Frameworks poderosos**: React, Vue, Angular, Express, y más

## Primeros pasos

```javascript
console.log("¡Hola, mundo!");
```

JavaScript es dinámico y fácil de aprender, pero tiene profundidad suficiente para construir aplicaciones complejas.

## Conclusión

Si estás comenzando en programación, JavaScript es una excelente elección por su versatilidad y oportunidades.',
        'que-es-javascript-y-por-que-aprenderlo',
        'Programación',
        'JavaScript, Web Development, Principiantes',
        'PUBLISHED',
        (SELECT id FROM usuarios WHERE email = 'carlos.lopez@mexaula.com')
    ),
    (
        'Introducción a React: Componentes y Props',
        'Aprende los conceptos fundamentales de React, la biblioteca más popular para construir interfaces de usuario.',
        '# Introducción a React

React es una biblioteca de JavaScript para construir interfaces de usuario desarrollada por Facebook.

## Componentes

Los componentes son la base de React. Son como bloques de construcción reutilizables.

```jsx
function Saludo(props) {
  return <h1>Hola, {props.nombre}</h1>;
}
```

## Props

Las props son la forma de pasar datos de un componente padre a un hijo.

```jsx
<Saludo nombre="María" />
```

## Conclusión

React hace que construir UIs complejas sea más manejable y eficiente.',
        'introduccion-a-react-componentes-y-props',
        'Programación',
        'React, JavaScript, Frontend',
        'PUBLISHED',
        (SELECT id FROM usuarios WHERE email = 'carlos.lopez@mexaula.com')
    ),
    (
        'Álgebra en la Vida Cotidiana',
        'Descubre cómo el álgebra está presente en tu día a día y por qué es importante aprenderla.',
        '# Álgebra en la Vida Cotidiana

El álgebra no es solo ecuaciones abstractas, está en todas partes.

## Aplicaciones prácticas

1. **Finanzas personales**: Calcular intereses y presupuestos
2. **Cocina**: Ajustar recetas para diferentes porciones
3. **Construcción**: Calcular materiales necesarios
4. **Tecnología**: Programación y algoritmos

## Ejemplo simple

Si x es el precio original y hay un 20% de descuento:
Precio final = x - 0.2x = 0.8x

## Por qué importa

El álgebra desarrolla el pensamiento lógico y la capacidad de resolver problemas.',
        'algebra-en-la-vida-cotidiana',
        'Matemáticas',
        'Álgebra, Vida cotidiana, Aplicaciones',
        'PUBLISHED',
        (SELECT id FROM usuarios WHERE email = 'ana.martinez@mexaula.com')
    ),
    (
        'Física Cuántica para Principiantes',
        'Una introducción accesible al fascinante mundo de la física cuántica.',
        '# Física Cuántica para Principiantes

La física cuántica estudia el comportamiento de la materia a escala microscópica.

## Conceptos clave

- **Partícula y onda**: La luz se comporta como ambas
- **Principio de incertidumbre**: No podemos conocer todo con precisión
- **Superposición**: Las partículas existen en múltiples estados

## ¿Por qué importa?

La física cuántica ha revolucionado la tecnología moderna: computadoras, láseres, y más.

## Para reflexionar

"Si crees que entiendes la mecánica cuántica, es que no la entiendes" - Richard Feynman',
        'fisica-cuantica-para-principiantes',
        'Ciencias',
        'Física, Cuántica, Ciencia',
        'PUBLISHED',
        (SELECT id FROM usuarios WHERE email = 'roberto.garcia@mexaula.com')
    ),
    (
        'Guía de Estudio Efectivo',
        'Técnicas probadas para mejorar tu rendimiento académico y retención de información.',
        '# Guía de Estudio Efectivo

## Técnicas recomendadas

1. **Técnica Pomodoro**: 25 minutos de estudio, 5 de descanso
2. **Resúmenes activos**: Escribe con tus propias palabras
3. **Enseña a otros**: Explica lo que aprendiste
4. **Práctica espaciada**: Repasa en intervalos crecientes

## Ambiente de estudio

- Lugar tranquilo y bien iluminado
- Sin distracciones (celular lejos)
- Material organizado

## Conclusión

La calidad del estudio es más importante que la cantidad de horas.',
        'guia-de-estudio-efectivo',
        'Educación',
        'Estudio, Técnicas, Aprendizaje',
        'PUBLISHED',
        (SELECT id FROM usuarios WHERE email = 'ana.martinez@mexaula.com')
    ),
    (
        'Próximas funcionalidades de mexaula',
        'Borrador sobre las nuevas características que vienen pronto a la plataforma.',
        '# Próximas funcionalidades

Este es un borrador sobre las próximas características:
- Sistema de gamificación mejorado
- Foros de discusión
- Clases en vivo

(En desarrollo...)',
        'proximas-funcionalidades-mexaula',
        'Anuncios',
        'mexaula, Novedades',
        'DRAFT',
        (SELECT id FROM usuarios WHERE email = 'carlos.lopez@mexaula.com')
    );

-- ============================================================================
-- ACTIVIDAD DE ALUMNOS (OPCIONAL)
-- ============================================================================

-- Registrar algunas actividades de ejemplo
INSERT INTO actividad_alumno (alumno_id, curso_id, tipo, descripcion) VALUES
    (
        (SELECT id FROM usuarios WHERE email = 'pedro.sanchez@mexaula.com'),
        (SELECT id FROM cursos WHERE titulo = 'Introducción a JavaScript'),
        'INSCRIPCION',
        'Alumno se inscribió en el curso'
    ),
    (
        (SELECT id FROM usuarios WHERE email = 'pedro.sanchez@mexaula.com'),
        (SELECT id FROM cursos WHERE titulo = 'Introducción a JavaScript'),
        'CERTIFICADO',
        'Alumno completó el curso y obtuvo certificado'
    ),
    (
        (SELECT id FROM usuarios WHERE email = 'laura.fernandez@mexaula.com'),
        (SELECT id FROM cursos WHERE titulo = 'Física para Principiantes'),
        'PROGRESO',
        'Alumno actualizó progreso a 75%'
    );

-- ============================================================================
-- FIN DE DATOS DE EJEMPLO
-- ============================================================================

-- Resumen de datos insertados
DO $$
BEGIN
    RAISE NOTICE 'Datos de ejemplo insertados correctamente:';
    RAISE NOTICE '- Usuarios: %', (SELECT COUNT(*) FROM usuarios);
    RAISE NOTICE '- Cursos: %', (SELECT COUNT(*) FROM cursos);
    RAISE NOTICE '- Inscripciones: %', (SELECT COUNT(*) FROM inscripciones);
    RAISE NOTICE '- Certificados: %', (SELECT COUNT(*) FROM certificados);
    RAISE NOTICE '- Vínculos parentales: %', (SELECT COUNT(*) FROM vinculos_parentales);
    RAISE NOTICE '- Configuraciones parentales: %', (SELECT COUNT(*) FROM configuracion_parental);
END $$;

