-- Script para convertir el campo etiquetas de formato CSV a JSON array
-- Este script debe ejecutarse una sola vez para actualizar los datos existentes

-- Actualizar tech_posts que tienen etiquetas en formato CSV (con comas)
UPDATE tech_posts
SET etiquetas =
    CASE
        -- Si las etiquetas ya están en formato JSON array, no hacer nada
        WHEN etiquetas ~ '^\[.*\]$' THEN etiquetas
        -- Si las etiquetas están vacías o nulas, convertir a array vacío
        WHEN etiquetas IS NULL OR etiquetas = '' THEN '[]'
        -- Si las etiquetas están en formato CSV, convertir a JSON array
        ELSE (
            SELECT json_agg(trim(both ' ' from unnest))::text
            FROM unnest(string_to_array(etiquetas, ','))
        )
    END
WHERE etiquetas IS NOT NULL
  AND etiquetas != ''
  AND etiquetas !~ '^\[.*\]$';

-- Verificar los resultados
SELECT id, titulo, etiquetas
FROM tech_posts
ORDER BY id;

