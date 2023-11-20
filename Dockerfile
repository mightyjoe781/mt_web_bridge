FROM alpine:3.14

ENV MINETEST_GAME_VERSION 5.4.1
ENV MULTICRAFT_TAG 2.0.4
ENV MT_WORLD prismo

# add build dependencies

RUN apk add --no-cache git build-base irrlicht-dev cmake bzip2-dev libpng-dev \
	jpeg-dev libxxf86vm-dev mesa-dev sqlite-dev libogg-dev \
	libvorbis-dev openal-soft-dev curl-dev freetype-dev zlib-dev \
	gmp-dev jsoncpp-dev postgresql-dev luajit-dev ca-certificates


# add prometheus
WORKDIR /usr/src/
RUN git clone --recursive https://github.com/jupp0r/prometheus-cpp/ && \
	mkdir prometheus-cpp/build && \
	cd prometheus-cpp/build && \
	cmake .. \
	-DCMAKE_INSTALL_PREFIX=/usr/local \
	-DCMAKE_BUILD_TYPE=Release \
	-DENABLE_TESTING=0 && \
	make -j2 && \
	make install

# add multicraft
WORKDIR /usr/src/
RUN git clone --recursive --depth 1 --branch ${MULTICRAFT_TAG} https://github.com/MultiCraft/MultiCraft/ multicraft && \
	mkdir multicraft/build && \
	cd multicraft/build && \
	cmake .. \
	-DCMAKE_INSTALL_PREFIX=/usr/local \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_SERVER=TRUE \
	-DENABLE_PROMETHEUS=TRUE \
	-DENABLE_PROMETHEUS=TRUE \
	-DBUILD_UNITTESTS=FALSE \
	-DBUILD_CLIENT=FALSE && \
	make -j2 && \
	make install

# add minetest_game
WORKDIR /usr/local/share/multicraft
RUN git clone --depth=1 -b ${MINETEST_GAME_VERSION} https://github.com/minetest/minetest_game.git ./games/minetest_game && \
	rm -fr ./games/minetest_game/.git

FROM alpine:3.14 as setup

# RUN apk upgrade
RUN apk add --no-cache sqlite-libs curl gmp libgcc libpq libstdc++ luajit screen tmux && \
	adduser -D multicraft --uid 30000 -h /var/lib/multicraft && \
	chown -R multicraft:multicraft /var/lib/multicraft

WORKDIR /var/lib/multicraft

COPY --from=0 /usr/local/share/multicraft /usr/local/share/multicraft
COPY --from=0 /usr/local/bin/multicraftserver /usr/local/bin/multicraftserver
COPY --from=0 /usr/local/share/doc/multicraft/multicraft.conf.example /etc/multicraft/multicraft.conf

USER multicraft:multicraft

EXPOSE 30000/udp 30000/tcp
EXPOSE 45001

VOLUME /var/lib/multicraft/worlds/${MT_WORLD}
COPY entrypoint.sh /var/lib/multicraft/

# CMD ["/usr/local/bin/multicraftserver", "--config", "/etc/multicraft/multicraft.conf", "--gameid","minetest"]
# CMD ["/entrypoint.sh"]