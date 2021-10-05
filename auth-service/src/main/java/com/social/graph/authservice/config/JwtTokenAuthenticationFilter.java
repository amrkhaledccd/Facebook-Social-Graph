package com.social.graph.authservice.config;

import com.google.gson.Gson;
import com.social.graph.authservice.model.AuthUserDetails;
import com.social.graph.authservice.service.JwtTokenProvider;
import com.social.graph.authservice.service.UserService;
import io.jsonwebtoken.Claims;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Set;

public class JwtTokenAuthenticationFilter extends OncePerRequestFilter {

    private final JwtConfig jwtConfig;
    private JwtTokenProvider tokenProvider;
    private UserService userService;

    public JwtTokenAuthenticationFilter(
            JwtConfig jwtConfig,
            JwtTokenProvider tokenProvider,
            UserService userService) {

        this.jwtConfig = jwtConfig;
        this.tokenProvider = tokenProvider;
        this.userService = userService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        // 1. get the authentication header. Tokens are supposed to be passed in the authentication header
        var header = request.getHeader(jwtConfig.getHeader());
        // 2. validate the header and check the prefix
        if(header == null || !header.startsWith(jwtConfig.getPrefix())) {
            chain.doFilter(request, response);  		// If not valid, go to the next filter.
            return;
        }
        // If there is no token provided and hence the user won't be authenticated.
        // It's Ok. Maybe the user accessing a public path or asking for a token.

        // All secured paths that needs a token are already defined and secured in config class.
        // And If user tried to access without access token, then he won't be authenticated and an exception will be thrown.

        // 3. Get the token
        var token = header.replace(jwtConfig.getPrefix(), "");

        if(tokenProvider.validateToken(token)) {
            Claims claims = tokenProvider.getClaimsFromJWT(token);
            String username = claims.getSubject();

            var auth = userService
                    .findByUsername(username)
                    .map(objectNode -> {
                        var password = objectNode.getData().get("password");
                        var roles =
                                new Gson().<Set<String>>fromJson(objectNode.getData().get("roles"), Set.class);
                        var isActive = Boolean.getBoolean(objectNode.getData().get("isActive"));

                        return new AuthUserDetails(username, password, roles ,isActive);
                    })
                    .map(userDetails -> {
                        var authentication = new UsernamePasswordAuthenticationToken(
                                userDetails, null, userDetails.getAuthorities());

                        authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                        return authentication;
                        })
                        .orElse(null);

            SecurityContextHolder.getContext().setAuthentication(auth);
        } else {
            SecurityContextHolder.clearContext();
        }
        // go to the next filter in the filter chain
        chain.doFilter(request, response);
    }

}
