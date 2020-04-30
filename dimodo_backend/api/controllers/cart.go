package controllers

import (
	"dimodo_backend/models"
	"dimodo_backend/sql/queries/utils"
	"dimodo_backend/utils/jwt"
	resp "dimodo_backend/utils/respond"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gorilla/mux"
	"github.com/leekchan/accounting"
)

type Cart struct {
	cs    models.CartService
	slack *utils.Slack
}

func NewCart(cs models.CartService, slack *utils.Slack) *Cart {
	return &Cart{
		cs:    cs,
		slack: slack,
	}
}

func (c *Cart) CreateCartItem(w http.ResponseWriter, r *http.Request) {
	auth := jwt.Payload(r)
	fmt.Printf("authId: %v \n ", auth.Id)

	var item models.Cart_item
	item.User_id = auth.Id
	decoder := json.NewDecoder(r.Body)

	if err := decoder.Decode(&item); err != nil {
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	defer r.Body.Close()

	quantity, err := c.cs.CreateCartItem(item)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(quantity))
}

func (c *Cart) AllCartItems(w http.ResponseWriter, r *http.Request) {
	//get user id from JWT token ?? how does this work?
	auth := jwt.Payload(r)
	print("authId: ", auth.Id)

	cartItems, err := c.cs.AllCartItems(auth.Id)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(cartItems))
}

func (c *Cart) UpdateCartItem(w http.ResponseWriter, r *http.Request) {
	var item models.Cart_item
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&item); err != nil {
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	defer r.Body.Close()

	auth := jwt.Payload(r)
	item.User_id = auth.Id // Use for security not pass Id Account into Body
	err := c.cs.UpdateItemCart(&item)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(item))
}

func (c *Cart) DeleteCartItem(w http.ResponseWriter, r *http.Request) {
	var item models.Cart_item
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&item); err != nil {
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	defer r.Body.Close()

	auth := jwt.Payload(r)
	item.User_id = auth.Id // Use for security not pass Id Account into Body
	err := c.cs.DeleteCartItem(&item)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(item))
}

//create new order by generating new id and creation time and moving cart_items to the order_detail tables
//it also sends slack notification when the user creates an order
func (c *Cart) CreateOrder(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	auth := jwt.Payload(r)
	//parse shipping fee, address, and total fees
	var order *models.Order

	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&order); err != nil {
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	defer r.Body.Close()
	order.User_id = auth.Id
	fmt.Println("order userid: ", auth.Id)

	order, err := c.cs.CreateOrder(*order)

	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
		return
	}
	userId := strconv.Itoa(order.User_id)
	orderId := strconv.Itoa(order.Id)
	// totalFee := fmt.Sprintf("%g", order.Total_fee)
	ac := accounting.Accounting{}
	totalFee := ac.FormatMoney(order.Total_fee)
	values := map[string]string{"text": "userId " + userId + " submitted order of " + totalFee + "₫ (orderId: " + orderId + ")"}

	orderBytes, _ := json.Marshal(values)

	err = c.slack.UpdateLiveSalesOnSlack(orderBytes)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("fail to update live sale to slack", err)
	}

	resp.Json(w, r, http.StatusOK, resp.WithSuccess(order))
}

func (c *Cart) OrderDetailByOrderID(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	// auth := jwt.Payload(r)
	params := mux.Vars(r)
	orderId, err := strconv.Atoi(params["id"])

	//returns order, address, and user info
	order, err := c.cs.OrderDetailByOrderID(orderId)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
		return
	}

	//order
	//address/
	//user info
	//

	resp.Json(w, r, http.StatusOK, resp.WithSuccess(order))
}

func (c *Cart) OrderHistoryByUserID(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	auth := jwt.Payload(r)
	orders, err := c.cs.OrderHistoryByUserID(auth.Id)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
		return
	}

	resp.Json(w, r, http.StatusOK, resp.WithSuccess(orders))
}
