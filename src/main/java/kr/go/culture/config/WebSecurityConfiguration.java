package kr.go.culture.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.security.authentication.encoding.BaseDigestPasswordEncoder;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;

import javax.annotation.Resource;

@EnableWebSecurity
public class WebSecurityConfiguration extends WebSecurityConfigurerAdapter {
    private static final Logger logger = LoggerFactory.getLogger(WebSecurityConfiguration.class);

    @Resource(name = "adminAuthenticationSuccessHandler")
    private AuthenticationSuccessHandler authenticationSuccessHandler;

//    @Resource(name = "adminAuthenticationFailureHandler")
//    private AuthenticationFailureHandler authenticationFailureHandler;

    @Resource(name = "UserService")
    private UserDetailsService userDetailsService;

    @Resource(name = "MD5MessageDigestPasswordEncoder")
    private BaseDigestPasswordEncoder passwordEncoder;

    @Override
    // @formatter:off
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {

        auth
                .userDetailsService(userDetailsService)
                .passwordEncoder(passwordEncoder)
        ;
    }
    // @formatter:on

    @Bean
    public HttpFirewall allowUrlEncodedPercentAndSemicolonHttpFirewall() {
        StrictHttpFirewall firewall = new StrictHttpFirewall();
        firewall.setAllowUrlEncodedPercent(true);
        firewall.setAllowSemicolon(true);
        return firewall;
    }

    @Override
    // @formatter:off
    public void configure(WebSecurity web) throws Exception {
        super.configure(web);

        web.ignoring().antMatchers(
                new String[]{
                        "/favicon.ico",
                        "/css/**",
                        "/images/**",
                        "/js/**",
                        "/mail/**",
                        "/font/**",
                        "/assets/**"
                }
        )
                .and()

                .httpFirewall(allowUrlEncodedPercentAndSemicolonHttpFirewall());
    }
    // @formatter:on

    @Override
    // @formatter:off
    protected void configure(HttpSecurity http) throws Exception {
        logger.debug("Using culture Web Security Configuration configure(HttpSecurity).");

        http
                .authorizeRequests()
                .antMatchers(new String[]{
                        "/**/**insert**.do",
                        "/**/**/**insert**.do",
                        "/**/**update**.do",
                        "/**/**/**update**.do",
                        "/**/**delete**.do",
                        "/**/**/**delete**.do",
                        "/**/**form.do",
                        "/**/**/**form.do"
                }).authenticated()
                //.antMatchers("/member/findId.do").access("hasRole('ROLE_USER')")
                .antMatchers(new String[]{
                        "/login.do",
                }).permitAll()
                .and()

                .formLogin()
                    .loginPage("/login.do")
                    .defaultSuccessUrl("/index.do")
                    .failureUrl("/loginfailed.do")
                    .loginProcessingUrl("/j_spring_security_check.do")
                    .usernameParameter("j_username")
                    .passwordParameter("j_password")
                    .successHandler(authenticationSuccessHandler)
    //                .failureHandler(authenticationFailureHandler)
                .and()
                    .logout()
                    .logoutSuccessUrl("/logout.do")
                    .invalidateHttpSession(false)
                .and()
                    .anonymous()
                .and()
                    .exceptionHandling().accessDeniedPage("/loginaccessdenied.do")
                .and()
                    .sessionManagement()
                    .sessionFixation().none()
                .and()
                    .httpBasic().disable()
                    .csrf().disable()
                    .headers()
                    .frameOptions().sameOrigin()
                    .httpStrictTransportSecurity()
                    .maxAgeInSeconds(0)
                .includeSubDomains(true)
        ;
    }
    // @formatter:on
}
