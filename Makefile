#
#   Makefile - wrap around create_jail to make things simple
#
.include <bsd.own.mk>

TOP=    ${PWD}
JDIR=	${TOP}/jails
CREATE_JAIL=	${TOP}/create_jail

#TARGETS=	pluginjail standard portjail jail
TARGETS=	pluginjail jail
RELEASE=	9.3-RELEASE
MIRROR=		ftp://ftp.freebsd.org

STANDARD_PATH_x86=	${JDIR}/x86/freenas-standard-${RELEASE}
STANDARD_PATH_x64=	${JDIR}/x64/freenas-standard-${RELEASE}
PORTJAIL_PATH_x86=	${JDIR}/x86/freenas-portjail-${RELEASE}
PORTJAIL_PATH_x64=	${JDIR}/x64/freenas-portjail-${RELEASE}
PLUGINJAIL_PATH_x86=	${JDIR}/x86/freenas-pluginjail-${RELEASE}
PLUGINJAIL_PATH_x64=	${JDIR}/x64/freenas-pluginjail-${RELEASE}
JAIL_PATH_x86=		${JDIR}/x86/freenas-jail-${RELEASE}
JAIL_PATH_x64=		${JDIR}/x64/freenas-jail-${RELEASE}

ARCH!=	uname -m
.if ${ARCH} == "amd64"
ARCH=	x64
.else
ARCH=	x86
.endif

GIT_REPO_SETTING=${TOP}/.git-repo-setting
.if exists(${GIT_REPO_SETTING})
GIT_LOCATION!=cat ${GIT_REPO_SETTING}
.endif

ENV_SETUP=env GIT_LOCATION=${GIT_LOCATION}

.include <bsd.prog.mk>

list:
	@echo ${TARGETS}

help: list

standard_x86: git-verify
	@cd ${TOP};
	${ENV_SETUP} ${CREATE_JAIL} -t standard -a x86 -r ${RELEASE} -m ${MIRROR}

standard_x64: git-verify
	@cd ${TOP};
	${ENV_SETUP} ${CREATE_JAIL} -t standard -a x64 -r ${RELEASE} -m ${MIRROR}

portjail_x86: git-verify
	@cd ${TOP};
	${ENV_SETUP} ${CREATE_JAIL} -t portjail -a x86 -r ${RELEASE} -m ${MIRROR}

portjail_x64: git-verify
	@cd ${TOP};
	${ENV_SETUP} ${CREATE_JAIL} -t portjail -a x64 -r ${RELEASE} -m ${MIRROR}

pluginjail_x86: git-verify
	@cd ${TOP};
	${ENV_SETUP} ${CREATE_JAIL} -t pluginjail -a x86 -r ${RELEASE} -m ${MIRROR}

pluginjail_x64: git-verify
	@cd ${TOP};
	${ENV_SETUP} ${CREATE_JAIL} -t pluginjail -a x64 -r ${RELEASE} -m ${MIRROR}

jail_x86: git-verify
	@cd ${TOP};
	${ENV_SETUP} ${CREATE_JAIL} -t jail -a x86 -r ${RELEASE} -m ${MIRROR}

jail_x64: git-verify
	@cd ${TOP};
	${ENV_SETUP} ${CREATE_JAIL} -t jail -a x64 -r ${RELEASE} -m ${MIRROR}

custom: git-verify
.if defined(NAME)
	@cd ${TOP};
	${ENV_SETUP} ${CREATE_JAIL} -t standard -a x64 -r ${RELEASE} -m ${MIRROR} -n ${NAME}
.endif


pluginjail: pluginjail_x86 pluginjail_x64 
standard: standard_x86 standard_x64
portjail: portjail_x86 portjail_x64
jail: jail_x86 jail_x64


clean_standard_x86:
.if exists(${STANDARD_PATH_x86}.tgz)
	rm -rf ${STANDARD_PATH_x86}.tgz
.endif
.if exists(${STANDARD_PATH_x86})
	find ${STANDARD_PATH_x86} | xargs chflags noschg
	rm -rf ${STANDARD_PATH_x86}
.endif
clean_standard_x64:
.if exists(${STANDARD_PATH_x64}.tgz)
	rm -rf ${STANDARD_PATH_x64}.tgz
.endif
.if exists(${STANDARD_PATH_x64})
	find ${STANDARD_PATH_x64} | xargs chflags noschg
	rm -rf ${STANDARD_PATH_x64}
.endif
clean_standard: clean_standard_x86 clean_standard_x64

clean_portjail_x86:
.if exists(${PORTJAIL_PATH_x86}.tgz)
	rm -rf ${PORTJAIL_PATH_x86}.tgz
.endif
.if exists(${PORTJAIL_PATH_x86})
	find ${PORTJAIL_PATH_x86}|xargs chflags noschg
	rm -rf ${PORTJAIL_PATH_x86}
.endif
clean_portjail_x64:
.if exists(${PORTJAIL_PATH_x64}.tgz)
	rm -rf ${PORTJAIL_PATH_x64}.tgz
.endif
.if exists(${PORTJAIL_PATH_x64})
	find ${PORTJAIL_PATH_x64}|xargs chflags noschg
	rm -rf ${PORTJAIL_PATH_x64}
.endif
clean_portjail: clean_portjail_x86  clean_portjail_x64

clean_pluginjail_x86:
.if exists(${PLUGINJAIL_PATH_x86}.tgz)
	rm -rf ${PLUGINJAIL_PATH_x86}.tgz
.endif
.if exists(${PLUGINJAIL_PATH_x86})
	find ${PLUGINJAIL_PATH_x86}|xargs chflags noschg
	rm -rf ${PLUGINJAIL_PATH_x86}
.endif
clean_pluginjail_x64:
.if exists(${PLUGINJAIL_PATH_x64}.tgz)
	rm -rf ${PLUGINJAIL_PATH_x64}.tgz
.endif
.if exists(${PLUGINJAIL_PATH_x64})
	find ${PLUGINJAIL_PATH_x64}|xargs chflags noschg
	rm -rf ${PLUGINJAIL_PATH_x64}
.endif
clean_pluginjail: clean_pluginjail_x86 clean_pluginjail_x64

clean_jail_x86:
.if exists(${JAIL_PATH_x86}.tgz)
	rm -rf ${JAIL_PATH_x86}.tgz
.endif
.if exists(${JAIL_PATH_x86})
	find ${JAIL_PATH_x86}|xargs chflags noschg
	rm -rf ${JAIL_PATH_x86}
.endif
clean_jail_x64:
.if exists(${JAIL_PATH_x64}.tgz)
	rm -rf ${JAIL_PATH_x64}.tgz
.endif
.if exists(${JAIL_PATH_x64})
	find ${JAIL_PATH_x64}|xargs chflags noschg
	rm -rf ${JAIL_PATH_x64}
.endif
clean_pluginjail: clean_jail_x86 clean_jail_x64

clean_custom:
.if defined(NAME) && exists(${JDIR}/x64/${NAME}-${RELEASE}.tgz)
	find ${JDIR}/x64/${NAME}-${RELEASE}|xargs chflags noschg
	rm -rf ${JDIR}/x64/${NAME}-${RELEASE}.tgz
	rm -rf ${JDIR}/x64/${NAME}-${RELEASE}
.endif

clean: git-verify clean_standard clean_portjail clean_pluginjail clean_jail
	@rm -rf ${JDIR}

git-verify:
	@if [ ! -f ${GIT_REPO_SETTING} ]; then \
		echo "No git repo choice is set.  Please use \"make git-external\" to build as an "; \
		echo "external developer or \"make git-internal\" to build as an iXsystems"; \
		echo "internal developer.  You only need to do this once."; \
		exit 1; \
        fi
	@echo "NOTICE: You are building from the ${GIT_LOCATION} git repo."


git-internal:
	@echo "INTERNAL" > ${GIT_REPO_SETTING}
	@echo "You are set up for internal (iXsystems) development.  You can use"
	@echo "the standard make targets now."

git-external:
	@echo "EXTERNAL" > ${GIT_REPO_SETTING}
	@echo "You are set up for external (github) development.  You can use"
	@echo "the standard make targets now."


all: ${TARGETS}
