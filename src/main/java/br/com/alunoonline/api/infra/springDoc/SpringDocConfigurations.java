package br.com.alunoonline.api.infra.springDoc;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.*;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SpringDocConfigurations {
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .components(new Components()
                        .addSecuritySchemes("bearer-key",
                                new SecurityScheme()
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")))
                .info(new Info()
                        .title("Aluno Online API")
                        .description("API Rest da aplicação Aluno Online, contendo as funcionalidades de CRUD de alunos, professores e matrículas")
                        .contact(new Contact()
                                .name("Time Backend")
                                .email("backend@alunoonline.com"))
                        .license(new License()
                                .name("Apache 2.0")
                                .url("http://aluno_online/api/licenca")));
    }
}
