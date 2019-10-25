package kr.go.culture.config;

import kr.go.culture.admin.interceptor.AdminMenuInterceptor;
import nz.net.ultraq.thymeleaf.LayoutDialect;
import nz.net.ultraq.thymeleaf.decorators.strategies.GroupingStrategy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.FileSystemResource;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;
import org.thymeleaf.dialect.IDialect;
import org.thymeleaf.extras.springsecurity4.dialect.SpringSecurityDialect;
import org.thymeleaf.spring4.SpringTemplateEngine;
import org.thymeleaf.spring4.view.ThymeleafViewResolver;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;

@Configuration
public class WebMvcConfiguration extends WebMvcConfigurationSupport {
    private static Logger logger = LoggerFactory.getLogger(WebMvcConfiguration.class);

    @Value(value = "${file.upload.base.location.dir:/data/culture_admin_2015}")
    private String multipartUploadTempDir;
    @Value(value = "${file.upload.size:1000000000}")
    private long multipartMaxUploadSize;
    @Value(value = "#{new Boolean('${culture.thymeleaf.cache:true}')}")
    private Boolean thymeleafCache;

    @Value(value = "${mail.host:mail.kcisa.kr}")
    private String mailHost;
    @Value(value = "${mail.username:culture}")
    private String mailUserName;
    @Value(value = "${mail.password:admin_00}")
    private String mailPassword;
    @Value(value = "${mail.port:25}")
    private int mailPort;
    @Value(value = "${mail.protocol:smtp}")
    private String mailProtocol;
    @Value(value = "${mail.smtp.auth:true}")
    private String mailSmtpAuth;
    @Value(value = "${mail.debug:true}")
    private String mailDebug;

    /*
     AdminMenuInterceptor
     */
    @Bean
    public AdminMenuInterceptor layoutInterceptor() {
        return new AdminMenuInterceptor();
    }

    @Override
    protected void addInterceptors(InterceptorRegistry registry) {
        super.addInterceptors(registry);

        registry.addInterceptor(layoutInterceptor())
                .addPathPatterns("/")
                .addPathPatterns("/*.do")
                .addPathPatterns("/**/*.do");
    }

    @Bean
    public MultipartResolver multipartResolver() throws IOException {
        if (logger.isInfoEnabled()) {
            logger.info("Multipart Configuration with : location={}, {}",
                    multipartUploadTempDir,
                    multipartMaxUploadSize
            );
        }

        CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
        multipartResolver.setUploadTempDir(new FileSystemResource(multipartUploadTempDir));
        multipartResolver.setMaxUploadSize(multipartMaxUploadSize);
        multipartResolver.setDefaultEncoding("UTF-8");
        multipartResolver.setResolveLazily(true);
        return multipartResolver;
    }


    @Override
    protected void addResourceHandlers(ResourceHandlerRegistry registry) {
        super.addResourceHandlers(registry);
    }

    @Override
    protected void configureViewResolvers(ViewResolverRegistry registry) {
        super.configureViewResolvers(registry);

        registry.beanName();

        if (logger.isInfoEnabled()) {
            logger.info("Initialize thymeleaf TemplateResolver with cache = {}", thymeleafCache);
        }

        ClassLoaderTemplateResolver classLoaderTemplateResolver = new ClassLoaderTemplateResolver();
        classLoaderTemplateResolver.setPrefix("/templates/");
        classLoaderTemplateResolver.setSuffix(".html");
        classLoaderTemplateResolver.setCacheable(thymeleafCache);
        classLoaderTemplateResolver.setTemplateMode(TemplateMode.HTML);
        classLoaderTemplateResolver.setCharacterEncoding("UTF-8");
        classLoaderTemplateResolver.setUseDecoupledLogic(false);

        SpringTemplateEngine templateEngine = new SpringTemplateEngine();
        templateEngine.setEnableSpringELCompiler(false);
        templateEngine.setAdditionalDialects(
                new HashSet<IDialect>(
                        Arrays.<IDialect>asList(
                                new LayoutDialect(new GroupingStrategy()),
                                new SpringSecurityDialect()
                        )
                )
        );
        templateEngine.setTemplateResolver(classLoaderTemplateResolver);

        ThymeleafViewResolver thymeleafViewResolver = new ThymeleafViewResolver();
        thymeleafViewResolver.setViewNames(new String[]{"thymeleaf/**"});
        thymeleafViewResolver.setTemplateEngine(templateEngine);

        registry.viewResolver(thymeleafViewResolver);

        registry.jsp("/WEB-INF/views/", ".jsp");

        registry.enableContentNegotiation(new MappingJackson2JsonView());
    }
}
