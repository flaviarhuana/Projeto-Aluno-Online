-- =======================================================================================
-- TRIGGER 1: SISTEMA DE AUDITORIA (LOG DE ALTERAÇÃO DE STATUS)
-- =======================================================================================

-- Passo A: Criar a tabela física que vai guardar os históricos
CREATE TABLE IF NOT EXISTS log_status_matricula (
    id SERIAL PRIMARY KEY,
    matricula_id INT,
    status_anterior VARCHAR(20),
    status_novo VARCHAR(20),
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Passo B: Criar a função com a lógica do disparo
CREATE OR REPLACE FUNCTION fn_log_status_matricula()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.status IS DISTINCT FROM NEW.status) THEN
        INSERT INTO log_status_matricula (matricula_id, status_anterior, status_novo)
        VALUES (OLD.id, OLD.status, NEW.status);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Passo C: Instalar o Gatilho na tabela matricula_aluno
CREATE OR REPLACE TRIGGER tg_auditoria_matricula
AFTER UPDATE ON matricula_aluno
FOR EACH ROW
EXECUTE FUNCTION fn_log_status_matricula();

-- Teste da trigger
SELECT * FROM log_status_matricula;


-- =======================================================================================
-- TRIGGER 2: HISTÓRICO DE AUDITORIA DE ALTERAÇÃO DE NOTAS
-- =======================================================================================

-- Passo A: Criar a tabela de logs de notas
CREATE TABLE IF NOT EXISTS log_alteracao_notas (
    id SERIAL PRIMARY KEY,
    matricula_id INT,
    nota_alterada VARCHAR(10),
    valor_anterior NUMERIC(4,2),
    valor_novo NUMERIC(4,2),
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Passo B: Criar a função da Trigger
CREATE OR REPLACE FUNCTION fn_log_alteracao_notas()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.nota1 IS DISTINCT FROM NEW.nota1) THEN
        INSERT INTO log_alteracao_notas (matricula_id, nota_alterada, valor_anterior, valor_novo)
        VALUES (OLD.id, 'NOTA 1', OLD.nota1, NEW.nota1);
    END IF;

    IF (OLD.nota2 IS DISTINCT FROM NEW.nota2) THEN
        INSERT INTO log_alteracao_notas (matricula_id, nota_alterada, valor_anterior, valor_novo)
        VALUES (OLD.id, 'NOTA 2', OLD.nota2, NEW.nota2);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Passo C: Instalar o Gatilho
CREATE OR REPLACE TRIGGER tg_log_notas
AFTER UPDATE ON matricula_aluno
FOR EACH ROW
EXECUTE FUNCTION fn_log_alteracao_notas();

-- Teste da trigger
SELECT * FROM log_alteracao_notas;

-- =======================================================================================
-- TRIGGER 3: LIMITADOR DE MATRÍCULAS POR ALUNO (MÁXIMO 6 DISCIPLINAS)
-- =======================================================================================

CREATE OR REPLACE FUNCTION fn_limitar_maximo_matriculas()
RETURNS TRIGGER AS $$
DECLARE
    total_matriculas INT;
BEGIN
    -- Conta quantas matrículas com status 'MATRICULADO' o aluno já possui
    SELECT COUNT(*) INTO total_matriculas 
    FROM matricula_aluno 
    WHERE aluno_id = NEW.aluno_id AND status = 'MATRICULADO';

    -- Se já atingiu o limite de 6, impede a inserção da próxima
    IF (total_matriculas >= 6) THEN
        RAISE EXCEPTION 'Matrícula Recusada: O aluno já atingiu o limite máximo de 6 disciplinas permitidas para este semestre.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tg_limite_matriculas
BEFORE INSERT ON matricula_aluno
FOR EACH ROW
EXECUTE FUNCTION fn_limitar_maximo_matriculas();

-- Teste Trigger
SELECT COUNT(*) AS total_atual FROM matricula_aluno 
WHERE aluno_id = 14 AND status = 'MATRICULADO';


-- =======================================================================================
-- TRIGGER 4: IMPEDIR DUPLICIDADE DE MATRÍCULA NA MESMA DISCIPLINA
-- =======================================================================================

CREATE OR REPLACE FUNCTION fn_impedir_matricula_duplicada()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se já existe um registo para o mesmo aluno na mesma disciplina com status ativo
    IF EXISTS (
        SELECT 1 FROM matricula_aluno 
        WHERE aluno_id = NEW.aluno_id 
          AND disciplina_id = NEW.disciplina_id 
          AND status = 'MATRICULADO'
    ) THEN
        RAISE EXCEPTION 'Matrícula Recusada: O aluno já se encontra matriculado nesta disciplina.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tg_impedir_duplicidade_matricula
BEFORE INSERT ON matricula_aluno
FOR EACH ROW
EXECUTE FUNCTION fn_impedir_matricula_duplicada();

-- Teste Trigger
SELECT * FROM matricula_aluno WHERE aluno_id = 14 AND disciplina_id = 6;



