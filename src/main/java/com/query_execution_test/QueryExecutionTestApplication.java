package com.query_execution_test;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.util.ResourceUtils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@SpringBootApplication
@Slf4j
@RequiredArgsConstructor
public class QueryExecutionTestApplication implements CommandLineRunner {
	private final JdbcTemplate jdbcTemplate;
	private final QueryServiceImpl queryService;

	public static void main(String[] args) {
		SpringApplication.run(QueryExecutionTestApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		String query = queryService.getQuery();
		System.out.println(query);
		System.out.println(queryService.getDateCastingQuery());


//		String query = readQueryFromFile();
//		long start = System.currentTimeMillis();
//		log.info("Query execution started");
//		jdbcTemplate.execute(query);
//		log.info("Query execution completed");
//		long end = System.currentTimeMillis();
//		log.info("Time taken to execute the query: {} minutes", (end - start) / 60000.0);
	}

	private String readQueryFromFile() throws IOException {
		File file = ResourceUtils.getFile("classpath:" + "query.sql");
		return new String(Files.readAllBytes(file.toPath()));
	}
}
