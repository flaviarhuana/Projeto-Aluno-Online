package br.com.alunoonline.api.dtos;

import jakarta.validation.constraints.NotBlank;

public record DadosCadastroAluno (
        @NotBlank(message = "Nome completo é obrigatório!")
        String nomeCompleto,

        @NotBlank(message = "Email é obrigatório!")
        String email,

        @NotBlank(message = "CPF é obrigatório!")
        String cpf
){
}
