package com.uniconn.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class UniConnApplication {

	public static void main(String[] args) {
		SpringApplication.run(UniConnApplication.class, args);
	}

}