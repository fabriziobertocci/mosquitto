include ../config.mk

.PHONY: all install uninstall reallyclean clean static static_pub static_sub static_rr

ifeq ($(WITH_SHARED_LIBRARIES),yes)
SHARED_DEP:=../lib/libmosquitto.so.${SOVERSION}
endif

ifeq ($(WITH_SHARED_LIBRARIES),yes)
ALL_DEPS:= mosquitto_pub.com mosquitto_sub.com mosquitto_rr.com
else
ifeq ($(WITH_STATIC_LIBRARIES),yes)
ALL_DEPS:= static_pub static_sub static_rr
endif
endif

all : ${ALL_DEPS}

static : static_pub static_sub static_rr
	# This makes mosquitto_pub/sub/rr versions that are statically linked with
	# libmosquitto only.

static_pub : pub_client.o pub_shared.o client_props.o client_shared.o ../lib/libmosquitto.a
	${CROSS_COMPILE}${CC} $^ -o mosquitto_pub.com.dbg ${CLIENT_LDFLAGS} ${STATIC_LIB_DEPS} ${CLIENT_STATIC_LDADD}
	objcopy -S -O binary mosquitto_pub.com.dbg mosquitto_pub.com

static_sub : sub_client.o sub_client_output.o client_props.o client_shared.o ../lib/libmosquitto.a
	${CROSS_COMPILE}${CC} $^ -o mosquitto_sub.com.dbg ${CLIENT_LDFLAGS} ${STATIC_LIB_DEPS} ${CLIENT_STATIC_LDADD}
	objcopy -S -O binary mosquitto_sub.com.dbg mosquitto_sub.com

static_rr : rr_client.o client_props.o client_shared.o pub_shared.o sub_client_output.o ../lib/libmosquitto.a
	${CROSS_COMPILE}${CC} $^ -o mosquitto_rr.com.dbg ${CLIENT_LDFLAGS} ${STATIC_LIB_DEPS} ${CLIENT_STATIC_LDADD}
	objcopy -S -O binary mosquitto_rr.com.dbg mosquitto_rr.com

mosquitto_pub.com : pub_client.o pub_shared.o client_shared.o client_props.o
	${CROSS_COMPILE}${CC} $(CLIENT_LDFLAGS) $^ -o $@ $(CLIENT_LDADD)
	objcopy -S -O $@.dbg $@

mosquitto_sub.com : sub_client.o sub_client_output.o client_shared.o client_props.o
	${CROSS_COMPILE}${CC} $(CLIENT_LDFLAGS) $^ -o $@ $(CLIENT_LDADD)
	objcopy -S -O $@.dbg $@

mosquitto_rr.com : rr_client.o client_shared.o client_props.o pub_shared.o sub_client_output.o
	${CROSS_COMPILE}${CC} $(CLIENT_LDFLAGS) $^ -o $@ $(CLIENT_LDADD)
	objcopy -S -O $@.dbg $@

pub_client.o : pub_client.c ${SHARED_DEP}
	${CROSS_COMPILE}${CC} $(CLIENT_CPPFLAGS) $(CLIENT_CFLAGS) -c $< -o $@

pub_shared.o : pub_shared.c ${SHARED_DEP}
	${CROSS_COMPILE}${CC} $(CLIENT_CPPFLAGS) $(CLIENT_CFLAGS) -c $< -o $@

sub_client.o : sub_client.c ${SHARED_DEP}
	${CROSS_COMPILE}${CC} $(CLIENT_CPPFLAGS) $(CLIENT_CFLAGS) -c $< -o $@

sub_client_output.o : sub_client_output.c sub_client_output.h ${SHARED_DEP}
	${CROSS_COMPILE}${CC} $(CLIENT_CPPFLAGS) $(CLIENT_CFLAGS) -c $< -o $@

rr_client.o : rr_client.c ${SHARED_DEP}
	${CROSS_COMPILE}${CC} $(CLIENT_CPPFLAGS) $(CLIENT_CFLAGS) -c $< -o $@

client_shared.o : client_shared.c client_shared.h
	${CROSS_COMPILE}${CC} $(CLIENT_CPPFLAGS) $(CLIENT_CFLAGS) -c $< -o $@

client_props.o : client_props.c client_shared.h
	${CROSS_COMPILE}${CC} $(CLIENT_CPPFLAGS) $(CLIENT_CFLAGS) -c $< -o $@

# The "testing" target is intended to make it easy to compile a quick client
# for testing purposes. testing.c should not be committed as a file.
testing : testing.o
	${CROSS_COMPILE}${CC} $(CLIENT_LDFLAGS) $^ -o $@  $(CLIENT_LDFLAGS) $(CLIENT_LDADD)

testing.o : testing.c
	${CROSS_COMPILE}${CC} $(CLIENT_CPPFLAGS) $(CLIENT_CFLAGS) -c $< -o $@


../lib/libmosquitto.so.${SOVERSION} :
	$(MAKE) -C ../lib

../lib/libmosquitto.a :
	$(MAKE) -C ../lib libmosquitto.a

install : all
	$(INSTALL) -d "${DESTDIR}$(prefix)/bin"
	$(INSTALL) ${STRIP_OPTS} mosquitto_pub "${DESTDIR}${prefix}/bin/mosquitto_pub"
	$(INSTALL) ${STRIP_OPTS} mosquitto_sub "${DESTDIR}${prefix}/bin/mosquitto_sub"
	$(INSTALL) ${STRIP_OPTS} mosquitto_rr "${DESTDIR}${prefix}/bin/mosquitto_rr"

uninstall :
	-rm -f "${DESTDIR}${prefix}/bin/mosquitto_pub"
	-rm -f "${DESTDIR}${prefix}/bin/mosquitto_sub"
	-rm -f "${DESTDIR}${prefix}/bin/mosquitto_rr"

reallyclean : clean

clean : 
	-rm -f *.o mosquitto_pub mosquitto_sub mosquitto_rr *.gcda *.gcno
