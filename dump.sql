--
-- PostgreSQL database dump
--

\restrict CYq8JcIycBVv66voZ7is7Wckz0KzZyKe0lTqPmerwyj8MPkDjpFUl7qKRaXkn67

-- Dumped from database version 16.12 (Debian 16.12-1.pgdg13+1)
-- Dumped by pg_dump version 16.12 (Debian 16.12-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: orderstatus; Type: TYPE; Schema: public; Owner: flowers_user
--

CREATE TYPE public.orderstatus AS ENUM (
    'new',
    'delivering',
    'done',
    'canceled'
);


ALTER TYPE public.orderstatus OWNER TO flowers_user;

--
-- Name: userrole; Type: TYPE; Schema: public; Owner: flowers_user
--

CREATE TYPE public.userrole AS ENUM (
    'user',
    'admin'
);


ALTER TYPE public.userrole OWNER TO flowers_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: app_cart_items; Type: TABLE; Schema: public; Owner: flowers_user
--

CREATE TABLE public.app_cart_items (
    id integer NOT NULL,
    user_id integer NOT NULL,
    flower_id integer NOT NULL,
    qty integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.app_cart_items OWNER TO flowers_user;

--
-- Name: app_cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: flowers_user
--

CREATE SEQUENCE public.app_cart_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_cart_items_id_seq OWNER TO flowers_user;

--
-- Name: app_cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flowers_user
--

ALTER SEQUENCE public.app_cart_items_id_seq OWNED BY public.app_cart_items.id;


--
-- Name: app_order_items; Type: TABLE; Schema: public; Owner: flowers_user
--

CREATE TABLE public.app_order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    flower_id integer NOT NULL,
    qty integer NOT NULL,
    unit_price numeric(10,2) NOT NULL
);


ALTER TABLE public.app_order_items OWNER TO flowers_user;

--
-- Name: app_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: flowers_user
--

CREATE SEQUENCE public.app_order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_order_items_id_seq OWNER TO flowers_user;

--
-- Name: app_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flowers_user
--

ALTER SEQUENCE public.app_order_items_id_seq OWNED BY public.app_order_items.id;


--
-- Name: app_orders; Type: TABLE; Schema: public; Owner: flowers_user
--

CREATE TABLE public.app_orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    status public.orderstatus NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    delivery_address text DEFAULT ''::text NOT NULL,
    payment_method character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.app_orders OWNER TO flowers_user;

--
-- Name: app_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: flowers_user
--

CREATE SEQUENCE public.app_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_orders_id_seq OWNER TO flowers_user;

--
-- Name: app_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flowers_user
--

ALTER SEQUENCE public.app_orders_id_seq OWNED BY public.app_orders.id;


--
-- Name: app_users; Type: TABLE; Schema: public; Owner: flowers_user
--

CREATE TABLE public.app_users (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role public.userrole NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.app_users OWNER TO flowers_user;

--
-- Name: app_users_id_seq; Type: SEQUENCE; Schema: public; Owner: flowers_user
--

CREATE SEQUENCE public.app_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_users_id_seq OWNER TO flowers_user;

--
-- Name: app_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flowers_user
--

ALTER SEQUENCE public.app_users_id_seq OWNED BY public.app_users.id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: flowers_user
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    actor_user_id integer,
    actor_username character varying(64) NOT NULL,
    action character varying(64) NOT NULL,
    entity character varying(64) NOT NULL,
    entity_id integer,
    before json,
    after json,
    meta json,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.audit_logs OWNER TO flowers_user;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: flowers_user
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO flowers_user;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flowers_user
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: bouquets; Type: TABLE; Schema: public; Owner: flowers_user
--

CREATE TABLE public.bouquets (
    id integer NOT NULL,
    category_id integer,
    name character varying(255) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    image_url character varying(500),
    stock integer DEFAULT 0,
    is_popular boolean DEFAULT false,
    category character varying(255) DEFAULT 'Другое'::character varying NOT NULL
);


ALTER TABLE public.bouquets OWNER TO flowers_user;

--
-- Name: bouquets_id_seq; Type: SEQUENCE; Schema: public; Owner: flowers_user
--

CREATE SEQUENCE public.bouquets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bouquets_id_seq OWNER TO flowers_user;

--
-- Name: bouquets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flowers_user
--

ALTER SEQUENCE public.bouquets_id_seq OWNED BY public.bouquets.id;


--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: flowers_user
--

CREATE TABLE public.cart_items (
    id integer NOT NULL,
    user_id integer,
    bouquet_id integer,
    quantity integer DEFAULT 1 NOT NULL,
    added_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cart_items OWNER TO flowers_user;

--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: flowers_user
--

CREATE SEQUENCE public.cart_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_items_id_seq OWNER TO flowers_user;

--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flowers_user
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: flowers_user
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(100)
);


ALTER TABLE public.categories OWNER TO flowers_user;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: flowers_user
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO flowers_user;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flowers_user
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: flowers_user
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer,
    bouquet_id integer,
    quantity integer DEFAULT 1 NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL
);


ALTER TABLE public.order_items OWNER TO flowers_user;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: flowers_user
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO flowers_user;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flowers_user
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: flowers_user
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer,
    status character varying(50) DEFAULT 'new'::character varying,
    total_amount numeric(10,2),
    payment_method character varying(50),
    delivery_address text,
    delivery_time timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.orders OWNER TO flowers_user;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: flowers_user
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO flowers_user;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flowers_user
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: flowers_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20),
    password_hash character varying(255) NOT NULL,
    role character varying(50) DEFAULT 'customer'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO flowers_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: flowers_user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO flowers_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flowers_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: app_cart_items id; Type: DEFAULT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_cart_items ALTER COLUMN id SET DEFAULT nextval('public.app_cart_items_id_seq'::regclass);


--
-- Name: app_order_items id; Type: DEFAULT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_order_items ALTER COLUMN id SET DEFAULT nextval('public.app_order_items_id_seq'::regclass);


--
-- Name: app_orders id; Type: DEFAULT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_orders ALTER COLUMN id SET DEFAULT nextval('public.app_orders_id_seq'::regclass);


--
-- Name: app_users id; Type: DEFAULT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_users ALTER COLUMN id SET DEFAULT nextval('public.app_users_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: bouquets id; Type: DEFAULT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.bouquets ALTER COLUMN id SET DEFAULT nextval('public.bouquets_id_seq'::regclass);


--
-- Name: cart_items id; Type: DEFAULT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: app_cart_items; Type: TABLE DATA; Schema: public; Owner: flowers_user
--

COPY public.app_cart_items (id, user_id, flower_id, qty, created_at, updated_at) FROM stdin;
3	6	6	7	2026-03-25 10:22:40.066813+00	2026-03-25 10:23:37.832007+00
5	6	5	1	2026-03-25 10:23:43.806049+00	2026-03-25 10:23:43.806056+00
4	6	7	2	2026-03-25 10:23:37.727116+00	2026-03-25 10:23:42.743647+00
6	6	2	1	2026-03-25 10:23:46.413539+00	2026-03-25 10:23:46.413548+00
7	6	3	2	2026-03-25 10:24:04.500138+00	2026-03-25 10:24:17.001989+00
8	7	2	3	2026-03-25 10:27:21.644872+00	2026-03-25 10:27:36.788519+00
\.


--
-- Data for Name: app_order_items; Type: TABLE DATA; Schema: public; Owner: flowers_user
--

COPY public.app_order_items (id, order_id, flower_id, qty, unit_price) FROM stdin;
1	1	2	6	1800.00
2	1	3	2	4500.00
\.


--
-- Data for Name: app_orders; Type: TABLE DATA; Schema: public; Owner: flowers_user
--

COPY public.app_orders (id, user_id, status, created_at, updated_at, delivery_address, payment_method) FROM stdin;
1	1	done	2026-03-18 10:16:08.529471+00	2026-03-24 12:38:56.040137+00		
\.


--
-- Data for Name: app_users; Type: TABLE DATA; Schema: public; Owner: flowers_user
--

COPY public.app_users (id, username, password_hash, role, created_at) FROM stdin;
2	string	$pbkdf2-sha256$29000$mxPCGAOAUOqdk1Kq9V7rXQ$laHafjSYtcacR/Sea.VK2YvCtA2ZQw9nxgKI.xfLMEY	user	2026-03-17 20:49:04.458532+00
3	kalashnikov.m.v@edu.mirea.ru	$pbkdf2-sha256$29000$z5kzJkQoJQSg9H6vFQKgVA$khltcdn.HCKWcp6wK9V.cpkbXaSMkAMU.9dTsV44JJ0	user	2026-03-18 08:14:01.093452+00
4	Саша	$pbkdf2-sha256$29000$RChFqLV2rrW2ltK69/7/Hw$lPnn56NfKJBZ4res1NMEFdYILcBBFhCthTp9kdBWsmc	user	2026-03-18 08:14:34.873136+00
1	admin	$pbkdf2-sha256$29000$NCaktHYOgVAqpRTivBfCOA$woxNoK5O72jFPGicdV1oNOc4y6JZkYCmP9zgwrMlEdw	admin	2026-03-17 19:05:47.17053+00
5	test	$pbkdf2-sha256$29000$RejduzdGqDUGYExp7T2HsA$xsWw7ZwhqpF3BNZG9ha5IUezcrvIPmjqFetc.M0ijyw	user	2026-03-25 08:01:16.915999+00
6	рпрпрпрпрп	$pbkdf2-sha256$29000$a20NgTBG6H3v/V.LcQ5B6A$05n0wr0EXMxpn3/5haNWJUq105tyhDxkhzBEe/H46ks	user	2026-03-25 10:21:02.106832+00
7	11111	$pbkdf2-sha256$29000$3ltLSYlRCiHk3Hvv3ZsTIg$d4Ct3YNAB7G3xFEIEyfZWX6jmVXhOjqruduzuSfzsjU	user	2026-03-25 10:27:03.605947+00
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: flowers_user
--

COPY public.audit_logs (id, actor_user_id, actor_username, action, entity, entity_id, before, after, meta, created_at) FROM stdin;
1	1	admin	update_status	order	1	{"id": 1, "status": "new"}	{"id": 1, "status": "done"}	null	2026-03-24 12:38:56.580911+00
\.


--
-- Data for Name: bouquets; Type: TABLE DATA; Schema: public; Owner: flowers_user
--

COPY public.bouquets (id, category_id, name, description, price, image_url, stock, is_popular, category) FROM stdin;
1	1	Красные розы	15 красных роз премиум	2500.00	/images/roses.jpg	15	t	Другое
2	2	Белые тюльпаны	20 белых тюльпан	1800.00	/images/tulips.jpg	25	f	Другое
3	3	Любимая	Микс роз + хризантемы	4500.00	/images/mix.jpg	8	t	Другое
4	1	Полярные розы	10 полярных роз	3200.00	/images/polar.jpg	12	f	Другое
5	\N	string	\N	0.00	https://example.com/	0	f	Другое
6	\N	11111	\N	1111.00	https://example.com/	0	f	Другое
7	\N	333	\N	33.00	string	0	f	Другое
\.


--
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: flowers_user
--

COPY public.cart_items (id, user_id, bouquet_id, quantity, added_at) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: flowers_user
--

COPY public.categories (id, name, slug) FROM stdin;
1	Розы	roses
2	Тюльпаны	tulips
3	Микс	mix
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: flowers_user
--

COPY public.order_items (id, order_id, bouquet_id, quantity, unit_price, subtotal) FROM stdin;
1	1	1	1	2500.00	2500.00
2	1	2	1	1800.00	1800.00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: flowers_user
--

COPY public.orders (id, user_id, status, total_amount, payment_method, delivery_address, delivery_time, created_at) FROM stdin;
1	1	paid	4300.00	card	Москва, ул. Ленина 10	\N	2026-03-17 10:01:55.900332
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: flowers_user
--

COPY public.users (id, full_name, email, phone, password_hash, role, created_at) FROM stdin;
1	Иван Иванов	ivan@example.com	79991234567	$2b$12$test_hash	customer	2026-03-17 10:01:55.89656
2	Админ	admin@example.com	79990000000	$2b$12$admin_hash	admin	2026-03-17 10:01:55.89656
3	Мария Петрова	maria@example.com	79997654321	$2b$12$test_hash	customer	2026-03-17 10:01:55.89656
\.


--
-- Name: app_cart_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flowers_user
--

SELECT pg_catalog.setval('public.app_cart_items_id_seq', 8, true);


--
-- Name: app_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flowers_user
--

SELECT pg_catalog.setval('public.app_order_items_id_seq', 2, true);


--
-- Name: app_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flowers_user
--

SELECT pg_catalog.setval('public.app_orders_id_seq', 1, true);


--
-- Name: app_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flowers_user
--

SELECT pg_catalog.setval('public.app_users_id_seq', 7, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flowers_user
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 1, true);


--
-- Name: bouquets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flowers_user
--

SELECT pg_catalog.setval('public.bouquets_id_seq', 7, true);


--
-- Name: cart_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flowers_user
--

SELECT pg_catalog.setval('public.cart_items_id_seq', 1, false);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flowers_user
--

SELECT pg_catalog.setval('public.categories_id_seq', 3, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flowers_user
--

SELECT pg_catalog.setval('public.order_items_id_seq', 2, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flowers_user
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flowers_user
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: app_cart_items app_cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_cart_items
    ADD CONSTRAINT app_cart_items_pkey PRIMARY KEY (id);


--
-- Name: app_order_items app_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_order_items
    ADD CONSTRAINT app_order_items_pkey PRIMARY KEY (id);


--
-- Name: app_orders app_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_orders
    ADD CONSTRAINT app_orders_pkey PRIMARY KEY (id);


--
-- Name: app_users app_users_pkey; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_users
    ADD CONSTRAINT app_users_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: bouquets bouquets_pkey; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.bouquets
    ADD CONSTRAINT bouquets_pkey PRIMARY KEY (id);


--
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: cart_items cart_items_user_id_bouquet_id_key; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_user_id_bouquet_id_key UNIQUE (user_id, bouquet_id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: app_cart_items uq_app_cart_user_flower; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_cart_items
    ADD CONSTRAINT uq_app_cart_user_flower UNIQUE (user_id, flower_id);


--
-- Name: app_order_items uq_app_order_flower; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_order_items
    ADD CONSTRAINT uq_app_order_flower UNIQUE (order_id, flower_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_cart_user_id; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX idx_cart_user_id ON public.cart_items USING btree (user_id);


--
-- Name: idx_order_items_order; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX idx_order_items_order ON public.order_items USING btree (order_id);


--
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- Name: idx_orders_user_id; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX idx_orders_user_id ON public.orders USING btree (user_id);


--
-- Name: ix_app_cart_items_flower_id; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX ix_app_cart_items_flower_id ON public.app_cart_items USING btree (flower_id);


--
-- Name: ix_app_cart_items_user_id; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX ix_app_cart_items_user_id ON public.app_cart_items USING btree (user_id);


--
-- Name: ix_app_order_items_flower_id; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX ix_app_order_items_flower_id ON public.app_order_items USING btree (flower_id);


--
-- Name: ix_app_order_items_order_id; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX ix_app_order_items_order_id ON public.app_order_items USING btree (order_id);


--
-- Name: ix_app_orders_user_id; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX ix_app_orders_user_id ON public.app_orders USING btree (user_id);


--
-- Name: ix_app_users_username; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE UNIQUE INDEX ix_app_users_username ON public.app_users USING btree (username);


--
-- Name: ix_audit_logs_action; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX ix_audit_logs_action ON public.audit_logs USING btree (action);


--
-- Name: ix_audit_logs_actor_user_id; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX ix_audit_logs_actor_user_id ON public.audit_logs USING btree (actor_user_id);


--
-- Name: ix_audit_logs_actor_username; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX ix_audit_logs_actor_username ON public.audit_logs USING btree (actor_username);


--
-- Name: ix_audit_logs_created_at; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX ix_audit_logs_created_at ON public.audit_logs USING btree (created_at);


--
-- Name: ix_audit_logs_entity; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX ix_audit_logs_entity ON public.audit_logs USING btree (entity);


--
-- Name: ix_audit_logs_entity_id; Type: INDEX; Schema: public; Owner: flowers_user
--

CREATE INDEX ix_audit_logs_entity_id ON public.audit_logs USING btree (entity_id);


--
-- Name: app_cart_items app_cart_items_flower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_cart_items
    ADD CONSTRAINT app_cart_items_flower_id_fkey FOREIGN KEY (flower_id) REFERENCES public.bouquets(id);


--
-- Name: app_cart_items app_cart_items_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_cart_items
    ADD CONSTRAINT app_cart_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id);


--
-- Name: app_order_items app_order_items_flower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_order_items
    ADD CONSTRAINT app_order_items_flower_id_fkey FOREIGN KEY (flower_id) REFERENCES public.bouquets(id);


--
-- Name: app_order_items app_order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_order_items
    ADD CONSTRAINT app_order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.app_orders(id);


--
-- Name: app_orders app_orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.app_orders
    ADD CONSTRAINT app_orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id);


--
-- Name: audit_logs audit_logs_actor_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_actor_user_id_fkey FOREIGN KEY (actor_user_id) REFERENCES public.app_users(id);


--
-- Name: bouquets bouquets_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.bouquets
    ADD CONSTRAINT bouquets_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: cart_items cart_items_bouquet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_bouquet_id_fkey FOREIGN KEY (bouquet_id) REFERENCES public.bouquets(id) ON DELETE CASCADE;


--
-- Name: cart_items cart_items_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_bouquet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_bouquet_id_fkey FOREIGN KEY (bouquet_id) REFERENCES public.bouquets(id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flowers_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict CYq8JcIycBVv66voZ7is7Wckz0KzZyKe0lTqPmerwyj8MPkDjpFUl7qKRaXkn67

