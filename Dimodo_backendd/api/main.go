package api

import (
	"dimodo_backend/api/controllers"
	"dimodo_backend/models"
	"fmt"

	"flag"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gorilla/mux"
)

type API struct {
	r   *mux.Router
	cs  Controllers
	ms  *models.Services
	cfg *Config
}

type Controllers struct {
	userC    *controllers.User
	addressC *controllers.Address
	productC *controllers.Product
	cartC    *controllers.Cart
}

//NewAPI loads configuration files and initializes the router, DB, models, and controller objects.
func NewAPI() *API {
	boolPtr := flag.Bool("prod", false, "Provide a flag in prodction. This ensures that a config.json file is provided before the application starts")
	flag.Parse()
	//boolPtr is a pointer to a boolean, so we need to use
	//*boolPtr to get the boolean value and pass it into our
	//LoadingConfig function
	cfg := LoadConfig(*boolPtr)
	dbCfg := cfg.Database

	ms, err := models.NewServices(
		models.WithDB(dbCfg.Dialect(), dbCfg.ConnectionInfo()),
		models.WithAddress(),
		models.WithProduct(),
		models.WithCart(),
		models.WithMail(cfg.Domain),
		models.WithUser(cfg.HMACKey),
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Errorf(err.Error())
		panic(err)
	}

	cs := Controllers{
		userC:    controllers.NewUser(ms.User, ms.Mail, cfg.Name, cfg.Domain),
		addressC: controllers.NewAddress(ms.Address),
		cartC:    controllers.NewCart(ms.Cart),
		productC: controllers.NewProduct(ms.Product),
	}

	a := API{
		r:   mux.NewRouter(),
		cs:  cs,
		ms:  ms,
		cfg: &cfg,
	}

	fmt.Println("Project -", cfg.Name)
	fmt.Println("Database Successfully connected!")
	fmt.Println("Run Port :", cfg.Port)
	return &a
}

func (a *API) Run() {
	a.InitializeRoutes()
	// a.CORS()
	defer a.ms.Close()
}
