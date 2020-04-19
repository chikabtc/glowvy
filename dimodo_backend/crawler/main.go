package crawler

import (
	"database/sql"
	"fmt"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gchaincl/dotsql"
)

type crawler struct {
	DB  *sql.DB
	dot *dotsql.DotSql
}

//NewAPI loads configuration files and initializes the router, DB, models, and controller objects.
func NewCrawler() *crawler {
	//boolPtr is a pointer to a boolean, so we need to use
	//*boolPtr to get the boolean value and pass it into our
	//LoadingConfig function
	cfg := LoadConfig(false)
	dbCfg := cfg.Database

	db, err := sql.Open(dbCfg.Dialect(), dbCfg.ConnectionInfo())
	if err != nil {
		bugsnag.Notify(err)
		panic(err)
	}

	dot, _ := dotsql.LoadFromFile("sql/queries/brandi.pgsql")

	c := crawler{
		DB:  db,
		dot: dot,
	}

	fmt.Println("Project -", cfg.Name)
	fmt.Println("Database Successfully connected!")
	fmt.Println("Run Port :", cfg.Port)
	return &c
}
