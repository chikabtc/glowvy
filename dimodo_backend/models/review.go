package models

type Reviews struct {
	TotalCount          int64    `json:"total_count"`
	AverageSatisfaction int64    `json:"average_satisfaction"`
	Reviews             []Review `json:"reviews"`
}

type ReviewProduct struct {
	ID         string `json:"id"`
	Sid        string `json:"sid"`
	OptionName string `json:"option_name"`
	SellerID   string `json:"seller_id"`
}

type Review struct {
	ID          string `json:"id"`
	CreatedTime string `json:"created_time"`
	Type        string `json:"type"`
	Text        string `json:"text"`
	Score       int    `json:"score"`
	// LikeCount    int64  `json:"like_count"`
	// CommentCount int64  `json:"comment_count"`
	// IsLiked      bool   `json:"is_liked"`
	Product ReviewProduct `json:"product"`
	User    struct {
		ID           string `json:"id"`
		Name         string `json:"name"`
		ImageURL     string `json:"image_url"`
		Height       int64  `json:"height"`
		ShirtSize    string `json:"shirt_size"`
		PantsSize    string `json:"pants_size"`
		FootwearSize string `json:"footwear_size"`
	} `json:"user"`
	// Evaluation struct {
	// 	Satisfaction         string `json:"satisfaction"`
	// 	WearingSensationCode string `json:"wearing_sensation_code"`
	// 	WearingSensation     string `json:"wearing_sensation"`
	// } `json:"evaluation"`
	Images []string `json:"images"`
}
