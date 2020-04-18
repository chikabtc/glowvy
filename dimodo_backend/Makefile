hello:
	echo "Deploy Dimodo_backend TO Server"

build:
	rm dimodo_backend
	GOOS=linux GOARCH=amd64 go build .

to-server:
	ssh root@139.180.131.81
	# rm  app/dimodo_backend
	kill -9 $(sudo lsof -t -i:80)
	exit .
copy-toserver:
	scp dimodo_backend root@139.180.131.81:~/


	