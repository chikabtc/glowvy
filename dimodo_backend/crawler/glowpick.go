package crawler

import (
	"dimodo_backend/models/glowpick"
	"encoding/csv"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"strconv"

	"os"
	"time"

	userAgent "github.com/EDDYCJY/fake-useragent"
	"github.com/bugsnag/bugsnag-go"
	"github.com/gocolly/colly"
	"github.com/gocolly/colly/extensions"
)

const glowPickAuth = "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJnbG93cGljay53ZWIiLCJpYXQiOjE1OTM3NDE1MzUsInN1YiI6Imdsb3dwaWNrLWF1dGgiLCJpc3MiOiJnbG93ZGF5eiIsImV4cCI6MTU5MzgyNzkzNSwiYXVkIjoiSTRXWmlNbTg1YmppUDlaTzI4VUJncC8zSkYvZVpuSlpueURsOWp0cGx2N3AyaVRrL0VVWmhINDgwN0p0dzhwRGFxZjhlZmJCc2FTeTh1RCtpMXZaWVE9PSJ9.He1EiN05Cknz9qAiD2PV8GfwMnRkL8tkDYHo-IIsbWM"

//parentid always 2
//category: idx
//serum and essence: 2
//cleanser: 32
//cream: 4

//skin type
//all
//sensitive
//oily
//mix
//normal
//dry

//need to be careful when the order is price or others not rank
//should not change the rank of the products if the order is not rank
func (c *Crawler) GetGlowPickProductsByRank(level, categoryId, limit int, skinType, order string) error {

	url := "https://api-j.glowpick.com/api/ranking/category/" + fmt.Sprint(level) + "/" + fmt.Sprint(categoryId) + "?id=" + fmt.Sprint(categoryId) + "&idBrandCategory=&order=" + order + "&limit=" + fmt.Sprint(limit) + "&skinType=" + fmt.Sprint(skinType) + "&level=" + fmt.Sprint(level) + "&offset=0"
	fmt.Println(url)

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("Authorization", glowPickAuth)

	client := http.Client{Timeout: time.Second * 30}
	res, err := client.Do(req)
	if err != nil {
		fmt.Println("Error")

		bugsnag.Notify(err)
		return err
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var GlowPickProducts glowpick.GlowPickProducts
	err = json.Unmarshal(body, &GlowPickProducts)

	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("Error")
	}

	for i, p := range GlowPickProducts.Products {
		fmt.Println("title: " + p.ProductTitle + "rank: i")

		err = c.createGlowPickProductById(fmt.Sprint(p.IDProduct), skinType, categoryId, level, i+1)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println("Error")
		}
	}

	return err
}

func (c *Crawler) createGlowPickProductById(id, skinType string, category, level, rank int) error {
	var isProductAvailable bool
	row, err := c.GlowpickDot.QueryRow(c.DB, "CheckProduct", id)

	if err != nil {
		fmt.Println("fail to run sql:", err)
		bugsnag.Notify(err)
		return nil
	}

	if err := row.Scan(&isProductAvailable); err != nil {
		fmt.Println("fail to scan review", err)
		return nil
	}

	url := "https://api-j.glowpick.com/api/product/" + id
	fmt.Println("createProductByID: ", url)
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Add("Authorization", glowPickAuth)
	random := userAgent.Random()
	log.Printf("Random: %s", random)
	req.Header.Set("User-Agent", random)
	r := rand.Intn(5)
	time.Sleep(time.Duration(r) * time.Microsecond)
	// randomProxyIndex := rand.Intn(len(proxies))
	// proxyUrl, err := netUrl.Parse(proxies[randomProxyIndex])
	// , Transport: &http.Transport{Proxy: http.ProxyURL(proxyUrl)}
	client := http.Client{Timeout: time.Second * 50}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return err
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var glwProduct glowpick.GlowpickDetailedProduct

	if err := json.Unmarshal(body, &glwProduct); err != nil {
		bugsnag.Notify((err))
		return err
	}
	//parentCategory
	//save the most specific category
	// var categoryId = convertCategoryID(category)
	var categoryId = int(glwProduct.Data.CategoryInfo[0].IDThirdCategory)

	if !isProductAvailable {
		fmt.Println("glow pick product title:", glwProduct.Data.ProductTitle)

		_, err = c.GlowpickDot.Exec(c.DB, "CreateProduct",
			glwProduct.Data.IDProduct,
			glwProduct.Data.ProductTitle,
			glwProduct.Data.Volume,
			glwProduct.Data.Price,
			glwProduct.Data.ReviewCount,
			glwProduct.Data.RatingAvg,
			glwProduct.Data.ProductImg,
			glwProduct.Data.IsDiscontinue,
			glwProduct.Data.Brand.IDBrand,
			glwProduct.Data.Brand.BrandTitle,
			glwProduct.Data.Brand.BrandImg,
			glwProduct.Data.Description,
			categoryId,
		)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println("CreateProduct: ", err.Error())
			return err
		}
		// if glwProduct.Data.ReviewGraph.PositiveReview.Contents != "" {
		// 	_, err = c.GlowpickDot.Exec(c.DB, "CreateReview",
		// 		glwProduct.Data.IDProduct,
		// 		glwProduct.Data.ReviewGraph.PositiveReview.Register.Nickname,
		// 		glwProduct.Data.ReviewGraph.PositiveReview.Register.SkinType,
		// 		glwProduct.Data.ReviewGraph.PositiveReview.Register.Age,
		// 		glwProduct.Data.ReviewGraph.PositiveReview.ReviewID,
		// 		glwProduct.Data.ReviewGraph.PositiveReview.Contents,
		// 		glwProduct.Data.ReviewGraph.PositiveReview.Rating,
		// 	)
		// 	if err != nil {
		// 		bugsnag.Notify(err)
		// 		fmt.Println("CreateReview: ", err.Error())
		// 		return err
		// 	}
		// }
		// if glwProduct.Data.ReviewGraph.NegativeReview.Contents != "" {
		// 	_, err = c.GlowpickDot.Exec(c.DB, "CreateReview",
		// 		glwProduct.Data.IDProduct,
		// 		glwProduct.Data.ReviewGraph.NegativeReview.Register.Nickname,
		// 		glwProduct.Data.ReviewGraph.NegativeReview.Register.SkinType,
		// 		glwProduct.Data.ReviewGraph.NegativeReview.Register.Age,
		// 		glwProduct.Data.ReviewGraph.NegativeReview.ReviewID,
		// 		glwProduct.Data.ReviewGraph.NegativeReview.Contents,
		// 		glwProduct.Data.ReviewGraph.NegativeReview.Rating,
		// 	)
		// 	if err != nil {
		// 		bugsnag.Notify(err)
		// 		fmt.Println("CreateReview: ", err.Error())
		// 		return err
		// 	}
		// }

	}

	idx, err := strconv.Atoi(id)
	//if general, then set the general
	if level == 2 {
		categoryId = int(glwProduct.Data.CategoryInfo[0].IDSecondCategory)
	}
	err = c.setProductRankBySkinType(skinType, categoryId, level, idx, rank)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("setProductRank: ", err.Error())
		return err
	}
	err = c.addTags(glwProduct)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("addTags: ", err.Error())
		return err
	}
	return err
}

func (c *Crawler) addTags(product glowpick.GlowpickDetailedProduct) error {
	var err error
	for _, tag := range product.Data.Keywords {
		row, err := c.GlowpickDot.Exec(c.DB, "AddTag", tag, product.Data.IDProduct)
		if err != nil {
			fmt.Println("AddTag: ", err)
			bugsnag.Notify(err)
		}

		fmt.Println("tag name :" + tag + " sid :" + fmt.Sprint(product.Data.IDProduct))
		//if the tag already exists, then insert the tag to the product_tags
		//if the tag that belongs to the product exists, then do nothing
		if row != nil {
			fmt.Println("nil row")

			var isProductTagExists bool

			row, err := c.GlowpickDot.QueryRow(c.DB, "checkIfTagForProductExists", tag, product.Data.IDProduct)
			row.Scan(&isProductTagExists)

			if err != nil {
				fmt.Println("checkIfTagForProductExists :", err)
				bugsnag.Notify(err)
			}
			if !isProductTagExists {
				_, err = c.GlowpickDot.Exec(c.DB, "AddTagToProductTags", tag, product.Data.IDProduct)
				if err != nil {
					fmt.Println("AddTagToProductTags :", err)
					// bugsnag.Notify(err)
				}
			}
		}
	}
	return err
}

//level 1 has no ranking
//level 2 is the parent category like Skin Care
//level 3 is the specific category
func (c *Crawler) setProductRankBySkinType(skinType string, categoryId, level, productId, rank int) error {
	var err error
	//specific category rank
	switch skinType {
	case "all":
		_, err = c.GlowpickDot.Exec(c.DB, "SetAllSkinRank", rank, categoryId, productId)
		if err != nil {
			fmt.Println(err)
			return err
		}

	case "sensitive":
		_, err = c.GlowpickDot.Exec(c.DB, "SetSensitiveSkinRank", rank, categoryId, productId)
		if err != nil {
			fmt.Println(err)
			return err
		}
	case "oily":
		_, err = c.GlowpickDot.Exec(c.DB, "SetOilySkinRank", rank, categoryId, productId)
		if err != nil {
			fmt.Println(err)
			return err
		}
	case "dry":
		_, err = c.GlowpickDot.Exec(c.DB, "SetDrySkinRank", rank, categoryId, productId)
		if err != nil {
			fmt.Println(err)
			return err
		}
		// bugsnag.Notify(errors.New("attempted to create a new product when a product already exists"))
	}
	return err
}

func getFacialCleanserRanking() {
	fileName := "faicle_cleanser_glowpick.csv"
	file, err := os.Create(fileName)
	if err != nil {
		log.Fatalf("Could not create %s", fileName)
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	err = writer.Write([]string{"ProductName", "Brand", "volumne", "Thumbnail", "Review Count", "Stars", "Price"})
	if err != nil {
		fmt.Println("fail to write to csv file: ", err)
	}

	c := colly.NewCollector(
		colly.Async(true),
	)

	c.Limit(&colly.LimitRule{
		RandomDelay: 2 * time.Second,
		Parallelism: 4,
	})

	extensions.RandomUserAgent(c)

	// proxySwitcher, err := proxy.RoundRobinProxySwitcher("socks5://188.226.141.127:1080", "socks5://67.205.132.241:1080")
	// if err != nil {
	// 	log.Fatal(err)
	// }
	// c.SetProxyFunc(proxySwitcher)

	c.OnRequest(func(r *colly.Request) {
		fmt.Println("Visiting", r.URL)
		fmt.Println("UserAgent", r.Headers.Get("User-Agent"))
	})

	c.OnHTML("section.section-list", func(e *colly.HTMLElement) {
		e.ForEach("div.list-item", func(_ int, e *colly.HTMLElement) {
			var productName, brand, volumne, stars, reviewCount, price, thumbnail string

			productName = e.ChildText("p.details__labels__name")
			brand = e.ChildText("p.details__labels__brand")
			volumne = e.ChildText("span.details__labels__price-volume__volume")

			thumbnail = e.ChildAttr("div.image product-image__detail image--loaded", "aria-label")
			reviewCount = e.ChildText("span.details__score__reviews")

			if productName == "" {
				// If we can't get any name, we return and go directly to the next element
				return
			}

			stars = e.ChildText("span.details__score__rating")
			// utils.FormatStars(&stars)

			price = e.ChildText("span.details__labels__price-volume__price")
			// utils.FormatPrice(&price)

			err := writer.Write([]string{
				productName,
				brand,
				volumne,
				thumbnail,
				reviewCount,
				stars,
				price,
			})
			if err != nil {
				fmt.Println(err)
			}
			fmt.Println("productName" + productName + " brand: " + brand + " volumne: " + volumne + " thumbnail: " + thumbnail + "stars: " + stars + " reviewCount: " + reviewCount + " price: " + price)

		})
	})

	fullURL := fmt.Sprintf("https://www.glowpick.com/beauty/ranking?id=32&level=2&gender=f&age=20early,20late&skin_type=all&min_price=0&max_price=198000")
	c.Visit(fullURL)

	c.Wait()
}
