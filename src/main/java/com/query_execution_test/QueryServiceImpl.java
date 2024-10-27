package com.query_execution_test;

public abstract class QueryServiceImpl {
    public abstract String getDateCastingQuery();

    public String getQuery() {
        return "SELECT * FROM TABLE";
    }
}
