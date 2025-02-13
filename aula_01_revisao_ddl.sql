-- Ctrl + F7 - indentar a tabela

CREATE TABLE pais (
    id_pais   NUMBER PRIMARY KEY,
    nome_pais VARCHAR2(30)
);

CREATE TABLE estado (
    id_estado   NUMBER PRIMARY KEY,
    nome_estado VARCHAR2(30),
    id_pais     NUMBER
);

ALTER TABLE estado
    ADD CONSTRAINT fk_estado FOREIGN KEY ( id_pais )
        REFERENCES pais ( id_pais );

CREATE TABLE cidade (
    id_cidade   NUMBER PRIMARY KEY,
    nome_cidade VARCHAR2(30),
    id_estado   NUMBER
);

ALTER TABLE cidade
    ADD CONSTRAINT fk_cidade FOREIGN KEY ( id_estado )
        REFERENCES estado ( id_estado );

CREATE TABLE bairro (
    id_bairro   NUMBER PRIMARY KEY,
    nome_bairro VARCHAR2(50),
    id_cidade   NUMBER
);

ALTER TABLE bairro
    ADD CONSTRAINT fk_bairro FOREIGN KEY ( id_cidade )
        REFERENCES cidade ( id_cidade );

CREATE TABLE end_cliente (
    id_endereco NUMBER PRIMARY KEY,
    cep         NUMBER,
    logradouro  VARCHAR2(50),
    numero      NUMBER,
    complemento VARCHAR2(50),
    id_bairro   NUMBER
);

ALTER TABLE end_cliente
    ADD CONSTRAINT fk_end_client FOREIGN KEY ( id_bairro )
        REFERENCES bairro ( id_bairro );

--- INSERTS ---

INSERT INTO pais (id_pais, nome_pais) VALUES (1, 'Brasil');
INSERT INTO pais (id_pais, nome_pais) VALUES (2, 'Itália');
INSERT INTO pais (id_pais, nome_pais) VALUES (3, 'Rússia');
INSERT INTO pais (id_pais, nome_pais) VALUES (4, 'Austrália');
INSERT INTO pais (id_pais, nome_pais) VALUES (5, 'Cuba');

INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (1, 'Rio Grande do Sul', 1);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (2, 'Lazio', 2);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (3, 'São Petersburgo', 3);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (4, 'Victoria', 4);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (5, 'Havana', 5);

INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (1, 'Santa Cruz do Sul', 1);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (2, 'Roma', 2);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (3, 'São Petersburgo', 3);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (4, 'Melbourne', 4);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (5, 'Havana', 5);

INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (1, 'Aliança', 1);
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (2, 'Trastevere', 2);
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (3, 'Vasilyevsky Island', 3);
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (4, 'Fitzroy', 4);
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (5, 'La Habana', 5);

INSERT INTO end_cliente (id_endereco, cep, logradouro, numero, complemento, id_bairro) VALUES (1, 96833600, 'Rua dos Coqueirais', 90, 'Casa 4', 1);
INSERT INTO end_cliente (id_endereco, cep, logradouro, numero, complemento, id_bairro) VALUES (2, 00153, 'Via della Lungaretta', 15, 'Apt 14 Bloco E', 2);
INSERT INTO end_cliente (id_endereco, cep, logradouro, numero, complemento, id_bairro) VALUES (3, 199034, 'Bolshoy Prospect', 8, 'Kvartira 12', 3);
INSERT INTO end_cliente (id_endereco, cep, logradouro, numero, complemento, id_bairro) VALUES (4, 3065, 'Brunswick Street', 145, 'Unit 3', 4);
INSERT INTO end_cliente (id_endereco, cep, logradouro, numero, complemento, id_bairro) VALUES (5, 10300, 'Calle Neptuno', 132, 'Apt 7A', 5);

SELECT * FROM pais;
SELECT * FROM estado;
SELECT * FROM cidade;
SELECT * FROM bairro;
SELECT * FROM end_cliente;

--- DROPS 

/*
DROP TABLE end_cliente;
DROP TABLE bairro;
DROP TABLE cidade;
DROP TABLE estado;
DROP TABLE pais;
*/