#
#   Makefile - wrap around create_jail to make things simple
#
.include <bsd.own.mk>

TOP=    ${PWD}
JDIR=	${TOP}/jails
CREATE_JAIL=	${TOP}/create_jail

TARGETS=	pluginjail standard portjail
RELEASE=	9.2-RELEASE
MIRROR=		ftp://ftp.freebsd.org

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

pluginjail_x86: git-verify
	@cd ${TOP};
	${ENV_SETUP} ${CREATE_JAIL} -t pluginjail -a x86 -r ${RELEASE} -m ${MIRROR}

pluginjail_x64: git-verify
	@cd ${TOP};
	${ENV_SETUP} ${CREATE_JAIL} -t pluginjail -a x64 -r ${RELEASE} -m ${MIRROR}

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

pluginjail: pluginjail_x86 pluginjail_x64
standard: standard_x86 standard_x64
portjail: portjail_x86 portjail_x64

standard:

clean: git-verify
	find ${TOP} | xargs chflags noschg
	rm -rf ${TOP}/jails

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
