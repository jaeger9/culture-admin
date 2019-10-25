package kr.go.culture.config;

import egovframework.rte.psl.orm.ibatis.SqlMapClientFactoryBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.support.lob.DefaultLobHandler;
import org.springframework.jdbc.support.lob.LobHandler;

import javax.annotation.Resource;
import javax.sql.DataSource;

@Configuration
public class OrmConfiguration {
    private static final Logger logger = LoggerFactory.getLogger(OrmConfiguration.class);

    @Resource(name = "dataSource-ck")
    private DataSource ckDataSource;

    @Resource(name = "dataSource-culture")
    private DataSource cultureDataSource;

    @Resource(name = "dataSource-culdata")
    private DataSource culdataDataSource;

    @Bean(name = "lobHandler")
    public LobHandler lobHandler() {
        return new DefaultLobHandler();
    }

    @Bean(name = "sqlMapClient-ck")
    public SqlMapClientFactoryBean sqlMapClient() {
        SqlMapClientFactoryBean factoryBean = new SqlMapClientFactoryBean();
        factoryBean.setConfigLocations(new org.springframework.core.io.Resource[]{
                new ClassPathResource("ibatis/conf/ibatis-oracle-config.xml")
        });
        PathMatchingResourcePatternResolver pathMatchingResourcePatternResolver = new PathMatchingResourcePatternResolver();

        org.springframework.core.io.Resource[] mappingResources = null;

        try {
            mappingResources = pathMatchingResourcePatternResolver.getResources("classpath:ibatis/sql/oracle/ck/**/*.xml");
        } catch (Exception e) {
            logger.info("Notfound any mappings to create SqlMapClient");
            mappingResources = new org.springframework.core.io.Resource[]{};
        }

        factoryBean.setMappingLocations(mappingResources);

        factoryBean.setDataSource(ckDataSource);
        factoryBean.setLobHandler(lobHandler());

        return factoryBean;
    }

    @Bean(name = "sqlMapClient-culdata")
    public SqlMapClientFactoryBean sqlMapCuldataClient() {
        SqlMapClientFactoryBean factoryBean = new SqlMapClientFactoryBean();
        factoryBean.setConfigLocations(new org.springframework.core.io.Resource[]{
                new ClassPathResource("ibatis/conf/ibatis-oracle-config.xml")
        });
        PathMatchingResourcePatternResolver pathMatchingResourcePatternResolver = new PathMatchingResourcePatternResolver();

        org.springframework.core.io.Resource[] mappingResources = null;

        try {
            mappingResources = pathMatchingResourcePatternResolver.getResources("classpath:ibatis/sql/oracle/ck/**/*.xml");
        } catch (Exception e) {
            logger.info("Notfound any mappings to create SqlMapClient");
            mappingResources = new org.springframework.core.io.Resource[]{};
        }

        factoryBean.setMappingLocations(mappingResources);

        factoryBean.setDataSource(culdataDataSource);
        factoryBean.setLobHandler(lobHandler());

        return factoryBean;
    }

    @Bean(name = "sqlMapClient-culture")
    public SqlMapClientFactoryBean sqlMapCulturedataClient() {
        SqlMapClientFactoryBean factoryBean = new SqlMapClientFactoryBean();
        factoryBean.setConfigLocations(new org.springframework.core.io.Resource[]{
                new ClassPathResource("ibatis/conf/ibatis-oracle-config.xml")
        });
        PathMatchingResourcePatternResolver pathMatchingResourcePatternResolver = new PathMatchingResourcePatternResolver();

        org.springframework.core.io.Resource[] mappingResources = null;

        try {
            mappingResources = pathMatchingResourcePatternResolver.getResources("classpath:ibatis/sql/oracle/culture/main/**/*.xml");
        } catch (Exception e) {
            logger.info("Notfound any mappings to create SqlMapClient");
            mappingResources = new org.springframework.core.io.Resource[]{};
        }

        factoryBean.setMappingLocations(mappingResources);

        factoryBean.setDataSource(cultureDataSource);
        factoryBean.setLobHandler(lobHandler());

        return factoryBean;
    }

}
