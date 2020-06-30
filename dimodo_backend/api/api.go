package api

import (
	"dimodo_backend/api/controllers"
	"dimodo_backend/crawler"
	"dimodo_backend/models"
	"dimodo_backend/utils"
	"fmt"

	"flag"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gorilla/mux"
)

type API struct {
	R   *mux.Router
	Cs  Controllers
	Ms  *models.Services
	Cfg *Config
}

type Controllers struct {
	UserC    *controllers.User
	AddressC *controllers.Address
	ProductC *controllers.Product
	CartC    *controllers.Cart
}

//NewAPI loads configuration files and initializes the router, DB, models, and controller objects.
func NewAPI(crawler *crawler.Crawler) *API {
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
		models.WithCosmetics(),
		models.WithCart(),
		models.WithMail(cfg.Domain),
		models.WithUser(cfg.HMACKey),
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Errorf(err.Error())
		panic(err)
	}

	slack := utils.NewSlackService()

	cs := Controllers{
		UserC:    controllers.NewUser(ms.User, ms.Mail, cfg.Name, cfg.Domain),
		AddressC: controllers.NewAddress(ms.Address),
		CartC:    controllers.NewCart(ms.Cart, slack),
		ProductC: controllers.NewProduct(ms.Product, ms.Cosmetics, crawler),
	}

	a := API{
		R:   mux.NewRouter(),
		Cs:  cs,
		Ms:  ms,
		Cfg: &cfg,
	}

	fmt.Println("Project -", cfg.Name)
	fmt.Println("Database Successfully connected!")
	fmt.Println("Run Port :", cfg.Port)
	return &a
}

func (a *API) Run() {
	a.InitializeRoutes()
	// a.CORS()
	defer a.Ms.Close()
}
