package crawler

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"os"
	"time"

	"github.com/bugsnag/bugsnag-go"
	_ "github.com/lib/pq"
)

type Config struct {
	Name     string         `json:"name"`
	Port     int            `json:"port"`
	Env      string         `json:"env"`
	Domain   string         `json:"domain"`
	Host     string         `json:"host"`
	HMACKey  string         `json:"hmac_key"`
	Database PostgresConfig `json:"database"`
}
type PostgresConfig struct {
	Host     string `json:"host"`
	Port     int    `json:"port"`
	User     string `json:"user"`
	Password string `json:"password"`
	Name     string `json:"name"`
	SslMode  string `json:"sslmode"`
}

func DefaultConfig() Config {
	return Config{
		Name:     "DIMODO_Crawlers_dev",
		Port:     3000,
		Env:      "dev",
		Domain:   "dimodo.app",
		Host:     "localhost",
		HMACKey:  "BDdj5htFONoZpUeErXMsTfbI01YVKQmc7l9Ai2vaqnCH8uG6Sgx43RPJwLkWyz",
		Database: DefaultPostgresConfig(),
	}
}

func LoadConfig(configReq bool) Config {
	f, err := os.Open("crawler.config")
	if err != nil {
		bugsnag.Notify(err)
		if configReq {
			panic(err)
		}
		fmt.Println("Using the default config...")
		return DefaultConfig()
	}

	var c Config
	dec := json.NewDecoder(f)
	err = dec.Decode(&c)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("crawler config", err)
		panic(err)
	}
	//if all goes well, return the loaded config
	fmt.Println("successfully loaded .config")
	return c
}

func DefaultPostgresConfig() PostgresConfig {
	return PostgresConfig{
		Host:     "localhost",
		Port:     5432,
		User:     "present",
		Password: "your-password",
		Name:     "dimodo",
		SslMode:  "disable",
	}
}

func (c PostgresConfig) Dialect() string {
	return "postgres"
}

func (c PostgresConfig) ConnectionInfo() string {
	if c.Password == "" {
		return fmt.Sprintf("user=%s dbname=%s host=%s port=%d sslmode=%s", c.User, c.Name, c.Host, c.Port, c.SslMode)
	}
	return fmt.Sprintf("user=%s password=%s dbname=%s host=%s port=%d sslmode=%s",
		c.User, c.Password, c.Name, c.Host, c.Port, c.SslMode)
}

func (c Config) IsProd() bool {
	return c.Env == "prod"
}

func init() {
	rand.Seed(time.Now().UnixNano())
}
