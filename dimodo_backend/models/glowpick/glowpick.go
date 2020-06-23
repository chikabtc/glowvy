package glowpick

type GlowPickProducts struct {
	IDFirstCategory  int64             `json:"idFirstCategory"`
	RecommendProduct interface{}       `json:"recommendProduct"`
	IDSecondCategory int64             `json:"idSecondCategory"`
	NextOffset       int64             `json:"nextOffset"`
	ProductsCount    int64             `json:"productsCount"`
	IDThirdCategory  int64             `json:"idThirdCategory"`
	Products         []GlowPickProduct `json:"products"`
}

type GlowPickProduct struct {
	IDProduct      int64          `json:"idProduct"`
	ProductRank    int64          `json:"productRank"`
	ProductTitle   string         `json:"productTitle"`
	Volume         string         `json:"volume"`
	Price          int64          `json:"price"`
	ReviewCnt      int64          `json:"reviewCnt"`
	RatingAvg      float64        `json:"ratingAvg"`
	ProductImg     string         `json:"productImg"`
	IsDiscontinue  bool           `json:"isDiscontinue"`
	RankChangeType RankChangeType `json:"rankChangeType"`
	Brand          GlowPickBrand  `json:"brand"`
	GoodsInfo      GoodsInfo      `json:"goodsInfo"`
}

type GlowPickBrand struct {
	IDBrand    int64  `json:"idBrand"`
	BrandTitle string `json:"brandTitle"`
	BrandImg   string `json:"brandImg"`
}

type GoodsInfo struct {
	GoodsCount int64 `json:"goodsCount"`
}

type RankChangeType string

const (
	Hide RankChangeType = "hide"
)

type GlowpickDetailedProduct struct {
	Data Data `json:"data"`
}

type Data struct {
	IDProduct             int64                  `json:"idProduct"`
	ProductTitle          string                 `json:"productTitle"`
	ProductImg            string                 `json:"productImg"`
	RatingAvg             float64                `json:"ratingAvg"`
	ReviewCount           int64                  `json:"reviewCount"`
	Volume                string                 `json:"volume"`
	Price                 int64                  `json:"price"`
	IsDiscontinue         bool                   `json:"isDiscontinue"`
	ColorType             interface{}            `json:"colorType"`
	Description           string                 `json:"description"`
	WishCount             int64                  `json:"wishCount"`
	ReviewType            string                 `json:"reviewType"`
	ReviewTypeMsg         interface{}            `json:"reviewTypeMsg"`
	RegisterRating        interface{}            `json:"registerRating"`
	GoodsInfo             interface{}            `json:"goodsInfo"`
	Brand                 GlowPickBrand          `json:"brand"`
	Keywords              []string               `json:"keywords"`
	BlogInfo              BlogInfo               `json:"blogInfo"`
	AwardInfo             []interface{}          `json:"awardInfo"`
	AwardInfoV2           []interface{}          `json:"awardInfoV2"`
	IngredientInfo        IngredientInfo         `json:"ingredientInfo"`
	MonthlyNew            interface{}            `json:"monthlyNew"`
	CategoryInfo          []CategoryInfo         `json:"categoryInfo"`
	Stores                []interface{}          `json:"stores"`
	ReviewGraph           ReviewGraph            `json:"reviewGraph"`
	Ranking               Ranking                `json:"ranking"`
	StoreCategoryProducts []StoreCategoryProduct `json:"storeCategoryProducts"`
}

type BlogInfo struct {
	Title       string `json:"title"`
	Description string `json:"description"`
	Link        string `json:"link"`
	BloggerName string `json:"bloggerName"`
	BloggerLink string `json:"bloggerLink"`
}

type CategoryInfo struct {
	IDFirstCategory    int64  `json:"idFirstCategory"`
	FirstCategoryText  string `json:"firstCategoryText"`
	IDSecondCategory   int64  `json:"idSecondCategory"`
	SecondCategoryText string `json:"secondCategoryText"`
	IDThirdCategory    int64  `json:"idThirdCategory"`
	ThirdCategoryText  string `json:"thirdCategoryText"`
}

type IngredientInfo struct {
	Hazard            string      `json:"hazard"`
	HighHazardSummary interface{} `json:"highHazardSummary"`
	SubDescription    string      `json:"subDescription"`
}

type Ranking struct {
	Categories []Category  `json:"categories"`
	Brand      SecondClass `json:"brand"`
}

type SecondClass struct {
	ID    int64  `json:"id"`
	Name  string `json:"name"`
	Rank  int64  `json:"rank"`
	Total int64  `json:"total"`
}

type Category struct {
	Second SecondClass `json:"second"`
	Third  SecondClass `json:"third"`
}

type ReviewGraph struct {
	ReviewTotal    int64      `json:"reviewTotal"`
	PositiveTotal  int64      `json:"positiveTotal"`
	NegativeTotal  int64      `json:"negativeTotal"`
	ScoreBoard     ScoreBoard `json:"scoreBoard"`
	PositiveReview TiveReview `json:"positiveReview"`
	NegativeReview TiveReview `json:"negativeReview"`
}

type TiveReview struct {
	ReviewID     int64    `json:"reviewId"`
	Rating       int64    `json:"rating"`
	IsEvaluation bool     `json:"isEvaluation"`
	LikeCount    int64    `json:"likeCount"`
	Contents     string   `json:"contents"`
	State        string   `json:"state"`
	CreatedAt    int64    `json:"createdAt"`
	Register     Register `json:"register"`
}

type Register struct {
	IDRegister  int64  `json:"idRegister"`
	Email       string `json:"email"`
	Nickname    string `json:"nickname"`
	Age         int64  `json:"age"`
	Gender      string `json:"gender"`
	SkinType    string `json:"skinType"`
	ReviewCount int64  `json:"reviewCount"`
	ProfileImg  string `json:"profileImg"`
	Rank        int64  `json:"rank"`
	IsBlind     int64  `json:"isBlind"`
}

type ScoreBoard struct {
	BlindTotal int64  `json:"blindTotal"`
	Rating     Rating `json:"rating"`
}

type Rating struct {
	Point1 int64 `json:"point1"`
	Point2 int64 `json:"point2"`
	Point3 int64 `json:"point3"`
	Point4 int64 `json:"point4"`
	Point5 int64 `json:"point5"`
}

type StoreCategoryProduct struct {
	ID                int64   `json:"id"`
	Name              string  `json:"name"`
	RetailPrice       float64 `json:"retailPrice"`
	CurrentSalePrice  float64 `json:"currentSalePrice"`
	DiscountRate      int64   `json:"discountRate"`
	ProductImg        string  `json:"productImg"`
	IsShowRetailPrice bool    `json:"isShowRetailPrice"`
}
