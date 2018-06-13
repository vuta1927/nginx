- Cau lenh push data tu camera len server nginx:
AIfuturiX2018
fmpeg -i "rtsp://[camera_ip]/user=admin&password=&channel=1&stream=0.sdp?real_stream" -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -c:a libmp3lame -ab 128k -ar 44100 -c:v copy -threads 2 -f flv rtmp://[ip_server_nginx:1935]/myapp/live
rtsp://admin:admin@192.168.100.177:5544/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif