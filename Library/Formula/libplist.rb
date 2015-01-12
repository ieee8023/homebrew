require "formula"

class Libplist < Formula
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libplist-1.12.tar.bz2"
  sha1 "48f071c723387637ef2cc2980d4ca0627aab067b"

  bottle do
    cellar :any
    sha1 "abd1c58c509b305549310367feab44bca513d647" => :yosemite
    sha1 "e7bf9fbf14a51449b6b8dd5c2f084ace824f553f" => :mavericks
    sha1 "40172d50d4c836931dbfd38700a9088842c56b6c" => :mountain_lion
  end

  head do
    url "http://git.sukimashita.com/libplist.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-python", "Enable Cython Python bindings"

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on :python => :optional

  resource "cython" do
    url "http://cython.org/release/Cython-0.21.tar.gz"
    sha1 "f5784539870715e33b51374e9c4451ff6ff21c7f"
  end

  def install
    ENV.deparallelize
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    if build.with? "python"
      resource("cython").stage do
        ENV.prepend_create_path "PYTHONPATH", buildpath+"lib/python2.7/site-packages"
        system "python", "setup.py", "build", "install", "--prefix=#{buildpath}",
                 "--single-version-externally-managed", "--record=installed.txt"
      end
      ENV.prepend_path "PATH", "#{buildpath}/bin"
    else
      args << "--without-cython"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
