package br.com.alunoonline.api.controller;

import br.com.alunoonline.api.dtos.DadosCadastroProfessor;
import br.com.alunoonline.api.dtos.DadosDetalhamentoProfessor;
import br.com.alunoonline.api.model.Professor;
import br.com.alunoonline.api.service.ProfessorService;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/professores")
@SecurityRequirement(name = "bearer-key")
public class ProfessorController {
    @Autowired
    ProfessorService professorService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public DadosDetalhamentoProfessor criarProfessor(@RequestBody @Valid DadosCadastroProfessor dados){
        return professorService.criarProfessor(dados);
    }

    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public List<DadosDetalhamentoProfessor> listarTodosProfessores(){
        return professorService.listarTodosProfessores();
    }

    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public DadosDetalhamentoProfessor buscarProfessorPorId(@PathVariable Long id){
        return professorService.buscarProfessorPorId(id);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deletarProfessorPorId(@PathVariable Long id){
        professorService.deletarProfessorPorId(id);
    }

    @PutMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public DadosDetalhamentoProfessor atualizarProfessorPorId(@PathVariable Long id, @RequestBody @Valid DadosCadastroProfessor dados){
       return professorService.atualizarProfessorPorId(id, dados);
    }


}
