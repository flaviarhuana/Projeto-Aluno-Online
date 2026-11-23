-- ==============================================================================
-- LISTA DE EXERCÍCIOS – SUBQUERYS E CTE
-- ==============================================================================


-- Questão 1
SELECT id, nome, email 
FROM clientes
WHERE id IN (
    SELECT DISTINCT v.cliente_id 
    FROM vendas v
    INNER JOIN itens_venda iv ON v.id = iv.venda_id
    INNER JOIN produtos p ON iv.produto_id = p.id
    WHERE p.descricao ILIKE '%ração%'
);


-- Questão 2
WITH media_compras_cliente AS (
    SELECT cliente_id, AVG(valor_total) AS media_gasto
    FROM vendas
    GROUP BY cliente_id
)
SELECT c.id, c.nome, ROUND(m.media_gasto, 2) AS media_venda
FROM clientes c
INNER JOIN media_compras_cliente m ON c.id = m.cliente_id
WHERE m.media_gasto > 200.00;


-- Questão 3
SELECT p.id, p.nome, total_vendido.quantidade_total
FROM produtos p
INNER JOIN (
    SELECT produto_id, SUM(quantidade) AS quantidade_total
    FROM itens_venda
    GROUP BY produto_id
) AS total_vendido ON p.id = total_vendido.produto_id
WHERE total_vendido.quantidade_total > 2;


-- Questão 4
WITH total_por_servico AS (
    SELECT servico_id, COUNT(*) AS qtd_agendamentos
    FROM agendamentos
    GROUP BY servico_id
)
SELECT s.nome AS servico, t.qtd_agendamentos
FROM servicos s
INNER JOIN total_por_servico t ON s.id = t.servico_id
ORDER BY t.qtd_agendamentos DESC
LIMIT 3;


-- Questão 5
WITH gasto_por_cliente AS (

    -- a. Total gasto por cada cliente
    SELECT cliente_id, SUM(valor_total) AS total_gasto
    FROM vendas
    GROUP BY cliente_id
),
media_geral AS (

    -- b. Média geral de gastos de todos os clientes
    SELECT AVG(total_gasto) AS media_geral_gastos 
    FROM gasto_por_cliente
),
contagem_pets AS (
    SELECT cliente_id, COUNT(*) AS qtd_pets
    FROM pets
    GROUP BY cliente_id
)
-- c. Listar clientes acima da média E com mais de 1 pet
SELECT c.nome AS cliente, 
       ROUND(g.total_gasto, 2) AS total_gasto, 
       p.qtd_pets
FROM clientes c
INNER JOIN gasto_por_cliente g ON c.id = g.cliente_id
INNER JOIN contagem_pets p ON c.id = p.cliente_id
CROSS JOIN media_geral m
WHERE g.total_gasto > m.media_geral_gastos 
  AND p.qtd_pets > 1;

