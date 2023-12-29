package main

import (
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/jwtauth/v5"
	"net/http"
)

func excludeEndpointMiddleware(excludeEndpoint string, middleware func(http.Handler) http.Handler) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		var middlewareNext = middleware(next)
		return http.HandlerFunc(func(writter http.ResponseWriter, request *http.Request) {
			if request.URL.Path != excludeEndpoint {
				middlewareNext.ServeHTTP(writter, request)
			} else {
				next.ServeHTTP(writter, request)
			}
		})
	}
}

func RegisterMiddlewares(router chi.Router, tokenAuth *jwtauth.JWTAuth) {
	router.Use(jwtauth.Verifier(tokenAuth))
	router.Use(excludeEndpointMiddleware("/login", jwtauth.Authenticator(tokenAuth)))
}
