# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for ollama AI service"

ACCT_USER_ID=-1
ACCT_USER_HOME=/opt/ollama-bin
ACCT_USER_HOME_PERMS=0755
ACCT_USER_GROUPS=( "${PN}" video )

acct-user_add_deps
