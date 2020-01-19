package com.frontend;

import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.annotation.WebFilter;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
@ServletComponentScan
@WebFilter(urlPatterns = "/japi/*", filterName = "ApiFilter")
public class MCApiFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        String author = request.getHeader("X-Login-User");
        response.setContentType("application/json; charset=utf-8");
        if (request.getMethod().toUpperCase() == "POST" && (author != null || !author.isEmpty())) {
            response.setStatus(401);
            response.getWriter().write("you must login first!");
        } else {
            response.setHeader("Access-Control-Allow-Origin", request.getHeader("Origin"));
            response.setHeader("Access-Control-Allow-Headers","x-requested-with");
            filterChain.doFilter(request, response);
        }
    }
}
