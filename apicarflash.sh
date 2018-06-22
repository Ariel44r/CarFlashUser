#!/bin/bash

while [[ "$#" > 0 ]]; do case $1 in

  -gc|--getcoupons)
	curl -X GET \
	'http://www.car-flash.mx/api/coupon.php?user_id=21&language_id=1&language_code=en' \
  	method="GET -> coupons"
	shift;
  ;;
  -gvc|--getviewcars)
	curl -X GET \
	'http://www.car-flash.mx/api/car_by_city.php?city_id=mexico&language_id=1&language_code=en' \
	method="GET -> viewCars"
	shift;
  ;;
  -gvwm|--getviewwalletmoney)
	curl -X GET \
	'http://www.car-flash.mx/api/view_wallent_money.php?language_id=1&language_code=en' \
	method="GET -> viewWalletMoney"
	shift;
  ;;
  -pcd|--postchangedrop)
	curl -X POST \
  	http://www.car-flash.mx/api/change_drop_location.php \
  	-H 'Content-Type: application/json' \
	-F drop_lat=19.3434349 \
	-F drop_long=-99.1747671 \
	-F drop_location=myLocation \
	-F app_id=1 \
	-F ride_id=11 \
	-F language_code=1
	method="POST -> changeDrop"
	shift;
  ;;
  -pvcwt|--postviewcarswithtime)
	curl -X POST \
	http://www.car-flash.mx/Carflash/Rental/Car_Type \
	-H 'Content-Type: application/json' \
	-F city_name=mexico \
	-F latitude=19.3434349 \
	-F longitude=-99.1747671 \
	-F language_id=en \
	-F language_code=1
	method="POST -> viewCardsWithTime"
	shift;
  ;;
  -gcl|--getcitylist)
	curl -X GET \
	'http://www.car-flash.mx/api/city.php?language_id=1&language_code=en' \
	method="GET -> cityList"
	shift;
  ;;
  -gau|--getaboutus)
	curl -X GET \
	'http://www.car-flash.mx/api/about.php?language_id=1&language_code=en' \
	method="GET -> aboutUs"
	shift;
  ;;
  -pcsa|--postcustomersupportapi)
	curl -X POST \
	http://www.car-flash.mx/Carflash/Common/Customer_support \
	-H 'Content-Type: application/json' \
	-F name=Ariel \
	-F driver_id=18 \
	-F user_id=21 \
	-F email=ariel44r@gmail.com \
	-F phone=5576604221 \
	-F query= \
	-F application=1 \
	-F language_id=1 \
	-F language_code=en \
	-F =
	method="POST -> customerSupportAPI"
	shift;
  ;;
  -gtc|--gettermsconditions)
	curl -X GET \
	'http://www.car-flash.mx/api/tc.php?language_id=1&language_code=en' \
	-H 'Cache-Control: no-cache' \
	-H 'Content-Type: application/json' \
	-H 'Postman-Token: d7f9d2c5-3f62-4c0a-b085-f1b46959cbe5'
	method="GET -> termsConditions"
	shift;
  ;;
  -grc|--getratecard)
	curl -X GET \
	'http://www.car-flash.mx/api/rate_card_city.php?city_id=1&car_type_id=1&language_id=1&language_code=en' \
	method="GET -> rateCard"
	shift;
  ;;
  -gres|--getrideestimatedscreen)
	curl -X GET \
	'http://www.car-flash.mx/api/ride_estimate.php?city_id=1&car_type_id=1&pickup_lat=19&pickup_long=-99&ride_time=45&language_id=1&language_code=en' \
	method="GET -> rideEstimatedScreen"
	shift;
  ;;
  -gcr|--getconfirmride)
	method="GET -> confirmRide";
	curl -X GET \
	'http://www.car-flash.mx/api/ride_now.php?user_id=21&coupon_code=123123&pickup_lat=19&pickup_long=-99&pickup_location=aa&drop_lat=19&drop_long=-99.12&drop_location=as&ride_type=1&ride_status=1&car_type_id=1&payment_option_id=1&card_id=1&pem_file=1&language_id=1&language_code=en' \
	shift;
  ;;
  -grlc|--getridelaterconfirm)
	method="GET -> rideLaterConfirm";
	url="http://www.car-flash.mx/api/ride_later.php?user_id=21&coupons_code=1111&pickup_lat=19&pickup_long=-99&pickup_location=11&drop_lat=33&drop_long=23&drop_location=23"
	curl -X GET \
	'http://www.car-flash.mx/api/ride_later.php?user_id=21&coupons_code=1111&pickup_lat=19&pickup_long=-99&pickup_location=11&drop_lat=33&drop_long=23&drop_location=23' \
	shift;
  ;;
  *) echo "Unknown parameter passed: $1"; exit 1;;

esac;
echo -e "\n\n\n\n============================================== [ APICarFlash ] ================================================================"
echo -e "\n=========> [ method: $method ]"
echo -e "\n=========> [ URL: $url ]\n\n"
shift;
done
