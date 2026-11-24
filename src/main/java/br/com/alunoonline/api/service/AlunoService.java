package br.com.alunoonline.api.service;

import br.com.alunoonline.api.dtos.DadosCadastroAluno;
import br.com.alunoonline.api.dtos.DadosDetalhamentoAluno;
import br.com.alunoonline.api.model.Aluno;
import br.com.alunoonline.api.repository.AlunoRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AlunoService {

    @Autowired
    AlunoRepository alunoRepository;

    public DadosDetalhamentoAluno criarAluno(DadosCadastroAluno dados) {
        var aluno = new Aluno(null, dados.nomeCompleto(), dados.email(), dados.cpf());
        alunoRepository.save(aluno);
        return new DadosDetalhamentoAluno(aluno);
    }
    public List<DadosDetalhamentoAluno> listarTodosAlunos(){
        return alunoRepository.findAll().stream()
                .map(DadosDetalhamentoAluno::new)
                .toList();
    }

    public DadosDetalhamentoAluno buscarAlunoPorId(Long id){
        var aluno = alunoRepository.findById(id)
                .orElseThrow(EntityNotFoundException::new);
        return new DadosDetalhamentoAluno(aluno);
    }

    public void deletarAlunoPorId(Long id){
        alunoRepository.deleteById(id);
    }

    public DadosDetalhamentoAluno atualizarAlunoPorId(Long id, DadosCadastroAluno dados){
        var aluno = alunoRepository.findById(id)
                .orElseThrow(EntityNotFoundException::new);
        aluno.setNomeCompleto(dados.nomeCompleto());
        aluno.setEmail(dados.email());
        aluno.setCpf(dados.cpf());
        alunoRepository.save(aluno);
        return new DadosDetalhamentoAluno(aluno);
    }

}
