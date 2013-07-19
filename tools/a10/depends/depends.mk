# your working dir
WORKINGDIR=/opt/melehacking
# where do your binaries go?
EXPORTDIR=/opt/allwinner
# whether to compile for armhf
USEARMHF=1

ifeq ($(USEARMHF), 1)
HF=hf
else
HF=
endif

ifeq ($(shell uname -m),armv7l)
###################
# do native compile
#
# where is your arm rootfs
SDKSTAGE=/
# where is your dest-directory
export PREFIX=/
# where is your toolchain
TOOLCHAIN=/usr
# how many make jobs to start
JOBS=1
export BUILD=arm-linux-gnueabi$(HF)
export HOST=arm-linux-gnueabi$(HF)
export CROSS_COMPILE=

else
##################
# do cross compile
#
# where is your arm rootfs
SDKSTAGE=$(WORKINGDIR)/rootfs/debrootfs
# where is your dest-directory
export PREFIX=$(EXPORTDIR)/vlc
# where is your toolchain
TOOLCHAIN=/usr/arm-linux-gnueabi$(HF)
# how many make jobs to start
JOBS=2
export BUILD=amd64-linux
export HOST=arm-linux-gnueabi$(HF)
export CROSS_COMPILE=${HOST}-

endif

export RLINK_PATH=-Wl,-rpath-link,$(SDKSTAGE)/usr/local/lib:${SDKSTAGE}/lib:${SDKSTAGE}/lib/arm-linux-gnueabi$(HF):${SDKSTAGE}/usr/lib:${SDKSTAGE}/usr/lib/arm-linux-gnueabi$(HF)
export LDFLAGS=\
${RLINK_PATH} \
-L${PREFIX}/lib \
-L${SDKSTAGE}/usr/local/lib \
-L${SDKSTAGE}/lib \
-L${SDKSTAGE}/lib/arm-linux-gnueabi$(HF) \
-L${SDKSTAGE}/usr/lib \
-L${SDKSTAGE}/usr/lib/arm-linux-gnueabi$(HF)

ifeq ($(USEARMHF), 1)
export CFLAGS=-pipe -O2 -mlong-calls -mthumb -fstrict-aliasing -fprefetch-loop-arrays -ffast-math -mfloat-abi=hard -mtune=cortex-a8 -mcpu=cortex-a8 -mfpu=neon -march=armv7-a -ftree-vectorize -mvectorize-with-neon-quad -funsafe-math-optimizations
else
export CFLAGS=-pipe -O2 -mfloat-abi=softfp -mtune=cortex-a8 -mcpu=cortex-a8
endif

export CFLAGS+=\
-isystem${SDKSTAGE}/usr/local/include \
-isystem${SDKSTAGE}/usr/include \
-isystem${SDKSTAGE}/usr/include/arm-linux-gnueabi$(HF)

export CEDARINCLUDES=-I$(PREFIX)/include
export CFLAGS+=$(CEDARINCLUDES)

export CFLAGS+=${LDFLAGS}
export CXXFLAGS=${CFLAGS}
export CPPFLAGS=${CFLAGS}
export LD=${CROSS_COMPILE}ld
export AR=${CROSS_COMPILE}ar
export CC=${CROSS_COMPILE}gcc
export CXX=${CROSS_COMPILE}g++
export CXXCPP=${CXX} -E
export RANLIB=${CROSS_COMPILE}ranlib
export STRIP=${CROSS_COMPILE}strip
export OBJDUMP=${CROSS_COMPILE}objdump
export PATH:=${PREFIX}/bin:${TOOLCHAIN}/bin:$(PATH)
export PKG_CONFIG_SYSROOT_DIR=${SDKSTAGE}
export PKG_CONFIG_LIBDIR=${PREFIX}/lib/pkgconfig:${SDKSTAGE}/lib/pkgconfig:${SDKSTAGE}/usr/lib/pkgconfig:${SDKSTAGE}/usr/lib/arm-linux-gnueabi$(HF)/pkgconfig:${SDKSTAGE}/usr/share/pkgconfig:${SDKSTAGE}/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH=${PREFIX}/bin/pkg-config
