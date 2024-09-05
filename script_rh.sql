USE rh;
SELECT * FROM datasetrh;


SELECT
	COUNT(Id_Funcionario) IS NULL AS Ids_Nulos,
	COUNT(Id_Funcionario) AS Total_Registros,
	COUNT(DISTINCT Id_Funcionario) AS Total_Registros_Unicos
FROM datasetrh;

-- ------------------------------------------------------------------------------------------------------
-- MÉDIA DE SATISFAÇÃO POR FUNÇÃO, SALÁRIO POR FUNÇÃO E 10 MAIORES SALÁRIOS
-- MÉDIA SATISFAÇÃO FUNÇÃO

SELECT
	Funcao,
	AVG(Nivel_Satisfacao_Trabalho) AS Media_satisfacao 
FROM datasetrh
GROUP BY Funcao
ORDER BY Media_satisfacao DESC;

-- MÉDIA SALARIO POR FUNÇÃO

SELECT
	Funcao,
	ROUND(AVG(Salario_Mensal), 2) AS Média_Salario
FROM datasetrh
GROUP BY Funcao;

-- 10 MAIORES SALÁRIOS

SELECT
	Id_Funcionario,
    Funcao,
    Salario_Mensal
FROM datasetrh
ORDER BY Salario_Mensal DESC
LIMIT 10;

-- ------------------------------------------------------------------------------------------------------
-- QUANTIDADE DE NIVEIS DE ENVOLVIMENTO NO TRABALHO 

SELECT DISTINCT Indice_Envolvimento_Trabalho AS Niveis_Indices_Envolvimento
FROM datasetrh
ORDER BY Indice_Envolvimento_Trabalho DESC;

-- FUNCIONÁRIOS COM BAIXO ENVOLVIMENTO (NIVEL SATISFAÇÃO E SALÁRIO)
SELECT
	Id_Funcionario,
	Indice_Envolvimento_Trabalho,
    Nivel_Satisfacao_Trabalho,
    Salario_Mensal
FROM
	datasetrh
WHERE Indice_Envolvimento_Trabalho < 2
ORDER BY
	Id_Funcionario;

-- FUNCIONÁRIOS COM ENVOLVIMENTO BAIXO E SATISFAÇÃO ALTA
SELECT
	Id_Funcionario,
    Salario_Mensal,
    Anos_na_Empresa,
    Funcao,
    Indice_Envolvimento_Trabalho,
    Nivel_Satisfacao_Trabalho
FROM datasetrh
WHERE
	Indice_Envolvimento_Trabalho = 1 AND
	Nivel_Satisfacao_Trabalho = 4
ORDER BY Id_Funcionario;

-- ------------------------------------------------------------------
-- SATISFAÇÃO E SALÁRIO POR ANOS DE EXPERIÊNCIA

SELECT
	CASE
		WHEN Anos_Experiencia < 1 THEN 'Aprendiz'
        		WHEN Anos_Experiencia <= 3 THEN 'Junior'
        		WHEN Anos_Experiencia <= 5 THEN 'Pleno'
        		WHEN Anos_Experiencia <= 8 THEN 'Senior'
       		 WHEN Anos_Experiencia <= 10 THEN 'Especialista'
        	ELSE 'Gerente'
	END AS Experiencia,
    	AVG(Nivel_Satisfacao_Trabalho) AS Media_Satisfacao,
    	ROUND(AVG(Salario_Mensal), 2) AS Media_Salarial
FROM datasetrh
GROUP BY Experiencia
ORDER BY Media_Salarial;

-- ---------------------------------------------------------------
-- FUNCIONÁRIOS COM TÍTULOS DE ANALISTA

SELECT
	Funcao,
	COUNT(*) AS Qtd_Funcionarios
FROM datasetrh
WHERE Funcao LIKE '%Analista%'
GROUP BY Funcao
ORDER BY Qtd_Funcionarios;

-- ----------------------------------------------------------------
-- FUNÇÃO MAIS FUNCIONÁRIOS (SATISFAÇÃO E MÉDIA SALARIAL) 

SELECT
    Funcao,
    Qtd_Funcionario,
    Nivel_Satisfacao_Trabalho,
    Media_Salario,
    Salarios_Abaixo_Media,
    ROUND(Salarios_Abaixo_Media / Qtd_Funcionario * 100, 2) AS Porcentagem_Salarios_Abaixo_Media
FROM (
    SELECT
        Funcao,
        COUNT(*) AS Qtd_Funcionario,
        ROUND(AVG(Nivel_Satisfacao_Trabalho), 2) AS Nivel_Satisfacao_Trabalho,
        ROUND(AVG(Salario_Mensal), 2) AS Media_Salario,
        SUM(CASE
                WHEN Salario_Mensal < (SELECT AVG(Salario_Mensal) FROM datasetrh WHERE Funcao = d.Funcao)
                THEN 1 ELSE 0
            END) AS Salarios_Abaixo_Media
    FROM datasetrh d
    GROUP BY Funcao
) AS Mais_Func
ORDER BY Qtd_Funcionario DESC;

-- --------------------------------------------------
-- VARIAÇÃO DE SALÁRIO POR CATEGORIA DE PERFORMANCE

SELECT
    Aval_Performance AS Categoria_Avaliacao_Performance,
    count(*) AS Quantidade_Funcionarios,
    ROUND(AVG(Salario_Mensal), 2) AS Media_Salario
FROM datasetrh
GROUP BY Aval_Performance
ORDER BY Media_Salario DESC;

-- ----------------------------------------------------------------
-- IMPACTO DOS TREINAMENTOS MO SALÁRIO E SATISFAÇÃO

SELECT
	Numero_Treinamentos_Ano_Anterior AS Num_Treinamentos,
    ROUND(AVG(Salario_Mensal), 2) AS Media_Salarial,
    ROUND(AVG(Nivel_Satisfacao_Trabalho), 2) as Media_Satisfacao
FROM datasetrh
GROUP BY Num_Treinamentos
ORDER BY Num_treinamentos;

-- ----------------------------------------------------------------------------
-- FUNCIONÁRIOS COM ALTA SATISFAÇÃO E DISPONÍVEIS HORA EXTRA

SELECT
	Id_Funcionario,
    Nivel_Satisfacao_trabalho,
    Disponivel_Hora_extra
FROM datasetrh
WHERE Nivel_Satisfacao_trabalho = 4 AND Disponivel_Hora_extra = 'S'
ORDER BY Id_Funcionario;

-- --------------------------------------------------------------------------
-- ANÁLISE DE FUNCIONÁRIOS COM MENOS DE 5 ANOS DE EXPERIÊNCIA (QUANTIDADE E SALÁRIO MÉDIO)

-- CONSULTA 1:
SELECT
    Id_Funcionario,
    Anos_Experiencia,
    Indice_Envolvimento_Trabalho,
    Numero_Treinamentos_Ano_Anterior,
    Aval_Performance
FROM datasetrh
WHERE Anos_Experiencia < 5;

-- CONSULTA 2:
SELECT
	COUNT(Id_Funcionario) AS Qtd_Funcionarios,
    ROUND(AVG(Salario_Mensal), 2) AS Media_Salarial
FROM datasetrh
WHERE Anos_Experiencia < 5;

-- ----------------------------------------------------------
-- RELAÇÃO ENTRE CATEGORIAS DE ENVOLVIMENTO E MÉDIA SATISFAÇÃO

SELECT DISTINCT Indice_Envolvimento_Trabalho
FROM datasetrh
ORDER BY Indice_Envolvimento_Trabalho;

SELECT
	CASE
		WHEN Indice_Envolvimento_Trabalho = 1 THEN 'Baixo'
        WHEN Indice_Envolvimento_Trabalho > 1 AND Indice_Envolvimento_Trabalho < 4 THEN 'Medio'
        ELSE 'Alto'
	END AS Categoria_Envolvimento,
    ROUND(AVG(Nivel_Satisfacao_Trabalho), 2) AS Media_Satisfacao_Trabalho,
    COUNT(Id_Funcionario) AS Qtd_Funcionarios
FROM datasetrh
GROUP BY Categoria_Envolvimento
ORDER BY Media_Satisfacao_Trabalho;



