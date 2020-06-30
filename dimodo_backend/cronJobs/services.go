package cronJobs

import (
	"database/sql"
	"dimodo_backend/crawler"
	"dimodo_backend/models"
	"dimodo_backend/utils"
	"dimodo_backend/utils/mail"

	"errors"
	"fmt"
	"time"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gchaincl/dotsql"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/lib/pq"
	"github.com/robfig/cron"
)

type CronServices struct {
	crawler *crawler.Crawler
	// api     *api.API
	cron *cron.Cron
	DB   *sql.DB
	dot  *dotsql.DotSql
}

func NewCronServices(c *crawler.Crawler, db *sql.DB) *CronServices {
	cronDot, _ := dotsql.LoadFromFile("sql/cronJobs.pgsql")
	return &CronServices{
		crawler: c,
		// api:     api,
		cron: cron.New(),
		DB:   db,
		dot:  cronDot,
	}
}

func (cs *CronServices) Run() {
	// cs.remindPaymentByEmail()
	// cs.crawler.UpdateProducts()
	cs.cron.Start()

}

func (cs *CronServices) remindPaymentByEmail() error {

	//at every 8 pm
	err := cs.cron.AddFunc("0 2 14 * * ?", func() {
		start := time.Now()
		cronMessage := errors.New("   reminding payments by email...")
		bugsnag.Notify(cronMessage)

		//find orders that
		//1. have been unfulfilled for more than 12 hrs
		//2. have not been reminded of payment
		rows, err := cs.dot.Query(cs.DB, "GetUnfulfilledOrders")
		if err != nil {
			fmt.Println("fail to GetUnfulfilledOrders: ", err)
			bugsnag.Notify(err)
		}
		for rows.Next() {
			var order models.Order
			// var ordererEmail string
			if err := rows.Scan(
				&order.Id,
				&order.Total_discounts,
				&order.Total_fee,
				&order.Date_created,
			); err != nil {
				fmt.Println("fail to scan: ", err)
			}

			if utils.GetHoursPassed(order.Date_created) > 12 {
				err := mail.SendEmail(mail.CEOMail, "qkrghdqja71@gmail.com", "Transfer to get your products!")
				if err != nil {
					fmt.Println(err)
					bugsnag.Notify(err)
					return
				}
				_, err = cs.dot.Exec(cs.DB, "setIsRemindedTrue", order.Id)
				if err != nil {
					fmt.Println("fail to updateOrder: ", err)
					bugsnag.Notify(err)
				}
			}

		}
		elapsed := time.Since(start)

		crawlTime := fmt.Errorf("reminding all unfulfilled orders took %s", elapsed)
		bugsnag.Notify(crawlTime)
	})
	if err != nil {
		fmt.Println(err)
		bugsnag.Notify(err)
	}
	return err
}

// func (cs CronServices) updateProductInfo() {
// 	err := cs.cron.AddFunc("0 0 3 * * ?", func() {
// 		start := time.Now()
// 		cronMessage := errors.New("   updating products...")
// 		bugsnag.Notify(cronMessage)

// 		rows, err := cs.DB.Query()
// 		if err != nil {
// 			bugsnag.Notify(cronMessage)
// 		}

// 		elapsed := time.Since(start)

// 		crawlTime := fmt.Errorf("updating all products prices %s", elapsed)
// 		bugsnag.Notify(crawlTime)
// 	})
// 	if err != nil {
// 		fmt.Println(err)
// 		bugsnag.Notify(err)
// 	}
// }
