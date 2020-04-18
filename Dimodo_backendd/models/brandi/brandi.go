package brandi

type Products struct {
	Data []struct {
		ID                string `json:"id"`
		ImageMediumURL    string `json:"image_medium_url"`
		ImageThumbnailURL string `json:"image_thumbnail_url"`
		ImageURL          string `json:"image_url"`
		IsFreeDelivery    bool   `json:"is_free_delivery"`
		IsHeartDelivery   bool   `json:"is_heart_delivery"`
		IsNew             bool   `json:"is_new"`
		IsSell            bool   `json:"is_sell"`
		IsSpecialPrice    bool   `json:"is_special_price"`
		IsTodayDelivery   bool   `json:"is_today_delivery"`
		Name              string `json:"name"`
		Price             int    `json:"price"`
		SalePercent       int    `json:"sale_percent"`
		SalePrice         int    `json:"sale_price"`
		Seller            struct {
			EnName       string `json:"en_name"`
			ID           string `json:"id"`
			ImageURL     string `json:"image_url"`
			IsBrandstore bool   `json:"is_brandstore"`
			Name         string `json:"name"`
			Text         string `json:"text"`
		} `json:"seller"`
		Statistics struct {
			PurchaseCount int `json:"purchase_count"`
		} `json:"statistics"`
	} `json:"data"`
	Meta struct {
		Code  int `json:"code"`
		Count int `json:"count"`
	} `json:"meta"`
}

type MyJsonName struct {
	Data struct {
		DateText      string        `json:"date_text"`
		DetailHTML    string        `json:"detail_html"`
		DetailText    string        `json:"detail_text"`
		Heading       string        `json:"heading"`
		ID            string        `json:"id"`
		ImageURL      string        `json:"image_url"`
		IsTag         bool          `json:"is_tag"`
		Media         []interface{} `json:"media"`
		Name          string        `json:"name"`
		ProductGroups []struct {
			Products []struct {
				ID                string `json:"id"`
				ImageMediumURL    string `json:"image_medium_url"`
				ImageThumbnailURL string `json:"image_thumbnail_url"`
				ImageURL          string `json:"image_url"`
				IsSell            bool   `json:"is_sell"`
				IsTodayDelivery   bool   `json:"is_today_delivery"`
				Name              string `json:"name"`
				Price             int    `json:"price"`
				SalePercent       int    `json:"sale_percent"`
				SalePrice         int    `json:"sale_price"`
				Seller            struct {
					ID       string `json:"id"`
					ImageURL string `json:"image_url"`
					Name     string `json:"name"`
					Text     string `json:"text"`
				} `json:"seller"`
			} `json:"products"`
			Tag struct {
				ID   string `json:"id"`
				Name string `json:"name"`
			} `json:"tag"`
		} `json:"product_groups"`
		Text  string `json:"text"`
		Title string `json:"title"`
		Type  string `json:"type"`
	} `json:"data"`
	Meta struct {
		Code  int `json:"code"`
		Count int `json:"count"`
	} `json:"meta"`
}

type Product struct {
	Data struct {
		AddInfo []struct {
			Key  string `json:"key"`
			Text string `json:"text"`
		} `json:"add_info"`
		BookmarkCount       int    `json:"bookmark_count"`
		BrandID             string `json:"brand_id"`
		CategoryHierarchies []struct {
			ID    string `json:"id"`
			Level int    `json:"level"`
			Name  string `json:"name"`
		} `json:"category_hierarchies"`
		CategoryId []struct {
			ID string `json:"id"`
		} `json:"category_id"`
		CouponApplyPrice  int           `json:"coupon_apply_price"`
		Coupons           []interface{} `json:"coupons"`
		CreatedTime       string        `json:"created_time"`
		DeliveryPrice     int           `json:"delivery_price"`
		EndTime           string        `json:"end_time"`
		FreeDeliveryPrice int           `json:"free_delivery_price"`
		ID                string        `json:"id"`
		ImageThumbnailURL string        `json:"image_thumbnail_url"`
		Images            []struct {
			ImageMediumURL    string `json:"image_medium_url"`
			ImageThumbnailURL string `json:"image_thumbnail_url"`
			ImageURL          string `json:"image_url"`
		} `json:"images"`
		InquiryCount           int           `json:"inquiry_count"`
		IsAllFreeDelivery      bool          `json:"is_all_free_delivery"`
		IsBookmark             bool          `json:"is_bookmark"`
		IsGenuineCertification bool          `json:"is_genuine_certification"`
		IsNew                  bool          `json:"is_new"`
		IsPartner              bool          `json:"is_partner"`
		IsPurchased            bool          `json:"is_purchased"`
		IsSell                 bool          `json:"is_sell"`
		IsSpecialPrice         bool          `json:"is_special_price"`
		IsTodayDelivery        bool          `json:"is_today_delivery"`
		MaxCouponInfo          interface{}   `json:"max_coupon_info"`
		Media                  []interface{} `json:"media"`
		Memo                   string        `json:"memo"`
		Name                   string        `json:"name"`
		OptionType             string        `json:"option_type"`
		Options                []struct {
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
		} `json:"options"`
		OriginalPoint       int `json:"original_point"`
		OriginalSalePercent int `json:"original_sale_percent"`
		OriginalSalePrice   int `json:"original_sale_price"`
		PartnerInfo         struct {
			Text  string `json:"text"`
			Title string `json:"title"`
		} `json:"partner_info"`
		Point              int           `json:"point"`
		PointPercent       int           `json:"point_percent"`
		PurchaseCount      int           `json:"purchase_count"`
		Price              int           `json:"price"`
		RelatationProducts []interface{} `json:"relatation_products"`
		SaleEndTime        string        `json:"sale_end_time"`
		SalePercent        int           `json:"sale_percent"`
		SalePrice          int           `json:"sale_price"`
		SaleStartTime      string        `json:"sale_start_time"`
		Seller             struct {
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
		} `json:"seller"`
		ServiceType     string `json:"service_type"`
		SettlementCount int    `json:"settlement_count"`
		SimpleText      string `json:"simple_text"`
		SprintVersion   int    `json:"sprint_version"`
		StartTime       string `json:"start_time"`
		Tags            []struct {
			ID   string `json:"id"`
			Name string `json:"name"`
		} `json:"tags"`
		Text     string      `json:"text"`
		Type     string      `json:"type"`
		VideoURL interface{} `json:"video_url"`
	} `json:"data"`
	Meta struct {
		Code  int `json:"code"`
		Count int `json:"count"`
	} `json:"meta"`
}

type Reviews struct {
	Meta struct {
		Code  int64 `json:"code"`
		Count int64 `json:"count"`
	} `json:"meta"`
	Data []Reivew `json:"data"`
}

type Reivew struct {
	ID           string `json:"id"`
	CreatedTime  string `json:"created_time"`
	Type         string `json:"type"`
	Text         string `json:"text"`
	LikeCount    int64  `json:"like_count"`
	CommentCount int64  `json:"comment_count"`
	IsLiked      bool   `json:"is_liked"`
	Product      struct {
		ID         string `json:"id"`
		ParentID   string `json:"parent_id"`
		OptionName string `json:"option_name"`
		SellerID   string `json:"seller_id"`
	} `json:"product"`
	User struct {
		ID           string `json:"id"`
		Name         string `json:"name"`
		ImageURL     string `json:"image_url"`
		Height       int64  `json:"height"`
		ShirtSize    string `json:"shirt_size"`
		PantsSize    string `json:"pants_size"`
		FootwearSize string `json:"footwear_size"`
	} `json:"user"`
	Evaluation struct {
		Satisfaction         string `json:"satisfaction"`
		WearingSensationCode string `json:"wearing_sensation_code"`
		WearingSensation     string `json:"wearing_sensation"`
	} `json:"evaluation"`
	Images []struct {
		ID                int64  `json:"id"`
		ImageThumbnailURL string `json:"image_thumbnail_url"`
		ImageMediumURL    string `json:"image_medium_url"`
		ImageURL          string `json:"image_url"`
	} `json:"images"`
}

type MainProducts struct {
	Meta Meta `json:"meta"`
	Data Data `json:"data"`
}

type Data struct {
	MainBanners   []Banner      `json:"main_banners"`
	MiddleBanners []Banner      `json:"middle_banners"`
	BottomBanners []interface{} `json:"bottom_banners"`
	Zoning1       []Zoning      `json:"zoning_1"`
	Zoning2       []Zoning      `json:"zoning_2"`
	Recommend     Recommend     `json:"recommend"`
}

type Banner struct {
	ID       string `json:"id"`
	ImageURL string `json:"image_url"`
	Type     string `json:"type"`
	Link     string `json:"link"`
}

type Recommend struct {
	Name     string             `json:"name"`
	Count    int64              `json:"count"`
	Products []RecommendProduct `json:"products"`
}

type RecommendProduct struct {
	ID                string     `json:"id"`
	ImageThumbnailURL string     `json:"image_thumbnail_url"`
	ImageMediumURL    string     `json:"image_medium_url"`
	ImageURL          string     `json:"image_url"`
	Name              string     `json:"name"`
	Price             int64      `json:"price"`
	SalePrice         int64      `json:"sale_price"`
	SalePercent       int64      `json:"sale_percent"`
	IsSell            bool       `json:"is_sell"`
	IsSpecialPrice    bool       `json:"is_special_price"`
	IsNew             bool       `json:"is_new"`
	IsFreeDelivery    bool       `json:"is_free_delivery"`
	IsHeartDelivery   bool       `json:"is_heart_delivery"`
	IsTodayDelivery   bool       `json:"is_today_delivery"`
	Statistics        Statistics `json:"statistics"`
	PurchaseCount     *int64     `json:"purchase_count,omitempty"`
	Seller            Seller     `json:"seller"`
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

type Statistics struct {
	PurchaseCount int64 `json:"purchase_count"`
}

type Zoning struct {
	ID       string            `json:"id"`
	Name     string            `json:"name"`
	Text     string            `json:"text"`
	Link     Link              `json:"link"`
	Products []Zoning1_Product `json:"products"`
}

type Link struct {
	Type  string `json:"type"`
	Value string `json:"value"`
}

type Zoning1_Product struct {
	ID                string     `json:"id"`
	ImageThumbnailURL string     `json:"image_thumbnail_url"`
	ImageMediumURL    string     `json:"image_medium_url"`
	ImageURL          string     `json:"image_url"`
	Name              string     `json:"name"`
	Price             int64      `json:"price"`
	SalePrice         int64      `json:"sale_price"`
	SalePercent       int64      `json:"sale_percent"`
	IsSell            bool       `json:"is_sell"`
	IsSpecialPrice    bool       `json:"is_special_price"`
	IsNew             bool       `json:"is_new"`
	IsFreeDelivery    bool       `json:"is_free_delivery"`
	IsTodayDelivery   bool       `json:"is_today_delivery"`
	Statistics        Statistics `json:"statistics"`
	PurchaseCount     *int64     `json:"purchase_count,omitempty"`
	Seller            Seller     `json:"seller"`
}

type Meta struct {
	Code  int64 `json:"code"`
	Count int64 `json:"count"`
}
