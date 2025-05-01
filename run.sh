docker run -d -p 5001:5901 -p 4001:22222 \
  -e VNC_PASSWORD=password \
  -v /etc/_docker/ubuntu-xfce-vnc:/root/.local/share \
  ubuntu-xfce-vnc
