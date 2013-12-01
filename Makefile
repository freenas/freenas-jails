#
#   Makefile - wrap around create_jail to make things simple
#
.include <bsd.own.mk>

TOP=    ${.CURDIR}
JDIR=	${TOP}/jails
CREATE_JAIL=	${TOP}/create_jail

TARGETS=	pluginjail standard portjail
RELEASE=	9.2-RELEASE
MIRROR=		ftp://ftp.freebsd.org

ARCH!=	uname -m
.if ${ARCH} == "amd64"
ARCH=	x64
.else
ARCH=	x32
.endif

.include <bsd.prog.mk>

list:
	@echo ${TARGETS}

pluginjail_x32:
	@cd ${TOP};
	${CREATE_JAIL} -t pluginjail -a x32 -r ${RELEASE} -m ${MIRROR}

pluginjail_x64:
	@cd ${TOP};
	${CREATE_JAIL} -t pluginjail -a x64 -r ${RELEASE} -m ${MIRROR}

standard_x32:
	@cd ${TOP};
	${CREATE_JAIL} -t standard -a x32 -r ${RELEASE} -m ${MIRROR}

standard_x64:
	@cd ${TOP};
	${CREATE_JAIL} -t standard -a x64 -r ${RELEASE} -m ${MIRROR}

portjail_x32:
	@cd ${TOP};
	${CREATE_JAIL} -t portjail -a x32 -r ${RELEASE} -m ${MIRROR}

portjail_x64:
	@cd ${TOP};
	${CREATE_JAIL} -t portjail -a x64 -r ${RELEASE} -m ${MIRROR}

pluginjail: pluginjail_x32 pluginjail_x64
standard: standard_x32 standard_x64
portjail: portjail_x32 portjail_x64

clean:
	find ${TOP} | xargs chflags noschg
	rm -rf ${TOP}/jails

git-internal:
	@echo "Setting up for internal git repository"

git-external:
	@echo "Setting up for external git repository"

all: ${TARGETS}
