package br.com.alunoonline.api.controller;

import br.com.alunoonline.api.dtos.DadosCadastroAluno;
import br.com.alunoonline.api.dtos.DadosDetalhamentoAluno;
import br.com.alunoonline.api.model.Aluno;
import br.com.alunoonline.api.service.AlunoService;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;


@RestController
@RequestMapping("/alunos")
@SecurityRequirement(name = "bearer-key")
public class AlunoController {

    @Autowired
    AlunoService alunoService;

    @PostMapping
    @ResponseStatus (HttpStatus.CREATED)
    public DadosDetalhamentoAluno criarAluno(@RequestBody @Valid DadosCadastroAluno dados) {
        return alunoService.criarAluno(dados); }

    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public List<DadosDetalhamentoAluno> listarTodosAlunos(){
        return alunoService.listarTodosAlunos();
    }

    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public DadosDetalhamentoAluno buscarAlunoPorId(@PathVariable Long id){
        return alunoService.buscarAlunoPorId(id);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deletarAlunoPorId(@PathVariable Long id){
       alunoService.deletarAlunoPorId(id);
    }

    @PutMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public DadosDetalhamentoAluno atualizarAlunoPorId(@PathVariable Long id, @RequestBody @Valid DadosCadastroAluno dados){
        return alunoService.atualizarAlunoPorId(id, dados);
    }


}
