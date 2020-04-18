package controllers

import (
	"dimodo_backend/models"
	"dimodo_backend/utils/jwt"
	resp "dimodo_backend/utils/respond"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/bugsnag/bugsnag-go"
)

type Cart struct {
	cs models.CartService
}

func NewCart(cs models.CartService) *Cart {
	return &Cart{
		cs: cs,
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
func (c *Cart) CreateOrder(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	auth := jwt.Payload(r)
	order, err := c.cs.CreateOrder(auth.Id)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(err))
		return
	}
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
