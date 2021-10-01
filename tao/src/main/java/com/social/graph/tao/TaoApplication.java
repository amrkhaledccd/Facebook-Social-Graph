package com.social.graph.tao;

import com.social.graph.tao.model.ObjectType;
import com.social.graph.tao.service.impl.DefaultObjectNodeService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import java.util.Arrays;

@SpringBootApplication
public class TaoApplication {

	public static void main(String[] args) {
		SpringApplication.run(TaoApplication.class, args);
	}


	@Bean
	public CommandLineRunner init(DefaultObjectNodeService service) {
		return  args -> {
          service.createObject(ObjectType.USER,
				  Arrays.asList("username:amkhaledccd", "email:amrkhaledccd@hotmail.com"));

			service.createObject(ObjectType.USER,
					Arrays.asList("username:samir", "email:samir@hotmail.com"));
		};
	}
}
