--
-- PostgreSQL database dump
--

-- Dumped from database version 10.9
-- Dumped by pg_dump version 11.2

-- Started on 2019-08-28 00:25:03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 295 (class 1255 OID 26025)
-- Name: sp_consorcio_cud(character, integer, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_consorcio_cud(in_action character, in_id_consorcio integer, in_nombre_consorcio character varying, in_participantes character varying, in_id_fideicomiso integer) RETURNS TABLE(exito integer, mensaje character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF (in_action = 'C') OR (in_action = 'U') THEN
			-- si el id es nulo guardar... de otra forma ... actualizarlo
			IF in_id_consorcio IS NULL THEN
				INSERT INTO consorcio ( nombre_consorcio, participantes, id_fideicomiso) VALUES
					(in_nombre_consorcio, in_participantes, in_id_fideicomiso);
			ELSE
				UPDATE consorcio SET
					nombre_consorcio = in_nombre_consorcio,
					participantes = in_participantes,
					id_fideicomiso = 	in_id_fideicomiso				
				WHERE id_consorcio = in_id_consorcio;
			END IF;
		END IF;
		-- ELimina el registro indicado por el ID
		IF (in_action = 'D') THEN
			UPDATE consorcio SET
					eliminado = 1
			WHERE id_consorcio = in_id_consorcio;
		END IF;
		exito := '1'; 
		mensaje := 'Proceso realizado con éxito!'; 
		return next; 
									  
		---------------- Control de expeciones ---------------------------								  
		-- Catch errores por cualquier excepción
		EXCEPTION
			WHEN not_null_violation THEN
				exito := '0'; 
				mensaje := 'Todos los campos son requeridos'; 		
				return next; 
				RETURN;			  
			WHEN foreign_key_violation THEN
			    exito := '0'; 
				mensaje := 'EL registro no puede ser borrado, existen dependencias para este registro.'; 		
				return next; 
				RETURN;	
			WHEN string_data_right_truncation THEN
				exito := '0'; 
				mensaje := 'Se ha superado el maximo de caracteres permitidos.'; 		
				return next; 
				RETURN;
			WHEN unique_violation THEN
				exito := '0'; 
				mensaje := 'La elemento % ya existe en la base de datos.', upper(trim(concepto));		
				return next; 
				RETURN;
		---------------- Control de expeciones ---------------------------	
	END;
	
$$;


ALTER FUNCTION public.sp_consorcio_cud(in_action character, in_id_consorcio integer, in_nombre_consorcio character varying, in_participantes character varying, in_id_fideicomiso integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 266 (class 1259 OID 25975)
-- Name: consorcio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consorcio (
    id_consorcio integer NOT NULL,
    nombre_consorcio character varying,
    participantes character varying,
    id_fideicomiso integer,
    eliminado smallint
);


ALTER TABLE public.consorcio OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 26026)
-- Name: sp_consorcio_get(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_consorcio_get(in_id_consorcio integer DEFAULT NULL::integer) RETURNS SETOF public.consorcio
    LANGUAGE plpgsql
    AS $$
	DECLARE reg RECORD; 
	BEGIN
		IF (in_fideicomiso IS NOT NULL) THEN
	 		FOR REG IN SELECT * FROM consorcio WHERE id_consorcio = in_id_consorcio AND (eliminado IS NULL OR eliminado <> 1) loop 
				RETURN NEXT reg;
			END LOOP;
		ELSE
			FOR REG IN SELECT * FROM consorcio WHERE eliminado IS NULL OR eliminado <> 1 loop 
				RETURN NEXT reg;
			END LOOP;
		END IF;
		RETURN;
	END; 
$$;


ALTER FUNCTION public.sp_consorcio_get(in_id_consorcio integer) OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 26027)
-- Name: sp_consorcios_propietarios_cud(character, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_consorcios_propietarios_cud(in_action character, in_id_consorcios_propietarios integer, in_id_propietario integer, in_id_consorcio integer) RETURNS TABLE(exito integer, mensaje character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF (in_action = 'C') OR (in_action = 'U') THEN
			-- si el id es nulo guardar... de otra forma ... actualizarlo
			IF in_id_consorcios_propietarios IS NULL THEN
				INSERT INTO consorcios_propietarios ( id_propietario, id_consorcio) VALUES
					(in_id_propietario, in_id_consorcio);
			ELSE
				UPDATE consorcios_propietarios SET
					id_propietario = in_id_propietario,
					id_consorcio = in_id_consorcio			
				WHERE id_consorcios_propietarios = in_id_consorcios_propietarios;
			END IF;
		END IF;
		-- ELimina el registro indicado por el ID
		IF (in_action = 'D') THEN
			UPDATE consorcios_propietarios SET
					eliminado = 1
			WHERE id_consorcio = in_id_consorcio;
		END IF;
		exito := '1'; 
		mensaje := 'Proceso realizado con éxito!'; 
		return next; 
									  
		---------------- Control de expeciones ---------------------------								  
		-- Catch errores por cualquier excepción
		EXCEPTION
			WHEN not_null_violation THEN
				exito := '0'; 
				mensaje := 'Todos los campos son requeridos'; 		
				return next; 
				RETURN;			  
			WHEN foreign_key_violation THEN
			    exito := '0'; 
				mensaje := 'EL registro no puede ser borrado, existen dependencias para este registro.'; 		
				return next; 
				RETURN;	
			WHEN string_data_right_truncation THEN
				exito := '0'; 
				mensaje := 'Se ha superado el maximo de caracteres permitidos.'; 		
				return next; 
				RETURN;
			WHEN unique_violation THEN
				exito := '0'; 
				mensaje := 'La elemento % ya existe en la base de datos.', upper(trim(concepto));		
				return next; 
				RETURN;
		---------------- Control de expeciones ---------------------------	
	END;
	
$$;


ALTER FUNCTION public.sp_consorcios_propietarios_cud(in_action character, in_id_consorcios_propietarios integer, in_id_propietario integer, in_id_consorcio integer) OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 26028)
-- Name: sp_consorcios_propietarios_get(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_consorcios_propietarios_get(in_id_consorcio integer DEFAULT NULL::integer) RETURNS SETOF public.consorcio
    LANGUAGE plpgsql
    AS $$
	DECLARE reg RECORD; 
	BEGIN
		IF (in_id_consorcio IS NOT NULL) THEN
	 		FOR REG IN SELECT * FROM consorcios_propietarios WHERE id_consorcio = in_id_consorcio AND (eliminado IS NULL OR eliminado <> 1) loop 
				RETURN NEXT reg;
			END LOOP;
		ELSE
			FOR REG IN SELECT * FROM consorcios_propietarios WHERE eliminado IS NULL OR eliminado <> 1 loop 
				RETURN NEXT reg;
			END LOOP;
		END IF;
		RETURN;
	END; 
$$;


ALTER FUNCTION public.sp_consorcios_propietarios_get(in_id_consorcio integer) OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 26029)
-- Name: sp_descuento_transbordo_cud(character, integer, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_descuento_transbordo_cud(in_action character, in_id_descuento integer, in_transbordo_1 double precision, in_transbordo_2 double precision) RETURNS TABLE(exito integer, mensaje character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF (in_action = 'C') OR (in_action = 'U') THEN
			-- si el id es nulo guardar... de otra forma ... actualizarlo
			IF in_id_descuento IS NULL THEN
				INSERT INTO descuento_transbordo ( transbordo_1, transbordo_2) VALUES
					(in_transbordo_1, in_transbordo_2);
			ELSE
				UPDATE descuento_transbordo SET
					transbordo_1 = in_transbordo_1,
					transbordo_2 = in_transbordo_2 
				WHERE id_descuento = in_id_descuento;
			END IF;
		END IF;
		-- ELimina el registro indicado por el ID
		IF (in_action = 'D') THEN
			UPDATE descuento_transbordo SET
					eliminado = 1
			WHERE id_descuento = in_id_descuento;
		END IF;
		exito := '1'; 
		mensaje := 'Proceso realizado con éxito!'; 
		return next; 
									  
		---------------- Control de expeciones ---------------------------								  
		-- Catch errores por cualquier excepción
		EXCEPTION
			WHEN not_null_violation THEN
				exito := '0'; 
				mensaje := 'Todos los campos son requeridos'; 		
				return next; 
				RETURN;			  
			WHEN foreign_key_violation THEN
			    exito := '0'; 
				mensaje := 'EL registro no puede ser borrado, existen dependencias para este registro.'; 		
				return next; 
				RETURN;	
			WHEN string_data_right_truncation THEN
				exito := '0'; 
				mensaje := 'Se ha superado el maximo de caracteres permitidos.'; 		
				return next; 
				RETURN;
			WHEN unique_violation THEN
				exito := '0'; 
				mensaje := 'La elemento % ya existe en la base de datos.', upper(trim(concepto));		
				return next; 
				RETURN;
		---------------- Control de expeciones ---------------------------	
	END;
	
$$;


ALTER FUNCTION public.sp_descuento_transbordo_cud(in_action character, in_id_descuento integer, in_transbordo_1 double precision, in_transbordo_2 double precision) OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 25877)
-- Name: descuento_transbordo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.descuento_transbordo (
    id_descuento integer NOT NULL,
    transbordo_1 double precision,
    transbordo_2 double precision,
    eliminado smallint
);


ALTER TABLE public.descuento_transbordo OWNER TO postgres;

--
-- TOC entry 300 (class 1255 OID 26030)
-- Name: sp_descuento_transbordo_get(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_descuento_transbordo_get(in_id_descuento integer DEFAULT NULL::integer) RETURNS SETOF public.descuento_transbordo
    LANGUAGE plpgsql
    AS $$
	DECLARE reg RECORD; 
	BEGIN
		IF (in_id_descuento IS NOT NULL) THEN
	 		FOR REG IN SELECT * FROM descuento_transbordo WHERE id_descuento = in_id_descuento AND (eliminado IS NULL OR eliminado <> 1) loop 
				RETURN NEXT reg;
			END LOOP;
		ELSE
			FOR REG IN SELECT * FROM descuento_transbordo WHERE eliminado IS NULL OR eliminado <> 1 loop 
				RETURN NEXT reg;
			END LOOP;
		END IF;
		RETURN;
	END; 
$$;


ALTER FUNCTION public.sp_descuento_transbordo_get(in_id_descuento integer) OWNER TO postgres;

--
-- TOC entry 301 (class 1255 OID 26031)
-- Name: sp_fideicomiso_cud(character, integer, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_fideicomiso_cud(in_action character, in_id_fideicomiso integer, in_folio character varying, in_nombre_fideicomiso character varying, in_estado_republica character varying, in_cuenta_fideicomiso character varying, in_estado character varying) RETURNS TABLE(exito integer, mensaje character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF (in_action = 'C') OR (in_action = 'U') THEN
			-- si el id es nulo guardar... de otra forma ... actualizarlo
			IF in_id_fideicomiso IS NULL THEN
				INSERT INTO fideicomiso ( folio, nombre_fideicomiso, estado_republica, cuenta_fideicomiso, estado) VALUES
					(in_folio, in_nombre_fideicomiso, in_estado_republica, in_cuenta_fideicomiso, in_estado);
			ELSE
				UPDATE fideicomiso SET
					folio = in_folio,
					nombre_fideicomiso = in_nombre_fideicomiso,
					estado_republica = in_estado_republica ,
					cuenta_fideicomiso = in_cuenta_fideicomiso,
					estado = in_estado
				WHERE id_fideicomiso = in_id_fideicomiso;
			END IF;
		END IF;
		-- ELimina el registro indicado por el ID
		IF (in_action = 'D') THEN
			UPDATE fideicomiso SET
					eliminado = 1
			WHERE id_fideicomiso = in_id_fideicomiso;
		END IF;
		exito := '1'; 
		mensaje := 'Proceso realizado con éxito!'; 
		return next; 
									  
		---------------- Control de expeciones ---------------------------								  
		-- Catch errores por cualquier excepción
		EXCEPTION
			WHEN not_null_violation THEN
				exito := '0'; 
				mensaje := 'Todos los campos son requeridos'; 		
				return next; 
				RETURN;			  
			WHEN foreign_key_violation THEN
			    exito := '0'; 
				mensaje := 'EL registro no puede ser borrado, existen dependencias para este registro.'; 		
				return next; 
				RETURN;	
			WHEN string_data_right_truncation THEN
				exito := '0'; 
				mensaje := 'Se ha superado el maximo de caracteres permitidos.'; 		
				return next; 
				RETURN;
			WHEN unique_violation THEN
				exito := '0'; 
				mensaje := 'La elemento % ya existe en la base de datos.', upper(trim(concepto));		
				return next; 
				RETURN;
		---------------- Control de expeciones ---------------------------	
	END;
	
$$;


ALTER FUNCTION public.sp_fideicomiso_cud(in_action character, in_id_fideicomiso integer, in_folio character varying, in_nombre_fideicomiso character varying, in_estado_republica character varying, in_cuenta_fideicomiso character varying, in_estado character varying) OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 25885)
-- Name: fideicomiso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fideicomiso (
    id_fideicomiso integer NOT NULL,
    folio character varying,
    nombre_fideicomiso character varying,
    estado_republica character varying,
    cuenta_fideicomiso character varying,
    estado character varying,
    eliminado smallint
);


ALTER TABLE public.fideicomiso OWNER TO postgres;

--
-- TOC entry 302 (class 1255 OID 26032)
-- Name: sp_fideicomisos_get(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_fideicomisos_get(in_fideicomiso integer DEFAULT NULL::integer) RETURNS SETOF public.fideicomiso
    LANGUAGE plpgsql
    AS $$
	DECLARE reg RECORD; 
	BEGIN
		IF (in_fideicomiso IS NOT NULL) THEN
	 		FOR REG IN SELECT * FROM fideicomiso WHERE id_fideicomiso = in_fideicomiso AND (eliminado IS NULL OR eliminado <> 1) loop 
				RETURN NEXT reg;
			END LOOP;
		ELSE
			FOR REG IN SELECT * FROM fideicomiso WHERE eliminado IS NULL OR eliminado <> 1 loop 
				RETURN NEXT reg;
			END LOOP;
		END IF;
		RETURN;
	END; 
$$;


ALTER FUNCTION public.sp_fideicomisos_get(in_fideicomiso integer) OWNER TO postgres;

--
-- TOC entry 303 (class 1255 OID 26033)
-- Name: sp_operadores_cud(character, integer, character varying, character varying, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_operadores_cud(in_action character, in_id_operador integer, in_nombre character varying, in_licencia character varying, in_estado integer, in_primer_apellido character varying, in_segundo_apellido character varying, in_fotografia_path character varying) RETURNS TABLE(exito integer, mensaje character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF (in_action = 'C') OR (in_action = 'U') THEN
			-- si el id es nulo guardar... de otra forma ... actualizarlo
			IF in_id_operador IS NULL THEN
				INSERT INTO operadores ( nombre, primer_apellido, segundo_apellido, licencia, estado, fotografia_path) VALUES
					(in_nombre, in_primer_apellido, in_segundo_apellido, in_licencia, in_estado, in_fotografia_path);
			ELSE
				UPDATE operadores SET
					nombre = in_nombre,
					primer_apellido = in_primer_apellido,
					segundo_apellido = in_segundo_apellido ,
					licencia = in_licencia,
					estado = in_estado,
					fotografia_path = in_fotografia_path
				WHERE id_operador = in_id_operador;
			END IF;
		END IF;
		-- ELimina el registro indicado por el ID
		IF (in_action = 'D') THEN
			UPDATE operadores SET
					eliminado = 1
			WHERE id_operador = in_id_operador;
		END IF;
		exito := '1'; 
		mensaje := 'Proceso realizado con éxito!'; 
		return next; 
									  
		---------------- Control de expeciones ---------------------------								  
		-- Catch errores por cualquier excepción
		EXCEPTION
			WHEN not_null_violation THEN
				exito := '0'; 
				mensaje := 'Todos los campos son requeridos'; 		
				return next; 
				RETURN;			  
			WHEN foreign_key_violation THEN
			    exito := '0'; 
				mensaje := 'EL registro no puede ser borrado, existen dependencias para este registro.'; 		
				return next; 
				RETURN;	
			WHEN string_data_right_truncation THEN
				exito := '0'; 
				mensaje := 'Se ha superado el maximo de caracteres permitidos.'; 		
				return next; 
				RETURN;
			WHEN unique_violation THEN
				exito := '0'; 
				mensaje := 'La elemento % ya existe en la base de datos.', upper(trim(concepto));		
				return next; 
				RETURN;
		---------------- Control de expeciones ---------------------------	
	END;
	
$$;


ALTER FUNCTION public.sp_operadores_cud(in_action character, in_id_operador integer, in_nombre character varying, in_licencia character varying, in_estado integer, in_primer_apellido character varying, in_segundo_apellido character varying, in_fotografia_path character varying) OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 25896)
-- Name: operadores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.operadores (
    id_operador integer NOT NULL,
    nombre character varying,
    licencia character varying,
    estado integer,
    primer_apellido character varying,
    segundo_apellido character varying,
    fotografia_path character varying,
    eliminado smallint
);


ALTER TABLE public.operadores OWNER TO postgres;

--
-- TOC entry 304 (class 1255 OID 26034)
-- Name: sp_operadores_get(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_operadores_get(in_id_operador integer DEFAULT NULL::integer) RETURNS SETOF public.operadores
    LANGUAGE plpgsql
    AS $$
	DECLARE reg RECORD; 
	BEGIN
		IF (in_id_operador IS NOT NULL) THEN
	 		FOR REG IN SELECT * FROM operadores WHERE id_operador=in_id_operador AND (eliminado IS NULL OR eliminado <> 1) loop 
				RETURN NEXT reg;
			END LOOP;
		ELSE
			FOR REG IN SELECT * FROM operadores WHERE eliminado IS NULL OR eliminado <> 1 loop 
				RETURN NEXT reg;
			END LOOP;
		END IF;
		RETURN;
	END; 
$$;


ALTER FUNCTION public.sp_operadores_get(in_id_operador integer) OWNER TO postgres;

--
-- TOC entry 305 (class 1255 OID 26035)
-- Name: sp_propietario_unidad_cud(character, integer, character varying, character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_propietario_unidad_cud(in_action character, in_id_propietario integer, in_nombre character varying, in_primer_apellido character varying, in_segundo_apellido character varying, in_e_mail character varying, in_telefono character varying, in_estado integer) RETURNS TABLE(exito integer, mensaje character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF (in_action = 'C') OR (in_action = 'U') THEN
			-- si el id es nulo guardar... de otra forma ... actualizarlo
			IF in_id_propietario IS NULL THEN
				INSERT INTO propietario_unidad ( nombre, primer_apellido, segundo_apellido, e_mail, telefono, estado) VALUES
					(in_nombre, in_primer_apellido, in_segundo_apellido, in_e_mail, in_telefono, in_estado);
			ELSE
				UPDATE propietario_unidad SET					
					nombre = in_nombre,
					primer_apellido = in_primer_apellido,
					segundo_apellido = in_segundo_apellido ,
					e_mail = in_e_mail,
					telefono = in_telefono,
					estado = in_estado
					
				WHERE id_propietario = in_id_propietario;
			END IF;
		END IF;
		-- ELimina el registro indicado por el ID
		IF (in_action = 'D') THEN
			UPDATE propietario_unidad SET					
					eliminado = 1
			WHERE id_propietario = in_id_propietario;
		END IF;
		exito := '1'; 
		mensaje := 'Proceso realizado con éxito!'; 
		return next; 
									  
		---------------- Control de expeciones ---------------------------								  
		-- Catch errores por cualquier excepción
		EXCEPTION
			WHEN not_null_violation THEN
				exito := '0'; 
				mensaje := 'Todos los campos son requeridos'; 		
				return next; 
				RETURN;			  
			WHEN foreign_key_violation THEN
			    exito := '0'; 
				mensaje := 'EL registro no puede ser borrado, existen dependencias para este registro.'; 		
				return next; 
				RETURN;	
			WHEN string_data_right_truncation THEN
				exito := '0'; 
				mensaje := 'Se ha superado el maximo de caracteres permitidos.'; 		
				return next; 
				RETURN;
			WHEN unique_violation THEN
				exito := '0'; 
				mensaje := 'La elemento % ya existe en la base de datos.', upper(trim(concepto));		
				return next; 
				RETURN;
		---------------- Control de expeciones ---------------------------	
	END;
	
$$;


ALTER FUNCTION public.sp_propietario_unidad_cud(in_action character, in_id_propietario integer, in_nombre character varying, in_primer_apellido character varying, in_segundo_apellido character varying, in_e_mail character varying, in_telefono character varying, in_estado integer) OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 25907)
-- Name: propietario_unidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.propietario_unidad (
    id_propietario integer NOT NULL,
    nombre character varying,
    primer_apellido character varying,
    segundo_apellido character varying,
    e_mail character varying,
    telefono character varying,
    estado integer,
    eliminado smallint
);


ALTER TABLE public.propietario_unidad OWNER TO postgres;

--
-- TOC entry 306 (class 1255 OID 26036)
-- Name: sp_propietario_unidad_get(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_propietario_unidad_get(in_id_propietario integer DEFAULT NULL::integer) RETURNS SETOF public.propietario_unidad
    LANGUAGE plpgsql
    AS $$
	DECLARE reg RECORD; 
	BEGIN
		IF (in_id_propietario IS NOT NULL) THEN
	 		FOR REG IN SELECT * FROM propietario_unidad WHERE id_propietario = in_id_propietario AND (eliminado IS NULL OR eliminado <> 1) loop 
				RETURN NEXT reg;
			END LOOP;
		ELSE
			FOR REG IN SELECT * FROM propietario_unidad WHERE eliminado IS NULL OR eliminado <> 1 loop 
				RETURN NEXT reg;
			END LOOP;
		END IF;
		RETURN;
	END; 
$$;


ALTER FUNCTION public.sp_propietario_unidad_get(in_id_propietario integer) OWNER TO postgres;

--
-- TOC entry 307 (class 1255 OID 26037)
-- Name: sp_ramales_cud(character, integer, character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_ramales_cud(in_action character, in_id_ramal integer, in_nombre_ramal character varying, in_numero integer, in_kmz_geo character varying) RETURNS TABLE(exito integer, mensaje character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF (in_action = 'C') OR (in_action = 'U') THEN
			-- si el id es nulo guardar... de otra forma ... actualizarlo
			IF in_id_ramal IS NULL THEN
				INSERT INTO ramales ( nombre_ramal, numero, kmz_geo) VALUES
					(in_nombre_ramal, in_numero, in_kmz_geo);
			ELSE
				UPDATE ramales SET
					nombre_ramal = in_nombre_ramal , 
					numero = in_numero , 
					kmz_geo = in_kmz_geo 
								
				WHERE id_ramal = in_id_ramal;
			END IF;
		END IF;
		-- ELimina el registro indicado por el ID
		IF (in_action = 'D') THEN
			UPDATE ramales SET
					eliminado = 1
			WHERE id_ramal = in_id_ramal;
		END IF;
		exito := '1'; 
		mensaje := 'Proceso realizado con éxito!'; 
		return next; 
									  
		---------------- Control de expeciones ---------------------------								  
		-- Catch errores por cualquier excepción
		EXCEPTION
			WHEN not_null_violation THEN
				exito := '0'; 
				mensaje := 'Todos los campos son requeridos'; 		
				return next; 
				RETURN;			  
			WHEN foreign_key_violation THEN
			    exito := '0'; 
				mensaje := 'EL registro no puede ser borrado, existen dependencias para este registro.'; 		
				return next; 
				RETURN;	
			WHEN string_data_right_truncation THEN
				exito := '0'; 
				mensaje := 'Se ha superado el maximo de caracteres permitidos.'; 		
				return next; 
				RETURN;
			WHEN unique_violation THEN
				exito := '0'; 
				mensaje := 'La elemento % ya existe en la base de datos.', upper(trim(concepto));		
				return next; 
				RETURN;
		---------------- Control de expeciones ---------------------------	
	END;
	
$$;


ALTER FUNCTION public.sp_ramales_cud(in_action character, in_id_ramal integer, in_nombre_ramal character varying, in_numero integer, in_kmz_geo character varying) OWNER TO postgres;

--
-- TOC entry 308 (class 1255 OID 26038)
-- Name: sp_rutas_cud(character, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_rutas_cud(in_action character, in_id_ruta integer, in_nombre_ruta_ruta character varying, in_numero_ruta character varying, in_kmz_geo character varying) RETURNS TABLE(exito integer, mensaje character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF (in_action = 'C') OR (in_action = 'U') THEN
			-- si el id es nulo guardar... de otra forma ... actualizarlo
			IF in_id_ruta IS NULL THEN
				INSERT INTO rutas ( nombre_ruta, numero_ruta, kmz_geo) VALUES
					(in_nombre_ruta, in_numero_ruta, in_kmz_geo);
			ELSE
				UPDATE rutas SET					
					nombre_ruta = in_nombre_ruta,
					numero_ruta = in_numero_ruta,
					kmz_geo = in_kmz_geo
				WHERE id_ruta = id_ruta;
			END IF;
		END IF;
		-- ELimina el registro indicado por el ID
		IF (in_action = 'D') THEN
			UPDATE rutas SET					
					eliminado = 1
			WHERE id_ruta = id_ruta;
		END IF;
		exito := '1'; 
		mensaje := 'Proceso realizado con éxito!'; 
		return next; 
									  
		---------------- Control de expeciones ---------------------------								  
		-- Catch errores por cualquier excepción
		EXCEPTION
			WHEN not_null_violation THEN
				exito := '0'; 
				mensaje := 'Todos los campos son requeridos'; 		
				return next; 
				RETURN;			  
			WHEN foreign_key_violation THEN
			    exito := '0'; 
				mensaje := 'EL registro no puede ser borrado, existen dependencias para este registro.'; 		
				return next; 
				RETURN;	
			WHEN string_data_right_truncation THEN
				exito := '0'; 
				mensaje := 'Se ha superado el maximo de caracteres permitidos.'; 		
				return next; 
				RETURN;
			WHEN unique_violation THEN
				exito := '0'; 
				mensaje := 'La elemento % ya existe en la base de datos.', upper(trim(concepto));		
				return next; 
				RETURN;
		---------------- Control de expeciones ---------------------------	
	END;
	
$$;


ALTER FUNCTION public.sp_rutas_cud(in_action character, in_id_ruta integer, in_nombre_ruta_ruta character varying, in_numero_ruta character varying, in_kmz_geo character varying) OWNER TO postgres;

--
-- TOC entry 309 (class 1255 OID 26039)
-- Name: sp_tarifas_cud(character, integer, character varying, integer, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_tarifas_cud(in_action character, in_idtarifa integer, in_concepto character varying, in_aireac integer, in_tarifaac double precision, in_tarifabase double precision, in_tarifatotal double precision) RETURNS TABLE(exito integer, mensaje character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF (in_action = 'C') OR (in_action = 'U') THEN
			-- si el id es nulo guardar... de otra forma ... actualizarlo
			IF in_idtarifa IS NULL THEN
				INSERT INTO tarifas (concepto, aire_acondicionado, tarifa_ac, tarifa_base, tarifa_total) VALUES
					(in_concepto, in_aireac, in_tarifaac, in_tarifabase, in_tarifatotal);
			ELSE
				UPDATE tarifas SET
					concepto = upper(trim(in_concepto)),
					aire_acondicionado = in_aireac,
					tarifa_ac = in_tarifaac,
					tarifa_base =  in_tarifabase,
					tarifa_total = in_tarifatotal
				WHERE id_tarifa = in_idtarifa;
			END IF;
		END IF;
		-- ELimina el registro indicado por el ID
		IF (in_action = 'D') THEN
				UPDATE tarifas SET
					eliminado = 1
				WHERE id_tarifa = in_idtarifa;
		END IF;
		exito := '1'; 
		mensaje := 'Proceso realizado con éxito!'; 
		return next; 
									  
		---------------- Control de expeciones ---------------------------								  
		-- Catch errores por cualquier excepción
		EXCEPTION
			WHEN not_null_violation THEN
				exito := '0'; 
				mensaje := 'Todos los campos son requeridos'; 		
				return next; 
				RETURN;			  
			WHEN foreign_key_violation THEN
			    exito := '0'; 
				mensaje := 'EL registro no puede ser borrado, existen dependencias para este registro.'; 		
				return next; 
				RETURN;	
			WHEN string_data_right_truncation THEN
				exito := '0'; 
				mensaje := 'Se ha superado el maximo de caracteres permitidos.'; 		
				return next; 
				RETURN;
			WHEN unique_violation THEN
				exito := '0'; 
				mensaje := 'La elemento % ya existe en la base de datos.', upper(trim(concepto));		
				return next; 
				RETURN;
		---------------- Control de expeciones ---------------------------	
	END;
	
$$;


ALTER FUNCTION public.sp_tarifas_cud(in_action character, in_idtarifa integer, in_concepto character varying, in_aireac integer, in_tarifaac double precision, in_tarifabase double precision, in_tarifatotal double precision) OWNER TO postgres;

--
-- TOC entry 310 (class 1255 OID 26040)
-- Name: sp_tarifas_get(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_tarifas_get(in_id_tarifa integer DEFAULT NULL::integer) RETURNS SETOF public.operadores
    LANGUAGE plpgsql
    AS $$
	DECLARE reg RECORD; 
	BEGIN
		IF (in_id_tarifa IS NOT NULL) THEN
	 		FOR REG IN SELECT * FROM tarifas WHERE id_tarifa = in_id_tarifa AND (eliminado IS NULL OR eliminado <> 1) loop 
				RETURN NEXT reg;
			END LOOP;
		ELSE
			FOR REG IN SELECT * FROM tarifas WHERE eliminado IS NULL OR eliminado <> 1 loop 
				RETURN NEXT reg;
			END LOOP;
		END IF;
		RETURN;
	END; 
$$;


ALTER FUNCTION public.sp_tarifas_get(in_id_tarifa integer) OWNER TO postgres;

--
-- TOC entry 311 (class 1255 OID 26041)
-- Name: sp_unidades_cud(character, integer, character varying, character varying, double precision, integer, character varying, character varying, character varying, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_unidades_cud(in_action character, in_id_unidad integer, in_modelo character varying, in_placas character varying, in_kilometraje double precision, in_capacidad integer, in_serie character varying, in_niv character varying, in_descripcion character varying, in_id_propietario integer, in_estado integer, in_id_tarifa integer, in_id_ruta integer, in_id_ramal integer) RETURNS TABLE(exito integer, mensaje character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF (in_action = 'C') OR (in_action = 'U') THEN
			-- si el id es nulo guardar... de otra forma ... actualizarlo
			IF in_id_unidad IS NULL THEN
				INSERT INTO unidades ( modelo, placas, kilometraje, capacidad, serie, niv, descripcion, id_propietario, estado, id_ruta, id_ramal, id_tarifa) VALUES
					(in_modelo, in_placas, in_kilometraje, in_capacidad, in_serie, in_niv, in_descripcion, in_id_propietario, in_estado, in_id_ruta, in_id_ramal, in_id_tarifa);
			ELSE
				UPDATE unidades SET
					modelo = in_modelo,
					placas = in_placas,
					kilometraje = in_kilometraje ,
					capacidad = in_capacidad,
					serie = in_serie,
					niv = in_niv,
					descripcion = in_descripcion,
					id_propietario = in_id_propietario,
					estado = in_estado,
					id_ruta = in_id_ruta,
					id_ramal = in_id_ramal,
					id_tarifa = in_id_tarifa
				WHERE id_unidad = in_id_unidad;
			END IF;
		END IF;
		-- ELimina el registro indicado por el ID
		IF (in_action = 'D') THEN
				UPDATE unidades SET
					eliminado = 1
				WHERE id_unidad = in_id_unidad;
		END IF;
		exito := '1'; 
		mensaje := 'Proceso realizado con éxito!'; 
		return next; 
									  
		---------------- Control de expeciones ---------------------------								  
		-- Catch errores por cualquier excepción
		EXCEPTION
			WHEN not_null_violation THEN
				exito := '0'; 
				mensaje := 'Todos los campos son requeridos'; 		
				return next; 
				RETURN;			  
			WHEN foreign_key_violation THEN
			    exito := '0'; 
				mensaje := 'EL registro no puede ser borrado, existen dependencias para este registro.'; 		
				return next; 
				RETURN;	
			WHEN string_data_right_truncation THEN
				exito := '0'; 
				mensaje := 'Se ha superado el maximo de caracteres permitidos.'; 		
				return next; 
				RETURN;
			WHEN unique_violation THEN
				exito := '0'; 
				mensaje := 'La elemento % ya existe en la base de datos.', upper(trim(concepto));		
				return next; 
				RETURN;
		---------------- Control de expeciones ---------------------------	
	END;
	
$$;


ALTER FUNCTION public.sp_unidades_cud(in_action character, in_id_unidad integer, in_modelo character varying, in_placas character varying, in_kilometraje double precision, in_capacidad integer, in_serie character varying, in_niv character varying, in_descripcion character varying, in_id_propietario integer, in_estado integer, in_id_tarifa integer, in_id_ruta integer, in_id_ramal integer) OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 25940)
-- Name: unidades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidades (
    id_unidad integer NOT NULL,
    modelo character varying,
    placas character varying,
    kilometraje double precision,
    capacidad integer,
    serie character varying,
    niv character varying,
    descripcion character varying,
    id_propietario integer,
    estado integer,
    id_tarifa integer,
    eliminado smallint,
    id_ruta integer,
    id_ramal integer
);


ALTER TABLE public.unidades OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 26042)
-- Name: sp_unidades_get(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_unidades_get(in_id_unidad integer DEFAULT NULL::integer) RETURNS SETOF public.unidades
    LANGUAGE plpgsql
    AS $$
	DECLARE reg RECORD; 
	BEGIN
		IF (in_id_unidad IS NOT NULL) THEN
	 		FOR REG IN SELECT * FROM unidades WHERE id_unidad=in_id_unidad AND (eliminado IS NULL OR eliminado <> 1) loop 
				RETURN NEXT reg;
			END LOOP;
		ELSE
			FOR REG IN SELECT * FROM unidades WHERE eliminado IS NULL OR eliminado <> 1 loop 
				RETURN NEXT reg;
			END LOOP;
		END IF;
		RETURN;
	END; 
$$;


ALTER FUNCTION public.sp_unidades_get(in_id_unidad integer) OWNER TO postgres;

--
-- TOC entry 312 (class 1255 OID 26043)
-- Name: sp_usuarios_cud(character, integer, integer, character varying, character varying, character varying, character varying, character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_usuarios_cud(in_action character, in_id_usuario integer, in_id_cuenta integer, in_nombre character varying, in_primer_apellido character varying, in_segundo_apellido character varying, in_telefono character varying, in_email character varying, in_id_tipo_usuario integer, in_fotografia_path character varying) RETURNS TABLE(exito integer, mensaje character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF (in_action = 'C') OR (in_action = 'U') THEN
			-- si el id es nulo guardar... de otra forma ... actualizarlo
			IF in_id_usuario IS NULL THEN
				INSERT INTO usuarios ( id_cuenta, nombre, primer_apellido, segundo_apellido, telefono, email, id_tipo_usuario, fotografia_path) VALUES
					(in_id_cuenta, in_nombre, in_primer_apellido, in_segundo_apellido, in_telefono, in_email, in_id_tipo_usuario, in_fotografia_path);
			ELSE
				UPDATE usuarios SET
					id_cuenta = in_id_cuenta , 
					nombre = in_nombre , 
					primer_apellido = in_primer_apellido , 
					segundo_apellido =  in_segundo_apellido, 
					telefono =  in_telefono, 
					email = in_email , 
					id_tipo_usuario = in_id_tipo_usuario , 
					fotografia_path = in_fotografia_path				
				WHERE id_usuario = in_id_usuario;
			END IF;
		END IF;
		-- ELimina el registro indicado por el ID
		IF (in_action = 'D') THEN
			UPDATE usuarios SET
					eliminado = 1
			WHERE id_usuario = in_id_usuario;
		END IF;
		exito := '1'; 
		mensaje := 'Proceso realizado con éxito!'; 
		return next; 
									  
		---------------- Control de expeciones ---------------------------								  
		-- Catch errores por cualquier excepción
		EXCEPTION
			WHEN not_null_violation THEN
				exito := '0'; 
				mensaje := 'Todos los campos son requeridos'; 		
				return next; 
				RETURN;			  
			WHEN foreign_key_violation THEN
			    exito := '0'; 
				mensaje := 'EL registro no puede ser borrado, existen dependencias para este registro.'; 		
				return next; 
				RETURN;	
			WHEN string_data_right_truncation THEN
				exito := '0'; 
				mensaje := 'Se ha superado el maximo de caracteres permitidos.'; 		
				return next; 
				RETURN;
			WHEN unique_violation THEN
				exito := '0'; 
				mensaje := 'La elemento % ya existe en la base de datos.', upper(trim(concepto));		
				return next; 
				RETURN;
		---------------- Control de expeciones ---------------------------	
	END;
	
$$;


ALTER FUNCTION public.sp_usuarios_cud(in_action character, in_id_usuario integer, in_id_cuenta integer, in_nombre character varying, in_primer_apellido character varying, in_segundo_apellido character varying, in_telefono character varying, in_email character varying, in_id_tipo_usuario integer, in_fotografia_path character varying) OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 25951)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id_usuario integer NOT NULL,
    id_cuenta integer,
    nombre character varying,
    primer_apellido character varying,
    segundo_apellido character varying,
    telefono character varying,
    email character varying,
    id_tipo_usuario integer,
    fotografia_path character varying,
    eliminado smallint
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 313 (class 1255 OID 26044)
-- Name: sp_usuarios_get(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_usuarios_get(in_id_usuario integer DEFAULT NULL::integer) RETURNS SETOF public.usuarios
    LANGUAGE plpgsql
    AS $$
	DECLARE reg RECORD; 
	BEGIN
		IF (in_id_usuario IS NOT NULL) THEN
	 		FOR REG IN SELECT * FROM usuarios WHERE in_id_usuario = in_id_ramal AND (eliminado IS NULL OR eliminado <> 1) loop 
				RETURN NEXT reg;
			END LOOP;
		ELSE
			FOR REG IN SELECT * FROM usuarios WHERE eliminado IS NULL OR eliminado <> 1 loop 
				RETURN NEXT reg;
			END LOOP;
		END IF;
		RETURN;
	END; 
$$;


ALTER FUNCTION public.sp_usuarios_get(in_id_usuario integer) OWNER TO postgres;

--
-- TOC entry 319 (class 1255 OID 35103)
-- Name: ws_asociar_operador_unidad(character varying, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ws_asociar_operador_unidad(in_niv character varying DEFAULT NULL::character varying, in_id_operador integer DEFAULT NULL::integer, in_usuario character varying DEFAULT NULL::character varying, in_password character varying DEFAULT NULL::character varying) RETURNS TABLE(msg character varying, pass character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    acceso character varying := '';
    unidad_activa INTEGER := 0;
    id_selected_unidad INTEGER := 0;
	operador_valido INTEGER :=0;

BEGIN
     SELECT contrasena
        INTO acceso
        FROM acceso
    WHERE niv_unidad = in_niv AND usuario = in_usuario ;
	
    IF not found THEN

        RETURN QUERY
        Select '005, “Usuario y/o contraseña inválidos”'::CHARACTER VARYING, 'Contraseña incorrecta'::character varying;  
    ELSE
        SELECT id_unidad 
            INTO id_selected_unidad
            FROM unidades
            WHERE niv = in_niv;

        SELECT COUNT(id_unidad_operador) 
            INTO unidad_activa
            FROM unidades_operadores
            WHERE id_operador = in_id_operador AND id_unidad = id_selected_unidad 
                AND eliminado = 0;
        
        IF unidad_activa < 1 THEN
			select id_operador into operador_valido from operadores
			where id_operador =in_id_operador;
			
			IF NOT FOUND THEN 
				RETURN QUERY
				SELECT '“El operador no existe”'::CHARACTER VARYING, acceso::character varying;
			ELSE
				 INSERT INTO 
                unidades_operadores
                VALUES (id_selected_unidad,in_niv,in_id_operador,NOW(),0);
			RETURN QUERY
            SELECT '006, “Operador asociado a unidad satisfactoriamente”'::CHARACTER VARYING, acceso::character varying;
			END IF;
			
           
        ELSE
			RETURN QUERY
            SELECT '007, “La asociación del operador a la unidad ha fallado”'::CHARACTER VARYING, acceso::character varying;
        END IF;

    END IF;
END;
$$;


ALTER FUNCTION public.ws_asociar_operador_unidad(in_niv character varying, in_id_operador integer, in_usuario character varying, in_password character varying) OWNER TO postgres;

--
-- TOC entry 321 (class 1255 OID 35129)
-- Name: ws_consultar_administradores(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ws_consultar_administradores(in_niv character varying, in_usuario character varying, in_password character varying) RETURNS TABLE(msg character varying, numero_tarjeta character varying, nip character varying, nombre_administrador character varying, pass character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    acceso character varying := '';
    ident_unidad integer := 0;
    consulta integer := 0;
    
BEGIN
	SELECT contrasena
        INTO acceso
        FROM acceso
    WHERE niv_unidad = in_niv AND usuario = in_usuario ;
        
    IF not found THEN

        RETURN QUERY
        Select '005, “Usuario y/o contraseña inválidos”'::CHARACTER VARYING,
            null::CHARACTER VARYING,
            null::INTEGER,
            null::CHARACTER VARYING,
			acceso::CHARACTER VARYING;   
    ELSE
        SELECT COUNT(id_administrador)
            INTO consulta
            FROM administrador_unidad 
            WHERE eliminado = 0;
        
        IF not found THEN
            RETURN QUERY
            SELECT '002, “No se encontró ningún resultado”'::CHARACTER VARYING,
                null::INTEGER,
                null::INTEGER,
                null::CHARACTER VARYING,
				acceso::CHARACTER VARYING;
        ELSE
            RETURN QUERY
            SELECT '001, "“Operación Exitosa"'::CHARACTER VARYING,
                au.numero_cuenta::character varying, 
                au.nip::character varying,
				au.nombre_administrador :: character varying,
				acceso:: CHARACTER VARYING
            FROM unidades u
            INNER JOIN det_administrador_unidad det on u.id_unidad = det.id_unidad
			INNER JOIN administrador_unidad au on det.id_administrador = au.id_administrador
            WHERE u.niv = in_niv;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.ws_consultar_administradores(in_niv character varying, in_usuario character varying, in_password character varying) OWNER TO postgres;

--
-- TOC entry 315 (class 1255 OID 35107)
-- Name: ws_consultar_catalogo_servicios(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ws_consultar_catalogo_servicios(in_niv character varying DEFAULT NULL::character varying, in_usuario character varying DEFAULT NULL::character varying, in_password character varying DEFAULT NULL::character varying) RETURNS TABLE(msg character varying, id_servicio integer, nombre_servicio character varying, pass character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    acceso character varying := '';
    consulta integer := 0;
    
BEGIN
     SELECT contrasena
        INTO acceso
        FROM acceso
    WHERE niv_unidad = in_niv AND usuario = in_usuario ;
        
    IF not found THEN

        RETURN QUERY
        Select '005, “Usuario y/o contraseña inválidos”'::CHARACTER VARYING,
            null::INTEGER,
            null::CHARACTER VARYING, acceso::character varying; 
    ELSE
            SELECT COUNT(cat_servicios.id_servicio)
            INTO consulta
            FROM cat_servicios WHERE eliminado = 0;
            
            IF consulta = 0 THEN
                RETURN QUERY
                SELECT '002, “No se encontró ningún resultado”'::CHARACTER VARYING,
                    null::INTEGER,
                    null::CHARACTER VARYING,
					acceso::character varying;
            ELSE
                RETURN QUERY
                SELECT '001, “Operación Exitosa”'::CHARACTER VARYING,
                    cat_servicios.id_servicio::INTEGER,
                    cat_servicios.nombre_servicio::CHARACTER VARYING,
					acceso::character varying
                FROM cat_servicios 
                WHERE eliminado <> 1 ;
            END IF;
        END IF;

END;
$$;


ALTER FUNCTION public.ws_consultar_catalogo_servicios(in_niv character varying, in_usuario character varying, in_password character varying) OWNER TO postgres;

--
-- TOC entry 314 (class 1255 OID 26074)
-- Name: ws_consultar_datos_operador(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ws_consultar_datos_operador(in_id_operador integer DEFAULT NULL::integer) RETURNS TABLE(msg character varying, nombre_operador character varying, licencia character varying, fotografia character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    consulta integer := 0;
    
    BEGIN
        SELECT COUNT(id_operador)
            INTO consulta
            FROM operadores o
            WHERE o.eliminado <> 1 and o.id_operador = in_id_operador;
        
        IF consulta = 0 THEN
            RETURN QUERY
            SELECT '002, “No se encontró ningún resultado con la información proporcionada.”'::CHARACTER VARYING,
            null::CHARACTER VARYING,
            null::CHARACTER VARYING,
            null::CHARACTER VARYING;
        ELSE
            RETURN QUERY
            SELECT '001, “Operación Exitosa”'::CHARACTER VARYING,
                CONCAT (o.nombre,' ',o.primer_apellido,' ',o.segundo_apellido)::CHARACTER VARYING,
                o.licencia::CHARACTER VARYING,
                o.fotografia_path::CHARACTER VARYING
            FROM operadores o
            WHERE o.eliminado <> 1  AND o.id_operador = in_id_operador;
        END IF; 
    END;
$$;


ALTER FUNCTION public.ws_consultar_datos_operador(in_id_operador integer) OWNER TO postgres;

--
-- TOC entry 318 (class 1255 OID 35105)
-- Name: ws_consultar_operador_turno(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ws_consultar_operador_turno(in_niv character varying, in_usuario character varying, in_password character varying) RETURNS TABLE(msg character varying, id_operador integer, nombre_operador character varying, pass character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    acceso character varying := 0;
    ident_unidad integer := 0;
    consulta integer := 0;
    
BEGIN
     SELECT contrasena
        INTO acceso
        FROM acceso
    WHERE niv_unidad = in_niv AND usuario = in_usuario ;
        
    IF not found THEN

        RETURN QUERY
        Select '005, “Usuario y/o contraseña inválidos”'::CHARACTER VARYING,
            null::INTEGER,
            null::CHARACTER VARYING,
			acceso::CHARACTER VARYING;   
    ELSE
        SELECT COUNT (r.id_recarga)
            INTO consulta
            FROM recarga r
            INNER JOIN unidades u ON r.id_unidad = u.id_unidad
            WHERE r.eliminado = 0 AND u.niv = '1';
        
        IF consulta = 0 THEN
            RETURN QUERY
            SELECT '002, “No se encontró ningún resultado”'::CHARACTER VARYING,
                null::INTEGER,
                null::CHARACTER VARYING,
				acceso::CHARACTER VARYING;
        ELSE
            RETURN QUERY
            SELECT '001, "“Operación Exitosa"'::CHARACTER VARYING,
                o.id_operador::INTEGER, 
                CONCAT(o.nombre,' ',o.primer_apellido,' ',o.segundo_apellido)::CHARACTER VARYING,
				acceso::CHARACTER VARYING
            FROM recarga r
            INNER JOIN unidades u ON r.id_unidad = u.id_unidad
            INNER JOIN operadores o ON r.id_operador = o.id_operador
            WHERE u.niv = in_niv;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.ws_consultar_operador_turno(in_niv character varying, in_usuario character varying, in_password character varying) OWNER TO postgres;

--
-- TOC entry 317 (class 1255 OID 35102)
-- Name: ws_consultar_operadores(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ws_consultar_operadores(in_niv character varying DEFAULT NULL::character varying, in_usuario character varying DEFAULT NULL::character varying, in_password character varying DEFAULT NULL::character varying) RETURNS TABLE(msg character varying, id_operador integer, nombre character varying, pass character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    acceso character varying := '';
    consulta integer := 0;
    
BEGIN
    SELECT contrasena
        INTO acceso
        FROM acceso
    WHERE niv_unidad = in_niv AND usuario = in_usuario ;
	
    IF not found THEN

        RETURN QUERY
        Select '005, “Usuario y/o contraseña inválidos”'::CHARACTER VARYING,
            null::INTEGER,
            null::CHARACTER VARYING, acceso::character varying; 
    ELSE
            SELECT COUNT(operadores.id_operador)
            INTO consulta
            FROM operadores WHERE eliminado = 0;
            
            IF consulta = 0 THEN
                RETURN QUERY
                SELECT '002, “No se encontró ningún resultado”'::CHARACTER VARYING,
                    null::INTEGER,
                    null::CHARACTER VARYING, acceso::character varying;
            ELSE
                RETURN QUERY
                SELECT '001, “Operación Exitosa”'::CHARACTER VARYING,
                    o.id_operador::INTEGER,
                    CONCAT (o.nombre,' ',o.primer_apellido,' ',o.segundo_apellido)::CHARACTER VARYING,
					 acceso::character varying
                FROM operadores o
                WHERE o.eliminado <> 1 ;
            END IF;
        END IF;
END;
$$;


ALTER FUNCTION public.ws_consultar_operadores(in_niv character varying, in_usuario character varying, in_password character varying) OWNER TO postgres;

--
-- TOC entry 320 (class 1255 OID 35100)
-- Name: ws_consultar_tarifas(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ws_consultar_tarifas(in_niv character varying DEFAULT NULL::character varying, in_usuario character varying DEFAULT NULL::character varying, in_password character varying DEFAULT NULL::character varying) RETURNS TABLE(msg character varying, id_tarifa integer, concepto_tarifa character varying, aire_acondicionado character varying, tarifa_total double precision, primer_descuento double precision, segundo_descuento double precision, pass character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    acceso character varying := '';
    ident_unidad integer := 0;
    consulta integer := 0;
BEGIN
    SELECT contrasena
        INTO acceso
        FROM acceso
    WHERE niv_unidad = in_niv and usuario = in_usuario ;
	
    IF acceso=='' THEN

        RETURN QUERY
        SELECT '005, “Usuario y/o contraseña inválidos”'::CHARACTER VARYING,
            null::INTEGER,
            null::CHARACTER VARYING,
            null::CHARACTER VARYING,
            null::DOUBLE PRECISION,
            null::DOUBLE PRECISION,
            null::DOUBLE PRECISION;
    
    ELSE

        SELECT id_unidad
            INTO ident_unidad
            FROM unidades
            WHERE niv = in_niv AND eliminado = 0;
        
        IF not found THEN
            RETURN QUERY
            SELECT '003, “Unidad inactiva”'::CHARACTER VARYING,
                null::INTEGER,
                null::CHARACTER VARYING,
                null::CHARACTER VARYING,
                null::DOUBLE PRECISION,
                null::DOUBLE PRECISION,
                null::DOUBLE PRECISION;
        ELSE
            SELECT t.id_tarifa
                INTO consulta
                FROM unidades u
                INNER JOIN tarifas t ON u.id_tarifa = t.id_tarifa
                WHERE u.eliminado = 0;
            IF consulta = 0 THEN
                RETURN QUERY
                SELECT '002, “No se encontró ningún resultado”'::CHARACTER VARYING,
                    null::INTEGER,
                    null::CHARACTER VARYING,
                    null::CHARACTER VARYING,
                    null::DOUBLE PRECISION,
                    null::DOUBLE PRECISION,
                    null::DOUBLE PRECISION;
            ELSE
                RETURN QUERY
                SELECT distinct
                    '001, "“Operación Exitosa"'::CHARACTER VARYING,
                    t.id_tarifa::INTEGER,
                    t.concepto::CHARACTER VARYING,
                    t.aire_acondicionado::CHARACTER VARYING,
                    t.tarifa_total::DOUBLE PRECISION,
                    (SELECT transbordo_1
                        FROM descuento_transbordo
                        WHERE id_descuento = 1)::DOUBLE PRECISION,
                    (SELECT transbordo_2
                        FROM descuento_transbordo
                        WHERE id_descuento = 1)::DOUBLE PRECISION,
						acceso:: character varying
                    FROM unidades u
                    INNER JOIN tarifas t ON u.id_tarifa = t.id_tarifa
                    WHERE u.eliminado <> 1;
            END IF;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.ws_consultar_tarifas(in_niv character varying, in_usuario character varying, in_password character varying) OWNER TO postgres;

--
-- TOC entry 316 (class 1255 OID 35106)
-- Name: ws_registrar_pago(character varying, character varying, character varying, character varying, integer, integer, double precision, double precision, double precision, character varying, character varying, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ws_registrar_pago(in_niv_unidad character varying DEFAULT NULL::character varying, in_usuario character varying DEFAULT NULL::character varying, in_password character varying DEFAULT NULL::character varying, in_referencia_usuario character varying DEFAULT NULL::character varying, in_id_servicio integer DEFAULT NULL::integer, in_forma_pago integer DEFAULT NULL::integer, in_cantidad double precision DEFAULT NULL::double precision, in_importe double precision DEFAULT NULL::double precision, in_total double precision DEFAULT NULL::double precision, in_denominaciones_recibidas character varying DEFAULT NULL::character varying, in_denominaciones_entregadas character varying DEFAULT NULL::character varying, in_fecha_hora date DEFAULT NULL::date) RETURNS TABLE(msg character varying, id_operacion integer, pass character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    acceso character varying := '';
    unidad_activa integer := 0;
    id_operacion integer := 0;
    ultima_transaccion integer := 0;
    
BEGIN
       SELECT contrasena
        INTO acceso
        FROM acceso
    WHERE niv_unidad = in_niv_unidad AND usuario = in_usuario ;
        
    IF not found THEN
        RETURN QUERY
        Select '005, “Usuario y/o contraseña inválidos”'::CHARACTER VARYING,
            null::INTEGER;
    ELSE
        SELECT  id_unidad
            INTO unidad_activa
            FROM unidades 
            WHERE niv = in_niv_unidad AND eliminado = 0;

        IF unidad_activa = 0 THEN
            RETURN QUERY
            SELECT '003, “Unidad inactiva”'::CHARACTER VARYING,
                null::INTEGER, acceso::character varying;
        ELSE
            --EFECTIVO
            IF in_forma_pago = 0 THEN
				RETURN QUERY
                INSERT INTO transaccion_local (forma_pago, id_servicio,
                        cantidad,
                        importe,
                        total, 
                        fecha_hora,
                        eliminado,
                        denominacion_recibida,
                        denominacion_entregada)
                    VALUES(in_forma_pago,in_id_servicio,
                        in_cantidad,
                        in_importe,
                        in_total,
                        NOW(),
                        0,
                        in_denominaciones_recibidas,
                        in_denominaciones_entregadas)
						returning '001, “Operación exitosa”'::CHARACTER VARYING,
						id_transaccion_local, acceso::character varying;

               
            ELSE --TARJETA
            END IF;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.ws_registrar_pago(in_niv_unidad character varying, in_usuario character varying, in_password character varying, in_referencia_usuario character varying, in_id_servicio integer, in_forma_pago integer, in_cantidad double precision, in_importe double precision, in_total double precision, in_denominaciones_recibidas character varying, in_denominaciones_entregadas character varying, in_fecha_hora date) OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 26053)
-- Name: acceso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acceso (
    niv_unidad character varying,
    usuario character varying,
    contrasena character varying
);


ALTER TABLE public.acceso OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 25800)
-- Name: administrador_unidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.administrador_unidad (
    id_administrador integer NOT NULL,
    numero_cuenta character varying,
    unidades character varying,
    eliminado smallint,
    nombre_administrador character varying,
    nip character varying
);


ALTER TABLE public.administrador_unidad OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 25798)
-- Name: administrador_unidad_id_administrador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.administrador_unidad_id_administrador_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.administrador_unidad_id_administrador_seq OWNER TO postgres;

--
-- TOC entry 3213 (class 0 OID 0)
-- Dependencies: 235
-- Name: administrador_unidad_id_administrador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.administrador_unidad_id_administrador_seq OWNED BY public.administrador_unidad.id_administrador;


--
-- TOC entry 196 (class 1259 OID 25720)
-- Name: administrador_unidad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.administrador_unidad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.administrador_unidad_seq OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 25722)
-- Name: alcancia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alcancia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alcancia_seq OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 25964)
-- Name: alcancias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alcancias (
    id_alcancia integer NOT NULL,
    direccion_mac character varying,
    ultima_sincronizacion character varying,
    id_unidad integer,
    eliminado smallint
);


ALTER TABLE public.alcancias OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 25962)
-- Name: alcancias_id_alcancia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alcancias_id_alcancia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alcancias_id_alcancia_seq OWNER TO postgres;

--
-- TOC entry 3214 (class 0 OID 0)
-- Dependencies: 263
-- Name: alcancias_id_alcancia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alcancias_id_alcancia_seq OWNED BY public.alcancias.id_alcancia;


--
-- TOC entry 198 (class 1259 OID 25724)
-- Name: alertas_alcancia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alertas_alcancia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alertas_alcancia_seq OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 25726)
-- Name: asignacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asignacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asignacion_seq OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 25728)
-- Name: cajero_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cajero_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cajero_seq OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 25730)
-- Name: capas_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.capas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.capas_seq OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 25811)
-- Name: cat_cajero; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cat_cajero (
    id_cajero integer NOT NULL,
    nombre_cajero character varying,
    eliminado smallint
);


ALTER TABLE public.cat_cajero OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 25809)
-- Name: cat_cajero_id_cajero_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cat_cajero_id_cajero_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cat_cajero_id_cajero_seq OWNER TO postgres;

--
-- TOC entry 3215 (class 0 OID 0)
-- Dependencies: 237
-- Name: cat_cajero_id_cajero_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cat_cajero_id_cajero_seq OWNED BY public.cat_cajero.id_cajero;


--
-- TOC entry 240 (class 1259 OID 25822)
-- Name: cat_estado_actividad_asignacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cat_estado_actividad_asignacion (
    id_estado_actividad integer NOT NULL,
    desc_estado_actividad character varying,
    eliminado smallint
);


ALTER TABLE public.cat_estado_actividad_asignacion OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 25820)
-- Name: cat_estado_actividad_asignacion_id_estado_actividad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cat_estado_actividad_asignacion_id_estado_actividad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cat_estado_actividad_asignacion_id_estado_actividad_seq OWNER TO postgres;

--
-- TOC entry 3216 (class 0 OID 0)
-- Dependencies: 239
-- Name: cat_estado_actividad_asignacion_id_estado_actividad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cat_estado_actividad_asignacion_id_estado_actividad_seq OWNED BY public.cat_estado_actividad_asignacion.id_estado_actividad;


--
-- TOC entry 242 (class 1259 OID 25833)
-- Name: cat_servicios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cat_servicios (
    id_servicio integer NOT NULL,
    nombre_servicio character varying,
    eliminado smallint
);


ALTER TABLE public.cat_servicios OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 25831)
-- Name: cat_servicios_id_servicio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cat_servicios_id_servicio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cat_servicios_id_servicio_seq OWNER TO postgres;

--
-- TOC entry 3217 (class 0 OID 0)
-- Dependencies: 241
-- Name: cat_servicios_id_servicio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cat_servicios_id_servicio_seq OWNED BY public.cat_servicios.id_servicio;


--
-- TOC entry 244 (class 1259 OID 25844)
-- Name: cat_tipo_tarjeta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cat_tipo_tarjeta (
    id_tipo_tarjeta integer NOT NULL,
    desc_tipo_tarjeta character varying,
    eliminado smallint
);


ALTER TABLE public.cat_tipo_tarjeta OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 25842)
-- Name: cat_tipo_tarjeta_id_tipo_tarjeta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cat_tipo_tarjeta_id_tipo_tarjeta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cat_tipo_tarjeta_id_tipo_tarjeta_seq OWNER TO postgres;

--
-- TOC entry 3218 (class 0 OID 0)
-- Dependencies: 243
-- Name: cat_tipo_tarjeta_id_tipo_tarjeta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cat_tipo_tarjeta_id_tipo_tarjeta_seq OWNED BY public.cat_tipo_tarjeta.id_tipo_tarjeta;


--
-- TOC entry 246 (class 1259 OID 25855)
-- Name: cat_tipo_usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cat_tipo_usuario (
    id_tipo_usuario integer NOT NULL,
    desc_tipo_usuario character varying,
    eliminado smallint
);


ALTER TABLE public.cat_tipo_usuario OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 25853)
-- Name: cat_tipo_usuario_id_tipo_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cat_tipo_usuario_id_tipo_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cat_tipo_usuario_id_tipo_usuario_seq OWNER TO postgres;

--
-- TOC entry 3219 (class 0 OID 0)
-- Dependencies: 245
-- Name: cat_tipo_usuario_id_tipo_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cat_tipo_usuario_id_tipo_usuario_seq OWNED BY public.cat_tipo_usuario.id_tipo_usuario;


--
-- TOC entry 265 (class 1259 OID 25973)
-- Name: consorcio_id_consorcio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.consorcio_id_consorcio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.consorcio_id_consorcio_seq OWNER TO postgres;

--
-- TOC entry 3220 (class 0 OID 0)
-- Dependencies: 265
-- Name: consorcio_id_consorcio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.consorcio_id_consorcio_seq OWNED BY public.consorcio.id_consorcio;


--
-- TOC entry 202 (class 1259 OID 25732)
-- Name: consorcio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.consorcio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.consorcio_seq OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 25986)
-- Name: consorcios_propietarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consorcios_propietarios (
    id_consorcios_propietarios integer NOT NULL,
    id_propietario integer,
    id_consorcio integer,
    eliminado smallint
);


ALTER TABLE public.consorcios_propietarios OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 25984)
-- Name: consorcios_propietarios_id_consorcios_propietarios_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.consorcios_propietarios_id_consorcios_propietarios_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.consorcios_propietarios_id_consorcios_propietarios_seq OWNER TO postgres;

--
-- TOC entry 3221 (class 0 OID 0)
-- Dependencies: 267
-- Name: consorcios_propietarios_id_consorcios_propietarios_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.consorcios_propietarios_id_consorcios_propietarios_seq OWNED BY public.consorcios_propietarios.id_consorcios_propietarios;


--
-- TOC entry 203 (class 1259 OID 25734)
-- Name: consorcios_propietarios_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.consorcios_propietarios_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.consorcios_propietarios_seq OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 26080)
-- Name: consulta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consulta (
    count bigint
);


ALTER TABLE public.consulta OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 25994)
-- Name: corte_caja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.corte_caja (
    id_corte_caja integer NOT NULL,
    numero_corte_caja character varying,
    fecha_hora_inicio date,
    fecha_hora_corte date,
    monto_cobros_preferenciales integer,
    viajes_gratis_preferenciales integer,
    primeros_transbordos integer,
    no_tarjetas integer,
    monto_total double precision,
    preferentes character varying,
    cobros_ordinarios integer,
    monto_cobros_ordinarios double precision,
    viajes_gratis_ordinarios integer,
    primeros_transbordos_ordinarios integer,
    segundos_transbordos_ordinarios integer,
    no_tarjetas_ordinarias integer,
    monto_total_ordinario double precision,
    tipo_tarjeta_preferencial character varying,
    cantidad_tipo_tarjeta_preferencial integer,
    moneda_50c integer,
    moneda_1p integer,
    moneda_2p integer,
    moneda_5p integer,
    moneda_10p integer,
    billete_20p integer,
    billete_50p integer,
    billete_100p integer,
    billete_200p integer,
    billete_500p integer,
    cantidad_recargas integer,
    monto_recargas double precision,
    id_tarifa integer,
    id_ramal integer,
    id_ruta integer,
    id_unidad integer,
    eliminado smallint
);


ALTER TABLE public.corte_caja OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 25992)
-- Name: corte_caja_id_corte_caja_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.corte_caja_id_corte_caja_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.corte_caja_id_corte_caja_seq OWNER TO postgres;

--
-- TOC entry 3222 (class 0 OID 0)
-- Dependencies: 269
-- Name: corte_caja_id_corte_caja_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.corte_caja_id_corte_caja_seq OWNED BY public.corte_caja.id_corte_caja;


--
-- TOC entry 204 (class 1259 OID 25736)
-- Name: corte_caja_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.corte_caja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.corte_caja_seq OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 25738)
-- Name: cuenta_bancaria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuenta_bancaria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cuenta_bancaria_seq OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 25740)
-- Name: cuenta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuenta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cuenta_seq OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 26005)
-- Name: cuentas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuentas (
    id_cuenta integer NOT NULL,
    numero_cuenta character varying,
    saldo double precision,
    estado_cuenta integer,
    id_motivo_cuenta integer,
    eliminado smallint
);


ALTER TABLE public.cuentas OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 25866)
-- Name: cuentas_bancarias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuentas_bancarias (
    id_cuenta_bancaria integer NOT NULL,
    clabe character varying,
    propietario_cuenta character varying,
    nombre_cuenta character varying,
    banco character varying,
    sucursal character varying,
    eliminado smallint
);


ALTER TABLE public.cuentas_bancarias OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 25864)
-- Name: cuentas_bancarias_id_cuenta_bancaria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuentas_bancarias_id_cuenta_bancaria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cuentas_bancarias_id_cuenta_bancaria_seq OWNER TO postgres;

--
-- TOC entry 3223 (class 0 OID 0)
-- Dependencies: 247
-- Name: cuentas_bancarias_id_cuenta_bancaria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cuentas_bancarias_id_cuenta_bancaria_seq OWNED BY public.cuentas_bancarias.id_cuenta_bancaria;


--
-- TOC entry 271 (class 1259 OID 26003)
-- Name: cuentas_id_cuenta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuentas_id_cuenta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cuentas_id_cuenta_seq OWNER TO postgres;

--
-- TOC entry 3224 (class 0 OID 0)
-- Dependencies: 271
-- Name: cuentas_id_cuenta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cuentas_id_cuenta_seq OWNED BY public.cuentas.id_cuenta;


--
-- TOC entry 249 (class 1259 OID 25875)
-- Name: descuento_transbordo_id_descuento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.descuento_transbordo_id_descuento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.descuento_transbordo_id_descuento_seq OWNER TO postgres;

--
-- TOC entry 3225 (class 0 OID 0)
-- Dependencies: 249
-- Name: descuento_transbordo_id_descuento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.descuento_transbordo_id_descuento_seq OWNED BY public.descuento_transbordo.id_descuento;


--
-- TOC entry 207 (class 1259 OID 25742)
-- Name: descuento_transbordo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.descuento_transbordo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.descuento_transbordo_seq OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 26068)
-- Name: det_administrador_unidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.det_administrador_unidad (
    id_administrador integer,
    id_unidad integer,
    eliminado integer
);


ALTER TABLE public.det_administrador_unidad OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 25744)
-- Name: estado_actividad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estado_actividad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.estado_actividad_seq OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 25883)
-- Name: fideicomiso_id_fideicomiso_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fideicomiso_id_fideicomiso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fideicomiso_id_fideicomiso_seq OWNER TO postgres;

--
-- TOC entry 3226 (class 0 OID 0)
-- Dependencies: 251
-- Name: fideicomiso_id_fideicomiso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fideicomiso_id_fideicomiso_seq OWNED BY public.fideicomiso.id_fideicomiso;


--
-- TOC entry 209 (class 1259 OID 25746)
-- Name: fideicomiso_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fideicomiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fideicomiso_seq OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 25748)
-- Name: historial_tarjeta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historial_tarjeta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.historial_tarjeta_seq OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 25750)
-- Name: itinerarios_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.itinerarios_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.itinerarios_seq OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 25752)
-- Name: motiv_cuenta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.motiv_cuenta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.motiv_cuenta_seq OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 25754)
-- Name: motiv_tarjeta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.motiv_tarjeta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.motiv_tarjeta_seq OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 25756)
-- Name: operador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.operador_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.operador_seq OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 25894)
-- Name: operadores_id_operador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.operadores_id_operador_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.operadores_id_operador_seq OWNER TO postgres;

--
-- TOC entry 3227 (class 0 OID 0)
-- Dependencies: 253
-- Name: operadores_id_operador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.operadores_id_operador_seq OWNED BY public.operadores.id_operador;


--
-- TOC entry 215 (class 1259 OID 25758)
-- Name: paradas_obligatorias_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paradas_obligatorias_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.paradas_obligatorias_seq OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 25905)
-- Name: propietario_unidad_id_propietario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.propietario_unidad_id_propietario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.propietario_unidad_id_propietario_seq OWNER TO postgres;

--
-- TOC entry 3228 (class 0 OID 0)
-- Dependencies: 255
-- Name: propietario_unidad_id_propietario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.propietario_unidad_id_propietario_seq OWNED BY public.propietario_unidad.id_propietario;


--
-- TOC entry 216 (class 1259 OID 25760)
-- Name: propietario_unidad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.propietario_unidad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.propietario_unidad_seq OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25762)
-- Name: puntos_carga_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.puntos_carga_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.puntos_carga_seq OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 25764)
-- Name: puntos_control_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.puntos_control_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.puntos_control_seq OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25766)
-- Name: ramales_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ramales_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ramales_seq OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 26016)
-- Name: recarga; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recarga (
    id_recarga integer NOT NULL,
    folio character varying,
    id_unidad integer,
    id_operador integer,
    fecha_recarga date,
    id_usuario integer,
    id_cuenta integer,
    id_alcancia integer,
    eliminado smallint
);


ALTER TABLE public.recarga OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 26014)
-- Name: recarga_id_recarga_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recarga_id_recarga_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recarga_id_recarga_seq OWNER TO postgres;

--
-- TOC entry 3229 (class 0 OID 0)
-- Dependencies: 273
-- Name: recarga_id_recarga_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recarga_id_recarga_seq OWNED BY public.recarga.id_recarga;


--
-- TOC entry 220 (class 1259 OID 25768)
-- Name: recarga_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recarga_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recarga_seq OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 25770)
-- Name: rutas_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rutas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rutas_seq OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25772)
-- Name: servicio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.servicio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.servicio_seq OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 25774)
-- Name: talleres_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.talleres_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.talleres_seq OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25776)
-- Name: tarifa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tarifa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tarifa_seq OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 25918)
-- Name: tarifas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tarifas (
    id_tarifa integer NOT NULL,
    concepto character varying,
    aire_acondicionado integer,
    tarifa_ac double precision,
    tarifa_base double precision,
    tarifa_total double precision,
    eliminado smallint
);


ALTER TABLE public.tarifas OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 25916)
-- Name: tarifas_id_tarifa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tarifas_id_tarifa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tarifas_id_tarifa_seq OWNER TO postgres;

--
-- TOC entry 3230 (class 0 OID 0)
-- Dependencies: 257
-- Name: tarifas_id_tarifa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tarifas_id_tarifa_seq OWNED BY public.tarifas.id_tarifa;


--
-- TOC entry 225 (class 1259 OID 25778)
-- Name: tarjeta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tarjeta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tarjeta_seq OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 25780)
-- Name: terminal_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.terminal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.terminal_seq OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25782)
-- Name: tipo_tarjeta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_tarjeta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_tarjeta_seq OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 25784)
-- Name: tipo_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_usuario_seq OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25786)
-- Name: tramos_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tramos_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tramos_seq OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 26097)
-- Name: transaccion_local; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaccion_local (
    identificador_dispositivo character varying,
    numero_tarjeta character varying,
    forma_pago integer,
    id_servicio integer,
    concepto character varying,
    cantidad double precision,
    importe double precision,
    total double precision,
    fecha_hora date,
    id_tarjeta integer,
    eliminado smallint,
    denominacion_recibida character varying,
    denominacion_entregada character varying,
    id_transaccion_local integer NOT NULL
);


ALTER TABLE public.transaccion_local OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 26173)
-- Name: transaccion_local_id_transaccion_local_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaccion_local_id_transaccion_local_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaccion_local_id_transaccion_local_seq OWNER TO postgres;

--
-- TOC entry 3231 (class 0 OID 0)
-- Dependencies: 281
-- Name: transaccion_local_id_transaccion_local_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaccion_local_id_transaccion_local_seq OWNED BY public.transaccion_local.id_transaccion_local;


--
-- TOC entry 230 (class 1259 OID 25788)
-- Name: transaccion_local_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaccion_local_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaccion_local_seq OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 25790)
-- Name: transaccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaccion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaccion_seq OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 25792)
-- Name: unidad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unidad_seq OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 25938)
-- Name: unidades_id_unidad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidades_id_unidad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unidades_id_unidad_seq OWNER TO postgres;

--
-- TOC entry 3232 (class 0 OID 0)
-- Dependencies: 259
-- Name: unidades_id_unidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidades_id_unidad_seq OWNED BY public.unidades.id_unidad;


--
-- TOC entry 279 (class 1259 OID 26144)
-- Name: unidades_operadores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidades_operadores (
    id_unidad integer,
    niv character varying,
    id_operador integer,
    fecha_asignacion date,
    eliminado integer,
    id_unidad_operador integer NOT NULL
);


ALTER TABLE public.unidades_operadores OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 26151)
-- Name: unidades_operadores_id_unidad_operador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidades_operadores_id_unidad_operador_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unidades_operadores_id_unidad_operador_seq OWNER TO postgres;

--
-- TOC entry 3233 (class 0 OID 0)
-- Dependencies: 280
-- Name: unidades_operadores_id_unidad_operador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidades_operadores_id_unidad_operador_seq OWNED BY public.unidades_operadores.id_unidad_operador;


--
-- TOC entry 233 (class 1259 OID 25794)
-- Name: usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_seq OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 25949)
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuarios_id_usuario_seq OWNER TO postgres;

--
-- TOC entry 3234 (class 0 OID 0)
-- Dependencies: 261
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id_usuario;


--
-- TOC entry 234 (class 1259 OID 25796)
-- Name: vueltas_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vueltas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vueltas_seq OWNER TO postgres;

--
-- TOC entry 2935 (class 2604 OID 25803)
-- Name: administrador_unidad id_administrador; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrador_unidad ALTER COLUMN id_administrador SET DEFAULT nextval('public.administrador_unidad_id_administrador_seq'::regclass);


--
-- TOC entry 2949 (class 2604 OID 25967)
-- Name: alcancias id_alcancia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alcancias ALTER COLUMN id_alcancia SET DEFAULT nextval('public.alcancias_id_alcancia_seq'::regclass);


--
-- TOC entry 2936 (class 2604 OID 25814)
-- Name: cat_cajero id_cajero; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cat_cajero ALTER COLUMN id_cajero SET DEFAULT nextval('public.cat_cajero_id_cajero_seq'::regclass);


--
-- TOC entry 2937 (class 2604 OID 25825)
-- Name: cat_estado_actividad_asignacion id_estado_actividad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cat_estado_actividad_asignacion ALTER COLUMN id_estado_actividad SET DEFAULT nextval('public.cat_estado_actividad_asignacion_id_estado_actividad_seq'::regclass);


--
-- TOC entry 2938 (class 2604 OID 25836)
-- Name: cat_servicios id_servicio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cat_servicios ALTER COLUMN id_servicio SET DEFAULT nextval('public.cat_servicios_id_servicio_seq'::regclass);


--
-- TOC entry 2939 (class 2604 OID 25847)
-- Name: cat_tipo_tarjeta id_tipo_tarjeta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cat_tipo_tarjeta ALTER COLUMN id_tipo_tarjeta SET DEFAULT nextval('public.cat_tipo_tarjeta_id_tipo_tarjeta_seq'::regclass);


--
-- TOC entry 2940 (class 2604 OID 25858)
-- Name: cat_tipo_usuario id_tipo_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cat_tipo_usuario ALTER COLUMN id_tipo_usuario SET DEFAULT nextval('public.cat_tipo_usuario_id_tipo_usuario_seq'::regclass);


--
-- TOC entry 2950 (class 2604 OID 25978)
-- Name: consorcio id_consorcio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consorcio ALTER COLUMN id_consorcio SET DEFAULT nextval('public.consorcio_id_consorcio_seq'::regclass);


--
-- TOC entry 2951 (class 2604 OID 25989)
-- Name: consorcios_propietarios id_consorcios_propietarios; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consorcios_propietarios ALTER COLUMN id_consorcios_propietarios SET DEFAULT nextval('public.consorcios_propietarios_id_consorcios_propietarios_seq'::regclass);


--
-- TOC entry 2952 (class 2604 OID 25997)
-- Name: corte_caja id_corte_caja; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corte_caja ALTER COLUMN id_corte_caja SET DEFAULT nextval('public.corte_caja_id_corte_caja_seq'::regclass);


--
-- TOC entry 2953 (class 2604 OID 26008)
-- Name: cuentas id_cuenta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuentas ALTER COLUMN id_cuenta SET DEFAULT nextval('public.cuentas_id_cuenta_seq'::regclass);


--
-- TOC entry 2941 (class 2604 OID 25869)
-- Name: cuentas_bancarias id_cuenta_bancaria; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuentas_bancarias ALTER COLUMN id_cuenta_bancaria SET DEFAULT nextval('public.cuentas_bancarias_id_cuenta_bancaria_seq'::regclass);


--
-- TOC entry 2942 (class 2604 OID 25880)
-- Name: descuento_transbordo id_descuento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.descuento_transbordo ALTER COLUMN id_descuento SET DEFAULT nextval('public.descuento_transbordo_id_descuento_seq'::regclass);


--
-- TOC entry 2943 (class 2604 OID 25888)
-- Name: fideicomiso id_fideicomiso; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fideicomiso ALTER COLUMN id_fideicomiso SET DEFAULT nextval('public.fideicomiso_id_fideicomiso_seq'::regclass);


--
-- TOC entry 2944 (class 2604 OID 25899)
-- Name: operadores id_operador; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operadores ALTER COLUMN id_operador SET DEFAULT nextval('public.operadores_id_operador_seq'::regclass);


--
-- TOC entry 2945 (class 2604 OID 25910)
-- Name: propietario_unidad id_propietario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.propietario_unidad ALTER COLUMN id_propietario SET DEFAULT nextval('public.propietario_unidad_id_propietario_seq'::regclass);


--
-- TOC entry 2954 (class 2604 OID 26019)
-- Name: recarga id_recarga; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recarga ALTER COLUMN id_recarga SET DEFAULT nextval('public.recarga_id_recarga_seq'::regclass);


--
-- TOC entry 2946 (class 2604 OID 25921)
-- Name: tarifas id_tarifa; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarifas ALTER COLUMN id_tarifa SET DEFAULT nextval('public.tarifas_id_tarifa_seq'::regclass);


--
-- TOC entry 2955 (class 2604 OID 26175)
-- Name: transaccion_local id_transaccion_local; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaccion_local ALTER COLUMN id_transaccion_local SET DEFAULT nextval('public.transaccion_local_id_transaccion_local_seq'::regclass);


--
-- TOC entry 2947 (class 2604 OID 25943)
-- Name: unidades id_unidad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidades ALTER COLUMN id_unidad SET DEFAULT nextval('public.unidades_id_unidad_seq'::regclass);


--
-- TOC entry 2956 (class 2604 OID 26153)
-- Name: unidades_operadores id_unidad_operador; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidades_operadores ALTER COLUMN id_unidad_operador SET DEFAULT nextval('public.unidades_operadores_id_unidad_operador_seq'::regclass);


--
-- TOC entry 2948 (class 2604 OID 25954)
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);


--
-- TOC entry 3201 (class 0 OID 26053)
-- Dependencies: 275
-- Data for Name: acceso; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.acceso (niv_unidad, usuario, contrasena) VALUES ('1', 'usuario', 'zWjZ397C2XyQX+NuCS9lRZ0zGd5Jf0F7Wkg=');


--
-- TOC entry 3162 (class 0 OID 25800)
-- Dependencies: 236
-- Data for Name: administrador_unidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.administrador_unidad (id_administrador, numero_cuenta, unidades, eliminado, nombre_administrador, nip) VALUES (1, 'ThSb4HvIiAA3Yqf5WbWUgd9pf6JfM668P9f9t7tR4Kg=', '2', 0, 'WA8fuHqzmRayC/7JPSh1DmRXyhFNaQ==', 'VcO00psHF1i1gQx8lWlPvvZucBqm4A==');
INSERT INTO public.administrador_unidad (id_administrador, numero_cuenta, unidades, eliminado, nombre_administrador, nip) VALUES (2, 'Fm6UTlVCY3CrbjeC8MECV7U30PSBQkspZsYNlynQGVY=', '1', 0, 'x/fOfcykxRNlfWsSZkA741RRG9cUM2z/v1EDj+PvRg==', 'LvLRE7QaTDb18VOq6kE2dqR9tzlWLQ==');


--
-- TOC entry 3190 (class 0 OID 25964)
-- Dependencies: 264
-- Data for Name: alcancias; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3164 (class 0 OID 25811)
-- Dependencies: 238
-- Data for Name: cat_cajero; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_cajero (id_cajero, nombre_cajero, eliminado) VALUES (1, 'BenitoJuaresBBVA', 0);
INSERT INTO public.cat_cajero (id_cajero, nombre_cajero, eliminado) VALUES (2, 'PinoSuarez Banorte', 0);


--
-- TOC entry 3166 (class 0 OID 25822)
-- Dependencies: 240
-- Data for Name: cat_estado_actividad_asignacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_estado_actividad_asignacion (id_estado_actividad, desc_estado_actividad, eliminado) VALUES (1, 'Actividad 1', 0);
INSERT INTO public.cat_estado_actividad_asignacion (id_estado_actividad, desc_estado_actividad, eliminado) VALUES (2, 'Actividad 2', 1);
INSERT INTO public.cat_estado_actividad_asignacion (id_estado_actividad, desc_estado_actividad, eliminado) VALUES (3, 'Actividad 3', 0);


--
-- TOC entry 3168 (class 0 OID 25833)
-- Dependencies: 242
-- Data for Name: cat_servicios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_servicios (id_servicio, nombre_servicio, eliminado) VALUES (1, 'Servicio1', 0);
INSERT INTO public.cat_servicios (id_servicio, nombre_servicio, eliminado) VALUES (2, 'Servicio2', 0);


--
-- TOC entry 3170 (class 0 OID 25844)
-- Dependencies: 244
-- Data for Name: cat_tipo_tarjeta; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_tipo_tarjeta (id_tipo_tarjeta, desc_tipo_tarjeta, eliminado) VALUES (1, 'Tipo tarjeta1', 0);
INSERT INTO public.cat_tipo_tarjeta (id_tipo_tarjeta, desc_tipo_tarjeta, eliminado) VALUES (2, 'Tipo tarjeta2', 1);
INSERT INTO public.cat_tipo_tarjeta (id_tipo_tarjeta, desc_tipo_tarjeta, eliminado) VALUES (3, 'Tipo tarjeta3', 0);


--
-- TOC entry 3172 (class 0 OID 25855)
-- Dependencies: 246
-- Data for Name: cat_tipo_usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_tipo_usuario (id_tipo_usuario, desc_tipo_usuario, eliminado) VALUES (1, 'Usuario tipo 1', 0);
INSERT INTO public.cat_tipo_usuario (id_tipo_usuario, desc_tipo_usuario, eliminado) VALUES (2, 'Usuario tipo 2', 0);


--
-- TOC entry 3192 (class 0 OID 25975)
-- Dependencies: 266
-- Data for Name: consorcio; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3194 (class 0 OID 25986)
-- Dependencies: 268
-- Data for Name: consorcios_propietarios; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3203 (class 0 OID 26080)
-- Dependencies: 277
-- Data for Name: consulta; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.consulta (count) VALUES (0);


--
-- TOC entry 3196 (class 0 OID 25994)
-- Dependencies: 270
-- Data for Name: corte_caja; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3198 (class 0 OID 26005)
-- Dependencies: 272
-- Data for Name: cuentas; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3174 (class 0 OID 25866)
-- Dependencies: 248
-- Data for Name: cuentas_bancarias; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cuentas_bancarias (id_cuenta_bancaria, clabe, propietario_cuenta, nombre_cuenta, banco, sucursal, eliminado) VALUES (1, '169821403889490911767804978365', 'propietario1', 'razonsocial', 'BBVA', 'SucursalColima', 0);
INSERT INTO public.cuentas_bancarias (id_cuenta_bancaria, clabe, propietario_cuenta, nombre_cuenta, banco, sucursal, eliminado) VALUES (2, '264337110164691804752374262582', 'propietario2', 'razonsocial1', 'Banorte', 'SucursalManzanillo', 0);


--
-- TOC entry 3176 (class 0 OID 25877)
-- Dependencies: 250
-- Data for Name: descuento_transbordo; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.descuento_transbordo (id_descuento, transbordo_1, transbordo_2, eliminado) VALUES (1, 1.5, 3, 0);
INSERT INTO public.descuento_transbordo (id_descuento, transbordo_1, transbordo_2, eliminado) VALUES (2, 2, 3, 0);


--
-- TOC entry 3202 (class 0 OID 26068)
-- Dependencies: 276
-- Data for Name: det_administrador_unidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.det_administrador_unidad (id_administrador, id_unidad, eliminado) VALUES (1, 1, 0);


--
-- TOC entry 3178 (class 0 OID 25885)
-- Dependencies: 252
-- Data for Name: fideicomiso; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3180 (class 0 OID 25896)
-- Dependencies: 254
-- Data for Name: operadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.operadores (id_operador, nombre, licencia, estado, primer_apellido, segundo_apellido, fotografia_path, eliminado) VALUES (1, 'Operador 1', 'licencia1', 1, 'apellido 1', 'apellido 2', 'foto operador', 0);
INSERT INTO public.operadores (id_operador, nombre, licencia, estado, primer_apellido, segundo_apellido, fotografia_path, eliminado) VALUES (2, 'Operador 2', 'licencia2', 1, 'apellido 1', 'apellido 2', 'foto operador', 0);


--
-- TOC entry 3182 (class 0 OID 25907)
-- Dependencies: 256
-- Data for Name: propietario_unidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.propietario_unidad (id_propietario, nombre, primer_apellido, segundo_apellido, e_mail, telefono, estado, eliminado) VALUES (1, 'propietario de ', 'unidad', '1', 'duenodelcamion@gmail.com', '3356545543', 1, 0);


--
-- TOC entry 3200 (class 0 OID 26016)
-- Dependencies: 274
-- Data for Name: recarga; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.recarga (id_recarga, folio, id_unidad, id_operador, fecha_recarga, id_usuario, id_cuenta, id_alcancia, eliminado) VALUES (1, 'U8U8U8HQ2', 1, 1, '2019-07-27', 1, 1, 1, 0);


--
-- TOC entry 3184 (class 0 OID 25918)
-- Dependencies: 258
-- Data for Name: tarifas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tarifas (id_tarifa, concepto, aire_acondicionado, tarifa_ac, tarifa_base, tarifa_total, eliminado) VALUES (1, 'Concepto1', 1, 2, 6, 8, 0);
INSERT INTO public.tarifas (id_tarifa, concepto, aire_acondicionado, tarifa_ac, tarifa_base, tarifa_total, eliminado) VALUES (2, 'Concepto 2', 1, 2, 6, 8, 0);


--
-- TOC entry 3204 (class 0 OID 26097)
-- Dependencies: 278
-- Data for Name: transaccion_local; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-18', NULL, 0, 'b20_p=1', 'm2_p=1', 8);
INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-18', NULL, 0, 'b20_p=1', 'm2_p=1', 9);
INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-18', NULL, 0, 'b20_p=1', 'm2_p=1', 10);
INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-18', NULL, 0, 'b20_p=1', 'm2_p=1', 11);
INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-18', NULL, 0, 'b20_p=1', 'm2_p=1', 12);
INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-22', NULL, 0, 'b20_p=1', 'm2_p=1', 13);
INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-23', NULL, 0, 'b20_p=1', 'm2_p=1', 14);
INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-23', NULL, 0, 'b20_p=1', 'm2_p=1', 15);
INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-24', NULL, 0, 'b20_p=1', 'm2_p=1', 16);
INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-24', NULL, 0, 'b20_p=1', 'm2_p=1', 17);
INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-24', NULL, 0, 'b20_p=1', 'm2_p=1', 18);
INSERT INTO public.transaccion_local (identificador_dispositivo, numero_tarjeta, forma_pago, id_servicio, concepto, cantidad, importe, total, fecha_hora, id_tarjeta, eliminado, denominacion_recibida, denominacion_entregada, id_transaccion_local) VALUES (NULL, NULL, 0, 1, NULL, 15, 3, 18, '2019-08-26', NULL, 0, 'b20_p=1', 'm2_p=1', 19);


--
-- TOC entry 3186 (class 0 OID 25940)
-- Dependencies: 260
-- Data for Name: unidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.unidades (id_unidad, modelo, placas, kilometraje, capacidad, serie, niv, descripcion, id_propietario, estado, id_tarifa, eliminado, id_ruta, id_ramal) VALUES (1, 'Modelo 1999', 'JD93JEJS', 12000.200000000001, 50, '8JD83JD9JSHHD8Y87', '1', 'unidad 1', 1, 1, 1, 0, NULL, NULL);


--
-- TOC entry 3205 (class 0 OID 26144)
-- Dependencies: 279
-- Data for Name: unidades_operadores; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3188 (class 0 OID 25951)
-- Dependencies: 262
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuarios (id_usuario, id_cuenta, nombre, primer_apellido, segundo_apellido, telefono, email, id_tipo_usuario, fotografia_path, eliminado) VALUES (1, 1, 'David', 'Esquivel', 'Haro', '3121627534', 'david14eh@gmail.com', 1, 'foto', 0);


--
-- TOC entry 3235 (class 0 OID 0)
-- Dependencies: 235
-- Name: administrador_unidad_id_administrador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.administrador_unidad_id_administrador_seq', 1, false);


--
-- TOC entry 3236 (class 0 OID 0)
-- Dependencies: 196
-- Name: administrador_unidad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.administrador_unidad_seq', 1, false);


--
-- TOC entry 3237 (class 0 OID 0)
-- Dependencies: 197
-- Name: alcancia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alcancia_seq', 1, false);


--
-- TOC entry 3238 (class 0 OID 0)
-- Dependencies: 263
-- Name: alcancias_id_alcancia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alcancias_id_alcancia_seq', 1, false);


--
-- TOC entry 3239 (class 0 OID 0)
-- Dependencies: 198
-- Name: alertas_alcancia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alertas_alcancia_seq', 1, false);


--
-- TOC entry 3240 (class 0 OID 0)
-- Dependencies: 199
-- Name: asignacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asignacion_seq', 1, false);


--
-- TOC entry 3241 (class 0 OID 0)
-- Dependencies: 200
-- Name: cajero_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cajero_seq', 1, false);


--
-- TOC entry 3242 (class 0 OID 0)
-- Dependencies: 201
-- Name: capas_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.capas_seq', 1, false);


--
-- TOC entry 3243 (class 0 OID 0)
-- Dependencies: 237
-- Name: cat_cajero_id_cajero_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cat_cajero_id_cajero_seq', 1, false);


--
-- TOC entry 3244 (class 0 OID 0)
-- Dependencies: 239
-- Name: cat_estado_actividad_asignacion_id_estado_actividad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cat_estado_actividad_asignacion_id_estado_actividad_seq', 1, false);


--
-- TOC entry 3245 (class 0 OID 0)
-- Dependencies: 241
-- Name: cat_servicios_id_servicio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cat_servicios_id_servicio_seq', 1, false);


--
-- TOC entry 3246 (class 0 OID 0)
-- Dependencies: 243
-- Name: cat_tipo_tarjeta_id_tipo_tarjeta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cat_tipo_tarjeta_id_tipo_tarjeta_seq', 1, false);


--
-- TOC entry 3247 (class 0 OID 0)
-- Dependencies: 245
-- Name: cat_tipo_usuario_id_tipo_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cat_tipo_usuario_id_tipo_usuario_seq', 1, true);


--
-- TOC entry 3248 (class 0 OID 0)
-- Dependencies: 265
-- Name: consorcio_id_consorcio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consorcio_id_consorcio_seq', 1, false);


--
-- TOC entry 3249 (class 0 OID 0)
-- Dependencies: 202
-- Name: consorcio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consorcio_seq', 1, false);


--
-- TOC entry 3250 (class 0 OID 0)
-- Dependencies: 267
-- Name: consorcios_propietarios_id_consorcios_propietarios_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consorcios_propietarios_id_consorcios_propietarios_seq', 1, false);


--
-- TOC entry 3251 (class 0 OID 0)
-- Dependencies: 203
-- Name: consorcios_propietarios_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consorcios_propietarios_seq', 1, false);


--
-- TOC entry 3252 (class 0 OID 0)
-- Dependencies: 269
-- Name: corte_caja_id_corte_caja_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.corte_caja_id_corte_caja_seq', 1, false);


--
-- TOC entry 3253 (class 0 OID 0)
-- Dependencies: 204
-- Name: corte_caja_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.corte_caja_seq', 1, false);


--
-- TOC entry 3254 (class 0 OID 0)
-- Dependencies: 205
-- Name: cuenta_bancaria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuenta_bancaria_seq', 1, false);


--
-- TOC entry 3255 (class 0 OID 0)
-- Dependencies: 206
-- Name: cuenta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuenta_seq', 1, false);


--
-- TOC entry 3256 (class 0 OID 0)
-- Dependencies: 247
-- Name: cuentas_bancarias_id_cuenta_bancaria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuentas_bancarias_id_cuenta_bancaria_seq', 1, false);


--
-- TOC entry 3257 (class 0 OID 0)
-- Dependencies: 271
-- Name: cuentas_id_cuenta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuentas_id_cuenta_seq', 1, false);


--
-- TOC entry 3258 (class 0 OID 0)
-- Dependencies: 249
-- Name: descuento_transbordo_id_descuento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.descuento_transbordo_id_descuento_seq', 1, false);


--
-- TOC entry 3259 (class 0 OID 0)
-- Dependencies: 207
-- Name: descuento_transbordo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.descuento_transbordo_seq', 1, false);


--
-- TOC entry 3260 (class 0 OID 0)
-- Dependencies: 208
-- Name: estado_actividad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estado_actividad_seq', 1, false);


--
-- TOC entry 3261 (class 0 OID 0)
-- Dependencies: 251
-- Name: fideicomiso_id_fideicomiso_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fideicomiso_id_fideicomiso_seq', 1, false);


--
-- TOC entry 3262 (class 0 OID 0)
-- Dependencies: 209
-- Name: fideicomiso_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fideicomiso_seq', 1, false);


--
-- TOC entry 3263 (class 0 OID 0)
-- Dependencies: 210
-- Name: historial_tarjeta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historial_tarjeta_seq', 1, false);


--
-- TOC entry 3264 (class 0 OID 0)
-- Dependencies: 211
-- Name: itinerarios_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.itinerarios_seq', 1, false);


--
-- TOC entry 3265 (class 0 OID 0)
-- Dependencies: 212
-- Name: motiv_cuenta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.motiv_cuenta_seq', 1, false);


--
-- TOC entry 3266 (class 0 OID 0)
-- Dependencies: 213
-- Name: motiv_tarjeta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.motiv_tarjeta_seq', 1, false);


--
-- TOC entry 3267 (class 0 OID 0)
-- Dependencies: 214
-- Name: operador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.operador_seq', 1, false);


--
-- TOC entry 3268 (class 0 OID 0)
-- Dependencies: 253
-- Name: operadores_id_operador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.operadores_id_operador_seq', 1, false);


--
-- TOC entry 3269 (class 0 OID 0)
-- Dependencies: 215
-- Name: paradas_obligatorias_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paradas_obligatorias_seq', 1, false);


--
-- TOC entry 3270 (class 0 OID 0)
-- Dependencies: 255
-- Name: propietario_unidad_id_propietario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.propietario_unidad_id_propietario_seq', 1, false);


--
-- TOC entry 3271 (class 0 OID 0)
-- Dependencies: 216
-- Name: propietario_unidad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.propietario_unidad_seq', 1, false);


--
-- TOC entry 3272 (class 0 OID 0)
-- Dependencies: 217
-- Name: puntos_carga_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.puntos_carga_seq', 1, false);


--
-- TOC entry 3273 (class 0 OID 0)
-- Dependencies: 218
-- Name: puntos_control_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.puntos_control_seq', 1, false);


--
-- TOC entry 3274 (class 0 OID 0)
-- Dependencies: 219
-- Name: ramales_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ramales_seq', 1, false);


--
-- TOC entry 3275 (class 0 OID 0)
-- Dependencies: 273
-- Name: recarga_id_recarga_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recarga_id_recarga_seq', 1, false);


--
-- TOC entry 3276 (class 0 OID 0)
-- Dependencies: 220
-- Name: recarga_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recarga_seq', 1, false);


--
-- TOC entry 3277 (class 0 OID 0)
-- Dependencies: 221
-- Name: rutas_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rutas_seq', 1, false);


--
-- TOC entry 3278 (class 0 OID 0)
-- Dependencies: 222
-- Name: servicio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.servicio_seq', 1, false);


--
-- TOC entry 3279 (class 0 OID 0)
-- Dependencies: 223
-- Name: talleres_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.talleres_seq', 1, false);


--
-- TOC entry 3280 (class 0 OID 0)
-- Dependencies: 224
-- Name: tarifa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tarifa_seq', 1, false);


--
-- TOC entry 3281 (class 0 OID 0)
-- Dependencies: 257
-- Name: tarifas_id_tarifa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tarifas_id_tarifa_seq', 1, false);


--
-- TOC entry 3282 (class 0 OID 0)
-- Dependencies: 225
-- Name: tarjeta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tarjeta_seq', 1, false);


--
-- TOC entry 3283 (class 0 OID 0)
-- Dependencies: 226
-- Name: terminal_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.terminal_seq', 1, false);


--
-- TOC entry 3284 (class 0 OID 0)
-- Dependencies: 227
-- Name: tipo_tarjeta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_tarjeta_seq', 1, false);


--
-- TOC entry 3285 (class 0 OID 0)
-- Dependencies: 228
-- Name: tipo_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_usuario_seq', 1, false);


--
-- TOC entry 3286 (class 0 OID 0)
-- Dependencies: 229
-- Name: tramos_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tramos_seq', 1, false);


--
-- TOC entry 3287 (class 0 OID 0)
-- Dependencies: 281
-- Name: transaccion_local_id_transaccion_local_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaccion_local_id_transaccion_local_seq', 19, true);


--
-- TOC entry 3288 (class 0 OID 0)
-- Dependencies: 230
-- Name: transaccion_local_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaccion_local_seq', 1, false);


--
-- TOC entry 3289 (class 0 OID 0)
-- Dependencies: 231
-- Name: transaccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaccion_seq', 1, false);


--
-- TOC entry 3290 (class 0 OID 0)
-- Dependencies: 232
-- Name: unidad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidad_seq', 1, false);


--
-- TOC entry 3291 (class 0 OID 0)
-- Dependencies: 259
-- Name: unidades_id_unidad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidades_id_unidad_seq', 1, false);


--
-- TOC entry 3292 (class 0 OID 0)
-- Dependencies: 280
-- Name: unidades_operadores_id_unidad_operador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidades_operadores_id_unidad_operador_seq', 7, true);


--
-- TOC entry 3293 (class 0 OID 0)
-- Dependencies: 233
-- Name: usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_seq', 1, false);


--
-- TOC entry 3294 (class 0 OID 0)
-- Dependencies: 261
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 1, false);


--
-- TOC entry 3295 (class 0 OID 0)
-- Dependencies: 234
-- Name: vueltas_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vueltas_seq', 1, false);


--
-- TOC entry 2958 (class 2606 OID 25808)
-- Name: administrador_unidad administrador_unidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrador_unidad
    ADD CONSTRAINT administrador_unidad_pkey PRIMARY KEY (id_administrador);


--
-- TOC entry 2988 (class 2606 OID 25972)
-- Name: alcancias alcancia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alcancias
    ADD CONSTRAINT alcancia_pkey PRIMARY KEY (id_alcancia);


--
-- TOC entry 2960 (class 2606 OID 25819)
-- Name: cat_cajero cat_cajero_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cat_cajero
    ADD CONSTRAINT cat_cajero_pkey PRIMARY KEY (id_cajero);


--
-- TOC entry 2962 (class 2606 OID 25830)
-- Name: cat_estado_actividad_asignacion cat_estado_actividad_asignacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cat_estado_actividad_asignacion
    ADD CONSTRAINT cat_estado_actividad_asignacion_pkey PRIMARY KEY (id_estado_actividad);


--
-- TOC entry 2964 (class 2606 OID 25841)
-- Name: cat_servicios cat_servicios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cat_servicios
    ADD CONSTRAINT cat_servicios_pkey PRIMARY KEY (id_servicio);


--
-- TOC entry 2966 (class 2606 OID 25852)
-- Name: cat_tipo_tarjeta cat_tipo_tarjeta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cat_tipo_tarjeta
    ADD CONSTRAINT cat_tipo_tarjeta_pkey PRIMARY KEY (id_tipo_tarjeta);


--
-- TOC entry 2968 (class 2606 OID 25863)
-- Name: cat_tipo_usuario cat_tipo_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cat_tipo_usuario
    ADD CONSTRAINT cat_tipo_usuario_pkey PRIMARY KEY (id_tipo_usuario);


--
-- TOC entry 2990 (class 2606 OID 25983)
-- Name: consorcio consorcio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consorcio
    ADD CONSTRAINT consorcio_pkey PRIMARY KEY (id_consorcio);


--
-- TOC entry 2994 (class 2606 OID 26002)
-- Name: corte_caja corte_caja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corte_caja
    ADD CONSTRAINT corte_caja_pkey PRIMARY KEY (id_corte_caja);


--
-- TOC entry 2970 (class 2606 OID 25874)
-- Name: cuentas_bancarias cuentas_bancarias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuentas_bancarias
    ADD CONSTRAINT cuentas_bancarias_pkey PRIMARY KEY (id_cuenta_bancaria);


--
-- TOC entry 2996 (class 2606 OID 26013)
-- Name: cuentas cuentas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuentas
    ADD CONSTRAINT cuentas_pkey PRIMARY KEY (id_cuenta);


--
-- TOC entry 2972 (class 2606 OID 25882)
-- Name: descuento_transbordo descuento_transbordo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.descuento_transbordo
    ADD CONSTRAINT descuento_transbordo_pkey PRIMARY KEY (id_descuento);


--
-- TOC entry 2974 (class 2606 OID 25893)
-- Name: fideicomiso fideicomiso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fideicomiso
    ADD CONSTRAINT fideicomiso_pkey PRIMARY KEY (id_fideicomiso);


--
-- TOC entry 2992 (class 2606 OID 25991)
-- Name: consorcios_propietarios idx_consorcios_propietarios_id_consorcios_propietarios; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consorcios_propietarios
    ADD CONSTRAINT idx_consorcios_propietarios_id_consorcios_propietarios PRIMARY KEY (id_consorcios_propietarios);


--
-- TOC entry 2976 (class 2606 OID 25904)
-- Name: operadores operadores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operadores
    ADD CONSTRAINT operadores_pkey PRIMARY KEY (id_operador);


--
-- TOC entry 2978 (class 2606 OID 25915)
-- Name: propietario_unidad propietario_unidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.propietario_unidad
    ADD CONSTRAINT propietario_unidad_pkey PRIMARY KEY (id_propietario);


--
-- TOC entry 2998 (class 2606 OID 26024)
-- Name: recarga recarga_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recarga
    ADD CONSTRAINT recarga_pkey PRIMARY KEY (id_recarga);


--
-- TOC entry 2980 (class 2606 OID 25926)
-- Name: tarifas tarifas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarifas
    ADD CONSTRAINT tarifas_pkey PRIMARY KEY (id_tarifa);


--
-- TOC entry 2982 (class 2606 OID 25948)
-- Name: unidades unidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidades
    ADD CONSTRAINT unidad_pkey PRIMARY KEY (id_unidad);


--
-- TOC entry 3000 (class 2606 OID 26161)
-- Name: unidades_operadores unidades_operadores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidades_operadores
    ADD CONSTRAINT unidades_operadores_pkey PRIMARY KEY (id_unidad_operador);


--
-- TOC entry 2984 (class 2606 OID 25961)
-- Name: usuarios unq_usuarios_id_cuenta; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT unq_usuarios_id_cuenta UNIQUE (id_cuenta);


--
-- TOC entry 2986 (class 2606 OID 25959)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


-- Completed on 2019-08-28 00:25:08

--
-- PostgreSQL database dump complete
--

