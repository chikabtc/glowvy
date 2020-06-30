package models

import (
	"database/sql"
	"dimodo_backend/utils"
	"fmt"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gchaincl/dotsql"
)

//UserService is a set of methods used to manipulate and work with account model
type CartService interface {
	AllCartItems(userId int) ([]Cart_item, error)
	AvailableCoupons(userId int) ([]Coupon, error)
	CreateCartItem(item Cart_item) (int, error)
	CreateOrder(order Order) (*Order, error)
	UpdateItemCart(item *Cart_item) error
	DeleteCartItem(item *Cart_item) error
	OrderHistoryByUserID(authID int) ([]Order, error)
	OrderDetailByOrderID(orderID int) (*Order, error)
}

type cartService struct {
	DB  *sql.DB
	dot *dotsql.DotSql
}

func NewCartService(db *sql.DB) CartService {
	cartDot, _ := dotsql.LoadFromFile("sql/cart.pgsql")
	return &cartService{
		DB:  db,
		dot: cartDot,
	}
}

type Cart struct {
	Id     int         `json:"id,omitempty"`
	UserId int         `json:"user_id,omitempty"`
	item   []Cart_item `json:"item,omitempty"`
}

type Cart_item struct {
	Id         int     `json:"id,omitempty"`
	User_id    int     `json:"user_id,omitempty"`
	Option_id  int     `json:"option_id,omitempty"`
	Product_id int     `json:"product_id,omitempty"`
	Product    Product `json:"product,omitempty"`
	Quantity   int     `json:"quantity,omitempty"`
	Option     string  `json:"option,omitempty"`
}

type Coupon struct {
	Id                 int    `json:"id,omitempty"`
	UserId             int    `json:"user_id,omitempty"`
	Code               string `json:"code,omitempty"`
	Description        string `json:"description,omitempty"`
	DiscountType       string `json:"discount_type,omitempty"`
	DiscountAmount     int    `json:"discount_amount"`
	DiscountPercentage int    `json:"discount_percentage"`
	UsageLimit         int    `json:"usage_limit"`
	UsageCount         int    `json:"usage_count"`
	MinimumAmount      int    `json:"minimum_amount"`
	MaximumAmount      int    `json:"maximum_amount"`
	DateExpires        int    `json:"date_expires,omitempty"`
	DateCreated        int    `json:"date_created,omitempty"`
}
type Order struct {
	Id              int          `json:"order_id,omitempty"`
	User_id         int          `json:"user_id,omitempty"`
	User            User         `json:"user,omitempty"`
	Address_id      int          `json:"address_id,omitempty"`
	Address         Address      `json:"address,omitempty"`
	Total_shipping  float64      `json:"total_shipping,omitempty"`
	Total_fee       float64      `json:"total_fee,omitempty"`
	Total_discounts float64      `json:"total_discounts"`
	Date_created    int64        `json:"date_created,omitempty"`
	OrderItems      []Order_item `json:"order_items,omitempty"`
	AppliedCoupons  []Coupon     `json:"applied_coupons,omitempty"`
	Is_paid         bool         `json:"is_paid"`
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

func (cs *cartService) AllCartItems(userId int) ([]Cart_item, error) {
	rows, err := cs.dot.Query(cs.DB, "AllCartItems", userId)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}
	defer rows.Close()
	itemInCart := []Cart_item{}
	for rows.Next() {
		var item Cart_item
		if err := rows.Scan(
			&item.Id,
			&item.Quantity,
			&item.Option,
			&item.Option_id,
			&item.Product.Id,
			&item.Product.Name,
			&item.Product.CategoryId,
			&item.Product.Thumbnail,
			&item.Product.Price,
			&item.Product.Sale_price,
			&item.Product.Sale_percent); err != nil {
			return nil, err
		}
		itemInCart = append(itemInCart, item)
	}
	return itemInCart, nil
}

func (cs *cartService) AvailableCoupons(userId int) ([]Coupon, error) {
	rows, err := cs.dot.Query(cs.DB, "AvailableCoupons", userId)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}
	defer rows.Close()
	coupons := []Coupon{}
	for rows.Next() {
		var coupon Coupon
		if err := rows.Scan(
			&coupon.Id,
			&coupon.UserId,
			&coupon.Code,
			&coupon.Description,
			&coupon.DiscountType,
			&coupon.DiscountAmount,
			&coupon.DiscountPercentage,
			&coupon.UsageLimit,
			&coupon.UsageCount,
			&coupon.MinimumAmount,
			&coupon.MaximumAmount,
			&coupon.DateCreated,
			&coupon.DateExpires,
		); err != nil {
			return nil, err
		}
		fmt.Println("descript", coupon.Description)
		coupons = append(coupons, coupon)
	}
	return coupons, nil
}

func (cs *cartService) CreateCartItem(item Cart_item) (int, error) {
	_, err := cs.dot.Exec(cs.DB, "CreateCartItem", item.User_id, item.Option_id, item.Product_id, item.Quantity, item.Option)
	fmt.Printf("cart item unmarshalled: %v %v %v \n", item.Option_id, item.Quantity, item.Option)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CreateCartItem: ", err)
		// msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		return 0, err
	}
	return 1, err
}

//update the quantity
func (cs *cartService) UpdateItemCart(item *Cart_item) error {
	row, err := cs.dot.QueryRow(cs.DB, "UpdateCartItem", item.User_id, item.Option_id, item.Quantity)

	fmt.Println("cart item to update: ", item.Option_id)
	fmt.Println("UpdateItemCart userId: ", item.User_id)
	fmt.Println("UpdateItemQauntity userId: ", item.Quantity)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("UpdateCartItem: ", err)

		// msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		return err
	}
	row.Scan(&item.Quantity, &item.User_id)
	return nil
}

func (cs *cartService) DeleteCartItem(item *Cart_item) error {
	_, err := cs.dot.Exec(cs.DB, "RemoveCartItem", item.User_id, item.Option_id)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("RemoveCartItem: ", err)
		return err
	}
	return nil
}

//todo: calculate the total shipping and fees usign SQL
func (cs *cartService) CreateOrder(order Order) (*Order, error) {
	//move all the cart items to the order items and order
	fmt.Println("save userid: ", order.User_id)
	row, err := cs.dot.Exec(cs.DB, "CreateOrder", order.User_id, order.Address_id, order.Total_shipping, order.Total_fee, order.Total_discounts)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CreateOrder: ", err)
		return nil, err
	}
	if row != nil {
		fmt.Println("nil row", row)

	}

	for _, coupon := range order.AppliedCoupons {
		fmt.Println("order couponID: ", coupon.Id)
		_, err := cs.dot.Exec(cs.DB, "UpdateCouponUsageCount", coupon.Id, order.User_id)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println("UpdateCouponUsageCount fail to exec: ", err)
			return nil, err
		}
	}

	return &order, nil
}
func (cs *cartService) OrdersItemsByID(orderID int) ([]Order_item, error) {
	rows, err := cs.dot.Query(cs.DB, "OrderItemsByID", orderID)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}
	defer rows.Close()
	orderItems := []Order_item{}
	for rows.Next() {
		var item Order_item
		if err := rows.Scan(
			&item.Id,
			&item.Quantity,
			&item.Option,
			&item.Option_id,
			&item.Product.Id,
			&item.Product.Name,
			&item.Product.Thumbnail,
			&item.Product.Price,
			&item.Product.Sale_percent,
			&item.Product.Sale_percent); err != nil {
			return nil, err
		}
		orderItems = append(orderItems, item)
	}
	return orderItems, nil
}

// //how to retrieve multiple objects??
func (cs *cartService) OrderHistoryByUserID(authID int) ([]Order, error) {
	var orders []Order

	rows, err := cs.dot.Query(cs.DB, "OrdersByUserID", authID)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("OrdersByUserID", err)
		return nil, err
	}
	defer rows.Close()
	for rows.Next() {
		var order Order
		if err := rows.Scan(
			&order.Id,
			&order.User_id,
			&order.Is_paid,
			&order.Address_id,
			&order.Total_shipping,
			&order.Total_fee,
			&order.Total_discounts,
			&order.Date_created,
		); err != nil {
			fmt.Println("fail to scan OrdersByUserID: ", err)
			return nil, err
		}
		orders = append(orders, order)

	}
	for i, order := range orders {
		orderItems := []Order_item{}

		rows, err = cs.dot.Query(cs.DB, "OrderItemsByID", order.Id)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println("OrderItemsByID", err)
			return nil, err
		}
		defer rows.Close()
		for rows.Next() {
			var item Order_item
			if err := rows.Scan(
				&item.Id,
				&item.Quantity,
				&item.Option,
				&item.Option_id,
				&item.Product.Id,
				&item.Product.CategoryId,
				&item.Product.Name,
				&item.Product.Thumbnail,
				&item.Product.Price,
				&item.Product.Sale_price,
				&item.Product.Sale_percent); err != nil {
				fmt.Println("fail to scan OrderItemsByID: ", err)
				return nil, err
			}
			orderItems = append(orderItems, item)
		}
		orders[i].OrderItems = orderItems
	}

	if orders == nil {
		orders = make([]Order, 0)
	}

	return orders, nil
}

func (cs *cartService) OrderDetailByOrderID(orderID int) (*Order, error) {
	var order Order
	var user User
	var address Address
	fmt.Println("order id", orderID)

	//get order detail
	row, err := cs.dot.QueryRow(cs.DB, "OrderDetailByOrderID", orderID)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("OrdersByUserID", err)
		return nil, err
	}
	err = row.Scan(
		&order.Id,
		&order.User_id,
		&order.Address_id,
		&order.Total_fee,
		&order.Total_shipping,
		&order.Is_paid)

	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("fail to scan order", err)
		return nil, err
	}

	orderItems := []Order_item{}
	rows, err := cs.dot.Query(cs.DB, "OrderItemsByID", order.Id)

	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("OrderItemsByID", err)
		return nil, err
	}
	defer rows.Close()
	for rows.Next() {
		var item Order_item
		if err := rows.Scan(
			&item.Id,
			&item.Quantity,
			&item.Option,
			&item.Option_id,
			&item.Product.Id,
			&item.Product.Name,
			&item.Product.Thumbnail,
			&item.Product.Price,
			&item.Product.Sale_price,
			&item.Product.Sale_percent); err != nil {
			fmt.Println("fail to scan OrderItemsByID: ", err)
			return nil, err
		}
		orderItems = append(orderItems, item)
	}
	order.OrderItems = orderItems

	//get user
	utils.PrintJson(user)
	row, err = cs.dot.QueryRow(cs.DB, "GetUserById", order.User_id)
	row.Scan(
		&user.Id,
		&user.User_name,
		&user.Email,
		&user.Password,
		&user.Full_name,
		&user.Display_name,
		&user.Phone,
		&user.Avatar,
		&user.Birthday,
		&user.Rid,
		&user.Xid,
		&user.Sid,
		&user.Token,
		&user.Session,
		&user.Signer,
		&user.Active,
	)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}

	//todo: current data structure only support one address. Improve it later
	row, err = cs.dot.QueryRow(cs.DB, "getAddrssQuery", order.User_id)

	row.Scan(
		&address.Id,
		&address.Recipient_name,
		&address.PhoneNumber,
		&address.Street,
		&address.Ward.Province.Name,
		&address.Ward.District.Name,
		&address.Ward.Name)

	if err != nil {
		bugsnag.Notify(err)
		switch err {
		case sql.ErrNoRows:
			print("no row found")
			return nil, ErrNotFound
		default:
			return nil, err
		}
	}
	if address.Recipient_name == "" {
		return nil, nil
	}

	order.User = user
	order.Address = address

	return &order, nil
}
