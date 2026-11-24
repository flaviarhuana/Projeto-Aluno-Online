package br.com.alunoonline.api.dtos;

import br.com.alunoonline.api.model.Professor;

public record DadosDetalhamentoProfessor (
        Long id,
        String nome,
        String email,
        String cpf
){
    public DadosDetalhamentoProfessor(Professor professor) {
        this(professor.getId(), professor.getNome(), professor.getEmail(), professor.getCpf());
    }
}
