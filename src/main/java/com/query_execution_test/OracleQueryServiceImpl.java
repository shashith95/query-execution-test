package com.query_execution_test;

public class OracleQueryServiceImpl extends QueryServiceImpl {
    @Override
    public String getDateCastingQuery() {
        return "ORACLE";
    }
}
