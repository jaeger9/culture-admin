package kr.go.culture.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.*;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.ControllerAdvice;

@Configuration
@EnableGlobalMethodSecurity(
        prePostEnabled = true,
        securedEnabled = true,
        jsr250Enabled = true
)
@Import(
        {
                WebMvcConfiguration.class,
        }
)
@ComponentScans(
        {
                @ComponentScan(
                        basePackages = "kr.go.culture",
                        includeFilters = {
                                @ComponentScan.Filter(
                                        type = FilterType.ANNOTATION,
                                        classes = {Controller.class, ControllerAdvice.class}
                                )
                        },
                        excludeFilters = {
                                @ComponentScan.Filter(
                                        type = FilterType.ANNOTATION,
                                        classes = {Service.class, Repository.class}
                                )
                        },
                        useDefaultFilters = false
                )
        }
)
public class WebConfiguration {

    private static Logger logger = LoggerFactory.getLogger(WebConfiguration.class);

    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer();
        configurer.setLocations(
                new ClassPathResource("application.properties"),
                new ClassPathResource("multipart.properties")
        );
        configurer.setIgnoreUnresolvablePlaceholders(true);
        configurer.setIgnoreResourceNotFound(true);
        return configurer;
    }

    @Bean
    public MessageSource messageSource() {
        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        messageSource.setBasenames("messages");
        messageSource.setDefaultEncoding("UTF-8");
        return messageSource;
    }

}

