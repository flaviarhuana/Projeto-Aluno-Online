--Mostra o histórico geral dos alunos com notas, médias e status de todas as disciplinas
--=======================================================================================
CREATE OR REPLACE VIEW v_historico_alunos AS
SELECT 
    a.id AS aluno_id,
    a.nome_completo AS nome_aluno,
    d.nome AS nome_disciplina,
    p.nome AS nome_professor,
    m.nota1,
    m.nota2,
    -- Calcula a média na própria View para exibição rápida
    ROUND(((COALESCE(m.nota1, 0) + COALESCE(m.nota2, 0)) / 2)::numeric, 2) AS media,
    m.status AS status_matricula
FROM matricula_aluno m
JOIN aluno a ON m.aluno_id = a.id
JOIN disciplina d ON m.disciplina_id = d.id
JOIN professor p ON d.professor_id = p.id;

SELECT * FROM v_historico_alunos;

-- Mostra as notas e médias dos alunos em uma disciplina
-- =====================================================
CREATE OR REPLACE VIEW v_notas_por_disciplina AS
SELECT 
    d.id AS disciplina_id,
    d.nome AS nome_disciplina,
    a.id AS aluno_id,
    a.nome_completo AS nome_aluno,
    m.nota1,
    m.nota2,
    ROUND(((COALESCE(m.nota1, 0) + COALESCE(m.nota2, 0)) / 2)::numeric, 2) AS media,
    m.status AS status_matricula
FROM matricula_aluno m
JOIN disciplina d ON m.disciplina_id = d.id
JOIN aluno a ON m.aluno_id = a.id;

SELECT * FROM v_notas_por_disciplina WHERE disciplina_id = 1;

-- Informa o ranking de alunos que tiveram médias maior ou igual a 9.0 (contabiliza a quantidade de disciplinas)
-- =============================================================================================================
CREATE OR REPLACE VIEW v_ranking_premiacao AS
SELECT 
    DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS posicao,
    a.id AS aluno_id,
    a.nome_completo AS nome_aluno,
    COUNT(m.id) AS quantidade_disciplinas_excelentes
FROM matricula_aluno m
JOIN aluno a ON m.aluno_id = a.id
WHERE ((COALESCE(m.nota1, 0) + COALESCE(m.nota2, 0)) / 2) >= 9.0
GROUP BY a.id, a.nome_completo
ORDER BY posicao ASC;

SELECT * FROM v_ranking_premiacao;

-- Busca o histórico de um aluno
-- =============================
CREATE OR REPLACE VIEW v_perfil_completo_aluno AS
SELECT 
    a.id AS aluno_id,
    a.nome_completo AS nome_aluno,
    a.email AS email_aluno,
    a.cpf AS cpf_aluno,
    d.nome AS nome_disciplina,
    d.carga_horaria,
    p.nome AS nome_professor,
    m.nota1,
    m.nota2,
    ROUND(((COALESCE(m.nota1, 0) + COALESCE(m.nota2, 0)) / 2)::numeric, 2) AS media,
    m.status AS status_matricula
FROM aluno a
LEFT JOIN matricula_aluno m ON a.id = m.aluno_id
LEFT JOIN disciplina d ON m.disciplina_id = d.id
LEFT JOIN professor p ON d.professor_id = p.id;

SELECT * FROM v_perfil_completo_aluno WHERE aluno_id = 13;

-- Busca quais disciplinas o professor está lecionando
-- ===================================================
CREATE OR REPLACE VIEW v_disciplinas_por_professor AS
SELECT 
    p.id AS professor_id,
    p.nome AS nome_professor,
    p.email AS email_professor,
    d.id AS disciplina_id,
    d.nome AS nome_disciplina,
    d.carga_horaria
FROM professor p
INNER JOIN disciplina d ON d.professor_id = p.id;

SELECT * FROM v_disciplinas_por_professor WHERE professor_id = 2;

