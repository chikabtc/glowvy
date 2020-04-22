package crawler

import (
	"dimodo_backend/models"
	"dimodo_backend/models/brandi"
	"dimodo_backend/utils/translate"
	"log"
	"math/rand"
	"strings"
	"time"

	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"

	"github.com/PuerkitoBio/goquery"
	"github.com/bugsnag/bugsnag-go"
	"github.com/gchaincl/dotsql"
	"github.com/lib/pq"
	_ "github.com/lib/pq"
	"golang.org/x/net/html"
)

const brandiAuth = "3b17176f2eb5fdffb9bafdcc3e4bc192b013813caddccd0aad20c23ed272f076_1423639497"

//mainPage-0
//top-1
//brandi: :: t-shirts(13), blouse(15), hoodie(120), vest(19), cardigan(18)
//pants-2
//brandi: :: PANTS(366) pants(50) denim(25) slacks(24) shorts(51) leggings(121)
//dress-3
//brandi: :: onepiece(33) dress(367)
//skirt-4
//brandi: :: skirt(47) miniskirt(48) longskirt(49) SKIRT(365)
//coat-5
//brandi: :: coat(21) jumper(22) jacket(20)
//shoes-6
//brandi: :: sneakers(52) boots(122) heel(54) loader(55) sandal(56)
//lifeware-7
//brandi: :: lifeware(107)
//cosmetics-8
//brandi: :: beauty root(354),

//etc-9
//brandi: :: bags(6) accessories(10) jewerly(119) crossbag(57) clutch(58) shouldebag(59) totebags(60) backpack(123) phonecase(124) wallet(35) scarf(66) hats(34) socks(105) watch(36)eyeware (125) earing(127) necklace(128) ring(129) outer(363) top(364)
//this approach doesn't work..
//47 categories
func (c *Crawler) AddNewProductsByCategories() {
	var categories = make(map[int][]int)
	categories[1] = append(categories[1], 13, 15, 120, 19, 18)
	categories[2] = append(categories[2], 366, 50, 25, 24, 51, 121)
	categories[3] = append(categories[3], 33, 367)
	categories[4] = append(categories[4], 47, 48, 49, 365)
	categories[5] = append(categories[5], 21, 22, 28)
	categories[6] = append(categories[6], 52, 122, 54, 55, 56)
	categories[7] = append(categories[7], 107)
	categories[8] = append(categories[8], 354)
	categories[9] = append(categories[9], 6, 10, 119, 57, 58, 59, 60, 123, 124, 35, 66, 34, 105, 36, 125, 127, 128, 129, 363, 364)
	for parentId, childrenIds := range categories {
		for _, categoryId := range childrenIds {
			fmt.Println("calling product by category:", +categoryId, "parent id: ", parentId)
			c.GetPopularProductsByCategory(parentId, categoryId, 10)
		}
	}
	return
	// c.GetMainProducts()
}

func (c *Crawler) events(i int64) {
	// get api
	i = i * 100
	offset := strconv.FormatInt(i, 10)
	url := "https://cf-api-c.brandi.me/v1/web/events/4663?&limit=100&offset=" + offset

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("Authorization", brandiAuth)

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	// decode
	var product brandi.MyJsonName
	// fmt.Println(body)
	err := json.Unmarshal(body, &product)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("Error")
	}
	for _, k := range product.Data.ProductGroups[0].Products {
		c.ProductById(k.ID, "events")
	}
	fmt.Println(url)
}

func (c *Crawler) GetPopularProductsByCategory(parentId int, idx int, limit int) {
	// get api
	id := strconv.Itoa(idx)

	limits := strconv.Itoa(limit)

	url := "https://cf-api-c.brandi.me/v1/web/categories/" + id + "/products?offset=0&limit" + limits + "&order=popular&type=all"
	fmt.Println(url)

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("Authorization", brandiAuth)

	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	// decode
	var products brandi.Products
	// fmt.Println(body)
	err = json.Unmarshal(body, &products)
	// dot, _ := dotsql.LoadFromFile("sql/queries/brandi.pgsql")

	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("Error")
	}

	for _, p := range products.Data {

		err := c.CreateProductById(p.ID, "", parentId)

		if err != nil {
			bugsnag.Notify(err)
			fmt.Println(err.Error())
		}
	}
	fmt.Println(url)
	return
}

func (c *Crawler) GetPopularProductsByShopId(idx int, limits int) []models.Product {
	id := strconv.Itoa(idx)
	limit := strconv.Itoa(limits)

	url := "https://cf-api-c.brandi.me/v1/web/sellers/" + id + "/products?offset=0&limit=" + limit + "&type=reg"
	fmt.Println(url)

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("Authorization", brandiAuth)

	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return nil
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)

	var bProducts brandi.Products
	err = json.Unmarshal(body, &bProducts)
	products := make([]models.Product, len(bProducts.Data))

	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("Error")
	}
	translator, _ := translate.NewTranslator()

	for i, p := range bProducts.Data {
		// fmt.Println(p.ID + " cate " + id)
		// time.Sleep(1 * time.Second)
		name, err := translator.TranslateText(translate.Ko, translate.Vi, p.Name)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println(err)
		}
		sid, _ := strconv.Atoi(p.ID)
		id, _ := strconv.Atoi(fmt.Sprint(strconv.Itoa(rand.Intn(1000000)) + p.ID))

		products[i] = models.Product{
			Id:           id,
			Sid:          sid,
			Name:         name,
			Price:        p.Price,
			Sale_percent: p.SalePercent,
			Sale_price:   p.SalePrice,
			Thumbnail:    p.ImageThumbnailURL,
		}

		// sid, _ := strconv.Atoi(p.ID)
		// _, err = c.dot.Exec(c.DB, "AddProductsByShopId",
		// 	sid,
		// 	name,
		// 	p.Price,
		// 	p.SalePercent,
		// 	p.SalePrice,
		// 	p.ImageThumbnailURL,
		// )
		// if err != nil {
		bugsnag.Notify(err)
		// 	fmt.Println("AddProductsByShopId fail to insert:", err)
		// }
		bProducts.Data[i] = p
	}
	return products
}

func (c *Crawler) GetMainProducts() {
	// dot, _ := dotsql.LoadFromFile("sql/queries/brandi.pgsql")

	url := "https://cf-api-c.brandi.me/v1/web/main?version=42&is-web=true"
	fmt.Println("GetMainProducts: ", url)
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Add("Authorization", brandiAuth)
	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var main brandi.MainProducts
	if err := json.Unmarshal(body, &main); err != nil {
		panic(err)
	}

	// translator, _ := translate.NewTranslator()
	var zone1 = main.Data.Zoning1
	var zone2 = main.Data.Zoning2
	var recommend = main.Data.Recommend.Products
	// translator, _ := translate.NewTranslator()

	for _, zone := range zone1 {
		for _, p := range zone.Products {
			//make it async await !! hmm,,, not sure. but they definitely  returned []
			err := c.CreateProductById(p.ID, "trending", 0)

			if err != nil {
				bugsnag.Notify(err)
				fmt.Println(err.Error())
			}
		}
	}

	for _, zone := range zone2 {
		for _, p := range zone.Products {

			err := c.CreateProductById(p.ID, "trending", 0)

			if err != nil {
				bugsnag.Notify(err)
				fmt.Println(err.Error())
			}
		}
	}

	for _, p := range recommend {
		err := c.CreateProductById(p.ID, "trending", 0)

		if err != nil {
			bugsnag.Notify(err)
			fmt.Println(err.Error())
		}
	}
	fmt.Println(url)
	return
}

func (c *Crawler) ProductById(id string, tag string) {
	url := `https://cf-api-c.brandi.me/v1/web/products/` + id

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("Authorization", brandiAuth)

	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	// decode
	// var product models.Product
	var bProduct brandi.Product

	err = json.Unmarshal(body, &bProduct)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("Error")
	}

	dot, _ := dotsql.LoadFromFile("sql/queries/brandi.pgsql")

	_, err = dot.Exec(c.DB, "sqlCreateProducts",
		bProduct.Data.ID,
		bProduct.Data.Price,
		bProduct.Data.Name,
		bProduct.Data.CategoryId,
		bProduct.Data.ImageThumbnailURL,
		bProduct.Data.AddInfo,
		tag,
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println(err.Error())
	}

	_, err = dot.Exec(c.DB, "createBrandiSeller",
		bProduct.Data.Seller.KakaoTalkID,
		bProduct.Data.Seller.KakaoYellowID,
		bProduct.Data.Seller.Email,
		bProduct.Data.Seller.ID,
		bProduct.Data.Seller.Telephone,
		bProduct.Data.Seller.Name,
		bProduct.Data.Seller.EnName,
		bProduct.Data.Seller.Address1,
		bProduct.Data.Seller.BookmarkCount,
		bProduct.Data.Seller.BusinessInfo.BusinessName,
		bProduct.Data.Seller.BusinessInfo.BusinessCode,
		bProduct.Data.Seller.BusinessInfo.RepresentativeName,
		bProduct.Data.Seller.BusinessInfo.MailOrderBusinessCode)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println(err.Error())
	}
	fmt.Println(bProduct.Data.Seller.ID)
}

func (c *Crawler) ProductDetailById(bProductId string) error {
	url := "https://cf-api-c.brandi.me/v1/web/products/" + bProductId
	fmt.Println(url)
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Add("Authorization", brandiAuth)
	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return err
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var bp brandi.Product
	if err := json.Unmarshal(body, &bp); err != nil {
		panic(err)
		return err
	}

	translator, _ := translate.NewTranslator()
	desc, _ := translator.TranslateText(translate.Ko, translate.Vi, Description(bp.Data.Text))
	if desc == "" {
		desc = " "
	}

	//type conversion from BrandiProduct to dimodoProduct
	var productOptions = []models.Option{}
	var translatedOptions = bp.Data.Options

	for i, option := range bp.Data.Options {
		var newOption = option
		//translate the title only once
		for index, attribute := range option.Attributes {
			title, _ := translate.PpgTranslateText(translate.Ko, translate.Vi, attribute.Title)
			value, _ := translate.PpgTranslateText(translate.Ko, translate.Vi, attribute.Value)
			newOption.Attributes[index].Title = title
			newOption.Attributes[index].Value = value
		}
		translatedOptions[i] = newOption
		productOptions = append(productOptions, newOption)
	}

	var seller = models.Seller{}
	seller.ID = bp.Data.Seller.ID

	// fmt.Printf("seller info : %v \n", bp.Data.Seller)

	optionBytes, _ := json.Marshal(productOptions)
	sizeDetailBytes, _ := json.Marshal(SizeDetail(bp.Data.Text))

	_, err = c.dot.Exec(c.DB, "AddProductDetailsById",
		bp.Data.ID,
		bp.Data.Price,
		bp.Data.SalePrice,
		bp.Data.SalePercent,
		bp.Data.PurchaseCount,
		desc,
		pq.Array(SliderImages(bp)),
		pq.Array(ImagesFromHTML(bp.Data.Text)),
		optionBytes,
		seller,
		sizeDetailBytes,
		// bp.Data.CategoryId[0].ID,
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("AddProductDetailsById: ", err.Error())
		return err
	}
	return err
}

//private crawler usually used to run by hands
func (c *Crawler) CreateProductById(bProductId string, tag string, cateId int) error {
	//check if the product doesn't exist in the db --> avoid wasting computing resources
	var isProductAvailable bool
	row, err := c.dot.QueryRow(c.DB, "CheckProduct", bProductId)

	if err != nil {
		fmt.Println("fail to run sql:", err)
		bugsnag.Notify(err)
		return nil
	}

	if err := row.Scan(&isProductAvailable); err != nil {
		fmt.Println("fail to scan review", err)
		return nil
	}

	if isProductAvailable {
		fmt.Println("attempted to create a new product when a product already exists")
		// bugsnag.Notify(errors.New("attempted to create a new product when a product already exists"))
		return nil
	}

	url := "https://cf-api-c.brandi.me/v1/web/products/" + bProductId
	fmt.Println("createProductByID: ", url)
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Add("Authorization", brandiAuth)
	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return err
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var bp brandi.Product
	if err := json.Unmarshal(body, &bp); err != nil {
		bugsnag.Notify((err))
		return err
	}

	translator, _ := translate.NewTranslator()
	desc, _ := translator.TranslateText(translate.Ko, translate.Vi, Description(bp.Data.Text))
	// fmt.Println("this is descr: ", desc)
	name, _ := translator.TranslateText(translate.Ko, translate.Vi, Description(bp.Data.Name))
	if name == " " || len(name) < 4 || name == "[" {
		return fmt.Errorf("both translator fails to translate properly")
	}
	//type conversion from BrandiProduct to dimodoProduct
	var productOptions = []models.Option{}
	var translatedOptions = bp.Data.Options

	for i, option := range bp.Data.Options {
		var newOption = option
		//translate the title only once
		for index, attribute := range option.Attributes {
			title, _ := translate.PpgTranslateText(translate.Ko, translate.Vi, attribute.Title)
			value, _ := translate.PpgTranslateText(translate.Ko, translate.Vi, attribute.Value)
			newOption.Attributes[index].Title = title
			newOption.Attributes[index].Value = value
		}
		translatedOptions[i] = newOption
		productOptions = append(productOptions, newOption)
	}

	var seller = models.Seller{}
	seller.ID = bp.Data.Seller.ID

	// fmt.Printf("seller info : %v \n", bp.Data.Seller)

	optionBytes, _ := json.Marshal(productOptions)
	sizeDetailBytes, _ := json.Marshal(SizeDetail(bp.Data.Text))
	// var tags []string
	// tags = append(tags, "")

	_, err = c.dot.Exec(c.DB, "CreateProduct",
		bp.Data.ID,
		name,
		bp.Data.Price,
		bp.Data.SalePrice,
		bp.Data.SalePercent,
		bp.Data.PurchaseCount,
		bp.Data.Images[0].ImageMediumURL,
		desc,
		pq.Array(SliderImages(bp)),
		pq.Array(ImagesFromHTML(bp.Data.Text)),
		optionBytes,
		seller,
		sizeDetailBytes,
		cateId,
		tag,
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CreateProductById: ", err.Error())
		return err
	}
	return err
}

func (c *Crawler) GetPhotoReviewsFromBrandi(bProductId string, offset, limit string) *brandi.Reviews {
	//recursive fetching... just like the brandi when the user clicks the reviews then call more
	photoReviewURL := "https://cf-api-v2.brandi.me/v2/web/products/" + bProductId + "/reviews?version=28&limit=" + limit + "&offset=" + offset + "&tab-type=photo"

	// fmt.Println(photoReviewURL)
	req, _ := http.NewRequest("GET", photoReviewURL, nil)
	req.Header.Add("Authorization", brandiAuth)
	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return nil
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var reviews brandi.Reviews
	if err := json.Unmarshal(body, &reviews); err != nil {
		panic(err)
	}
	translator, _ := translate.NewTranslator()

	for _, r := range reviews.Data {
		// fmt.Println(r.ID + " review ")
		// time.Sleep(1 * time.Second)
		text, err := translator.TranslateText(translate.Ko, translate.Vi, r.Text)
		var images []string

		for _, image := range r.Images {
			if image.ImageURL != "" {
				fmt.Println("image url", image.ImageURL)
				images = append(images, image.ImageURL)
			}
		}

		if err != nil {
			bugsnag.Notify(err)
			fmt.Println(err)
		}

		_, err = c.dot.Exec(c.DB, "CreateReviews",
			bProductId,
			r.ID,
			r.User.Name,
			text,
			pq.Array(images),
		)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println(err.Error())
		}
	}
	//save images... what is the best way to save a list of images???????

	//todo: save to the db

	return &reviews
}
func (c *Crawler) GetTextReviewsFromBrandi(bProductId string, offset, limit string) *brandi.Reviews {
	textReviewURL := "https://cf-api-v2.brandi.me/v2/web/products/" + bProductId + "/reviews?version=28&limit=" + limit + "&offset=" + offset + "&tab-type=text"

	fmt.Println(textReviewURL)
	req, _ := http.NewRequest("GET", textReviewURL, nil)
	req.Header.Add("Authorization", brandiAuth)
	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return nil
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var reviews brandi.Reviews
	if err := json.Unmarshal(body, &reviews); err != nil {
		panic(err)
	}
	//todo: save to the db
	translator, _ := translate.NewTranslator()
	for _, r := range reviews.Data {
		// fmt.Println(" review id", r.ID)
		// time.Sleep(1 * time.Second)
		text, err := translator.TranslateText(translate.Ko, translate.Vi, r.Text)
		// images := make([]string, len(reviews.Data))

		if err != nil {
			bugsnag.Notify(err)
			fmt.Println(err)
		}

		_, err = c.dot.Exec(c.DB, "CreateReviews",
			bProductId,
			r.ID,
			r.User.Name,
			text,
			nil,
		)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println(err.Error())
		}
	}

	return &reviews
}

//Images  imgs out of html string
func ImagesFromHTML(s string) []string {
	var imgs []string
	doc, err := html.Parse(strings.NewReader(s))
	if err != nil {
		bugsnag.Notify(err)
		log.Fatal(err)
	}
	var f func(*html.Node)
	f = func(n *html.Node) {
		if n.Type == html.ElementNode && n.Data == "img" {
			for _, a := range n.Attr {
				if a.Key == "src" {
					img := strings.ReplaceAll(a.Val, `\"`, "")
					imgs = append(imgs, img)
					break
				}
			}
		}
		for c := n.FirstChild; c != nil; c = c.NextSibling {
			f(c)
		}
	}
	f(doc)
	// fmt.Println(imgs)
	return imgs
}
func SliderImages(bp brandi.Product) []string {
	var imgs []string
	for _, img := range bp.Data.Images {
		imgs = append(imgs, img.ImageURL)
	}
	// fmt.Println(imgs)
	return imgs
}

//Descriptions s texts out of html string
func Description(s string) string {
	p := strings.NewReader(s)
	doc, _ := goquery.NewDocumentFromReader(p)
	doc.Find("brandiProductInfoHeader").Remove()
	doc.Find("style").Remove()
	doc.Find("thead").Each(func(i int, el *goquery.Selection) {
		el.Remove()
	})
	doc.Find("tbody").Each(func(i int, el *goquery.Selection) {
		el.Remove()
	})

	doc.Find("script").Each(func(i int, el *goquery.Selection) {
		el.Remove()
	})
	doc.Find(".brandiProductSizeInfo").Remove()
	//iterate different sizes (s, m, l, free)
	//iterate the <td> tag. The first tag that has "class="brandiSelectedTxt" will be the size.
	doc.Find("brandiProductSizeInfo").Remove()

	// fmt.Println("description", doc.Text())
	return doc.Text()
}

//todo: need fucking comments as to why sizeDetails need to be list
func SizeDetail(s string) []models.SizeDetail {
	translator, _ := translate.NewTranslator()

	var sizeDetails []models.SizeDetail
	p := strings.NewReader(s)
	doc, _ := goquery.NewDocumentFromReader(p)
	var sizeHeaders []string
	//iterate over the size type. ex) arm hole. Store them inside a sizeDetail attributes title
	doc.Find(".brandiProductSizeInfo thead td").Each(func(i int, s *goquery.Selection) {
		sizeHeaders = append(sizeHeaders, s.Text())
		// fmt.Printf("sizeTypel %d: %s\n", i, s.Text())
	})
	//iterate different sizes (s, m, l, free)
	//iterate the <td> tag. The first tag that has "class="brandiSelectedTxt" will be the size.
	doc.Find(".brandiProductSizeInfo tbody tr").Each(func(i int, s *goquery.Selection) {
		var sizeDetail models.SizeDetail
		//iterate over the size detail and create sizeDetail object
		//append sizeDetail object per iteration
		s.Find("td").Each(func(i int, s *goquery.Selection) {
			size, _ := translator.TranslateText(translate.Ko, translate.Vi, sizeHeaders[i])

			sizeDetail.Attributes = append(sizeDetail.Attributes, models.Attribute{
				Title: size,
				Value: s.Text(),
			})
			// fmt.Printf("sizeDetail %d: %s\n", i, s.Text())
		})
		sizeDetails = append(sizeDetails, sizeDetail)
	})
	// fmt.Println("sizeDetails:", sizeDetails)
	return sizeDetails
}

//ProductEtcInfo s the etc info like elasticity from HTML string
func ProductEtcInfo(s string) models.ProductEtcInfo {
	var etcInfo models.ProductEtcInfo
	p := strings.NewReader(s)
	doc, _ := goquery.NewDocumentFromReader(p)

	//iterate over different etc info elasticity
	//TODO: refactor the temp attribs parts. There must be a way to write less codes.
	doc.Find(".brandiProductEtcInfo tr").Each(func(i int, s *goquery.Selection) {
		var attribs []string
		s.Find(".brandiSelectedTxt").Each(func(i int, s *goquery.Selection) {
			attribs = append(attribs, s.Text())
		})
		etcInfo.Attributes = append(etcInfo.Attributes, models.Attribute{
			Title: attribs[0],
			Value: attribs[1],
		})
	})
	fmt.Println(etcInfo)
	return etcInfo
}

// =============================================================================
// Private Functions
// =============================================================================
func (c *Crawler) ImageThumbnailByProductId(bProductId string) (string, error) {

	url := "https://cf-api-c.brandi.me/v1/web/products/" + bProductId
	fmt.Println("getting thumbnail: ", url)
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Add("Authorization", brandiAuth)
	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return "", err
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var bp brandi.Product
	if err := json.Unmarshal(body, &bp); err != nil {
		return "", err
	}

	fmt.Println("medium url", bp.Data.Images[0].ImageMediumURL)

	return bp.Data.Images[0].ImageMediumURL, nil
}
