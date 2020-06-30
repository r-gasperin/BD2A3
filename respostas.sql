
/*
 * RESPOSTAS DA ATIVIDADE
 *
 * RODRIGO GASPERIN, 2020
 */


-- EXERCICIO #1
-- Crie um Database chamado NOTAFISCAL.
----------------------------------------------------------------------------------------------------
CREATE DATABASE NOTAFISCAL
GO

-- EXERCICIO #2
-- Através do comando USE, selecione o Database recém criado.
----------------------------------------------------------------------------------------------------
USE NOTAFISCAL
GO

-- EXERCICIOS #3 E #4
-- Em seguida, utilizando o padrão visto em aula, elabore um script para criar as seguintes tabelas.
-- Defina as colunas que poderão ser autonumeradas e as colunas que deverão ser Unique.
----------------------------------------------------------------------------------------------------
CREATE TABLE NOT_CLIENTE (
	CLI_IN_CODIGO INT IDENTITY(1,1) NOT NULL,
	CLI_ST_NOME VARCHAR(50) NOT NULL,
	CLI_ST_ENDERECO VARCHAR(50),
	CLI_ST_CPF CHAR(11) UNIQUE,
	CLI_CH_SEXO CHAR(1)
)
GO

ALTER TABLE NOT_CLIENTE
ADD CONSTRAINT NOT_PK_CLI PRIMARY KEY(CLI_IN_CODIGO)
GO

CREATE TABLE NOT_NOTAFISCAL (
	NOT_IN_CODIGO NUMERIC(5,0) NOT NULL,
	NOT_DT_EMISSAO DATETIME NOT NULL,
	NOT_DT_SAIDA DATETIME NOT NULL,
	CLI_IN_CODIGO INT NOT NULL
)
GO

ALTER TABLE NOT_NOTAFISCAL
ADD CONSTRAINT NOT_PK_NOT PRIMARY KEY(NOT_IN_CODIGO)
GO

ALTER TABLE NOT_NOTAFISCAL
ADD CONSTRAINT NOT_FK_NOT_CLI FOREIGN KEY(CLI_IN_CODIGO) REFERENCES NOT_CLIENTE(CLI_IN_CODIGO)
GO

CREATE TABLE NOT_PRODUTO (
	PRO_IN_CODIGO INT IDENTITY(1,1) NOT NULL,
	PRO_ST_DESCRICAO VARCHAR(50),
	PRO_RE_VALOR NUMERIC(12,2)
)
GO

ALTER TABLE NOT_PRODUTO
ADD CONSTRAINT NOT_PK_PRO PRIMARY KEY(PRO_IN_CODIGO)
GO

CREATE TABLE NOT_PRODUTONOTAFISCAL (
	NOT_IN_CODIGO NUMERIC(5,0) NOT NULL,
	PRO_IN_CODIGO INT NOT NULL,
	NPR_RE_QUANTIDADE NUMERIC(12,2) NOT NULL
)
GO

ALTER TABLE NOT_PRODUTONOTAFISCAL
ADD CONSTRAINT NOT_PK_NPR PRIMARY KEY(NOT_IN_CODIGO, PRO_IN_CODIGO)
GO

ALTER TABLE NOT_PRODUTONOTAFISCAL
ADD CONSTRAINT NOT_FK_NPR_NOT FOREIGN KEY(NOT_IN_CODIGO) REFERENCES NOT_NOTAFISCAL(NOT_IN_CODIGO)
GO

ALTER TABLE NOT_PRODUTONOTAFISCAL
ADD CONSTRAINT NOT_FK_NPR_PRO FOREIGN KEY(PRO_IN_CODIGO) REFERENCES NOT_PRODUTO(PRO_IN_CODIGO)
GO

-- EXERCICIO #5
-- Efetue os insert's abaixo (Apenas Copie e Cole!).
----------------------------------------------------------------------------------------------------
-- Inserindo os Clientes
insert into NOT_CLIENTE values ('José Alves Prado', 'Rua Marechal Deodoro, 534', '14537214011', 'M')
insert into NOT_CLIENTE values ('Márcio Gusmão', 'Rua Papa João Paulo, 714', '43218432102', 'M')
insert into NOT_CLIENTE values ('Helena Gomes', 'Av da Saudade, 14', '19214217418', 'F')
GO

-- Inserindo os Produtos
insert into NOT_PRODUTO values ('Sabão em Pó', 4.90)
insert into NOT_PRODUTO values ('Arroz', 8.75)
insert into NOT_PRODUTO values ('Vinho Chileno Concha y Toro', 34.79)
insert into NOT_PRODUTO values ('Caixa de Bombom Ferrero Roche', 24.62)
GO

-- Inserindo as Notas Fiscais
insert into NOT_NOTAFISCAL values (00018, '2009-14-05', '2009-17-05', 1)
insert into NOT_NOTAFISCAL values (00019, '2009-14-05', '2009-16-05', 2)
insert into NOT_NOTAFISCAL values (00020, '2009-14-05', '2009-15-05', 2)
insert into NOT_NOTAFISCAL values (00021, '2009-03-05', '2009-04-05', 1)
insert into NOT_NOTAFISCAL values (00022, '2009-04-05', '2009-04-05', 3)
GO

-- Inserindo os produtos das Notas Fiscais
insert into NOT_PRODUTONOTAFISCAL values (00018, 3, 2)
insert into NOT_PRODUTONOTAFISCAL values (00018, 1, 4)
insert into NOT_PRODUTONOTAFISCAL values (00018, 2, 3)
insert into NOT_PRODUTONOTAFISCAL values (00019, 4, 2)
insert into NOT_PRODUTONOTAFISCAL values (00020, 1, 2)
insert into NOT_PRODUTONOTAFISCAL values (00020, 3, 10)
insert into NOT_PRODUTONOTAFISCAL values (00021, 4, 1)
insert into NOT_PRODUTONOTAFISCAL values (00022, 1, 2)
insert into NOT_PRODUTONOTAFISCAL values (00022, 2, 15)
insert into NOT_PRODUTONOTAFISCAL values (00022, 3, 18)
GO

-- EXERCICIO #6
-- Elabore os seguintes SELECT's.
----------------------------------------------------------------------------------------------------

-- a) Trazer todos os produtos cujo valor seja maior ou igual a 8 e menor ou igual a 30
----------------------------------------------------------------------------------------------------
SELECT * FROM NOT_PRODUTO WHERE PRO_RE_VALOR BETWEEN 8 AND 30
--SELECT * FROM NOT_PRODUTO WHERE PRO_RE_VALOR >= 8 AND PRO_RE_VALOR <= 30
GO

-- b) Trazer o nome e o número do CPF dos clientes onde o CPF começa por 1
----------------------------------------------------------------------------------------------------
SELECT CLI_ST_NOME, CLI_ST_CPF FROM NOT_CLIENTE WHERE CLI_ST_CPF LIKE '1%'
GO

-- c) Liste apenas o Nome, e Endereço dos clientes do sexo feminino
----------------------------------------------------------------------------------------------------
SELECT CLI_ST_NOME, CLI_ST_ENDERECO FROM NOT_CLIENTE WHERE CLI_CH_SEXO = 'F'
GO

-- d) Liste o nome de todos os produtos que custam mais de 20.00 ou que contenham no nome a palavra Chileno
----------------------------------------------------------------------------------------------------
SELECT PRO_ST_DESCRICAO FROM NOT_PRODUTO WHERE PRO_RE_VALOR > 20 OR PRO_ST_DESCRICAO LIKE '%Chileno%'
GO

-- e) Liste todas as Notas Fiscais emitidas entre os dias 03/04/2009 a 04/04/2009
----------------------------------------------------------------------------------------------------
SELECT * FROM NOT_NOTAFISCAL WHERE NOT_DT_EMISSAO BETWEEN '2009-03-04' AND '2009-04-04'
--SELECT * FROM NOT_NOTAFISCAL WHERE NOT_DT_EMISSAO BETWEEN '2009-03-05' AND '2009-04-05' --Dias 3 e 4 de maio
GO

-- f) Traga o número da nota, o nome do produto e a quantidade de todos os itens que tiveram uma quantidade de venda superior a 2 itens em cada NF
----------------------------------------------------------------------------------------------------
SELECT PNF.NOT_IN_CODIGO, P.PRO_ST_DESCRICAO, PNF.NPR_RE_QUANTIDADE
FROM NOT_PRODUTONOTAFISCAL AS PNF
INNER JOIN NOT_PRODUTO AS P ON PNF.PRO_IN_CODIGO = P.PRO_IN_CODIGO
WHERE PNF.NPR_RE_QUANTIDADE > 2
GO

-- g) Liste todos os clientes que compraram o produto Vinho
----------------------------------------------------------------------------------------------------
SELECT C.CLI_IN_CODIGO, C.CLI_ST_NOME, C.CLI_ST_ENDERECO, C.CLI_ST_CPF, C.CLI_CH_SEXO
FROM NOT_CLIENTE AS C
INNER JOIN NOT_NOTAFISCAL AS NF ON C.CLI_IN_CODIGO = NF.CLI_IN_CODIGO
INNER JOIN NOT_PRODUTONOTAFISCAL AS PNF ON NF.NOT_IN_CODIGO = PNF.NOT_IN_CODIGO
INNER JOIN NOT_PRODUTO AS P ON PNF.PRO_IN_CODIGO = P.PRO_IN_CODIGO
WHERE P.PRO_ST_DESCRICAO LIKE '%Vinho%'
GO

-- h) Trazer o número da NF, Data de Emissão, Nome do Cliente, Quantidade Comprada e Nome de todos os Produtos vendidos
----------------------------------------------------------------------------------------------------
SELECT NF.NOT_IN_CODIGO, NF.NOT_DT_EMISSAO, C.CLI_ST_NOME, PNF.NPR_RE_QUANTIDADE, P.PRO_ST_DESCRICAO
FROM NOT_CLIENTE AS C
INNER JOIN NOT_NOTAFISCAL AS NF ON C.CLI_IN_CODIGO = NF.CLI_IN_CODIGO
INNER JOIN NOT_PRODUTONOTAFISCAL AS PNF ON NF.NOT_IN_CODIGO = PNF.NOT_IN_CODIGO
INNER JOIN NOT_PRODUTO AS P ON PNF.PRO_IN_CODIGO = P.PRO_IN_CODIGO
ORDER BY P.PRO_ST_DESCRICAO ASC, NF.NOT_IN_CODIGO ASC
GO
