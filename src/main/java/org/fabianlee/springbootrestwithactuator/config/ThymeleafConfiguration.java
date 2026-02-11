/**
 * Configuration to enable Thymeleaf text template processing
 * Allows processing of .txt files in addition to default HTML templates
 */
package org.fabianlee.springbootrestwithactuator.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;
import org.thymeleaf.templatemode.TemplateMode;

@Configuration
public class ThymeleafConfiguration {

    /**
     * Add a text template resolver for .txt files
     * This allows Thymeleaf to process text templates in addition to HTML
     */
    @Bean
    public ClassLoaderTemplateResolver textTemplateResolver() {
        ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
        resolver.setPrefix("templates/");
        resolver.setSuffix(".txt");
        resolver.setTemplateMode(TemplateMode.TEXT);
        resolver.setCharacterEncoding("UTF-8");
        resolver.setOrder(1);  // Higher priority than default
        resolver.setCacheable(true);
        return resolver;
    }

    /**
     * Register the text template resolver with the template engine
     */
    @Bean
    public SpringTemplateEngine templateEngine(ClassLoaderTemplateResolver textTemplateResolver) {
        SpringTemplateEngine engine = new SpringTemplateEngine();
        engine.addTemplateResolver(textTemplateResolver);
        return engine;
    }
}
