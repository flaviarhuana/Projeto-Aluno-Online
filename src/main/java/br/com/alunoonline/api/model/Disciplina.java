package br.com.alunoonline.api.model;

import jakarta.persistence.*;
import lombok.*;

@Table(name = "disciplina")
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Disciplina {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;
    private Integer cargaHoraria;

    @ManyToOne
    @JoinColumn(name = "professor_id")
    private Professor professor;
}
