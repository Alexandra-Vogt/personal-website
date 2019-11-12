FROM alpine:3.7
RUN addgroup -S guests && adduser -S visitor -G guests
COPY $PWD/TMOUT.sh /etc/profile
COPY $PWD/visitor/ /home/visitor
WORKDIR /home/visitor
ENV ENV="home/visitor/.profile"
USER visitor
