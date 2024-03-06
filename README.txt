Clone o reposiorio : git clone https://github.com/gittiagohub/AuthenticationJWT
baixe e instale o gerenciador de denpendêcias boss:  https://github.com/hashload/boss/releases
abra o cmd, vá até a pasta AuthenticationJWT e rode o comando: "boss i"  para baixar todas as dependências
Depois compile o projeto.
criar um banco de dados no PG
Vá até a pasta AuthenticationJWT\Win32\Debug no arquivo Config.ini, insira o banco de dados na propriedade DatabaseName

criar a tabela users
CREATE TABLE public.users (
	guid uuid NOT NULL DEFAULT uuid_generate_v4(),
	id bigserial NOT NULL,
	username varchar(100) NOT NULL,
	fullname varchar(100) NOT NULL,
	"password" varchar NOT NULL,
	email varchar(256) NOT NULL,
	birthdate date NOT NULL,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamp NULL,
	CONSTRAINT users_email_check CHECK (((email)::text <> ''::text)),
	CONSTRAINT users_email_key UNIQUE (email),
	CONSTRAINT users_id_key UNIQUE (id),
	CONSTRAINT users_password_check CHECK (((password)::text <> ''::text)),
	CONSTRAINT users_pkey PRIMARY KEY (guid, id),
	CONSTRAINT users_username_check CHECK (((username)::text <> ''::text)),
	CONSTRAINT users_username_check1 CHECK (((username)::text <> ''::text)),
	CONSTRAINT users_username_key UNIQUE (username)
);


Criar a tabela user token
CREATE TABLE public.users_token (
	guid uuid NOT NULL DEFAULT uuid_generate_v4(),
	id bigserial NOT NULL,
	id_users int8 NOT NULL,
	"token" varchar NULL,
	expiry_at timestamp NOT NULL,
	ativo int4 NOT NULL DEFAULT 0,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamp NULL,
	CONSTRAINT users_token_id_key UNIQUE (id),
	CONSTRAINT users_token_pkey PRIMARY KEY (guid, id)
);
 
 
 insere usuario 
 insert into users  (username,fullname,password,email,birthdate)values
(
	'Tiago_Silva_Montalvao',
	'Tiago Silva Montalvão',
	'$2a$10$5WzbvqvTOmzYIzwiMB7jU.P0Wc4OXq16zidAGfDGvdpcZ4tN1dfFy',
	'tiago_cba10@hotmail.com',
	'1991-09-28')
	
	
pronto, 
Agora compile os projetos e rode o backend = AuthenticationJWT.exe, e o frontend = login.exe	
	
