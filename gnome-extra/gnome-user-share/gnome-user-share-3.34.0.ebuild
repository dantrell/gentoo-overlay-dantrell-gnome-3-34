# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2 meson multilib systemd

DESCRIPTION="Personal file sharing for the GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-user-share"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="+nautilus"

# FIXME: could libnotify be made optional ?
# FIXME: selinux automagic support
RDEPEND="
	>=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3:3
	nautilus? ( >=gnome-base/nautilus-3.27.90 )
	media-libs/libcanberra[gtk3]
	>=www-apache/mod_dnssd-0.6
	>=www-servers/apache-2.2[apache2_modules_dav,apache2_modules_dav_fs,apache2_modules_authn_file,apache2_modules_auth_digest,apache2_modules_authz_groupfile]
	>=x11-libs/libnotify-0.7:=
"
DEPEND="${RDEPEND}
	!<gnome-base/gnome-control-center-3.9
	app-text/yelp-tools
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# Upstream forces to use prefork because of Fedora defaults, but
	# that is problematic for us (bug #551012)
	# https://bugzilla.gnome.org/show_bug.cgi?id=750525#c2
	eapply "${FILESDIR}"/${PN}-3.18.1-no-prefork.patch

	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-D systemduserunitdir="$(systemd_get_userunitdir)"
		$(meson_use nautilus nautilus_extension)
		-D httpd=apache2
		-D modules_path=/usr/$(get_libdir)/apache2/modules/
	)
	meson_src_configure
}
