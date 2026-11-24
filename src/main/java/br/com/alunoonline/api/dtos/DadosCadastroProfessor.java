package br.com.alunoonline.api.dtos;

import jakarta.validation.constraints.NotBlank;

public record DadosCadastroProfessor (
        @NotBlank(message = "Nome é obrigatório!")
        String nome,

        @NotBlank(message = "Email é obrigatório!")
        String email,

        @NotBlank(message = "CPF é obrigatório!")
        String cpf
) {
}
