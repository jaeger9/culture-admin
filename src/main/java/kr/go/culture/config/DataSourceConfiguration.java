package kr.go.culture.config;

import net.sf.log4jdbc.Log4jdbcProxyDataSource;
import net.sf.log4jdbc.tools.Log4JdbcCustomFormatter;
import net.sf.log4jdbc.tools.LoggingType;
import org.apache.commons.dbcp2.BasicDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

import javax.sql.DataSource;

@Configuration
@PropertySource(value = {"classpath:/datasource.properties"})
public class DataSourceConfiguration {

    private final static Logger logger = LoggerFactory.getLogger(DataSourceConfiguration.class);

    @Value(value = "${debug:false}")
    private boolean debug;

    @Value(value = "${culture.url:jdbc:oracle:thin:@175.125.91.223:1521:MCST}")
    private String culture;
    @Value(value = "${culture.username:culture}")
    private String cultureUserName;
    @Value(value = "${culture.password:culture}")
    private String culturePassword;

    @Value(value = "${ck.url:jdbc:oracle:thin:@175.125.91.247:1521:CK11}")
    private String ck;
    @Value(value = "${ck.username:ANCWEBATAL}")
    private String ckUserName;
    @Value(value = "${ck.password:ANCMCT2005}")
    private String ckPassword;

    @Value(value = "${culdata.url:jdbc:oracle:thin:@175.125.91.47:1521:CULDATA1}")
    private String culdata;
    @Value(value = "${culdata.username:culture}")
    private String culUserName;
    @Value(value = "${culdata.password:culture1!}")
    private String culPassword;

    @Bean(name = "dataSource-ck")
    public DataSource ckDataSource() {
        BasicDataSource defaultDataSource = new BasicDataSource();

        defaultDataSource.setDriverClassName("oracle.jdbc.driver.OracleDriver");
        defaultDataSource.setUrl(ck);
        defaultDataSource.setUsername(ckUserName);
        defaultDataSource.setPassword(ckPassword);

        DataSource effectiveDataSource = null;

        if (debug) {
            Log4JdbcCustomFormatter formatter = new Log4JdbcCustomFormatter();
            formatter.setLoggingType(LoggingType.MULTI_LINE);
            formatter.setSqlPrefix("SQL=>");
            Log4jdbcProxyDataSource loggingDataSource = new Log4jdbcProxyDataSource(defaultDataSource);
            loggingDataSource.setLogFormatter(formatter);

            effectiveDataSource = loggingDataSource;
        } else {
            effectiveDataSource = defaultDataSource;
        }

        logger.info("dataSource Created with effectiveDataSource = {}", effectiveDataSource.toString());
        return effectiveDataSource;
    }

    @Bean(name = "dataSource-culture")
    public DataSource cultureDataSource() {
        BasicDataSource defaultDataSource = new BasicDataSource();

        defaultDataSource.setDriverClassName("oracle.jdbc.driver.OracleDriver");
        defaultDataSource.setUrl(culture);
        defaultDataSource.setUsername(cultureUserName);
        defaultDataSource.setPassword(culturePassword);

        DataSource effectiveDataSource = null;

        if (debug) {
            Log4JdbcCustomFormatter formatter = new Log4JdbcCustomFormatter();
            formatter.setLoggingType(LoggingType.MULTI_LINE);
            formatter.setSqlPrefix("SQL=>");
            Log4jdbcProxyDataSource loggingDataSource = new Log4jdbcProxyDataSource(defaultDataSource);
            loggingDataSource.setLogFormatter(formatter);

            effectiveDataSource = loggingDataSource;
        } else {
            effectiveDataSource = defaultDataSource;
        }

        logger.info("dataSource Created with effectiveDataSource = {}", effectiveDataSource.toString());
        return effectiveDataSource;
    }


    @Bean(name = "dataSource-culdata")
    public DataSource culdataeDataSource() {
        BasicDataSource defaultDataSource = new BasicDataSource();

        defaultDataSource.setDriverClassName("oracle.jdbc.driver.OracleDriver");
        defaultDataSource.setUrl(culdata);
        defaultDataSource.setUsername(culUserName);
        defaultDataSource.setPassword(culPassword);

        DataSource effectiveDataSource = null;

        if (debug) {
            Log4JdbcCustomFormatter formatter = new Log4JdbcCustomFormatter();
            formatter.setLoggingType(LoggingType.MULTI_LINE);
            formatter.setSqlPrefix("SQL=>");
            Log4jdbcProxyDataSource loggingDataSource = new Log4jdbcProxyDataSource(defaultDataSource);
            loggingDataSource.setLogFormatter(formatter);

            effectiveDataSource = loggingDataSource;
        } else {
            effectiveDataSource = defaultDataSource;
        }

        logger.info("dataSource Created with effectiveDataSource = {}", effectiveDataSource.toString());
        return effectiveDataSource;
    }
}
