package br.com.alunoonline.api.service;

import br.com.alunoonline.api.MatriculaAlunoStatusEnum;
import br.com.alunoonline.api.dtos.AtualizarNotasRequestDTO;
import br.com.alunoonline.api.model.Disciplina;
import br.com.alunoonline.api.model.MatriculaAluno;
import br.com.alunoonline.api.repository.MatriculaAlunoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class MatriculaAlunoService {

    @Autowired
    MatriculaAlunoRepository matriculaAlunoRepository;

    private static final Double MEDIA_PARA_APROVACAO = 7.0;

    public void criarMatricula(MatriculaAluno matriculaAluno){
        matriculaAluno.setStatus(MatriculaAlunoStatusEnum.MATRICULADO);
        matriculaAlunoRepository.save(matriculaAluno);
    }

    public void trancarMatricula(Long id){

        // 1- Buscar matrícula antes de atualizar, se não existe 404 not found
        MatriculaAluno matriculaAluno = matriculaAlunoRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        // 2- Só pode trancar se tiver MATRICULADO
        if (matriculaAluno.getStatus()
        .equals(MatriculaAlunoStatusEnum.MATRICULADO)) {
            matriculaAluno.setStatus(
                    MatriculaAlunoStatusEnum.TRANCADO);

            matriculaAlunoRepository.save(matriculaAluno);
        }else {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Só é possível trancar com status MATRICULADO");
        }
    }

    public void atualizarNotas(Long id, AtualizarNotasRequestDTO dto){
        // 1- Buscar matrícula
        MatriculaAluno matricula =
                matriculaAlunoRepository.findById(id)
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                                "Matrícula não encontrada!"));

        // 2- Só atualiza o que veio preenchido (PATCH parcial!)
        if (dto.getNota1() != null)
            matricula.setNota1(dto.getNota1());
        if (dto.getNota2() != null)
            matricula.setNota2(dto.getNota2());

        // 3- Se as 2 notas existem, calcula média e define status
        if (matricula.getNota1() != null
                && matricula.getNota2() != null) {
            Double media = (matricula.getNota1() + matricula.getNota2()) / 2;
            matricula.setStatus(media >= MEDIA_PARA_APROVACAO
                                        ? MatriculaAlunoStatusEnum.APROVADO
                                        : MatriculaAlunoStatusEnum.REPROVADO);
        }

        // 4- Salvar a matrícula atualizada
        matriculaAlunoRepository.save(matricula);
    }

    public void deletarMatriculaPorId(Long id) {
        if (!matriculaAlunoRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Matrícula não encontrada!");
        }
        matriculaAlunoRepository.deleteById(id);
    }
}
