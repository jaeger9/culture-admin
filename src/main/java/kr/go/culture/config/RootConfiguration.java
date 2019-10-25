package kr.go.culture.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.PropertiesFactoryBean;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.jcache.JCacheCacheManager;
import org.springframework.cache.jcache.JCacheManagerFactoryBean;
import org.springframework.context.annotation.*;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.cache.CacheManager;
import javax.sql.DataSource;
import java.io.IOException;
import java.util.Properties;

@EnableCaching
@Configuration
@ComponentScans(
        {
                @ComponentScan(
                        basePackages = "kr.go.culture",
                        includeFilters = {
                                @ComponentScan.Filter(
                                        type = FilterType.ANNOTATION,
                                        classes = {Service.class, Repository.class}
                                )
                        },
                        excludeFilters = {
                                @ComponentScan.Filter(
                                        type = FilterType.ANNOTATION,
                                        classes = {Controller.class}
                                )
                        },
                        useDefaultFilters = false
                )
        }
)
public class RootConfiguration {
    private static Logger logger = LoggerFactory.getLogger(RootConfiguration.class);

    @Bean(name = "application")
    public PropertiesFactoryBean configPropertiesFactoryBean() {
        PropertiesFactoryBean factoryBean = new PropertiesFactoryBean();
        factoryBean.setLocations(new ClassPathResource("application.properties"));

        return factoryBean;
    }

    @Value(value = "#{application['mail.host:mail.kcisa.kr'] ?: 'mail.kcisa.kr'}")
    private String mailHost;
    @Value(value = "#{application['mail.username'] ?: 'culture'}")
    private String mailUserName;
    @Value(value = "#{application['mail.password'] ?: 'admin_00'}")
    private String mailPassword;
    @Value(value = "#{application['mail.port'] ?: '25'}")
    private int mailPort;
    @Value(value = "#{application['mail.protocol'] ?: 'smtp'}")
    private String mailProtocol;
    @Value(value = "#{application['mail.smtp.auth'] ?: 'true'}")
    private String mailSmtpAuth;
    @Value(value = "#{application['mail.debug'] ?: 'true'}")
    private String mailDebug;

    @Bean
    public JCacheManagerFactoryBean jCacheManagerFactoryBean() throws IOException {
        JCacheManagerFactoryBean jCacheManagerFactoryBean = new JCacheManagerFactoryBean();
        jCacheManagerFactoryBean.setCacheManagerUri((new ClassPathResource("ehcache.xml")).getURI());

        return jCacheManagerFactoryBean;
    }

    @Bean
    public JCacheCacheManager jCacheCacheManager(CacheManager cacheManager) {
        return new JCacheCacheManager(cacheManager);
    }

    /**
     * JavaMail
     * @return
     */
    @Bean(name = "mailsender")
    public JavaMailSender mailSender() {

        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();

        mailSender.setHost(mailHost);
        mailSender.setPort(mailPort);
        mailSender.setUsername(mailUserName);
        mailSender.setPassword(mailPassword);

        Properties javaMailProperties = new Properties();

        javaMailProperties.setProperty("mail.transport.protocol",mailProtocol);
        javaMailProperties.setProperty("mail.smtp.auth",mailSmtpAuth);
        javaMailProperties.setProperty("mail.debug",mailDebug);
        mailSender.setJavaMailProperties(javaMailProperties);

        return mailSender;
    }

}
