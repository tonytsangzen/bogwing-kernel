VERSION=4.9.162
CROSS_COMPILE=aarch64-linux-gnu-
ARCH=arm64

.PHONY:all
all:vmlinux-${VERSION}

linux-${VERSION}.tar.xz:
	wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${VERSION}.tar.xz

linux-${VERSION}:linux-${VERSION}.tar.xz
	tar xvf $<
	cp bogwing_defconfig $@/arch/arm64/configs/

vmlinux-${VERSION}:linux-${VERSION}
	make -C $< ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} bogwing_defconfig
	make -C $< ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} -j 40
	cp $</arch/arm64/boot/Image $@

.PHONY:debug
debug:
	qemu-system-aarch64 -M virt -cpu cortex-a53  -m 1G -gdb tcp::26000 -S -kernel linux-${VERSION}/arch/arm64/boot/Image -nographic

.PHONY:clean
clean:
	rm -rf linux-${VERSION}
	rm vmlinux-${VERSION}
