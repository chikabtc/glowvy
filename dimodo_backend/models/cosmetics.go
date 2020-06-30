package models

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gchaincl/dotsql"
)

type CosmeticsService interface {
	ProductsByCategoryID(categoryID int, skinType string) ([]Product, error)
	UpdateBrandsName()
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

	var tags []uint8

	defer rows.Close()
	products := []Product{}
	for rows.Next() {
		var brand Seller

		var product Product
		if err := rows.Scan(
			&product.Id,
			&product.Sid,
			&product.Sname,
			// &product.Name,
			&product.Thumbnail,
			&product.Price,
			&product.Sale_price,
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
		); err != nil {
			bugsnag.Notify(err)
			fmt.Println("fail to Next", err)
			return nil, err
		}
		err = json.Unmarshal([]byte(tags), &product.Tags)
		if err != nil {
			fmt.Println("fail to unmarshall tags: ", err)
		}
		product.Seller = brand
		products = append(products, product)
	}
	return products, nil
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
		_, err := gs.dot.Exec(gs.DB, "AddEnglishBrandName", koBrandName, brandName)
		if err != nil {
			// bugsnag.Notify(err)
			fmt.Println("AddEnglishBrandName: ", err)
			return
		}
	}
}
