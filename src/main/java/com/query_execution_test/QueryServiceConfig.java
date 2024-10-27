package com.query_execution_test;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;
import java.sql.Connection;

import static org.springframework.boot.autoconfigure.data.jdbc.JdbcDatabaseDialect.ORACLE;
import static org.springframework.boot.autoconfigure.data.jdbc.JdbcDatabaseDialect.POSTGRESQL;


@Configuration
public class QueryServiceConfig {
    private static final Logger log = LoggerFactory.getLogger(QueryServiceConfig.class);
    private final DataSource dataSource;

    public QueryServiceConfig(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Bean
    public QueryServiceImpl queryFactoryBean() {
        if (getDatabaseType().equals(ORACLE.name())) {
            return new OracleQueryServiceImpl();
        } else {
            return new PostgresQueryGenerator();
        }
    }

    public String getDatabaseType() {
        try (Connection connection = dataSource.getConnection()) {
            String url = connection.getMetaData().getURL();
            return url.contains("jdbc:oracle") ? ORACLE.name() : POSTGRESQL.name(); // Return the database type based on the URL pattern
        } catch (Exception e) {
            log.error("Error while determining database type", e);
            throw new RuntimeException("Error while determining database type", e);
        }
    }
}
