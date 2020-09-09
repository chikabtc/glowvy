package models

import (
	"database/sql"
	"database/sql/driver"
	"dimodo_backend/utils/null"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gchaincl/dotsql"
	"github.com/lib/pq"
)

type ProductService interface {
	AllCategories() ([]Category, error)
	GetSubCategories(parentId int) ([]Category, error)
	ProductsByCategoryID(categoryID, sortBy string, start, count int) ([]Product, error)
	ProductsByShopId(shopId, start, count int) ([]Product, error)
	ProductsByTags(tagId string, sortBy string, start, count int) ([]Product, error)
	ReviewsByProductID(productId, start, count int) (*Reviews, error)
	CountReviews(productId, start, count int) (int, error)
	CheckOptions(productId int) (bool, error)
	CheckIfShopExists(shopId int) (bool, error)
	FindProductByID(id int) (*Product, error)
	ProductDetailById(id int) (*Product, error)
	UpdateThumbnailImage(productSid string, thumbnail string) (bool, error)
	GetAllSidsWithBigThumbnail() ([]string, error)
	GetSidsOfAllProducts() ([]string, error)
	UpdateProduct(product *Product) (bool, error)
	GetAllProducts() ([]Product, error)
	// TranslateAllCosmetics()
}

type productService struct {
	DB  *sql.DB
	dot *dotsql.DotSql
}

func NewProductService(db *sql.DB) ProductService {
	productDot, _ := dotsql.LoadFromFile("sql/product.pgsql")
	return &productService{
		DB:  db,
		dot: productDot,
	}
}

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
//cosmetics?

type Category struct {
	Id       int         `json:"id,omitempty"`
	ParentId int         `json:"parent_id,omitempty"`
	Name     null.String `json:"name,omitempty"`
	Image    null.String `json:"image,omitempty"`
}

type Attribute struct {
	Title     string `json:"title"`
	Value     string `json:"value"`
	IsSoldOut bool   `json:"is_sold_out"`
}

type SizeDetail struct {
	Attributes []Attribute `json:"attributes"`
}

type ProductEtcInfo struct {
	Attributes []Attribute `json:"attributes,omitempty"`
}

type Option struct {
	AddPrice   int `json:"add_price"`
	Attributes []struct {
		Order int    `json:"order"`
		Title string `json:"title"`
		Value string `json:"value"`
	} `json:"attributes"`
	DeliveryDate    string `json:"delivery_date"`
	IsEssential     bool   `json:"is_essential"`
	IsSell          bool   `json:"is_sell"`
	IsSoldOut       bool   `json:"is_sold_out"`
	IsTodayDelivery bool   `json:"is_today_delivery"`
	MaxOrderQty     int    `json:"max_order_qty"`
	MinOrderQty     int    `json:"min_order_qty"`
	ProductID       string `json:"product_id"`
	Qty             int    `json:"qty"`
	Sku             string `json:"sku"`
}

type Product struct {
	Id             int          `json:"id,omitempty"`
	Thumbnail      string       `json:"thumbnail,omitempty"`
	Name           string       `json:"name,omitempty"`
	Sname          string       `json:"sname,omitempty"`
	EnName         string       `json:"enname,omitempty"`
	Description    string       `json:"description,omitempty"`
	Sdescription   string       `json:"sdescription,omitempty"`
	DescImages     []string     `json:"desc_images"`
	SliderImages   []string     `json:"slider_images,omitempty"`
	Sale_price     int          `json:"sale_price,omitempty"`
	Rating         string       `json:"rating,omitempty"`
	Sale_percent   int          `json:"sale_percent,omitempty"`
	Purchase_count int          `json:"purchase_count,omitempty"`
	Review_count   int          `json:"review_count,omitempty"`
	Price          int          `json:"price,omitempty"`
	CategoryId     int          `json:"category_id"`
	CategoryName   string       `json:"category_name,omitempty"`
	Barcode        string       `json:"barcode,omitempty"`
	SizeDetails    []SizeDetail `json:"size_details,omitempty"`
	Options        []Option     `json:"options,omitempty"`
	Volume         string       `json:"volume,omitempty"`

	ProductEtcInfo ProductEtcInfo `json:"productEtcInfo,omitempty"`
	Seller         Seller         `json:"seller,omitempty"`
	AddInfo        []struct {
		Key  string `json:"key"`
		Text string `json:"text"`
	} `json:"add_info"`
	Tags          []Tag         `json:"tags,omitempty"`
	Sid           int           `json:"sid,omitempty"`
	Sprice        int           `json:"sprice,omitempty"`
	Surl          string        `json:"surl,omitempty"`
	CosmeticsRank CosmeticsRank `json:"cosmetics_rank,omitempty"`
	HazardScore   int           `json:"hazard_score,omitempty"`
	Ingredients   []Ingredient  `json:"ingredients,omitempty"`
}

type Ingredient struct {
	Id          int      `json:"id"`
	NameEn      string   `json:"name_en"`
	Purposes    []string `json:"purposes"`
	HazardScore int      `json:"hazard_score"`
}

type Tag struct {
	Id    int    `json:"id"`
	Name  string `json:"name,omitempty"`
	Sname string `json:"sname"`
	Type  string `json:"type,omitempty"`
}

type Seller struct {
	Address1      string `json:"address1"`
	Address2      string `json:"address2"`
	BookmarkCount int    `json:"bookmark_count"`
	BusinessInfo  struct {
		BusinessCode          string `json:"business_code"`
		BusinessName          string `json:"business_name"`
		MailOrderBusinessCode string `json:"mail_order_business_code"`
		RepresentativeName    string `json:"representative_name"`
	} `json:"business_info"`
	Email         string      `json:"email"`
	EnName        string      `json:"en_name"`
	ID            string      `json:"id"`
	ImageURL      string      `json:"image_url"`
	KakaoTalkID   interface{} `json:"kakao_talk_id,omitempty"`
	KakaoYellowID interface{} `json:"kakao_yellow_id,omitempty"`
	Name          string      `json:"name"`
	OperationTime string      `json:"operation_time"`
	Tags          []struct {
		ID   string `json:"id"`
		Name string `json:"name"`
		Type string `json:"type"`
	} `json:"tags"`
	Telephone string `json:"telephone"`
	Text      string `json:"text"`
	Type      struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"type"`
}

type CosmeticsRank struct {
	SensitiveSkinRank sql.NullInt32 `json:"sensitive_skin_rank"`
	OilySkinRank      sql.NullInt32 `json:"oily_skin_rank"`
	DrySkinRank       sql.NullInt32 `json:"dry_skin_rank"`
	AllSkinRank       sql.NullInt32 `json:"all_skin_rank"`
}

func (t Tag) Value() (driver.Value, error) {
	return json.Marshal(t)
}

// Make the Attrs struct implement the sql.Scanner interface. This method
// simply decodes a JSON-encoded value into the struct fields.
func (t *Tag) Scan(value interface{}) error {
	b, ok := value.([]byte)
	if !ok {
		return errors.New("type assertion to []byte failed")
	}

	return json.Unmarshal(b, &t)
}

func (t Product) Value() (driver.Value, error) {
	return json.Marshal(t)
}

// Make the Attrs struct implement the sql.Scanner interface. This method
// simply decodes a JSON-encoded value into the struct fields.
func (t *Product) Scan(value interface{}) error {
	b, ok := value.([]byte)
	if !ok {
		return errors.New("type assertion to []byte failed")
	}

	return json.Unmarshal(b, &t)
}

func (s Seller) Value() (driver.Value, error) {
	return json.Marshal(s)
}

// Make the Attrs struct implement the sql.Scanner interface. This method
// simply decodes a JSON-encoded value into the struct fields.
func (s *Seller) Scan(value interface{}) error {
	b, ok := value.([]byte)
	if !ok {
		return errors.New("type assertion to []byte failed")
	}

	return json.Unmarshal(b, &s)
}

func (ps *productService) AllCategories() ([]Category, error) {
	rows, err := ps.dot.Query(ps.DB, "QueryAllCategory")
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}
	defer rows.Close()
	categories := []Category{}
	for rows.Next() {
		var category Category
		if err := rows.Scan(&category.Id, &category.Name, &category.Image); err != nil {
			return nil, err
		}
		categories = append(categories, category)
	}
	return categories, nil
}

func (ps *productService) GetSubCategories(parentId int) ([]Category, error) {
	rows, err := ps.dot.Query(ps.DB, "GetSubCategories", parentId)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}
	defer rows.Close()
	categories := []Category{}
	for rows.Next() {
		var category Category
		if err := rows.Scan(&category.Id, &category.ParentId, &category.Name, &category.Image); err != nil {
			return nil, err
		}
		categories = append(categories, category)
	}
	return categories, nil
}

//Categories include the home categories as well which is 0
func (ps *productService) ProductsByCategoryID(categoryID, sortBy string, start, count int) ([]Product, error) {
	//if cateId is smaller than 10, it's a parent cateid
	fmt.Println("categoryId: ", categoryID)
	categoryId, err := strconv.Atoi(categoryID)
	if err != nil {
		fmt.Println("fail to convert categoryID to int :", err)
	}
	var rows *sql.Rows
	parentMaxId := int(10)

	if categoryId < parentMaxId {
		fmt.Println("ProductsByParentCategoryID")
		rows, err = ps.dot.Query(ps.DB, "ProductsByParentCategoryID", categoryID, sortBy, start, count)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println("ProductsByParentCategoryID", err)
			return nil, err
		}
	} else {
		fmt.Println("ProductsByCategoryID")

		rows, err = ps.dot.Query(ps.DB, "ProductsByCategoryID", categoryID, sortBy, start, count)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println("ProductsByCategoryID", err)
			return nil, err
		}
	}

	var tags []uint8

	defer rows.Close()
	products := []Product{}
	for rows.Next() {
		var product Product
		if err := rows.Scan(
			&product.Id,
			&product.Sid,
			&product.Name,
			&product.Thumbnail,
			&product.Price,
			&product.Sale_price,
			&product.Sale_percent,
			&product.Purchase_count,
			&product.CategoryName,
			&product.CategoryId,
			&tags); err != nil {
			bugsnag.Notify(err)
			fmt.Println("fail to Next", err)
			return nil, err
		}
		err = json.Unmarshal([]byte(tags), &product.Tags)
		if err != nil {
			fmt.Println("fail to unmarshall tags: ", err)
		}
		products = append(products, product)
	}
	return products, nil
}

func (ps *productService) ProductsByShopId(shopId, start, count int) ([]Product, error) {
	rows, err := ps.dot.Query(ps.DB, "ProductsByShopId", shopId, start, count)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("ProductsByShopId", err)
		return nil, err
	}

	defer rows.Close()
	products := []Product{}
	for rows.Next() {
		var product Product
		if err := rows.Scan(
			&product.Id,
			&product.Sid,
			&product.Price,
			&product.Sale_price,
			&product.Sale_percent,
			&product.Purchase_count,
			&product.Name,
			&product.Thumbnail); err != nil {
			fmt.Println("fail to Next ProductsByShopId", err)

			return nil, err
		}

		products = append(products, product)
	}
	return products, nil
}

func (ps *productService) ProductsByTags(tagId string, sortBy string, start, count int) ([]Product, error) {
	fmt.Println("sortBy : ", sortBy)
	var tags []uint8

	rows, err := ps.dot.Query(ps.DB, "ProductsByTags", tagId, sortBy, start, count)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("ProductsByTags err", err)
		return nil, err
	}

	defer rows.Close()
	products := []Product{}
	for rows.Next() {
		var product Product
		if err := rows.Scan(
			&product.Id,
			&product.Sid,
			&product.Price,
			&product.Sale_price,
			&product.Sale_percent,
			&product.Purchase_count,
			&product.Name,
			&product.Thumbnail,
			&product.CategoryId,
			&product.CategoryName,
			&tags,
		); err != nil {
			fmt.Println("fail to Next ProductsByShopId", err)

			return nil, err
		}
		err = json.Unmarshal([]byte(tags), &product.Tags)
		if err != nil {
			fmt.Println("fail to unmarshall tags: ", err)
		}
		products = append(products, product)
	}

	return products, nil
}

func (ps *productService) FindProductByID(id int) (*Product, error) {
	product := Product{Id: id}
	row, err := ps.dot.QueryRow(ps.DB, "FindProductById", id)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}
	row.Scan(&product.Id, &product.Price, &product.Name, &product.Thumbnail)
	return &product, nil
}

func (ps *productService) ProductDetailById(id int) (*Product, error) {
	product := Product{Sid: id}
	var productOptions []uint8
	var tags []uint8
	var sizeDetails []uint8

	fmt.Println("product detail by id: ", id)
	row, err := ps.dot.QueryRow(ps.DB, "ProductDetailById", id)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}

	err = row.Scan(
		&product.Id,
		&product.Sid,
		&product.Name,
		&product.Price,
		&product.Sale_percent,
		&product.Sale_price,
		&product.Description,
		&product.Sdescription,
		&product.Thumbnail,
		&product.Purchase_count,
		pq.Array(&product.SliderImages),
		pq.Array(&product.DescImages),
		&tags,
		&product.Seller,
		&sizeDetails,
		&product.CategoryId,
		&product.CategoryName,
		&productOptions,
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("fail to scan productDetailById", err)
	}

	err = json.Unmarshal([]byte(productOptions), &product.Options)
	if err != nil {
		fmt.Println("fail to unmarshall productOptions: ", err)
	}
	err = json.Unmarshal([]byte(sizeDetails), &product.SizeDetails)
	if err != nil {
		fmt.Println("fail to unmarshall sizeDetails: ", err)
	}
	err = json.Unmarshal([]byte(tags), &product.Tags)
	if err != nil {
		fmt.Println("fail to unmarshall tags: ", err)
	}
	fmt.Println("json tags: ", product.Tags)

	return &product, nil
}

func (ps *productService) CountReviews(productId, start, count int) (int, error) {
	var ReviewsCount int
	fmt.Println("review start", start)
	fmt.Println("review count", count)
	row, err := ps.dot.QueryRow(ps.DB, "CountReviews", productId, start, count)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CountReviews: ", err)
		return 0, err
	}
	if err := row.Scan(&ReviewsCount); err != nil {
		fmt.Println("fail to scan review", err)
		return 0, err
	}
	fmt.Printf("count of reivews: %v  \n", ReviewsCount)
	return ReviewsCount, nil
}

func (ps *productService) CheckOptions(productId int) (bool, error) {
	var OptionsCount bool
	var options sql.NullString
	row, err := ps.dot.QueryRow(ps.DB, "Options", productId)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CheckOptions: ", err)
		return false, err
	}
	if err := row.Scan(&options); err != nil {
		fmt.Println("fail to scan CheckOptions", err)
		return false, err
	}
	if options.Valid {
		OptionsCount = true
	} else {
		OptionsCount = false
	}
	fmt.Printf("isOptionsAvailable: %v  \n", OptionsCount)
	return OptionsCount, nil
}

func (ps *productService) CheckIfShopExists(shopId int) (bool, error) {
	var shopExists bool
	var shopJson sql.NullString
	row, err := ps.dot.QueryRow(ps.DB, "CheckIfShopExists", shopId)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CheckIfShopExists: ", err)
		return false, err
	}
	if err := row.Scan(&shopJson); err != nil {
		fmt.Println("fail to scan CheckIfShopExists", err)
		return false, err
	}
	if shopJson.Valid {
		shopExists = true
	} else {
		shopExists = false
	}
	fmt.Printf("isOptionsAvailable: %v  \n", shopExists)
	return shopExists, nil
}

func (ps *productService) ReviewsByProductID(productId, start, count int) (*Reviews, error) {

	rows, err := ps.dot.Query(ps.DB, "ReviewsByProductID", productId, start, count*2)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("ReviewsByProductID", err)
		return nil, err
	}

	defer rows.Close()
	reviews := Reviews{}
	for rows.Next() {
		var review Review
		if err := rows.Scan(
			&review.Product.Sid,
			&review.ID,
			&review.User.Name,
			&review.Content,
			pq.Array(&review.Images),
		); err != nil {
			fmt.Println("fail to Next", err)
			return nil, err
		}
		// review.Images
		reviews.Reviews = append(reviews.Reviews, review)
	}
	if reviews.Reviews == nil {
		reviews.Reviews = []Review{}
	}
	return &reviews, nil
}

// =============================================================================
// Private Functions only used manually by developers to edit db
// =============================================================================
func (ps *productService) UpdateThumbnailImage(productSid string, thumbnail string) (bool, error) {
	_, err := ps.dot.Exec(ps.DB, "UpdateThumbnailImage", productSid, thumbnail)
	if err != nil {
		// bugsnag.Notify(err)
		fmt.Println("UpdateThumbnailImage: ", err)
		return false, err
	}
	return true, nil
}

//get sid of product whose thumbnail contains image_L
func (ps *productService) GetAllSidsWithBigThumbnail() ([]string, error) {
	sids := make([]string, 0)

	rows, err := ps.dot.Query(ps.DB, "GetAllSidsWithBigThumbnail")
	if err != nil {
		// bugsnag.Notify(err)
		fmt.Println("GetAllSidsWithBigThumbnail: ", err)
		return nil, err
	}

	var sid string
	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(
			&sid,
		); err != nil {
			fmt.Println("fail to GetAllSidsWithBigThumbnail ", err)
			return nil, err
		}
		sids = append(sids, sid)

	}
	fmt.Println("sid counts: ", len(sids))
	return sids, nil
}

func (ps *productService) GetSidsOfAllProducts() ([]string, error) {
	sids := make([]string, 0)

	rows, err := ps.dot.Query(ps.DB, "GetAllSids")
	if err != nil {
		// bugsnag.Notify(err)
		fmt.Println("GetAllSids: ", err)
		return nil, err
	}

	var sid string
	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(
			&sid,
		); err != nil {
			fmt.Println("fail to GetAllSids ", err)
			return nil, err
		}
		sids = append(sids, sid)

	}
	fmt.Println("sid counts: ", len(sids))
	return sids, nil
}

func (ps *productService) UpdateProduct(product *Product) (bool, error) {
	_, err := ps.dot.Exec(ps.DB, "UpdateProduct", product.Price, product.Sale_price, product.Sale_percent, product.CategoryId, product.Options, product.Sid)
	if err != nil {
		// bugsnag.Notify(err)
		fmt.Println("UpdateProduct: ", err)
		return false, err
	}
	return true, nil
}

func (ps *productService) GetAllProducts() ([]Product, error) {
	sids, _ := ps.GetSidsOfAllProducts()
	products := make([]Product, 0)

	for _, sid := range sids {
		id, _ := strconv.Atoi(sid)
		product, err := ps.AlgolioProductDetailById(id)
		if err == nil {
			products = append(products, *product)

		}

	}

	return products, nil
}

func (ps *productService) AlgolioProductDetailById(id int) (*Product, error) {
	product := Product{Sid: id}
	// var productOptions []uint8
	var tags []uint8

	fmt.Println("product detail by id: ", id)
	row, err := ps.dot.QueryRow(ps.DB, "AlgolioProductDetailById", id)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}

	err = row.Scan(
		&product.Sid,
		&product.Name,
		&product.Price,
		&product.Sale_percent,
		&product.Sale_price,
		&product.Thumbnail,
		&product.Purchase_count,
		&tags,
		&product.Seller,
		&product.CategoryName,
		// &productOptions,
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("fail to scan AlgolioProductDetailById", err)
	}

	// err = json.Unmarshal([]byte(productOptions), &product.Options)
	// if err != nil {
	// 	fmt.Println("fail to unmarshall productOptions: ", err)
	// }

	err = json.Unmarshal([]byte(tags), &product.Tags)
	if err != nil {
		fmt.Println("fail to unmarshall tags: ", err)
	}
	fmt.Println("json tags: ", product.Tags)

	return &product, nil
}