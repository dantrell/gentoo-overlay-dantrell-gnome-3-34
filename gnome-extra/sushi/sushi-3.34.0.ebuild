# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson

DESCRIPTION="A quick previewer for Nautilus, the GNOME file manager"
HOMEPAGE="https://gitlab.gnome.org/GNOME/sushi"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="office wayland"

# Optional app-office/unoconv support (OOo to pdf)
# freetype needed for font loader
# gtk+[X] optionally needed for sushi_create_foreign_window(); when wayland is more widespread, might want to not force it
COMMON_DEPEND="
	>=x11-libs/gdk-pixbuf-2.23[introspection]
	>=dev-libs/gjs-1.40
	>=dev-libs/glib-2.29.14:2
	>=dev-libs/gobject-introspection-0.9.6:=
	>=media-libs/clutter-1.11.4:1.0[introspection]
	>=media-libs/clutter-gtk-1.0.1:1.0[introspection]
	>=x11-libs/gtk+-3.13.2:3[X,introspection,wayland?]

	>=app-text/evince-3.0[introspection]
	media-libs/freetype:2
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	>=media-libs/harfbuzz-0.9.9:=
	media-libs/clutter-gst:3.0[introspection]
	media-libs/musicbrainz:5=
	net-libs/webkit-gtk:4[introspection]
	x11-libs/gtksourceview:3.0[introspection]

	office? ( app-office/unoconv )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/nautilus-3.1.90
"

src_prepare() {
	if ! use wayland; then
		# From Gentoo:
		# 	https://forums.gentoo.org/viewtopic-p-8106588.html#8106588
		eapply "${FILESDIR}"/${PN}-3.34.0-fix-without-gdkwayland.patch
	fi

	gnome2_src_prepare
}

src_configure() {
	# Prevent sandbox violations when we need write access to
	# /dev/dri/card* in its init phase, bug #358755
	for card in /dev/dri/card* ; do
		addpredict "${card}"
	done

	# Prevent sandbox violations when we need write access to
	# /dev/dri/render* in its init phase, bug #358755
	for render in /dev/dri/render* ; do
		addpredict "${render}"
	done

	meson_src_configure
}
