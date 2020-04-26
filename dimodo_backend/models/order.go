package models

type Order struct {
	Id             int          `json:"order_id,omitempty"`
	User_id        int          `json:"user_id,omitempty"`
	Address_id     int          `json:"address_id,omitempty"`
	Total_shipping float64      `json:"total_shipping,omitempty"`
	Total_fee      float64      `json:"total_fee,omitempty"`
	Date_created   int          `json:"date_created,omitempty"`
	OrderItems     []Order_item `json:"order_items,omitempty"`
	Is_paid        bool         `json:"is_paid"`
}

type Order_item struct {
	Id         int     `json:"order_item_id,omitempty"`
	Order_id   int     `json:"order_id,omitempty"`
	User_id    int     `json:"user_id,omitempty"`
	Option_id  int     `json:"option_id,omitempty"`
	Product_id int     `json:"product_id,omitempty"`
	Product    Product `json:"product,omitempty"`
	Quantity   int     `json:"quantity,omitempty"`
	Option     string  `json:"option,omitempty"`
}
