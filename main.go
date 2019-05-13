package main

import "flag"
import "golang.org/x/net/http2"
import "net/http"
//import "bytes"
//import "io/ioutil"
import "fmt"
import "crypto/tls"
import "time"

var (
	prod = flag.Bool("prod", false, "Whether to configure itself to be the production server.")
	//target = flag.String("target", "https://127.0.0.1:4430/reqinfo", "target url to call with GET")
	//target = flag.String("target", "https://127.0.0.1:4430/nnrf-disc/v1/nf-instances", "target url to call with GET")
	//target = flag.String("target", "https://127.0.0.1:4430/nudm-sdm/v2/imsi-012345678901234/am-data", "target url to call with GET")
	target = flag.String("target", "https://127.0.0.1:4430/amfstart", "target url to call with GET")
	count =  flag.Int("count", 100, "10 x count = requests from UE to AMF from a single container")
)

func main() {
	flag.Parse()
	//target := "http://127.0.0.1:8080"
	//target := "https://127.0.0.1:4430/reqinfo"
	//target := "https://http2.golang.org/reqinfo"
	target := *target
	count := *count
	msgmultiplier := count * 10
	fmt.Println("target: " + target)
	fmt.Printf("msgmultiplier: %d\n", count)
	var avgtime, successes, errors int64 = 0,0,0

	certs, err := tls.LoadX509KeyPair("server.crt", "server.key")
	if err != nil {
		fmt.Printf("error %v\n", err)
	}

	t := &http2.Transport{
		TLSClientConfig: &tls.Config{
			Certificates: []tls.Certificate{certs},
			InsecureSkipVerify: true,
		},
	}
	c := &http.Client{
		Transport: t,
	}

	for i:=0;i<msgmultiplier;i=i+1 {
		// create request
		//r, _ := http.NewRequest("GET", target, bytes.NewBuffer([]byte("hello")))
		//target = target + "?target-nf-type=AUSF&requester-nf-type=AMF"
		r, _ := http.NewRequest("GET", target, nil)

		// call the server
		var t1=currentTime()
		var t2=currentTime()
		resp, err := c.Do(r)
		var t3=currentTime()
		var t=t3-t2-(t2-t1)
		if err != nil {
			fmt.Printf("time: %d; request error: %v\n", t, err)
			errors+=1
		} else {
			if resp != nil {
				if resp.Body != nil {
					resp.Body.Close()
				}
			}

			//defer resp.Body.Close()
			fmt.Printf("starttime: %d; timetaken: %d; response: %v\n", t1, t, resp)
			//content, _ := ioutil.ReadAll(resp.Body)
			//fmt.Printf("body length:%d\n", len(content))
			//resstring := string(content)
			//fmt.Println(resstring)
			successes+=1
			avgtime += t
		}
	}

	fmt.Printf("averagetimetaken: %d; successes: %d; errors: %d", avgtime/int64(msgmultiplier), successes, errors)
}

func currentTime() int64 {
	return time.Now().UnixNano()
}
