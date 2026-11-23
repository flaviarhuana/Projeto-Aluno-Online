-- ==============================================================================
-- LISTA DE EXERCÍCIOS – JOINS
-- ==============================================================================


-- Questão 1
SELECT p.nome AS nome_pet, 
       p.especie, 
       p.raca, 
       c.nome AS nome_dono, 
       c.telefone
FROM pets p
INNER JOIN clientes c ON p.cliente_id = c.id;


--Questão 2
SELECT c.nome AS cliente,
       p.nome AS pet,
       v.data_venda,
       prod.nome AS produto,
       iv.quantidade AS quantidade_comprada,
       iv.preco_unitario,
       (iv.quantidade * iv.preco_unitario) AS subtotal
FROM vendas v
INNER JOIN clientes c ON v.cliente_id = c.id
INNER JOIN pets p ON p.cliente_id = c.id
INNER JOIN itens_venda iv ON v.id = iv.venda_id
INNER JOIN produtos prod ON iv.produto_id = prod.id
ORDER BY v.data_venda DESC;


-- Questão 3
SELECT c.id, 
       c.nome AS cliente, 
       COALESCE(COUNT(v.id), 0) AS total_compras
FROM clientes c
LEFT JOIN vendas v ON c.id = v.cliente_id
GROUP BY c.id, c.nome;


-- Questão 4
SELECT p.id, 
       p.nome AS produto, 
       COALESCE(SUM(iv.quantidade), 0) AS unidades_vendidas
FROM produtos p
LEFT JOIN itens_venda iv ON p.id = iv.produto_id
GROUP BY p.id, p.nome
ORDER BY unidades_vendidas DESC;