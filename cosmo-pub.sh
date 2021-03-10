LIBSRC=`ls lib/*.c`
CLISHARED="client/client_props.c client/client_shared.c"
CLIPUB="client/pub_client.c client/pub_shared.c"
CLISUB="client/sub_client.c client/sub_client_output.c"


COSMODIR="../cosmopolitan.fork"
#BUILDDIR=$COSMODIR/o/dbg
BUILDDIR=$COSMODIR/o/rel

COSMO_HEADER=$COSMODIR/o/cosmopolitan.h
COSMO_LIB=$BUILDDIR/cosmopolitan.a
COSMO_APE_LDS=$BUILDDIR/ape/ape.lds
COSMO_APE_O=$BUILDDIR/ape/ape.o
COSMO_CRT_O=$BUILDDIR/libc/crt/crt.o

OUT_DBG=./client_pub.com.dbg
OUT_BIN=./mosquitto_pub.com

gcc \
    -I./cosmo-include -I. -Iinclude -Ilib -Ideps \
    -DVERSION="\"2.0.8\"" \
    -g -Os -static -nostdlib -nostdinc -fno-pie -no-pie -mno-red-zone \
    -fno-omit-frame-pointer -pg -mnop-mcount \
    -o client_pub.com.dbg $LIBSRC $CLISHARED $CLIPUB \
    -fuse-ld=bfd -Wl,-T,$COSMO_APE_LDS \
    -include $COSMO_HEADER $COSMO_CRT_O $COSMO_APE_O $COSMO_LIB

objcopy -S -O binary $OUT_DBG $OUT_BIN

