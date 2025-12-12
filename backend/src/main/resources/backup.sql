--
-- PostgreSQL database dump
--

\restrict 23VnYpKaeUeaclunVzRk6Pgm3c1DaI4HJX8OOLJuT06aNban7VfrlnW554HPcBC

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: actualizar_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.actualizado_en = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_timestamp() OWNER TO postgres;

--
-- Name: FUNCTION actualizar_timestamp(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.actualizar_timestamp() IS 'Actualiza automáticamente el campo actualizado_en';


--
-- Name: obtener_estadisticas_sistema(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.obtener_estadisticas_sistema() RETURNS TABLE(total_usuarios bigint, total_cursos bigint, total_inscripciones bigint, total_certificados bigint, cursos_publicados bigint, alumnos_activos bigint)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.obtener_estadisticas_sistema() OWNER TO postgres;

--
-- Name: FUNCTION obtener_estadisticas_sistema(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.obtener_estadisticas_sistema() IS 'Obtiene estadísticas generales del sistema';


--
-- Name: validar_certificado(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validar_certificado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.validar_certificado() OWNER TO postgres;

--
-- Name: FUNCTION validar_certificado(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.validar_certificado() IS 'Valida que el curso esté completado antes de emitir certificado';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actividad_alumno; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actividad_alumno (
    id bigint NOT NULL,
    alumno_id bigint NOT NULL,
    curso_id bigint,
    tipo character varying(50) NOT NULL,
    descripcion text,
    creado_en timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.actividad_alumno OWNER TO postgres;

--
-- Name: TABLE actividad_alumno; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.actividad_alumno IS 'Registro de actividad de alumnos para reportes';


--
-- Name: COLUMN actividad_alumno.tipo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.actividad_alumno.tipo IS 'Tipo de actividad: LOGIN, INSCRIPCION, PROGRESO, CERTIFICADO, etc.';


--
-- Name: actividad_alumno_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actividad_alumno_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.actividad_alumno_id_seq OWNER TO postgres;

--
-- Name: actividad_alumno_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actividad_alumno_id_seq OWNED BY public.actividad_alumno.id;


--
-- Name: certificados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.certificados (
    id bigint NOT NULL,
    alumno_id bigint NOT NULL,
    curso_id bigint NOT NULL,
    codigo_verificacion character varying(100) NOT NULL,
    fecha_emision timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.certificados OWNER TO postgres;

--
-- Name: TABLE certificados; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.certificados IS 'Certificados emitidos al completar cursos';


--
-- Name: COLUMN certificados.alumno_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.certificados.alumno_id IS 'Usuario que obtuvo el certificado';


--
-- Name: COLUMN certificados.codigo_verificacion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.certificados.codigo_verificacion IS 'Código único para verificación pública del certificado';


--
-- Name: certificados_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.certificados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.certificados_id_seq OWNER TO postgres;

--
-- Name: certificados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.certificados_id_seq OWNED BY public.certificados.id;


--
-- Name: configuracion_parental; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configuracion_parental (
    id bigint NOT NULL,
    padre_id bigint NOT NULL,
    nivel_maximo_contenido character varying(20),
    tiempo_maximo_diario_min integer,
    creado_en timestamp without time zone DEFAULT now() NOT NULL,
    actualizado_en timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_config_nivel_max CHECK (((nivel_maximo_contenido IS NULL) OR ((nivel_maximo_contenido)::text = ANY ((ARRAY['BASICO'::character varying, 'INTERMEDIO'::character varying, 'AVANZADO'::character varying])::text[])))),
    CONSTRAINT configuracion_parental_tiempo_maximo_diario_min_check CHECK (((tiempo_maximo_diario_min IS NULL) OR (tiempo_maximo_diario_min > 0)))
);


ALTER TABLE public.configuracion_parental OWNER TO postgres;

--
-- Name: TABLE configuracion_parental; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.configuracion_parental IS 'Configuración de controles parentales';


--
-- Name: COLUMN configuracion_parental.padre_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.configuracion_parental.padre_id IS 'Usuario con rol PADRE (uno por padre)';


--
-- Name: COLUMN configuracion_parental.nivel_maximo_contenido; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.configuracion_parental.nivel_maximo_contenido IS 'Nivel máximo de cursos que pueden ver los hijos';


--
-- Name: COLUMN configuracion_parental.tiempo_maximo_diario_min; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.configuracion_parental.tiempo_maximo_diario_min IS 'Tiempo máximo diario en minutos (opcional)';


--
-- Name: configuracion_parental_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.configuracion_parental_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.configuracion_parental_id_seq OWNER TO postgres;

--
-- Name: configuracion_parental_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.configuracion_parental_id_seq OWNED BY public.configuracion_parental.id;


--
-- Name: cursos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cursos (
    id bigint NOT NULL,
    titulo character varying(200) NOT NULL,
    descripcion text,
    nivel character varying(20) NOT NULL,
    publicado boolean DEFAULT false NOT NULL,
    maestro_id bigint NOT NULL,
    creado_en timestamp without time zone DEFAULT now() NOT NULL,
    actualizado_en timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_cursos_nivel CHECK (((nivel)::text = ANY ((ARRAY['BASICO'::character varying, 'INTERMEDIO'::character varying, 'AVANZADO'::character varying])::text[])))
);


ALTER TABLE public.cursos OWNER TO postgres;

--
-- Name: TABLE cursos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.cursos IS 'Cursos disponibles en la plataforma';


--
-- Name: COLUMN cursos.nivel; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cursos.nivel IS 'Nivel de dificultad: BASICO, INTERMEDIO, AVANZADO';


--
-- Name: COLUMN cursos.publicado; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cursos.publicado IS 'Indica si el curso está visible para los alumnos';


--
-- Name: COLUMN cursos.maestro_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cursos.maestro_id IS 'Usuario con rol MAESTRO que imparte el curso';


--
-- Name: cursos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cursos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cursos_id_seq OWNER TO postgres;

--
-- Name: cursos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cursos_id_seq OWNED BY public.cursos.id;


--
-- Name: inscripciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inscripciones (
    id bigint NOT NULL,
    curso_id bigint NOT NULL,
    alumno_id bigint NOT NULL,
    progreso_porcentaje numeric(5,2) DEFAULT 0 NOT NULL,
    completado boolean DEFAULT false NOT NULL,
    inscrito_en timestamp without time zone DEFAULT now() NOT NULL,
    actualizado_en timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT inscripciones_progreso_porcentaje_check CHECK (((progreso_porcentaje >= (0)::numeric) AND (progreso_porcentaje <= (100)::numeric)))
);


ALTER TABLE public.inscripciones OWNER TO postgres;

--
-- Name: TABLE inscripciones; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.inscripciones IS 'Inscripciones de alumnos a cursos con progreso';


--
-- Name: COLUMN inscripciones.alumno_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inscripciones.alumno_id IS 'Usuario con rol ALUMNO inscrito al curso';


--
-- Name: COLUMN inscripciones.progreso_porcentaje; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inscripciones.progreso_porcentaje IS 'Porcentaje de avance del curso (0-100)';


--
-- Name: COLUMN inscripciones.completado; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inscripciones.completado IS 'TRUE cuando progreso_porcentaje alcanza 100';


--
-- Name: inscripciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inscripciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inscripciones_id_seq OWNER TO postgres;

--
-- Name: inscripciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inscripciones_id_seq OWNED BY public.inscripciones.id;


--
-- Name: logros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logros (
    id bigint NOT NULL,
    titulo character varying(200) NOT NULL,
    descripcion text NOT NULL,
    icono_url character varying(500),
    tipo character varying(20) NOT NULL,
    criterio_codigo character varying(100) NOT NULL,
    puntos integer DEFAULT 0 NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    creado_en timestamp without time zone DEFAULT now() NOT NULL,
    actualizado_en timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_logros_tipo CHECK (((tipo)::text = ANY ((ARRAY['SYSTEM'::character varying, 'CUSTOM'::character varying])::text[])))
);


ALTER TABLE public.logros OWNER TO postgres;

--
-- Name: TABLE logros; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.logros IS 'Logros disponibles en el sistema para gamificación';


--
-- Name: COLUMN logros.tipo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.logros.tipo IS 'Tipo de logro: SYSTEM (predefinido) o CUSTOM (personalizado)';


--
-- Name: COLUMN logros.criterio_codigo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.logros.criterio_codigo IS 'Código único que identifica el criterio del logro';


--
-- Name: COLUMN logros.puntos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.logros.puntos IS 'Puntos que otorga el logro al desbloquearlo';


--
-- Name: COLUMN logros.activo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.logros.activo IS 'Indica si el logro está activo y puede ser obtenido';


--
-- Name: logros_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logros_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logros_id_seq OWNER TO postgres;

--
-- Name: logros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logros_id_seq OWNED BY public.logros.id;


--
-- Name: logros_usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logros_usuarios (
    id bigint NOT NULL,
    logro_id bigint NOT NULL,
    alumno_id bigint NOT NULL,
    fecha_obtenido timestamp without time zone DEFAULT now() NOT NULL,
    compartido_veces integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.logros_usuarios OWNER TO postgres;

--
-- Name: TABLE logros_usuarios; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.logros_usuarios IS 'Logros obtenidos por alumnos';


--
-- Name: COLUMN logros_usuarios.fecha_obtenido; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.logros_usuarios.fecha_obtenido IS 'Fecha en que el alumno desbloqueó el logro';


--
-- Name: COLUMN logros_usuarios.compartido_veces; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.logros_usuarios.compartido_veces IS 'Contador de veces que el alumno ha compartido este logro';


--
-- Name: logros_usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logros_usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logros_usuarios_id_seq OWNER TO postgres;

--
-- Name: logros_usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logros_usuarios_id_seq OWNED BY public.logros_usuarios.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    nombre character varying(20) NOT NULL,
    CONSTRAINT chk_roles_nombre CHECK (((nombre)::text = ANY ((ARRAY['ADMIN'::character varying, 'PADRE'::character varying, 'MAESTRO'::character varying, 'ALUMNO'::character varying])::text[])))
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: TABLE roles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.roles IS 'Roles disponibles en el sistema';


--
-- Name: COLUMN roles.nombre; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.roles.nombre IS 'Nombre del rol: ADMIN, PADRE, MAESTRO, ALUMNO';


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: tech_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tech_posts (
    id bigint NOT NULL,
    titulo character varying(200) NOT NULL,
    resumen character varying(500) NOT NULL,
    contenido_markdown text NOT NULL,
    slug character varying(200) NOT NULL,
    categoria character varying(100),
    etiquetas text,
    estado character varying(20) NOT NULL,
    autor_id bigint NOT NULL,
    creado_en timestamp without time zone DEFAULT now() NOT NULL,
    actualizado_en timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_tech_posts_estado CHECK (((estado)::text = ANY ((ARRAY['DRAFT'::character varying, 'PUBLISHED'::character varying])::text[])))
);


ALTER TABLE public.tech_posts OWNER TO postgres;

--
-- Name: TABLE tech_posts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.tech_posts IS 'Artículos técnicos y contenido educativo del blog';


--
-- Name: COLUMN tech_posts.contenido_markdown; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tech_posts.contenido_markdown IS 'Contenido completo del artículo en formato Markdown';


--
-- Name: COLUMN tech_posts.slug; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tech_posts.slug IS 'URL amigable única para el artículo';


--
-- Name: COLUMN tech_posts.etiquetas; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tech_posts.etiquetas IS 'Etiquetas separadas por coma para clasificación';


--
-- Name: COLUMN tech_posts.estado; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tech_posts.estado IS 'Estado del artículo: DRAFT (borrador) o PUBLISHED (publicado)';


--
-- Name: COLUMN tech_posts.autor_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tech_posts.autor_id IS 'Usuario que creó el artículo (ADMIN o MAESTRO)';


--
-- Name: tech_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tech_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tech_posts_id_seq OWNER TO postgres;

--
-- Name: tech_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tech_posts_id_seq OWNED BY public.tech_posts.id;


--
-- Name: usuario_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_roles (
    usuario_id bigint NOT NULL,
    rol_id bigint NOT NULL
);


ALTER TABLE public.usuario_roles OWNER TO postgres;

--
-- Name: TABLE usuario_roles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.usuario_roles IS 'Relación muchos-a-muchos entre usuarios y roles';


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id bigint NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password_hash character varying(255) NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    creado_en timestamp without time zone DEFAULT now() NOT NULL,
    actualizado_en timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: TABLE usuarios; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.usuarios IS 'Usuarios del sistema (admin, padres, maestros, alumnos)';


--
-- Name: COLUMN usuarios.password_hash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.usuarios.password_hash IS 'Contraseña encriptada con BCrypt';


--
-- Name: COLUMN usuarios.activo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.usuarios.activo IS 'Indica si el usuario puede acceder al sistema';


--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: v_certificados_completos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_certificados_completos AS
 SELECT cert.id,
    cert.codigo_verificacion,
    cert.fecha_emision,
    u.id AS alumno_id,
    (((u.nombre)::text || ' '::text) || (u.apellido)::text) AS alumno_nombre,
    u.email AS alumno_email,
    c.id AS curso_id,
    c.titulo AS curso_titulo,
    c.nivel AS curso_nivel,
    (((m.nombre)::text || ' '::text) || (m.apellido)::text) AS maestro_nombre
   FROM (((public.certificados cert
     JOIN public.usuarios u ON ((cert.alumno_id = u.id)))
     JOIN public.cursos c ON ((cert.curso_id = c.id)))
     JOIN public.usuarios m ON ((c.maestro_id = m.id)));


ALTER VIEW public.v_certificados_completos OWNER TO postgres;

--
-- Name: VIEW v_certificados_completos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.v_certificados_completos IS 'Vista de certificados con información completa';


--
-- Name: v_cursos_completos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_cursos_completos AS
 SELECT c.id,
    c.titulo,
    c.descripcion,
    c.nivel,
    c.publicado,
    c.maestro_id,
    (((u.nombre)::text || ' '::text) || (u.apellido)::text) AS maestro_nombre,
    u.email AS maestro_email,
    c.creado_en,
    c.actualizado_en,
    count(i.id) AS total_inscritos
   FROM ((public.cursos c
     JOIN public.usuarios u ON ((c.maestro_id = u.id)))
     LEFT JOIN public.inscripciones i ON ((c.id = i.curso_id)))
  GROUP BY c.id, c.titulo, c.descripcion, c.nivel, c.publicado, c.maestro_id, u.nombre, u.apellido, u.email, c.creado_en, c.actualizado_en;


ALTER VIEW public.v_cursos_completos OWNER TO postgres;

--
-- Name: VIEW v_cursos_completos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.v_cursos_completos IS 'Vista de cursos con información del maestro y total de inscritos';


--
-- Name: v_progreso_alumnos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_progreso_alumnos AS
 SELECT i.id AS inscripcion_id,
    u.id AS alumno_id,
    (((u.nombre)::text || ' '::text) || (u.apellido)::text) AS alumno_nombre,
    u.email AS alumno_email,
    c.id AS curso_id,
    c.titulo AS curso_titulo,
    c.nivel AS curso_nivel,
    i.progreso_porcentaje,
    i.completado,
    i.inscrito_en,
    i.actualizado_en
   FROM ((public.inscripciones i
     JOIN public.usuarios u ON ((i.alumno_id = u.id)))
     JOIN public.cursos c ON ((i.curso_id = c.id)));


ALTER VIEW public.v_progreso_alumnos OWNER TO postgres;

--
-- Name: VIEW v_progreso_alumnos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.v_progreso_alumnos IS 'Vista de progreso de alumnos en sus cursos';


--
-- Name: v_usuarios_roles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_usuarios_roles AS
 SELECT u.id,
    u.nombre,
    u.apellido,
    u.email,
    u.activo,
    array_agg(r.nombre ORDER BY r.nombre) AS roles,
    u.creado_en,
    u.actualizado_en
   FROM ((public.usuarios u
     LEFT JOIN public.usuario_roles ur ON ((u.id = ur.usuario_id)))
     LEFT JOIN public.roles r ON ((ur.rol_id = r.id)))
  GROUP BY u.id, u.nombre, u.apellido, u.email, u.activo, u.creado_en, u.actualizado_en;


ALTER VIEW public.v_usuarios_roles OWNER TO postgres;

--
-- Name: VIEW v_usuarios_roles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.v_usuarios_roles IS 'Vista de usuarios con sus roles agregados';


--
-- Name: vinculos_parentales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vinculos_parentales (
    id bigint NOT NULL,
    padre_id bigint NOT NULL,
    alumno_id bigint NOT NULL,
    creado_en timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_vinculos_diferente_usuario CHECK ((padre_id <> alumno_id))
);


ALTER TABLE public.vinculos_parentales OWNER TO postgres;

--
-- Name: TABLE vinculos_parentales; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.vinculos_parentales IS 'Relaciones padre-hijo para control parental';


--
-- Name: COLUMN vinculos_parentales.padre_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vinculos_parentales.padre_id IS 'Usuario con rol PADRE';


--
-- Name: COLUMN vinculos_parentales.alumno_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vinculos_parentales.alumno_id IS 'Usuario con rol ALUMNO (hijo)';


--
-- Name: vinculos_parentales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vinculos_parentales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vinculos_parentales_id_seq OWNER TO postgres;

--
-- Name: vinculos_parentales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vinculos_parentales_id_seq OWNED BY public.vinculos_parentales.id;


--
-- Name: actividad_alumno id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_alumno ALTER COLUMN id SET DEFAULT nextval('public.actividad_alumno_id_seq'::regclass);


--
-- Name: certificados id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certificados ALTER COLUMN id SET DEFAULT nextval('public.certificados_id_seq'::regclass);


--
-- Name: configuracion_parental id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracion_parental ALTER COLUMN id SET DEFAULT nextval('public.configuracion_parental_id_seq'::regclass);


--
-- Name: cursos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cursos ALTER COLUMN id SET DEFAULT nextval('public.cursos_id_seq'::regclass);


--
-- Name: inscripciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscripciones ALTER COLUMN id SET DEFAULT nextval('public.inscripciones_id_seq'::regclass);


--
-- Name: logros id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logros ALTER COLUMN id SET DEFAULT nextval('public.logros_id_seq'::regclass);


--
-- Name: logros_usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logros_usuarios ALTER COLUMN id SET DEFAULT nextval('public.logros_usuarios_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: tech_posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tech_posts ALTER COLUMN id SET DEFAULT nextval('public.tech_posts_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Name: vinculos_parentales id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vinculos_parentales ALTER COLUMN id SET DEFAULT nextval('public.vinculos_parentales_id_seq'::regclass);


--
-- Data for Name: actividad_alumno; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actividad_alumno (id, alumno_id, curso_id, tipo, descripcion, creado_en) FROM stdin;
1	7	1	INSCRIPCION	Alumno se inscribió en el curso	2025-12-11 18:06:15.051006
2	7	1	CERTIFICADO	Alumno completó el curso y obtuvo certificado	2025-12-11 18:06:15.051006
3	8	7	PROGRESO	Alumno actualizó progreso a 75%	2025-12-11 18:06:15.051006
\.


--
-- Data for Name: certificados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.certificados (id, alumno_id, curso_id, codigo_verificacion, fecha_emision) FROM stdin;
1	7	1	CERT-JS-D8BA3F654009	2025-12-11 18:06:15.006611
2	7	4	CERT-ALG-DF4D3D150071	2025-12-11 18:06:15.006611
3	8	7	CERT-FIS-89B6D70FF2DA	2025-12-11 18:06:15.006611
4	9	5	CERT-CALC-F8E4F172F81C	2025-12-11 18:06:15.006611
5	10	4	CERT-ALG-FE51E836AFAD	2025-12-11 18:06:15.006611
6	10	8	CERT-QUIM-2924EFCC4DC8	2025-12-11 18:06:15.006611
7	11	1	CERT-JS-31E8B9AB7008	2025-12-11 18:06:15.006611
8	12	9	CERT-BIO-199A526202BF	2025-12-11 18:06:15.006611
9	9	3	CERT-EF3D45188951AFE0	2025-12-11 18:06:23.04982
10	10	5	CERT-7DC8569783EE3864	2025-12-11 18:06:23.04982
11	8	8	CERT-B6E669B4EE5C9AE3	2025-12-11 18:06:23.04982
12	11	7	CERT-5A6EAEAC78E9098E	2025-12-11 18:06:23.04982
13	7	2	CERT-89E62F5A9583F518	2025-12-11 18:06:23.04982
14	8	1	CERT-84A23EBE649795F8	2025-12-11 18:06:23.04982
15	12	8	CERT-4B47822435A36749	2025-12-11 18:06:23.04982
\.


--
-- Data for Name: configuracion_parental; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configuracion_parental (id, padre_id, nivel_maximo_contenido, tiempo_maximo_diario_min, creado_en, actualizado_en) FROM stdin;
1	5	INTERMEDIO	120	2025-12-11 18:06:15.022199	2025-12-11 18:06:15.022199
2	6	AVANZADO	180	2025-12-11 18:06:15.026574	2025-12-11 18:06:15.026574
\.


--
-- Data for Name: cursos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cursos (id, titulo, descripcion, nivel, publicado, maestro_id, creado_en, actualizado_en) FROM stdin;
1	Introducción a JavaScript	Aprende los fundamentos de JavaScript desde cero. Este curso cubre variables, funciones, arrays, objetos y manipulación del DOM.	BASICO	t	2	2025-12-11 18:06:14.985525	2025-12-11 18:06:14.985525
2	JavaScript Avanzado y ES6+	Domina características avanzadas de JavaScript: Promises, Async/Await, Destructuring, Spread Operator y más.	AVANZADO	t	2	2025-12-11 18:06:14.985525	2025-12-11 18:06:14.985525
3	Desarrollo Web con React	Crea aplicaciones web modernas con React. Aprende componentes, hooks, estado y routing.	INTERMEDIO	t	2	2025-12-11 18:06:14.985525	2025-12-11 18:06:14.985525
4	Álgebra Básica	Fundamentos de álgebra: ecuaciones lineales, sistemas de ecuaciones y factorización.	BASICO	t	3	2025-12-11 18:06:14.989874	2025-12-11 18:06:14.989874
5	Cálculo Diferencial	Introducción al cálculo: límites, derivadas y aplicaciones en problemas reales.	INTERMEDIO	t	3	2025-12-11 18:06:14.989874	2025-12-11 18:06:14.989874
6	Geometría Analítica	Estudio de figuras geométricas usando coordenadas y ecuaciones.	INTERMEDIO	f	3	2025-12-11 18:06:14.989874	2025-12-11 18:06:14.989874
7	Física para Principiantes	Conceptos básicos de física: movimiento, fuerza, energía y trabajo.	BASICO	t	4	2025-12-11 18:06:14.991392	2025-12-11 18:06:14.991392
8	Química General	Introducción a la química: átomos, enlaces químicos, reacciones y estequiometría.	BASICO	t	4	2025-12-11 18:06:14.991392	2025-12-11 18:06:14.991392
9	Biología Molecular	Estudio de los procesos biológicos a nivel molecular: ADN, proteínas y células.	AVANZADO	t	4	2025-12-11 18:06:14.991392	2025-12-11 18:06:14.991392
\.


--
-- Data for Name: inscripciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inscripciones (id, curso_id, alumno_id, progreso_porcentaje, completado, inscrito_en, actualizado_en) FROM stdin;
1	1	7	100.00	t	2025-12-11 18:06:14.993016	2025-12-11 18:06:14.993016
3	4	7	100.00	t	2025-12-11 18:06:14.993016	2025-12-11 18:06:14.993016
5	7	8	100.00	t	2025-12-11 18:06:14.998754	2025-12-11 18:06:14.998754
8	5	9	100.00	t	2025-12-11 18:06:15.000527	2025-12-11 18:06:15.000527
11	8	10	100.00	t	2025-12-11 18:06:15.001779	2025-12-11 18:06:15.001779
13	1	11	100.00	t	2025-12-11 18:06:15.003284	2025-12-11 18:06:15.003284
14	9	12	100.00	t	2025-12-11 18:06:15.004841	2025-12-11 18:06:15.004841
2	2	7	100.00	t	2025-12-11 18:06:14.993016	2025-12-11 18:06:23.042278
4	1	8	100.00	t	2025-12-11 18:06:14.998754	2025-12-11 18:06:23.042278
6	8	8	100.00	t	2025-12-11 18:06:14.998754	2025-12-11 18:06:23.042278
7	3	9	100.00	t	2025-12-11 18:06:15.000527	2025-12-11 18:06:23.042278
12	7	11	100.00	t	2025-12-11 18:06:15.003284	2025-12-11 18:06:23.042278
15	8	12	100.00	t	2025-12-11 18:06:15.004841	2025-12-11 18:06:23.042278
10	5	10	20.00	f	2025-12-11 18:06:15.001779	2025-12-12 02:46:49.429866
9	4	10	40.00	f	2025-12-11 18:06:15.001779	2025-12-12 02:46:49.429866
\.


--
-- Data for Name: logros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logros (id, titulo, descripcion, icono_url, tipo, criterio_codigo, puntos, activo, creado_en, actualizado_en) FROM stdin;
2	Estudiante Dedicado	Completa tu primer curso	/icons/first-completion.svg	SYSTEM	FIRST_COURSE_COMPLETE	50	t	2025-12-11 18:06:15.027857	2025-12-11 18:06:15.027857
3	Aprendiz Destacado	Completa 3 cursos	/icons/three-courses.svg	SYSTEM	THREE_COURSES_COMPLETE	100	t	2025-12-11 18:06:15.027857	2025-12-11 18:06:15.027857
4	Maestro del Conocimiento	Completa 10 cursos	/icons/ten-courses.svg	SYSTEM	TEN_COURSES_COMPLETE	500	t	2025-12-11 18:06:15.027857	2025-12-11 18:06:15.027857
5	Racha de 7 Días	Estudia durante 7 días consecutivos	/icons/seven-day-streak.svg	SYSTEM	SEVEN_DAY_STREAK	75	t	2025-12-11 18:06:15.027857	2025-12-11 18:06:15.027857
6	Perfeccionista	Completa un curso con 100% de progreso	/icons/perfectionist.svg	SYSTEM	PERFECT_COMPLETION	30	t	2025-12-11 18:06:15.027857	2025-12-11 18:06:15.027857
7	Explorador	Inscríbete en 5 cursos diferentes	/icons/explorer.svg	SYSTEM	FIVE_ENROLLMENTS	40	t	2025-12-11 18:06:15.027857	2025-12-11 18:06:15.027857
8	Velocista	Completa un curso en menos de 7 días	/icons/speedrunner.svg	SYSTEM	COURSE_IN_WEEK	80	t	2025-12-11 18:06:15.027857	2025-12-11 18:06:15.027857
9	Certificado de Oro	Obtén tu primer certificado	/icons/gold-certificate.svg	SYSTEM	FIRST_CERTIFICATE	60	t	2025-12-11 18:06:15.027857	2025-12-11 18:06:15.027857
10	Coleccionista	Obtén 5 certificados	/icons/collector.svg	SYSTEM	FIVE_CERTIFICATES	200	t	2025-12-11 18:06:15.027857	2025-12-11 18:06:15.027857
11	JavaScript Ninja	Completa todos los cursos de JavaScript	/icons/js-ninja.svg	CUSTOM	JS_MASTER	150	t	2025-12-11 18:06:15.027857	2025-12-11 18:06:15.027857
12	Científico Junior	Completa cursos de Física, Química y Biología	/icons/scientist.svg	CUSTOM	SCIENCE_MASTER	250	t	2025-12-11 18:06:15.027857	2025-12-11 18:06:15.027857
1	Primer Paso	Completa tu primera inscripción a un curso	/icons/first-enrollment.svg	SYSTEM	FIRST_ENROLLMENT	10	t	2025-12-11 18:06:15.027857	2025-12-11 20:26:57.183399
\.


--
-- Data for Name: logros_usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logros_usuarios (id, logro_id, alumno_id, fecha_obtenido, compartido_veces) FROM stdin;
12	1	7	2025-12-11 18:06:23.029477	0
13	2	7	2025-12-11 18:06:23.029477	2
14	9	7	2025-12-11 18:06:23.029477	1
16	2	8	2025-12-11 18:06:23.029477	1
17	9	8	2025-12-11 18:06:23.029477	0
18	1	10	2025-12-11 18:06:23.029477	0
19	2	10	2025-12-11 18:06:23.029477	3
20	3	10	2025-12-11 18:06:23.029477	1
21	9	10	2025-12-11 18:06:23.029477	2
15	1	8	2025-12-11 18:06:23.029477	3
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, nombre) FROM stdin;
1	ADMIN
2	PADRE
3	MAESTRO
4	ALUMNO
\.


--
-- Data for Name: tech_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tech_posts (id, titulo, resumen, contenido_markdown, slug, categoria, etiquetas, estado, autor_id, creado_en, actualizado_en) FROM stdin;
1	¿Qué es JavaScript y por qué aprenderlo?	Descubre el lenguaje de programación más popular para desarrollo web y sus aplicaciones modernas.	# ¿Qué es JavaScript?\r\n\r\nJavaScript es un lenguaje de programación de alto nivel, interpretado y orientado a objetos. Es uno de los tres pilares fundamentales del desarrollo web moderno, junto con HTML y CSS.\r\n\r\n## ¿Por qué aprender JavaScript?\r\n\r\n1. **Versatilidad**: Puedes usarlo tanto en el frontend como en el backend (Node.js)\r\n2. **Demanda laboral**: Es uno de los lenguajes más solicitados en el mercado\r\n3. **Comunidad activa**: Miles de desarrolladores y recursos disponibles\r\n4. **Frameworks poderosos**: React, Vue, Angular, Express, y más\r\n\r\n## Primeros pasos\r\n\r\n```javascript\r\nconsole.log("¡Hola, mundo!");\r\n```\r\n\r\nJavaScript es dinámico y fácil de aprender, pero tiene profundidad suficiente para construir aplicaciones complejas.\r\n\r\n## Conclusión\r\n\r\nSi estás comenzando en programación, JavaScript es una excelente elección por su versatilidad y oportunidades.	que-es-javascript-y-por-que-aprenderlo	Programación	JavaScript, Web Development, Principiantes	PUBLISHED	2	2025-12-11 18:06:15.044998	2025-12-11 18:06:15.044998
2	Introducción a React: Componentes y Props	Aprende los conceptos fundamentales de React, la biblioteca más popular para construir interfaces de usuario.	# Introducción a React\r\n\r\nReact es una biblioteca de JavaScript para construir interfaces de usuario desarrollada por Facebook.\r\n\r\n## Componentes\r\n\r\nLos componentes son la base de React. Son como bloques de construcción reutilizables.\r\n\r\n```jsx\r\nfunction Saludo(props) {\r\n  return <h1>Hola, {props.nombre}</h1>;\r\n}\r\n```\r\n\r\n## Props\r\n\r\nLas props son la forma de pasar datos de un componente padre a un hijo.\r\n\r\n```jsx\r\n<Saludo nombre="María" />\r\n```\r\n\r\n## Conclusión\r\n\r\nReact hace que construir UIs complejas sea más manejable y eficiente.	introduccion-a-react-componentes-y-props	Programación	React, JavaScript, Frontend	PUBLISHED	2	2025-12-11 18:06:15.044998	2025-12-11 18:06:15.044998
3	Álgebra en la Vida Cotidiana	Descubre cómo el álgebra está presente en tu día a día y por qué es importante aprenderla.	# Álgebra en la Vida Cotidiana\r\n\r\nEl álgebra no es solo ecuaciones abstractas, está en todas partes.\r\n\r\n## Aplicaciones prácticas\r\n\r\n1. **Finanzas personales**: Calcular intereses y presupuestos\r\n2. **Cocina**: Ajustar recetas para diferentes porciones\r\n3. **Construcción**: Calcular materiales necesarios\r\n4. **Tecnología**: Programación y algoritmos\r\n\r\n## Ejemplo simple\r\n\r\nSi x es el precio original y hay un 20% de descuento:\r\nPrecio final = x - 0.2x = 0.8x\r\n\r\n## Por qué importa\r\n\r\nEl álgebra desarrolla el pensamiento lógico y la capacidad de resolver problemas.	algebra-en-la-vida-cotidiana	Matemáticas	Álgebra, Vida cotidiana, Aplicaciones	PUBLISHED	3	2025-12-11 18:06:15.044998	2025-12-11 18:06:15.044998
4	Física Cuántica para Principiantes	Una introducción accesible al fascinante mundo de la física cuántica.	# Física Cuántica para Principiantes\r\n\r\nLa física cuántica estudia el comportamiento de la materia a escala microscópica.\r\n\r\n## Conceptos clave\r\n\r\n- **Partícula y onda**: La luz se comporta como ambas\r\n- **Principio de incertidumbre**: No podemos conocer todo con precisión\r\n- **Superposición**: Las partículas existen en múltiples estados\r\n\r\n## ¿Por qué importa?\r\n\r\nLa física cuántica ha revolucionado la tecnología moderna: computadoras, láseres, y más.\r\n\r\n## Para reflexionar\r\n\r\n"Si crees que entiendes la mecánica cuántica, es que no la entiendes" - Richard Feynman	fisica-cuantica-para-principiantes	Ciencias	Física, Cuántica, Ciencia	PUBLISHED	4	2025-12-11 18:06:15.044998	2025-12-11 18:06:15.044998
5	Guía de Estudio Efectivo	Técnicas probadas para mejorar tu rendimiento académico y retención de información.	# Guía de Estudio Efectivo\r\n\r\n## Técnicas recomendadas\r\n\r\n1. **Técnica Pomodoro**: 25 minutos de estudio, 5 de descanso\r\n2. **Resúmenes activos**: Escribe con tus propias palabras\r\n3. **Enseña a otros**: Explica lo que aprendiste\r\n4. **Práctica espaciada**: Repasa en intervalos crecientes\r\n\r\n## Ambiente de estudio\r\n\r\n- Lugar tranquilo y bien iluminado\r\n- Sin distracciones (celular lejos)\r\n- Material organizado\r\n\r\n## Conclusión\r\n\r\nLa calidad del estudio es más importante que la cantidad de horas.	guia-de-estudio-efectivo	Educación	Estudio, Técnicas, Aprendizaje	PUBLISHED	3	2025-12-11 18:06:15.044998	2025-12-11 18:06:15.044998
6	Próximas funcionalidades de mexaula	Borrador sobre las nuevas características que vienen pronto a la plataforma.	# Próximas funcionalidades\r\n\r\nEste es un borrador sobre las próximas características:\r\n- Sistema de gamificación mejorado\r\n- Foros de discusión\r\n- Clases en vivo\r\n\r\n(En desarrollo...)	proximas-funcionalidades-mexaula	Anuncios	mexaula, Novedades	DRAFT	2	2025-12-11 18:06:15.044998	2025-12-11 18:06:15.044998
\.


--
-- Data for Name: usuario_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario_roles (usuario_id, rol_id) FROM stdin;
1	1
2	3
3	3
4	3
5	2
6	2
7	4
8	4
9	4
10	4
11	4
12	4
13	4
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nombre, apellido, email, password_hash, activo, creado_en, actualizado_en) FROM stdin;
13	Test	test	test@test.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-12 00:13:39.329089	2025-12-12 00:13:39.329089
10	Sofia	Ramírez	sofia.ramirez@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:14.975759	2025-12-12 00:14:00.612757
6	Juan	Rodríguez	juan.rodriguez@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:14.974574	2025-12-12 00:14:00.612757
5	María	González	maria.gonzalez@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:14.974574	2025-12-12 00:14:00.612757
4	Roberto	García	roberto.garcia@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:14.971368	2025-12-12 00:14:00.612757
11	Miguel	Vargas	miguel.vargas@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:14.975759	2025-12-12 00:14:00.612757
1	Admin	Sistema	admin@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:06.809615	2025-12-12 00:14:00.612757
7	Pedro	Sánchez	pedro.sanchez@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:14.975759	2025-12-12 00:14:00.612757
9	Diego	Torres	diego.torres@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:14.975759	2025-12-12 00:14:00.612757
8	Laura	Fernández	laura.fernandez@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:14.975759	2025-12-12 00:14:00.612757
2	Carlos	López	carlos.lopez@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:14.971368	2025-12-12 00:14:00.612757
12	Carmen	Luna	carmen.luna@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:14.975759	2025-12-12 00:14:00.612757
3	Ana	Martínez	ana.martinez@mexaula.com	$2a$10$lIr171SRUb0glu1YFKURDeo9fFvCgii.XLN18wzti42TPUFFVe2Vu	t	2025-12-11 18:06:14.971368	2025-12-12 00:14:00.612757
\.


--
-- Data for Name: vinculos_parentales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vinculos_parentales (id, padre_id, alumno_id, creado_en) FROM stdin;
1	5	7	2025-12-11 18:06:15.015359
2	5	8	2025-12-11 18:06:15.015359
3	6	9	2025-12-11 18:06:15.020837
4	6	10	2025-12-11 18:06:15.020837
\.


--
-- Name: actividad_alumno_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actividad_alumno_id_seq', 3, true);


--
-- Name: certificados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.certificados_id_seq', 15, true);


--
-- Name: configuracion_parental_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.configuracion_parental_id_seq', 2, true);


--
-- Name: cursos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cursos_id_seq', 9, true);


--
-- Name: inscripciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inscripciones_id_seq', 15, true);


--
-- Name: logros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logros_id_seq', 12, true);


--
-- Name: logros_usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logros_usuarios_id_seq', 21, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 4, true);


--
-- Name: tech_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tech_posts_id_seq', 12, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 13, true);


--
-- Name: vinculos_parentales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vinculos_parentales_id_seq', 4, true);


--
-- Name: actividad_alumno actividad_alumno_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_alumno
    ADD CONSTRAINT actividad_alumno_pkey PRIMARY KEY (id);


--
-- Name: certificados certificados_codigo_verificacion_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT certificados_codigo_verificacion_key UNIQUE (codigo_verificacion);


--
-- Name: certificados certificados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT certificados_pkey PRIMARY KEY (id);


--
-- Name: configuracion_parental configuracion_parental_padre_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracion_parental
    ADD CONSTRAINT configuracion_parental_padre_id_key UNIQUE (padre_id);


--
-- Name: configuracion_parental configuracion_parental_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracion_parental
    ADD CONSTRAINT configuracion_parental_pkey PRIMARY KEY (id);


--
-- Name: cursos cursos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);


--
-- Name: inscripciones inscripciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscripciones
    ADD CONSTRAINT inscripciones_pkey PRIMARY KEY (id);


--
-- Name: logros logros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logros
    ADD CONSTRAINT logros_pkey PRIMARY KEY (id);


--
-- Name: logros_usuarios logros_usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logros_usuarios
    ADD CONSTRAINT logros_usuarios_pkey PRIMARY KEY (id);


--
-- Name: roles roles_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key UNIQUE (nombre);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: tech_posts tech_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tech_posts
    ADD CONSTRAINT tech_posts_pkey PRIMARY KEY (id);


--
-- Name: tech_posts tech_posts_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tech_posts
    ADD CONSTRAINT tech_posts_slug_key UNIQUE (slug);


--
-- Name: inscripciones uq_inscripciones_curso_alumno; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscripciones
    ADD CONSTRAINT uq_inscripciones_curso_alumno UNIQUE (curso_id, alumno_id);


--
-- Name: logros_usuarios uq_logro_usuario; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logros_usuarios
    ADD CONSTRAINT uq_logro_usuario UNIQUE (logro_id, alumno_id);


--
-- Name: logros uq_logros_criterio; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logros
    ADD CONSTRAINT uq_logros_criterio UNIQUE (criterio_codigo);


--
-- Name: vinculos_parentales uq_vinculos_parentales; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vinculos_parentales
    ADD CONSTRAINT uq_vinculos_parentales UNIQUE (padre_id, alumno_id);


--
-- Name: usuario_roles usuario_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_roles
    ADD CONSTRAINT usuario_roles_pkey PRIMARY KEY (usuario_id, rol_id);


--
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: vinculos_parentales vinculos_parentales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vinculos_parentales
    ADD CONSTRAINT vinculos_parentales_pkey PRIMARY KEY (id);


--
-- Name: idx_actividad_alumno_alumno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_actividad_alumno_alumno ON public.actividad_alumno USING btree (alumno_id);


--
-- Name: idx_actividad_alumno_curso; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_actividad_alumno_curso ON public.actividad_alumno USING btree (curso_id);


--
-- Name: idx_actividad_alumno_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_actividad_alumno_fecha ON public.actividad_alumno USING btree (creado_en);


--
-- Name: idx_certificados_alumno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_certificados_alumno ON public.certificados USING btree (alumno_id);


--
-- Name: idx_certificados_codigo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_certificados_codigo ON public.certificados USING btree (codigo_verificacion);


--
-- Name: idx_certificados_curso; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_certificados_curso ON public.certificados USING btree (curso_id);


--
-- Name: idx_configuracion_parental_padre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_configuracion_parental_padre ON public.configuracion_parental USING btree (padre_id);


--
-- Name: idx_cursos_maestro; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cursos_maestro ON public.cursos USING btree (maestro_id);


--
-- Name: idx_cursos_nivel; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cursos_nivel ON public.cursos USING btree (nivel);


--
-- Name: idx_cursos_publicado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cursos_publicado ON public.cursos USING btree (publicado);


--
-- Name: idx_inscripciones_alumno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscripciones_alumno ON public.inscripciones USING btree (alumno_id);


--
-- Name: idx_inscripciones_completado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscripciones_completado ON public.inscripciones USING btree (completado);


--
-- Name: idx_inscripciones_curso; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscripciones_curso ON public.inscripciones USING btree (curso_id);


--
-- Name: idx_logros_activo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_logros_activo ON public.logros USING btree (activo);


--
-- Name: idx_logros_criterio; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_logros_criterio ON public.logros USING btree (criterio_codigo);


--
-- Name: idx_logros_tipo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_logros_tipo ON public.logros USING btree (tipo);


--
-- Name: idx_logros_usuarios_alumno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_logros_usuarios_alumno ON public.logros_usuarios USING btree (alumno_id);


--
-- Name: idx_logros_usuarios_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_logros_usuarios_fecha ON public.logros_usuarios USING btree (fecha_obtenido);


--
-- Name: idx_logros_usuarios_logro; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_logros_usuarios_logro ON public.logros_usuarios USING btree (logro_id);


--
-- Name: idx_tech_posts_autor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tech_posts_autor ON public.tech_posts USING btree (autor_id);


--
-- Name: idx_tech_posts_categoria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tech_posts_categoria ON public.tech_posts USING btree (categoria);


--
-- Name: idx_tech_posts_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tech_posts_estado ON public.tech_posts USING btree (estado);


--
-- Name: idx_tech_posts_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tech_posts_fecha ON public.tech_posts USING btree (creado_en);


--
-- Name: idx_tech_posts_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tech_posts_slug ON public.tech_posts USING btree (slug);


--
-- Name: idx_usuario_roles_rol; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuario_roles_rol ON public.usuario_roles USING btree (rol_id);


--
-- Name: idx_usuario_roles_usuario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuario_roles_usuario ON public.usuario_roles USING btree (usuario_id);


--
-- Name: idx_usuarios_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_email ON public.usuarios USING btree (email);


--
-- Name: idx_vinculos_parentales_alumno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vinculos_parentales_alumno ON public.vinculos_parentales USING btree (alumno_id);


--
-- Name: idx_vinculos_parentales_padre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vinculos_parentales_padre ON public.vinculos_parentales USING btree (padre_id);


--
-- Name: configuracion_parental trg_configuracion_parental_actualizado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_configuracion_parental_actualizado BEFORE UPDATE ON public.configuracion_parental FOR EACH ROW EXECUTE FUNCTION public.actualizar_timestamp();


--
-- Name: cursos trg_cursos_actualizado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_cursos_actualizado BEFORE UPDATE ON public.cursos FOR EACH ROW EXECUTE FUNCTION public.actualizar_timestamp();


--
-- Name: inscripciones trg_inscripciones_actualizado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_inscripciones_actualizado BEFORE UPDATE ON public.inscripciones FOR EACH ROW EXECUTE FUNCTION public.actualizar_timestamp();


--
-- Name: logros trg_logros_actualizado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_logros_actualizado BEFORE UPDATE ON public.logros FOR EACH ROW EXECUTE FUNCTION public.actualizar_timestamp();


--
-- Name: tech_posts trg_tech_posts_actualizado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tech_posts_actualizado BEFORE UPDATE ON public.tech_posts FOR EACH ROW EXECUTE FUNCTION public.actualizar_timestamp();


--
-- Name: usuarios trg_usuarios_actualizado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_usuarios_actualizado BEFORE UPDATE ON public.usuarios FOR EACH ROW EXECUTE FUNCTION public.actualizar_timestamp();


--
-- Name: certificados trg_validar_certificado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_validar_certificado BEFORE INSERT ON public.certificados FOR EACH ROW EXECUTE FUNCTION public.validar_certificado();


--
-- Name: actividad_alumno actividad_alumno_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_alumno
    ADD CONSTRAINT actividad_alumno_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- Name: actividad_alumno actividad_alumno_curso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_alumno
    ADD CONSTRAINT actividad_alumno_curso_id_fkey FOREIGN KEY (curso_id) REFERENCES public.cursos(id) ON DELETE SET NULL;


--
-- Name: certificados certificados_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT certificados_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE RESTRICT;


--
-- Name: certificados certificados_curso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT certificados_curso_id_fkey FOREIGN KEY (curso_id) REFERENCES public.cursos(id) ON DELETE RESTRICT;


--
-- Name: configuracion_parental configuracion_parental_padre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracion_parental
    ADD CONSTRAINT configuracion_parental_padre_id_fkey FOREIGN KEY (padre_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- Name: cursos cursos_maestro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cursos
    ADD CONSTRAINT cursos_maestro_id_fkey FOREIGN KEY (maestro_id) REFERENCES public.usuarios(id) ON DELETE RESTRICT;


--
-- Name: inscripciones inscripciones_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscripciones
    ADD CONSTRAINT inscripciones_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- Name: inscripciones inscripciones_curso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscripciones
    ADD CONSTRAINT inscripciones_curso_id_fkey FOREIGN KEY (curso_id) REFERENCES public.cursos(id) ON DELETE CASCADE;


--
-- Name: logros_usuarios logros_usuarios_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logros_usuarios
    ADD CONSTRAINT logros_usuarios_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- Name: logros_usuarios logros_usuarios_logro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logros_usuarios
    ADD CONSTRAINT logros_usuarios_logro_id_fkey FOREIGN KEY (logro_id) REFERENCES public.logros(id) ON DELETE CASCADE;


--
-- Name: tech_posts tech_posts_autor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tech_posts
    ADD CONSTRAINT tech_posts_autor_id_fkey FOREIGN KEY (autor_id) REFERENCES public.usuarios(id);


--
-- Name: usuario_roles usuario_roles_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_roles
    ADD CONSTRAINT usuario_roles_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.roles(id) ON DELETE RESTRICT;


--
-- Name: usuario_roles usuario_roles_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_roles
    ADD CONSTRAINT usuario_roles_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- Name: vinculos_parentales vinculos_parentales_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vinculos_parentales
    ADD CONSTRAINT vinculos_parentales_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- Name: vinculos_parentales vinculos_parentales_padre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vinculos_parentales
    ADD CONSTRAINT vinculos_parentales_padre_id_fkey FOREIGN KEY (padre_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 23VnYpKaeUeaclunVzRk6Pgm3c1DaI4HJX8OOLJuT06aNban7VfrlnW554HPcBC

