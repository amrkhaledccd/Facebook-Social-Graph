package com.social.graph.tao;

import com.social.graph.tao.service.impl.DefaultAssociationService;
import com.social.graph.tao.service.impl.DefaultObjectNodeService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.neo4j.config.EnableNeo4jAuditing;

@SpringBootApplication
@EnableNeo4jAuditing
public class TaoApplication {

	public static void main(String[] args) {
		SpringApplication.run(TaoApplication.class, args);
	}


	@Bean
	public CommandLineRunner init(DefaultObjectNodeService service, DefaultAssociationService aService) {
		return  args -> {

		};
	}
}
