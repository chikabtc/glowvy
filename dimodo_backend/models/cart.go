package models

import (
	"database/sql"
	"fmt"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gchaincl/dotsql"
)

//UserService is a set of methods used to manipulate and work with account model
type CartService interface {
	AllCartItems(cart_id int) ([]Cart_item, error)
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
	cartDot, _ := dotsql.LoadFromFile("sql/queries/cart.pgsql")
	return &cartService{
		DB:  db,
		dot: cartDot,
	}
}

type Cart struct {
	Id      int         `json:"id,omitempty"`
	User_id int         `json:user_id,omitempty"`
	item    []Cart_item `json:"item,omitempty"`
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

func (cs *cartService) AllCartItems(cart_id int) ([]Cart_item, error) {
	rows, err := cs.dot.Query(cs.DB, "AllCartItems", cart_id)
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
		// msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		return err
		// row.Scan(&item.User_id)
	}
	return nil
}

//todo: calculate the total shipping and fees usign SQL
func (cs *cartService) CreateOrder(order Order) (*Order, error) {
	//move all the cart items to the order items and order
	fmt.Println("save userid: ", order.User_id)
	row, err := cs.dot.QueryRow(cs.DB, "CreateOrder", order.User_id, order.Address_id, order.Total_shipping, order.Total_fee)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CreateOrder: ", err)
		// msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		return nil, err
	}
	if err = row.Scan(
		&order.Id,
		&order.User_id,
		&order.Address_id,
		&order.Total_shipping,
		&order.Total_fee,
		&order.Date_created,
		&order.Is_paid,
	); err != nil {
		fmt.Println("fail to scan: ", err)
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
			&order.Address_id,
			&order.Total_shipping,
			&order.Total_fee,
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
	var order *Order
	// var user *user
	// var address *address

	// rows, err := cs.dot.Query(cs.DB, "OrderDetailByUserID", orderID)
	// if err != nil {
	// 	bugsnag.Notify(err)
	// 	fmt.Println("OrdersByUserID", err)
	// 	return nil, err
	// }
	// defer rows.Close()
	// for rows.Next() {
	// 	var order Order
	// 	if err := rows.Scan(
	// 		&order.Id,
	// 		&order.Is_paid,
	// 		&order.Date_created,
	// 	); err != nil {
	// 		fmt.Println("fail to scan OrdersByUserID: ", err)
	// 		return nil, err
	// 	}
	// 	orders = append(orders, order)

	// }
	// for i, order := range orders {
	// 	orderItems := []Order_item{}

	// 	rows, err = cs.dot.Query(cs.DB, "OrderItemsByID", order.Id)
	// 	if err != nil {
	// 		bugsnag.Notify(err)
	// 		fmt.Println("OrderItemsByID", err)
	// 		return nil, err
	// 	}
	// 	defer rows.Close()
	// 	for rows.Next() {
	// 		var item Order_item
	// 		if err := rows.Scan(
	// 			&item.Id,
	// 			&item.Quantity,
	// 			&item.Option,
	// 			&item.Option_id,
	// 			&item.Product.Id,
	// 			&item.Product.Name,
	// 			&item.Product.Thumbnail,
	// 			&item.Product.Price,
	// 			&item.Product.Sale_price,
	// 			&item.Product.Sale_percent); err != nil {
	// 			fmt.Println("fail to scan OrderItemsByID: ", err)
	// 			return nil, err
	// 		}
	// 		orderItems = append(orderItems, item)
	// 	}
	// 	orders[i].OrderItems = orderItems
	// }
	// if orders == nil {
	// 	orders = make([]Order, 0)
	// }

	return order, nil
}
