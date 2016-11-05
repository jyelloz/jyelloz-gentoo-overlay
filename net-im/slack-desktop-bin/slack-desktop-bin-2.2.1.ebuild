# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="desktop client for Slack"
HOMEPAGE=""
SRC_URI="https://downloads.slack-edge.com/linux_releases/slack-2.2.1-0.1.fc21.x86_64.rpm"

LICENSE="Proprietary"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

inherit rpm

src_unpack () {
	rpm_unpack ${A}
	local dest="/opt/${P}"
	install -d "${S}"
	mv usr/* "${S}"
	rm -vr etc
	cat <<-EOF > "${T}/99slack"
	PATH="${dest}/bin"
	XDG_DATA_DIRS="${dest}/share"
	EOF
	sed \
		-e "s:/usr:${dest}:g" \
		-i "${S}/share/applications/slack.desktop" || die
}

src_prepare () {
	eapply_user
}

src_compile () {
	return
}

src_install () {
	local dest="/opt/${P}"
	local ddest="${ED}${dest#/}"
	pwd
	ls -la
	dodir "${dest}"
	cp -pPR bin lib share "${ddest}" || die
	dodir /etc/env.d
	insinto /etc/env.d
	doins "${T}/99slack" || die
}
