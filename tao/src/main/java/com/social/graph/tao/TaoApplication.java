package com.social.graph.tao;

import com.social.graph.tao.model.AssociationType;
import com.social.graph.tao.service.impl.DefaultAssociationService;
import com.social.graph.tao.service.impl.DefaultObjectNodeService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.UUID;


@SpringBootApplication
public class TaoApplication {

	public static void main(String[] args) {
		SpringApplication.run(TaoApplication.class, args);
	}


	@Bean
	public CommandLineRunner init(DefaultObjectNodeService service, DefaultAssociationService aService) {
		return  args -> {
			aService.createAssociation(
					UUID.fromString("0c83d9fb-ece7-49f8-9441-1005533e38f5"),
					UUID.fromString("8ccb0c85-6e45-4637-840f-de4583bc7edc"),
					AssociationType.CREATED);
		};
	}
}
