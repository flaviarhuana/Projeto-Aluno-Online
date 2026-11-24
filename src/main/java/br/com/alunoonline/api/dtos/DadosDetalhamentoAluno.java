package br.com.alunoonline.api.dtos;

import br.com.alunoonline.api.model.Aluno;

public record DadosDetalhamentoAluno (
        Long id,
        String nomeCompleto,
        String email,
        String cpf
) {
    public DadosDetalhamentoAluno(Aluno aluno) {
        this(aluno.getId(), aluno.getNomeCompleto(), aluno.getEmail(), aluno.getCpf());
    }
}
