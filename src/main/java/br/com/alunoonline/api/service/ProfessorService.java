package br.com.alunoonline.api.service;

import br.com.alunoonline.api.dtos.DadosCadastroProfessor;
import br.com.alunoonline.api.dtos.DadosDetalhamentoProfessor;
import br.com.alunoonline.api.model.Professor;
import br.com.alunoonline.api.repository.ProfessorRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProfessorService {
    @Autowired
    ProfessorRepository professorRepository;

    public DadosDetalhamentoProfessor criarProfessor(DadosCadastroProfessor dados){
        var professor = new Professor(null, dados.nome(), dados.email(), dados.cpf());
        professorRepository.save(professor);
        return new DadosDetalhamentoProfessor(professor);
    }

    public List<DadosDetalhamentoProfessor> listarTodosProfessores(){
        return professorRepository.findAll().stream()
                .map(DadosDetalhamentoProfessor::new)
                .toList();
    }

    public DadosDetalhamentoProfessor buscarProfessorPorId(Long id){
        var professor = professorRepository.findById(id)
                .orElseThrow(EntityNotFoundException::new);
        return new DadosDetalhamentoProfessor(professor);
    }

    public void deletarProfessorPorId(Long id){
        professorRepository.deleteById(id);
    }

    public DadosDetalhamentoProfessor atualizarProfessorPorId(Long id, DadosCadastroProfessor dados){
        var professor = professorRepository.findById(id)
                .orElseThrow(EntityNotFoundException::new);
        professor.setNome(dados.nome());
        professor.setEmail(dados.email());
        professor.setCpf(dados.cpf());
        professorRepository.save(professor);
        return new DadosDetalhamentoProfessor(professor);
    }

}
