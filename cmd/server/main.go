package main

import (
	"log"
	"net/http"
	"github.com/gorilla/mux"
)

func main() {
    r := mux.NewRouter()
    r.HandleFunc("/", HomeHandler)
    http.Handle("/", r)
    http.ListenAndServe(":8000", nil)
	log.Println("Application started successfully.")

}

func HomeHandler(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("Hello, World!"))
}
