package controllers

import (
	"database/sql"
	"dimodo_backend/crawler"
	"dimodo_backend/models"
	"dimodo_backend/utils/null"
	resp "dimodo_backend/utils/respond"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gorilla/mux"
)

type Product struct {
	ps models.ProductService
	cw *crawler.Crawler
}

func NewProduct(ps models.ProductService, cw *crawler.Crawler) *Product {
	return &Product{
		ps: ps,
		cw: cw,
	}
}

//				categories			//
type Categories struct {
	Id    int         `json:"id,omitempty"`
	Name  string      `json:"name,omitempty"`
	Image null.String `json:"image,omitempty"`
}

func (p *Product) AllCategories(w http.ResponseWriter, r *http.Request) {
	categories, err := p.ps.AllCategories()
	// print("categories: ", *categories)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(categories))
}

const QueryAllCategories = "SELECT id,name,image FROM category_default"

func AllCategories(db *sql.DB) ([]Categories, error) {
	rows, err := db.Query(QueryAllCategories)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}
	defer rows.Close()
	categoriesAll := []Categories{}
	for rows.Next() {
		var categories Categories
		if err := rows.Scan(&categories.Id, &categories.Name, &categories.Image); err != nil {
			return nil, err
		}
		categoriesAll = append(categoriesAll, categories)
	}
	return categoriesAll, nil
}

func (p *Product) ProductDetailById(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := strconv.Atoi(params["id"])
	fmt.Println(id)

	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Sprintf("Invalid actions Id. Error: %s", err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	var product *models.Product
	product, err = p.ps.ProductDetailById(id)

	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(product))
}

func (p *Product) ProductsByCategoryId(w http.ResponseWriter, r *http.Request) {
	count, _ := strconv.Atoi(r.FormValue("count"))
	start, _ := strconv.Atoi(r.FormValue("start"))
	sortBy := r.FormValue("sort_by")
	fmt.Println("sortBy: ", sortBy)
	if count > 24 || count < 1 {
		count = count
	}
	if start < 0 {
		start = 0
	}
	params := mux.Vars(r)
	id, err := strconv.Atoi(params["id"])
	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Sprintf("Invalid actions Id. Error: %s", err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	products, err := p.ps.ProductsByCategoryID(fmt.Sprintln(id), sortBy, start, count)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(products))
}

func (p *Product) ProductsByTags(w http.ResponseWriter, r *http.Request) {
	count, _ := strconv.Atoi(r.FormValue("count"))
	start, _ := strconv.Atoi(r.FormValue("start"))
	sortBy := r.FormValue("sort_by")

	if count > 24 || count < 1 {
		count = count
	}
	if start < 0 {
		start = 0
	}
	params := mux.Vars(r)
	tagId := params["tag"]
	// if err != nil {
	// 	bugsnag.Notify(err)
	// 	msgError := fmt.Sprintf("Invalid actions Id. Error: %s", err)
	// 	resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
	// 	return
	// }
	products, err := p.ps.ProductsByTags(tagId, sortBy, start, count)
	if err != nil {
		fmt.Println(err)
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(products))
}

func (p *Product) ProductsByShopId(w http.ResponseWriter, r *http.Request) {
	count, _ := strconv.Atoi(r.FormValue("count"))
	start, _ := strconv.Atoi(r.FormValue("start"))
	if count > 24 || count < 1 {
		count = count
	}
	if start < 0 {
		start = 0
	}
	params := mux.Vars(r)
	id, err := strconv.Atoi(params["id"])

	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Sprintf("Invalid actions Id. Error: %s", err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	var products []models.Product

	// crawler := crawler.NewCrawler()
	products = p.cw.GetPopularProductsByShopId(id, count)

	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(products))
}

func (p *Product) ProductReviewsById(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := strconv.Atoi(params["id"])
	fmt.Println(id)
	offset, _ := strconv.Atoi(r.FormValue("offset"))

	limit, _ := strconv.Atoi(r.FormValue("limit"))
	if limit > 6 || limit < 1 {
		limit = 6
	}
	if offset < 0 {
		offset = 0
	}

	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Sprintf("Invalid actions Id. Error: %s", err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	var reviews *models.Reviews
	// //returns a new dimodo product object based on the parentId
	//1. check if the product reviews exist in the database
	reviewsAvailable, _ := p.ps.CountReviews(id, offset, limit)

	//2. if available, retrieve and return them from the db
	if reviewsAvailable > 0 {
		reviews, err = p.ps.ReviewsByProductID(id, offset, limit)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println(err)
		}
		//3. if unavailalble, call reivew api of Brandi and save them and return them
	} else {
		//call review api of Brandi
		//save the returned reviews to the database
		// c := crawler.NewCrawler()
		//get the reviews

		p.cw.GetPhotoReviewsFromBrandi(params["id"], r.FormValue("offset"), r.FormValue("limit"))
		p.cw.GetTextReviewsFromBrandi(params["id"], r.FormValue("offset"), r.FormValue("limit"))
		reviews, err = p.ps.ReviewsByProductID(id, offset, limit)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println(err)
		}
	}

	fmt.Println(params["sr"])

	averageScore, totalCount := p.cw.GetReviewMetaData(params["id"])
	reviews.AverageSatisfaction = averageScore
	reviews.TotalCount = totalCount

	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
	}

	resp.Json(w, r, http.StatusOK, resp.WithSuccess(reviews))
}

// =============================================================================
// PRIVATE FUNCTIONS
// =============================================================================
func (p *Product) CreateProductById(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := strconv.Atoi(params["id"])
	fmt.Println(id)

	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Sprintf("Invalid actions Id. Error: %s", err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	// var product *models.Product

	err = p.cw.CreateProductById(params["id"], "", 0)

	// product, err = p.ps.ProductDetailById(id)

	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(err))
}

func (p *Product) UpdateProductPrices(w http.ResponseWriter, r *http.Request) {
	sids, err := p.ps.GetSidsOfAllProducts()

	for _, sid := range sids {
		time.Sleep(2 * time.Second)

		product, err := p.cw.ProductDetailById(sid)
		if err != nil {
			fmt.Println("ProductDetailById err: ", err)
		}

		isSuccess, err := p.ps.UpdateProduct(product)
		if err != nil {
			fmt.Println("UpdateProductPrices err: ", err)
		}
		fmt.Println("UpdateProductPrices? ", isSuccess)
	}
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(err))
}

func (p *Product) UpdateProductPrice(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)

	id := params["id"]

	product, err := p.cw.ProductDetailById(id)
	if err != nil {
		fmt.Println("ProductDetailById err: ", err)
	}

	isSuccess, err := p.ps.UpdateProduct(product)
	if err != nil {
		fmt.Println("UpdateProductPrices err: ", err)
	}

	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(isSuccess))
}

func (p *Product) UpdateThumbnailImages(w http.ResponseWriter, r *http.Request) {
	sids, err := p.ps.GetAllSidsWithBigThumbnail()

	for _, sid := range sids {
		time.Sleep(2 * time.Second)

		thumbnail, err := p.cw.ImageThumbnailByProductId(sid)
		if err != nil {
			fmt.Println("ImageThumbnailByProductId err: ", err)
		}

		isSuccess, err := p.ps.UpdateThumbnailImage(sid, thumbnail)
		if err != nil {
			fmt.Println("UpdateThumbnailImage err: ", err)
		}
		fmt.Println("updatating thumbnail success? ", isSuccess)
	}
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(err))
}
