package main

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

type Order struct {
	ID       string  `json:"id"`
	Product  string  `json:"product"`
	Quantity int     `json:"quantity"`
	Price    float64 `json:"price"`
}

var orders = []Order{
	{ID: "1", Product: "Widget A", Quantity: 2, Price: 9.99},
	{ID: "2", Product: "Widget B", Quantity: 1, Price: 24.99},
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
}

func ordersHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(orders)
}

func main() {
	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/orders", ordersHandler)
	http.Handle("/metrics", promhttp.Handler())

	log.Println("orders-api listening on :8083")
	if err := http.ListenAndServe(":8083", nil); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
