package main

import (
	"dimodo_backend/api"
	"dimodo_backend/crawler"

	"github.com/bugsnag/bugsnag-go"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/lib/pq"
)

func main() {

	bugsnag.Configure(bugsnag.Configuration{
		APIKey: "e01a6cf99f5bdf480b010b80e45f8c66",
		// The import paths for the Go packages containing your source files
		ProjectPackages: []string{"main", "gitlab.com/parkerfreeman/dimodo"},
		ReleaseStage:    "release",

		NotifyReleaseStages: []string{"production"},
	})

	crawler := crawler.NewCrawler()
	api := api.NewAPI(crawler)
	// crawler.GetLocallyPopularProducts()
	// api.Cs.ProductC.Cs.UpdateBrandsName()
	// time.Sleep(2 * time.Second)

	// api.Cs.ProductC.Cs.TranslateAllCosmeticsIngredient()
	// api.Cs.ProductC.Cs.TranslateAllCosmetics()
	// api.Cs.ProductC.Cs.TranslateAllCosmeticsReviews()
	// api.Cs.ProductC.Cs.UpdateCosmeticsIngredient()
	// api.Cs.ProductC.Cs.TranslateAllReviewUserName()
	// crawler.UpdateCosmeticsIngredient()

	// err := crawler.CollectAllOptions()
	// cosmetics, err := api.Cs.ProductC.Cs.AllCosmeticsProducts()

	// // }
	// if err != nil {
	// 	fmt.Println(err)
	// }
	// fmt.Println(cosmetics)

	// index := client.InitIndex("products")
	// res, err := index.SaveObjects(cosmetics, opt.AutoGenerateObjectIDIfNotExist(true))

	// fmt.Println(err)
	// cronServices.Run()
	// all creams

	// =============================================================================
	// make up
	// =============================================================================
	// if err := crawler.GetGlowPickProductsByRank(2, 41, 41, "all", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 41, 41, "sensitive", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 41, 41, "oily", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 41, 41, "dry", "rank"); err != nil {
	// 	fmt.Println(err)
	// }

	// if err := crawler.GetGlowPickProductsByRank(2, 14, 25, "sensitive", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 14, 25, "oily", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 14, 25, "dry", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 14, 25, "all", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 41, 25, "all", "rank"); err != nil {
	// 	fmt.Println(err)
	// }

	// client := search.NewClient("50G6MO803G", "ab5eb7ec7552bb7865f3819a2b08f462")
	// index := client.InitIndex("cosmetics")
	// var products []models.Product
	// products, err := api.Cs.ProductC.Cs.AllCosmeticsProducts()
	// if err != nil {
	// 	return

	// }
	// fmt.Println("err: ", err)

	// fmt.Println("product lenght", len(products))

	// res, err := index.SaveObjects(products, opt.AutoGenerateObjectIDIfNotExist(true))
	// fmt.Println("err: ", res, err)

	// if err != nil {
	// 	fmt.Println("fail to push the data to algolia: ", err)
	// }

	// fmt.Println("err: ", err)

	api.Run()

}
