package com.social.graph.tao;

import com.social.graph.tao.service.ObjectNodeService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class TaoApplication {

	public static void main(String[] args) {
		SpringApplication.run(TaoApplication.class, args);
	}


	@Bean
	public CommandLineRunner init(ObjectNodeService service) {
		return  args -> {
			service.save("0894b3bd-7c4c-4bcd-a58b-dd5ef98a61ca", "8e518f4f-e980-49cd-9212-f33216e0a85d");
		};
	}
}
