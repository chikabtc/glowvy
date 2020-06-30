package models

import (
	"database/sql"
	"fmt"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gchaincl/dotsql"
)

type AddressService interface {
	GetAddess(userID int) ([]Address, error)
	CreateAddress(address *Address) (*Address, error)
	UpdateAddress(address *Address) (*Address, error)
	DeleteAddress(address *Address) error
	ListDistrictsByID(id int) ([]District, error)
	ListWardsByID(id int) ([]Ward, error)
	AllProvinces() ([]Province, error)
}

type addressService struct {
	DB  *sql.DB
	dot *dotsql.DotSql
}

type Address struct {
	Id             int    `json:"id,omitempty"`
	Recipient_name string `json:"recipient_name,omitempty"`
	Street         string `json:"street,omitempty"`
	Ward_id        int    `json:"ward_id,omitempty"`
	Ward           Ward   `json:"ward,omitempty"`
	PhoneNumber    string `json:"phone_number,omitempty"`
	User_id        int    `json:"user_id,omitempty"`
	Is_default     bool   `json:"is_default"`
}

type Province struct {
	Id    int    `json:"id,omitempty"`
	Name  string `json:"name,omitempty"`
	Index int    `json:"index,omitempty"`
}
type District struct {
	Id          int      `json:"id,omitempty"`
	Name        string   `json:"name,omitempty"`
	Province_id int      `json:"province_id,omitempty"`
	Province    Province `json:"province,omitempty"`
}

type Ward struct {
	Id          int      `json:"id,omitempty"`
	Name        string   `json:"name,omitempty"`
	Province_id int      `json:"province_id,omitempty"`
	Province    Province `json:"province,omitempty"`
	District_id int      `json:"district_id,omitempty"`
	District    District `json:"district,omitempty"`
}

func NewAddressService(db *sql.DB) AddressService {
	addressDot, _ := dotsql.LoadFromFile("sql/address.pgsql")
	return &addressService{
		DB:  db,
		dot: addressDot,
	}
}

func (as *addressService) GetAddess(userID int) ([]Address, error) {
	var addresses []Address
	//todo: current data structure only support one address. Improve it later
	rows, err := as.dot.Query(as.DB, "GetAllAddresses", userID)

	for rows.Next() {
		var address Address

		rows.Scan(
			&address.Id,
			&address.Recipient_name,
			&address.PhoneNumber,
			&address.Street,
			&address.Ward.Province.Name,
			&address.Ward.District.Name,
			&address.Ward.Name,
			&address.Is_default)

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

		addresses = append(addresses, address)

	}

	return addresses, nil
}

func (as *addressService) CreateAddress(address *Address) (*Address, error) {
	if address.Is_default {
		err := as.MakeAllAddressesNonDefault(address.User_id)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println("err:", err)
		}
	}
	row, err := as.dot.QueryRow(as.DB, "CreateAddress",
		address.Recipient_name,
		address.Street,
		address.Ward_id,
		address.PhoneNumber,
		address.User_id,
		address.Is_default)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CreateAddress err:", err)
	}
	err = row.Scan(
		&address.Id,
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CreateAddress err:", err)
	}
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

	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("err:", err)
	}
	return address, err
}
func (as *addressService) UpdateAddress(address *Address) (*Address, error) {
	if address.Is_default {
		err := as.MakeAllAddressesNonDefault(address.User_id)
		if err != nil {
			bugsnag.Notify(err)
			fmt.Println("err:", err)
		}
	}
	//todo: current data structure only support one address. Improve it later
	row, err := as.dot.QueryRow(as.DB, "UpdateAddress",
		address.Recipient_name,
		address.Street,
		address.Ward_id,
		address.PhoneNumber,
		address.Is_default,
		address.Id,
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CreateAddress err:", err)
	}
	err = row.Scan(
		&address.Id,
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("CreateAddress err:", err)
	}
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

	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("err:", err)
	}
	return address, err
}

func (as *addressService) MakeAllAddressesNonDefault(userId int) error {
	_, err := as.dot.Exec(as.DB, "MakeAllAddressesNonDefault", userId)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("err:", err)
	}
	return err
}
func (as *addressService) DeleteAddress(address *Address) error {
	fmt.Println("addresss id to delete", address.Id)

	_, err := as.dot.Exec(as.DB, "DeleteAddress",
		address.Id,
	)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("err:", err)
	}
	return err
}

func (as *addressService) ListDistrictsByID(id int) ([]District, error) {
	rows, err := as.dot.Query(as.DB, "queryListDistrict", id)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println(err)
		return nil, err
	}
	defer rows.Close()
	districts := []District{}
	for rows.Next() {
		var district District
		if err := rows.Scan(&district.Id, &district.Name, &district.Province_id, &district.Province.Name); err != nil {
			fmt.Println(err)
			return nil, err
		}
		districts = append(districts, district)
	}
	return districts, nil
}

func (as *addressService) ListWardsByID(id int) ([]Ward, error) {
	rows, err := as.dot.Query(as.DB, "queryListWard", id)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}
	defer rows.Close()
	wards := []Ward{}
	for rows.Next() {
		var ward Ward
		if err := rows.Scan(&ward.Id, &ward.Name, &ward.Province_id, &ward.District_id); err != nil {
			return nil, err
		}
		wards = append(wards, ward)
	}
	return wards, nil
}

func (as *addressService) AllProvinces() ([]Province, error) {
	rows, err := as.dot.Query(as.DB, "queryAllProvinces")
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}
	defer rows.Close()
	provinces := []Province{}
	for rows.Next() {
		var province Province
		if err := rows.Scan(&province.Id, &province.Name, &province.Index); err != nil {
			return nil, err
		}
		provinces = append(provinces, province)
	}
	return provinces, nil
}
