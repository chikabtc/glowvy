package crawler

import (
	"bufio"
	"dimodo_backend/models"
	"dimodo_backend/models/brandi"
	"dimodo_backend/utils/translate"
	"log"
	"math/rand"
	"os"
	"strings"
	"time"

	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"

	"github.com/PuerkitoBio/goquery"
	"github.com/bugsnag/bugsnag-go"
	"github.com/lib/pq"
	_ "github.com/lib/pq"
	"golang.org/x/net/html"
)

const brandiAuth = "3b17176f2eb5fdffb9bafdcc3e4bc192b013813caddccd0aad20c23ed272f076_1423639497"

//exceptions outer
//cardigan(371)
//16 --> bags in dimodo 6--> bags on brandi

//mainPage-0
//top-1: 40,000
//brandi: :: t-shirts(13), blouse(15), hoodie(120), vest(19), cardigan(18) outer(363) top-big(364), knit(17) short sleeve t shirtS(374) top-knit (375)
//민소매/나시(379)
//셔츠/블라우스(378)

//pants-2 50,000
//brandi: :: big size PANTS(366) denim(25) slacks(24) shorts(51) leggings(121)
//dress-3 50,000
//brandi: :: onepiece(33) dress(367)
//skirt-4 40,000
//brandi: :: skirt(47) miniskirt(48) longskirt(49) SKIRT(365)
//coat-5 50,000
//brandi: :: coat(21) jumper(22) jacket(20)
//shoes-6 70,000
//brandi: :: sneakers(52) boots(122) heel(54) loader(55) loadfer(273) sandal(56) boot(271) SNEAKER(272) 샌들/슬리퍼(275)shoes-etc(387) running(385)
//lifeware-7 50,000
//brandi: :: lifeware(107) underwear(108) panty (402) homeware(109) swimwear (368) set(403) bra(401)
//cosmetics-8 40,000
//brandi: :: beauty root(354), skin care(355) make up (356)  body hair (357) nail and hair (369) inner beauty (358) 360(base) 361(color), nail (369)

//etc-9
//brandi: :: bags(6) accessories(10) jewerly(119) crossbag(57) clutch(58) shouldebag(59) totebags(60) backpack(123) phonecase(124) wallet(35) scarf(66) hats(34) socks(105) watch(36)eyeware (125) earing(127) necklace(128) ring(129)beauty etc(359)
//shoulder bag(278)

//47 categories
//call by category..nope.. need to know all cate.

func (c *Crawler) AddNewProductsByCategories() error {
	var categories = make(map[int][]int)
	var err error
	categories[1] = append(categories[1], 13, 15, 120, 17, 19, 18, 363, 364, 374, 379, 371, 375)
	categories[2] = append(categories[2], 366, 50, 25, 24, 51, 121)
	categories[3] = append(categories[3], 33, 367)
	categories[4] = append(categories[4], 47, 48, 49, 365)
	categories[5] = append(categories[5], 21, 22, 20)
	categories[6] = append(categories[6], 52, 122, 54, 55, 56, 272, 275, 387, 385)
	categories[7] = append(categories[7], 107, 108, 109, 368, 403, 402, 401)
	categories[8] = append(categories[8], 354, 355, 356, 357, 358, 360, 361, 369)
	categories[9] = append(categories[9], 6, 10, 119, 57, 58, 59, 60, 123, 124, 35, 66, 34, 105, 36, 125, 127, 128, 129, 278, 359)
	for parentId, childrenIds := range categories {
		for _, categoryId := range childrenIds {
			fmt.Println("calling product by category:", +categoryId, "parent id: ", parentId)
			err = c.GetPopularProductsByCategory(parentId, categoryId, 5)
			return err
		}
	}
	return err
}

func (c *Crawler) findCategoryId(cateId string) int {
	categoryId, _ := strconv.Atoi(cateId)
	var categories = make(map[int][]int)
	categories[1] = append(categories[1], 13, 15, 120, 17, 19, 18, 363, 364, 374, 379, 371, 375)
	categories[2] = append(categories[2], 366, 50, 25, 24, 51, 121)
	categories[3] = append(categories[3], 33, 367)
	categories[4] = append(categories[4], 47, 48, 49, 365)
	categories[5] = append(categories[5], 21, 22, 20)
	categories[6] = append(categories[6], 52, 122, 54, 55, 56, 272, 275, 387, 385)
	categories[7] = append(categories[7], 107, 108, 109, 368, 403, 402, 401)
	categories[8] = append(categories[8], 354, 355, 356, 357, 358, 360, 361, 369)
	categories[9] = append(categories[9], 6, 10, 119, 57, 58, 59, 60, 123, 124, 35, 66, 34, 105, 36, 125, 127, 128, 129, 278, 359)
	for parentId, childrenIds := range categories {
		for _, cateId := range childrenIds {
			if categoryId == cateId {
				fmt.Println("parentId", parentId)
				return parentId
			}
		}
	}
	f, err := os.OpenFile("unknowncates.txt", os.O_APPEND|os.O_WRONLY, 0600)
	if err != nil {
		panic(err)
	}

	defer f.Close()
	// Splits on newlines by default.
	file, err := os.Open("unknowncates.txt")
	if err != nil {
		return 0
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)

	line := 1
	// https://golang.org/pkg/bufio/#Scanner.Scan
	for scanner.Scan() {
		if strings.Contains(scanner.Text(), cateId) {
			fmt.Println("duplicate it!")
			return 0
		}
		line++
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("fail to scan!", err)
	}

	if _, err = f.WriteString(fmt.Sprint("\n\n ", cateId)); err != nil {
		panic(err)
	}
	f.Close()
	return 0
}

func (c *Crawler) GetPopularProductsByCategory(parentId int, idx int, limit int) error {
	// get api
	id := strconv.Itoa(idx)

	limits := strconv.Itoa(limit)

	url := "https://cf-api-c.brandi.me/v1/web/categories/" + id + "/products?offset=0&limit=" + limits + "&order=popular&type=all"
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
	var products brandi.Products
	err = json.Unmarshal(body, &products)

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
	return err
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
	//translator, _ := translate.NewTranslator()

	for i, p := range bProducts.Data {
		name, err := translate.TranslateText(translate.Ko, translate.Vi, p.Name)
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
		bugsnag.Notify(err)
		bProducts.Data[i] = p
	}
	return products
}

func (c *Crawler) GetMainProducts() error {
	url := "https://cf-api-c.brandi.me/v1/web/main?version=42&is-web=true"
	fmt.Println("GetMainProducts: ", url)
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
	var main brandi.MainProducts
	if err := json.Unmarshal(body, &main); err != nil {
		panic(err)
	}

	var zone1 = main.Data.Zoning1
	var zone2 = main.Data.Zoning2
	var recommend = main.Data.Recommend.Products

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
	return err
}

func (c *Crawler) ProductDetailById(bProductId string) (*models.Product, error) {
	url := "https://cf-api-c.brandi.me/v1/web/products/" + bProductId
	fmt.Println(url)
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Add("Authorization", brandiAuth)
	client := http.Client{Timeout: time.Second * 30}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var bp brandi.Product
	if err := json.Unmarshal(body, &bp); err != nil {
		panic(err)
	}
	sid, _ := strconv.Atoi(bp.Data.ID)
	//options in Korean
	var sProductOptions = []models.Option{}
	//options in vietnaemse
	var productOptions = []models.Option{}

	//just update the sold out property.. it's hard to update...
	//get the title and value from db..? and just update issoldout property.
	//can directly manipulate the jsonb..
	for _, option := range bp.Data.Options {
		var sOption = option
		var newOption = option
		//translate the title only once
		sProductOptions = append(sProductOptions, sOption)
		productOptions = append(productOptions, newOption)
	}

	var seller = models.Seller{}
	seller.ID = bp.Data.Seller.ID

	// sizeDetailBytes, _ := json.Marshal(c.SizeDetail(bp.Data.Text))
	adjustedPrice := int(float64(bp.Data.Price) * 1.1)
	adjustedSalePrice := int(float64(bp.Data.SalePrice) * 1.1)
	cateId, err := strconv.Atoi(bp.Data.CategoryId[0].ID)

	//add tags from brandi
	for _, bTag := range bp.Data.Tags {
		row, err := c.dot.Exec(c.DB, "AddTag", bTag.Name, bp.Data.ID)
		if err != nil {
			fmt.Println(err)
			bugsnag.Notify(err)
		}
		fmt.Println("tag name :" + bTag.Name + " sid :" + bp.Data.ID)

		//if the tag already exists, then insert the tag to the product_tags
		//if the tag that belongs to the product exists, then do nothing
		if row != nil {
			fmt.Println("nil row")

			var isProductTagExists bool

			row, err := c.dot.QueryRow(c.DB, "checkIfTagForProductExists", bTag.Name, bp.Data.ID)
			row.Scan(&isProductTagExists)

			if err != nil {
				fmt.Println(err)
				bugsnag.Notify(err)
			}
			if !isProductTagExists {
				_, err = c.dot.Exec(c.DB, "AddTagToProductTags", bTag.Name, bp.Data.ID)
				if err != nil {
					fmt.Println(err)
					// bugsnag.Notify(err)
				}
			}
		}
	}
	product := models.Product{
		Sid:          sid,
		Price:        adjustedPrice,
		Sale_price:   adjustedSalePrice,
		Sale_percent: bp.Data.SalePercent,
		Options:      productOptions,
		CategoryId:   cateId,
	}
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("AddProductDetailsById: ", err.Error())
		return nil, err
	}
	return &product, err
}

func (c *Crawler) AddTags(bp brandi.Product) error {
	var err error
	for _, bTag := range bp.Data.Tags {
		row, err := c.dot.Exec(c.DB, "AddTag", bTag.Name, bp.Data.ID)
		if err != nil {
			bugsnag.Notify(err)
			return err
		}
		fmt.Println("tag name :" + bTag.Name + " sid :" + bp.Data.ID)

		//if the tag already exists, then insert the tag to the product_tags
		//if the tag that belongs to the product exists, then do nothing
		if row != nil {
			fmt.Println("nil row")

			var isProductTagExists bool

			row, err := c.dot.QueryRow(c.DB, "checkIfTagForProductExists", bTag.Name, bp.Data.ID)
			row.Scan(&isProductTagExists)

			if err != nil {

				fmt.Println("checkIfTagForProductExists: ", err)
				bugsnag.Notify(err)
				return err
			}
			if !isProductTagExists {
				_, err = c.dot.Exec(c.DB, "AddTagToProductTags", bTag.Name, bp.Data.ID)
				if err != nil {
					fmt.Println("AddTagToProductTags: ", err)
					// bugsnag.Notify(err)
					return err
				}
			}
		}
	}
	return err
}

func (c *Crawler) CreateProductById(bProductId string, tag string, cateId int) error {
	//check if the product already exists in db
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
	client := http.Client{Timeout: time.Second * 50}
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

	//translator, _ := translate.NewTranslator()
	desc, _ := translate.TranslateText(translate.Ko, translate.Vi, Description(bp.Data.Text))
	// translatedName, _ := translate.TranslateText(translate.Ko, translate.Vi, bp.Data.Name)
	// if translatedName == " " || len(translatedName) < 4 || translatedName == "[" {
	// 	//log this info
	// 	fmt.Println("both translator fails to translate properly: discarded product")
	// 	return nil
	// }
	//type conversion from BrandiProduct to dimodoProduct
	//Korean options
	var sProductOptions = []models.Option{}
	//vietnaemse options
	var productOptions = []models.Option{}

	for _, option := range bp.Data.Options {
		var sOption = option
		var newOption = option
		//translate the title only once
		for index, attribute := range option.Attributes {
			title, _ := translate.PpgTranslateText(translate.Ko, translate.Vi, attribute.Title)
			value, _ := translate.PpgTranslateText(translate.Ko, translate.Vi, attribute.Value)
			newOption.Attributes[index].Title = title
			newOption.Attributes[index].Value = value
		}
		sProductOptions = append(sProductOptions, sOption)
		productOptions = append(productOptions, newOption)
	}

	var seller = models.Seller{}
	seller.ID = bp.Data.Seller.ID

	optionBytes, _ := json.Marshal(productOptions)
	sOptionBytes, _ := json.Marshal(sProductOptions)
	sizeDetailBytes, _ := json.Marshal(c.SizeDetail(bp.Data.Text))
	adjustedPrice := int(float64(bp.Data.Price) * 1.1)
	adjustedSalePrice := int(float64(bp.Data.SalePrice) * 1.1)

	_, err = c.dot.Exec(c.DB, "CreateProduct",
		bp.Data.ID,
		bp.Data.Name,
		adjustedPrice,
		adjustedSalePrice,
		bp.Data.SalePercent,
		bp.Data.PurchaseCount,
		bp.Data.Images[0].ImageMediumURL,
		desc,
		pq.Array(SliderImages(bp)),
		pq.Array(ImagesFromHTML(bp.Data.Text)),
		optionBytes,
		sOptionBytes,
		seller,
		sizeDetailBytes,
		cateId,
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CreateProductById: ", err.Error())
		return err
	}
	err = c.AddTags(bp)
	if err != nil {
		bugsnag.Notify(err)
	}
	return err
}

func (c *Crawler) GetReviewMetaData(bProductId string) (int64, int64) {
	//recursive fetching... just like the brandi when the user clicks the reviews then call more

	photoReviewURL := "https://cf-api-v2.brandi.me/v2/web/products/" + bProductId + "/reviews?version=28&limit=0&offset=0"

	req, _ := http.NewRequest("GET", photoReviewURL, nil)
	req.Header.Add("Authorization", brandiAuth)
	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return 0, 0
	}

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var reviews brandi.BrandiReviews
	if err := json.Unmarshal(body, &reviews); err != nil {
		panic(err)
	}
	totalCount := reviews.MetaData.PhotoReviews.TotalCount + reviews.MetaData.TextReviews.TotalCount
	var averageScore int64
	for _, score := range reviews.MetaData.Statistics.WearingSensations {
		if averageScore < score.Ratio {
			averageScore = score.Ratio
		}
	}
	fmt.Println("score ", averageScore)

	return averageScore, totalCount
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
	//translator, _ := translate.NewTranslator()

	for _, r := range reviews.Data {
		text, err := translate.TranslateText(translate.Ko, translate.Vi, r.Text)
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
	// //translator, _ := translate.NewTranslator()
	for _, r := range reviews.Data {
		text, err := translate.TranslateText(translate.Ko, translate.Vi, r.Text)
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

//Images  imgs out of html string//we could take text from it and display
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
	//delete the zoom image from brandi
	if imgs[0] == "https://image.brandi.me/common/banner_view_imgwide.png" {
		imgs[0] = ""
	}

	// imgs = imgs[:len(s)-1]

	return imgs
}
func SliderImages(bp brandi.Product) []string {
	var imgs []string
	for _, img := range bp.Data.Images {
		imgs = append(imgs, img.ImageURL)
	}
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
	//iterate the <td> tag. The first tag that has "class="brandiSelectedTxt" will be the size.
	doc.Find("brandiProductSizeInfo").Remove()
	return doc.Text()
}

//todo: need fucking comments as to why sizeDetails need to be list
func (c *Crawler) SizeDetail(s string) []models.SizeDetail {
	//translator, _ := translate.NewTranslator()

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
			size, _ := translate.TranslateText(translate.Ko, translate.Vi, sizeHeaders[i])

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

func (c *Crawler) UpdateProducts() error {
	sids := make([]string, 0)

	rows, err := c.dot.Query(c.DB, "GetSidsOfAllProducts")
	if err != nil {
		// bugsnag.Notify(err)
		fmt.Println("GetSidsOfAllProducts: ", err)
		return err
	}

	var sid string
	var id string
	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(
			&sid,
			&id,
		); err != nil {
			fmt.Println("fail to GetSidsOfAllProducts ", err)
			return err
		}
		fmt.Println("ProductId: ", id)
		time.Sleep(4 * time.Second)
		product, err := c.ProductDetailById(sid)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println("ProductDetailById: ", err)
			return err
		}

		var productOptionsBytes []uint8
		var originalProductOptions = []models.Option{}

		row, err := c.dot.QueryRow(c.DB, "GetProductOption", product.Sid)

		if err != nil {
			fmt.Println("fail to run sql:", err)
			bugsnag.Notify(err)
			return nil
		}

		if err := row.Scan(&productOptionsBytes); err != nil {
			fmt.Println("fail to scan review", err)
			return nil
		}
		_ = json.Unmarshal([]byte(productOptionsBytes), &originalProductOptions)

		//brandi might delete some option pairs so we need to update it properly as well
		//in the future we will use our own translation so we can just directly use their option
		//instead of
		//todo

		for index, _ := range product.Options {
			if len(originalProductOptions) == len(product.Options) {
				originalProductOptions[index].IsSoldOut = product.Options[index].IsSoldOut

			}
		}
		optionBytes, _ := json.Marshal(originalProductOptions)
		fmt.Println("sprie: ", product.Price)

		_, err = c.dot.Exec(c.DB, "UpdateProduct", product.Sid, product.Price, product.Sale_price, product.Sale_percent, product.CategoryId, optionBytes)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println("UpdateProduct: ", err)
			return err
		}
		sids = append(sids, sid)

	}
	fmt.Println("sid counts: ", len(sids))
	return err
}

func (c *Crawler) TranslateTags() error {
	rows, err := c.dot.Query(c.DB, "GetAllTagsWithoutName")
	if err != nil {
		// bugsnag.Notify(err)
		fmt.Println("GetAllTagsWithoutName: ", err)
		return err
	}

	defer rows.Close()

	for rows.Next() {
		var tagSname string
		var tagId int
		if err := rows.Scan(
			&tagSname,
			&tagId,
		); err != nil {
			fmt.Println("fail to GetAllTagsWithoutName ", err)
			return err
		}
		name, err := translate.TranslateText(translate.En, translate.Vi, tagSname)
		fmt.Println("tag name: ", name)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println(err)
		}

		_, err = c.dot.Exec(c.DB, "UpdateTagName", name, tagId)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println("UpdateProduct: ", err)
			return err
		}

	}
	return err
}
