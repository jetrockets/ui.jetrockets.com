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
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_login_change_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_login_change_keys (
    id bigint NOT NULL,
    key character varying NOT NULL,
    login character varying NOT NULL,
    deadline timestamp(6) without time zone NOT NULL
);


--
-- Name: account_login_change_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_login_change_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_login_change_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_login_change_keys_id_seq OWNED BY public.account_login_change_keys.id;


--
-- Name: account_password_reset_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_password_reset_keys (
    id bigint NOT NULL,
    key character varying NOT NULL,
    deadline timestamp(6) without time zone NOT NULL,
    email_last_sent timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: account_password_reset_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_password_reset_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_password_reset_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_password_reset_keys_id_seq OWNED BY public.account_password_reset_keys.id;


--
-- Name: account_remember_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_remember_keys (
    id bigint NOT NULL,
    key character varying NOT NULL,
    deadline timestamp(6) without time zone NOT NULL
);


--
-- Name: account_remember_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_remember_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_remember_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_remember_keys_id_seq OWNED BY public.account_remember_keys.id;


--
-- Name: account_verification_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_verification_keys (
    id bigint NOT NULL,
    key character varying NOT NULL,
    requested_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email_last_sent timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: account_verification_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_verification_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_verification_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_verification_keys_id_seq OWNED BY public.account_verification_keys.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    email public.citext NOT NULL,
    password_hash character varying,
    admin boolean DEFAULT false NOT NULL
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    name character varying,
    file character varying,
    types character varying[] DEFAULT '{}'::character varying[],
    assigned_to character varying,
    due_date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    is_completed boolean DEFAULT false NOT NULL
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: account_login_change_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_login_change_keys ALTER COLUMN id SET DEFAULT nextval('public.account_login_change_keys_id_seq'::regclass);


--
-- Name: account_password_reset_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_password_reset_keys ALTER COLUMN id SET DEFAULT nextval('public.account_password_reset_keys_id_seq'::regclass);


--
-- Name: account_remember_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_remember_keys ALTER COLUMN id SET DEFAULT nextval('public.account_remember_keys_id_seq'::regclass);


--
-- Name: account_verification_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_verification_keys ALTER COLUMN id SET DEFAULT nextval('public.account_verification_keys_id_seq'::regclass);


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: account_login_change_keys account_login_change_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_login_change_keys
    ADD CONSTRAINT account_login_change_keys_pkey PRIMARY KEY (id);


--
-- Name: account_password_reset_keys account_password_reset_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_password_reset_keys
    ADD CONSTRAINT account_password_reset_keys_pkey PRIMARY KEY (id);


--
-- Name: account_remember_keys account_remember_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_remember_keys
    ADD CONSTRAINT account_remember_keys_pkey PRIMARY KEY (id);


--
-- Name: account_verification_keys account_verification_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_verification_keys
    ADD CONSTRAINT account_verification_keys_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_email ON public.accounts USING btree (email) WHERE (status = ANY (ARRAY[1, 2]));


--
-- Name: account_login_change_keys fk_rails_18962144a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_login_change_keys
    ADD CONSTRAINT fk_rails_18962144a4 FOREIGN KEY (id) REFERENCES public.accounts(id);


--
-- Name: account_verification_keys fk_rails_2e3b612008; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_verification_keys
    ADD CONSTRAINT fk_rails_2e3b612008 FOREIGN KEY (id) REFERENCES public.accounts(id);


--
-- Name: account_remember_keys fk_rails_9b2f6d8501; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_remember_keys
    ADD CONSTRAINT fk_rails_9b2f6d8501 FOREIGN KEY (id) REFERENCES public.accounts(id);


--
-- Name: account_password_reset_keys fk_rails_ccaeb37cea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_password_reset_keys
    ADD CONSTRAINT fk_rails_ccaeb37cea FOREIGN KEY (id) REFERENCES public.accounts(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240320152026'),
('20240321113306'),
('20250521092532'),
('20250523095528');


