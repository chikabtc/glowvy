package models

import (
	"database/sql"
	"dimodo_backend/utils/translate"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gchaincl/dotsql"
)

type CosmeticsService interface {
	ProductsByCategoryID(categoryID int, skinType string) ([]Product, error)
	UpdateBrandsName()
	CosmeticsReviewsByProductID(productId int) (*Reviews, error)
	// AllCategories() ([]Category, error)
	// GetSubCategories(parentId int) ([]Category, error)

	// ProductsByShopId(shopId, start, count int) ([]Product, error)
	// ProductsByTags(tagId string, sortBy string, start, count int) ([]Product, error)
	// ReviewsByProductID(productId, start, count int) (*Reviews, error)
	// CountReviews(productId, start, count int) (int, error)
	// CheckOptions(productId int) (bool, error)
	// CheckIfShopExists(shopId int) (bool, error)
	// FindProductByID(id int) (*Product, error)
	// ProductDetailById(id int) (*Product, error)
	// UpdateThumbnailImage(productSid string, thumbnail string) (bool, error)
	// GetAllSidsWithBigThumbnail() ([]string, error)
	// GetSidsOfAllProducts() ([]string, error)
	// UpdateProduct(product *Product) (bool, error)
	// GetAllProducts() ([]Product, error)
	TranslateAllCosmeticsReviews()
	TranslateAllCosmeticsTags()
	TranslateAllReviewUserName()
	TranslateAllCosmetics()
}

type cosmeticsService struct {
	DB  *sql.DB
	dot *dotsql.DotSql
}

func NewCosmeticsService(db *sql.DB) CosmeticsService {
	cosmeticsDot, _ := dotsql.LoadFromFile("sql/cosmetics.pgsql")
	return &cosmeticsService{
		DB:  db,
		dot: cosmeticsDot,
	}
}

func (gs *cosmeticsService) ProductsByCategoryID(categoryID int, skinType string) ([]Product, error) {
	//if cateId is smaller than 10, it's a parent cateid
	fmt.Println("categoryId: ", categoryID)
	// categoryId, err := strconv.Atoi(categoryID)
	var rows *sql.Rows
	var err error
	rows, err = gs.dot.Query(gs.DB, "ProductsByCategoryID", categoryID, skinType)

	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("ProductsByCategoryID", err)
		return nil, err
	}

	var productOption Option
	var tags []uint8

	defer rows.Close()
	products := []Product{}
	for rows.Next() {
		var brand Seller
		var rating float64
		var cosmeticsRank CosmeticsRank

		var product Product
		if err := rows.Scan(
			&product.Id,
			&product.Sid,
			&product.Name,
			// &product.Name,
			&product.Thumbnail,
			&product.Price,
			&product.Sale_price,
			&rating,
			&product.Description,
			&product.Sdescription,
			&product.Volume,
			&product.Purchase_count,
			&product.CategoryName,
			&product.CategoryId,
			&tags,
			&brand.Name,
			&brand.ID,
			&brand.ImageURL,
			&cosmeticsRank.AllSkinRank,
			&cosmeticsRank.OilySkinRank,
			&cosmeticsRank.DrySkinRank,
			&cosmeticsRank.SensitiveSkinRank,
		); err != nil {
			bugsnag.Notify(err)
			fmt.Println("fail to Next", err)
			return nil, err
		}
		// productOptions
		err = json.Unmarshal([]byte(tags), &product.Tags)
		if err != nil {
			fmt.Println("fail to unmarshall tags: ", err)
		}
		var attribute struct {
			Order int    `json:"order"`
			Title string `json:"title"`
			Value string `json:"value"`
		}
		attribute.Title = "Option"
		attribute.Value = product.Volume

		productOption.Attributes = append(productOption.Attributes, attribute)
		productOption.ProductID = fmt.Sprintf("%d", product.Sid)

		averageRating := fmt.Sprintf("%f", rating) // s == "123
		product.Rating = averageRating
		product.CosmeticsRank = cosmeticsRank
		product.Options = append(product.Options, productOption)

		product.Seller = brand
		products = append(products, product)
	}
	return products, nil
}
func (ps *cosmeticsService) CosmeticsReviewsByProductID(productId int) (*Reviews, error) {

	rows, err := ps.dot.Query(ps.DB, "ReviewsByProductID", productId)
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
			&review.User.Name,
			&review.Content,
			&review.Scontent,
			&review.User.Age,
			&review.User.SkinType,
			&review.Score,
			// &review.CreatedTime,
		); err != nil {
			fmt.Println("fail to Next", err)
			return nil, err
		}
		// review.Images
		reviews.Reviews = append(reviews.Reviews, review)
	}
	reviews.TotalCount = len(reviews.Reviews)
	if reviews.Reviews == nil {
		reviews.Reviews = []Review{}
	}
	return &reviews, nil
}

func isParentCate(id int) bool {
	var parentCates = []int{3, 4, 32}
	for _, cate := range parentCates {
		if cate == id {
			return true
		}
	}
	return false
}

// =============================================================================
// PRIVATE FUNCTION
// =============================================================================
func (gs *cosmeticsService) UpdateBrandsName() {
	var rows *sql.Rows
	var err error
	rows, err = gs.dot.Query(gs.DB, "AllBrandsSname")

	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("AllBrandsSname", err)
		return
	}

	defer rows.Close()
	for rows.Next() {
		var brandName string
		// var englishBrandName string
		var koBrandName string

		if err := rows.Scan(
			&brandName,
		); err != nil {
			bugsnag.Notify(err)
			fmt.Println("fail to Next", err)
			return
		}
		i1 := strings.Index(brandName, "(")
		i2 := strings.Index(brandName, ")")

		if i1 == -1 || i2 == -1 {
			koBrandName = brandName
			fmt.Println("no change english brand name: ", koBrandName)
		} else {
			koBrandName = brandName[0 : i1-1]
			fmt.Println("english brand name: ", koBrandName)
		}
	}
}

func (cs *cosmeticsService) TranslateAllCosmeticsReviews() {
	var rows *sql.Rows

	rows, err := cs.dot.Query(cs.DB, "GetAllCosmeticsReviews")
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("GetAllCosmeticsReviews", err)
		return
	}

	defer rows.Close()
	for rows.Next() {
		var review Review
		if err := rows.Scan(
			&review.Product.Sid,
			&review.User.Name,
			&review.Scontent,
		); err != nil {
			bugsnag.Notify(err)
			fmt.Println("fail to Next", err)
			return
		}
		cs.TranslateReview((review))
	}
	return
}

func (cs *cosmeticsService) TranslateAllCosmeticsTags() {
	var rows *sql.Rows

	rows, err := cs.dot.Query(cs.DB, "GetAllCosmeticsTags")
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("GetAllCosmeticsTags", err)
		return
	}

	defer rows.Close()
	for rows.Next() {
		var tag string
		var id int
		if err := rows.Scan(
			&tag,
			&id,
		); err != nil {
			bugsnag.Notify(err)
			fmt.Println("fail to Next", err)
			return
		}
		enContent, _ := translate.TranslateText("ko", "en", tag)
		fmt.Println("vi: ", enContent)

		_, err := cs.dot.Exec(cs.DB, "TranslateCosmeticsTag", enContent, id)

		if err != nil {
			fmt.Println("TranslateCosmeticsTag ", err)
		}
	}
	return
}
func (cs *cosmeticsService) TranslateAllReviewUserName() {
	var rows *sql.Rows

	rows, err := cs.dot.Query(cs.DB, "GetAllCosmeticsReviewName")
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("GetAllCosmeticsReviewName", err)
		return
	}

	defer rows.Close()
	for rows.Next() {
		var userName string
		var id int
		if err := rows.Scan(
			&userName,
			&id,
		); err != nil {
			bugsnag.Notify(err)
			fmt.Println("fail to Next", err)
			return
		}
		enContent, _ := translate.TranslateText("ko", "en", userName)
		fmt.Println("vi: ", enContent)

		_, err := cs.dot.Exec(cs.DB, "TranslateReviewUserName", enContent, userName)

		if err != nil {
			fmt.Println("TranslateReviewUserName ", err)
		}
	}
	return
}

func (cs *cosmeticsService) TranslateReview(review Review) {
	// time.Sleep(1000)
	// enName, _ := translate.TranslateText("ko", "vi", review.User.Name)
	viContent, _ := translate.TranslateText("ko", "vi", review.Scontent)
	fmt.Println("vi: ", viContent)

	_, err := cs.dot.Exec(cs.DB, "TranslateCosmeticsReview", viContent, review.Scontent)

	if err != nil {
		fmt.Println("TranslateCosmeticsReview ", err)
	}
}

func (cs *cosmeticsService) TranslateAllCosmetics() {
	var rows *sql.Rows

	rows, err := cs.dot.Query(cs.DB, "GetAllCosmeticsProducts")
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("GetAllCosmeticsProducts", err)
		return
	}

	defer rows.Close()
	products := []Product{}
	for rows.Next() {
		var product Product
		if err := rows.Scan(
			&product.Sid,
			&product.Sdescription,
		); err != nil {
			bugsnag.Notify(err)
			fmt.Println("fail to Next", err)
			return
		}

		if err != nil {
			fmt.Println("GetAllCosmeticsProducts: ", err)
		}

		// enName, _ := translate.TranslateText("ko", "vi", product.EnName)
		// fmt.Println("vi: ", enName)
		enDescription, _ := translate.TranslateText("ko", "vi", product.Sdescription)
		// fmt.Println("enDescription: ", enDescription)

		_, err := cs.dot.Exec(cs.DB, "TranslateCosmetics", enDescription, product.Sid)

		if err != nil {
			fmt.Println("fail to unmarshall tags: ", err)
		}
		products = append(products, product)
	}
	return
}
