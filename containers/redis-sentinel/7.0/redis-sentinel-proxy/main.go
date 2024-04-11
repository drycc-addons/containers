package main

import (
	"context"
	"flag"
	"fmt"
	"io"
	"log"
	"net"

	"github.com/redis/go-redis/v9"
)

var (
	listen       = flag.String("listen", ":9999", "listen address")
	master       = flag.String("master", "", "name of the master redis node")
	sentinelAddr = flag.String("sentinel-addr", ":26379", "remote sentinel address")
	sentinelUser = flag.String("sentinel-user", "", "username to use when connecting to the sentinel server.")
	sentinelPass = flag.String("sentinel-pass", "", "password to use when connecting to the sentinel server.")
)

func proxy(local io.ReadWriteCloser, remoteAddr *net.TCPAddr) {
	remote, err := net.DialTCP("tcp", nil, remoteAddr)
	if err != nil {
		log.Println(err)
		local.Close()
		return
	}
	go func(r io.Reader, w io.WriteCloser) {
		io.Copy(w, r)
		w.Close()
	}(local, remote)
	go func(r io.Reader, w io.WriteCloser) {
		io.Copy(w, r)
		w.Close()
	}(remote, local)
}

func upstream() (*net.TCPAddr, error) {
	sentinel := redis.NewSentinelClient(&redis.Options{
		Addr:     *sentinelAddr,
		Username: *sentinelUser,
		Password: *sentinelPass,
	})
	addr, err := sentinel.GetMasterAddrByName(context.Background(), *master).Result()
	if err != nil {
		return nil, err
	}
	redisMasterAddr, err := net.ResolveTCPAddr(
		"tcp",
		fmt.Sprintf("%s:%s", addr[0], addr[1]),
	)
	if err != nil {
		return nil, err
	}
	return redisMasterAddr, nil
}

func main() {
	flag.Parse()

	listenAddr, err := net.ResolveTCPAddr("tcp", *listen)
	if err != nil {
		log.Fatalf("failed to resolve local address: %s", err)
	}

	listener, err := net.ListenTCP("tcp", listenAddr)
	if err != nil {
		log.Fatal(err)
	}

	for {
		downstream, err := listener.AcceptTCP()
		if err != nil {
			log.Println(err)
			continue
		}
		upstream, err := upstream()
		if err != nil {
			log.Println(err)
			continue
		}
		go proxy(downstream, upstream)
	}
}
