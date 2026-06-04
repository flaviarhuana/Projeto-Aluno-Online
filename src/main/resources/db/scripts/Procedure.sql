-- =======================================================================================
-- PROCEDURE: ARREDONDAMENTO ESPECÍFICO (MÉDIA DE 6.51 A 6.99 VIRA 7.0)
-- =======================================================================================

CREATE OR REPLACE PROCEDURE pr_arredondar_medias_proximas()
LANGUAGE plpgsql AS $$
DECLARE
    r_matricula RECORD;
    v_media NUMERIC(4,2);
    v_nova_nota2 NUMERIC(4,2);
BEGIN
    -- Varre as matrículas ativas que possuem as duas notas preenchidas
    FOR r_matricula IN 
        SELECT id, nota1, nota2 
        FROM matricula_aluno 
        WHERE status = 'MATRICULADO' 
          AND nota1 IS NOT NULL 
          AND nota2 IS NOT NULL
    LOOP
        -- Calcula a média real atual com precisão de duas casas decimais
        v_media := ROUND((r_matricula.nota1 + r_matricula.nota2) / 2, 2);

        -- Condição cirúrgica: Só entra se a média estiver entre 6.51 e 6.99
        -- Captura exatamente os casos de médias 6.6, 6.7, 6.8 e 6.9
        IF (v_media > 6.50 AND v_media < 7.00) THEN
            
            -- Para a média virar 7.0, a soma das duas notas precisa ser exatamente 14.0
            v_nova_nota2 := 14.00 - r_matricula.nota1;

            -- Faz o ajuste na tabela original e aprova o aluno
            UPDATE matricula_aluno
            SET nota2 = v_nova_nota2,
                status = 'APROVADO'
            WHERE id = r_matricula.id;

            -- Exibe no log do banco o ajuste que foi feito
            RAISE NOTICE 'RASTREAMENTO -> Matrícula ID %: Média antiga % corrigida para 7.00. Nota 2 alterada para %.', 
                r_matricula.id, v_media, v_nova_nota2;
        END IF;
    END LOOP;
    
    RAISE NOTICE 'Varredura de arredondamento finalizada!';
END;
$$;

-- Varrer todas as médias e arredondar
CALL pr_arredondar_medias_proximas();

-- Teste funcionamento da Procedure
SELECT id, nota1, nota2, status FROM matricula_aluno WHERE id = 1;