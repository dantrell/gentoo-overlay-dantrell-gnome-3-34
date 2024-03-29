# Distributed under the terms of the GNU General Public License v2

EAPI="8"
VALA_MIN_API_VERSION="0.28"
VALA_MAX_API_VERSION="0.48"

inherit gnome.org gnome2-utils xdg meson vala

DESCRIPTION="Nibbles clone for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Nibbles https://gitlab.gnome.org/GNOME/gnome-nibbles"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	dev-libs/libgee:0.8=
	dev-libs/libgnome-games-support:1=
	>=media-libs/clutter-1.22.0:1.0
	>=media-libs/clutter-gtk-1.4.0:1.0
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.18.0:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50.2
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
