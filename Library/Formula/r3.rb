class R3 < Formula
  desc "High-performance URL router library"
  homepage "https://github.com/c9s/r3"
  url "https://github.com/c9s/r3/archive/1.3.3.tar.gz"
  sha256 "347faa8011df9e8194b3ccf9bbf529882b1e331421d98aa78c788cb47db3df92"

  bottle do
    cellar :any
    sha256 "0ec7081059cb9e392b56cf27b44da1b33ed4e16ab9cb8b9e665b70f2569f2eff" => :mavericks
    sha256 "02ec0063b2d8ee60d6ef5ecea92dd191c86ba48acd5d5e20d71e524eb5a0d93e" => :mountain_lion
    sha256 "018f6e681d2abc8a02c0cd873f8e442bb3966a57cc92f69bdab110ed181b2660" => :lion
  end

  option :universal
  option "with-graphviz", "Enable Graphviz functions"

  head "https://github.com/c9s/r3.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "graphviz" => :optional
  depends_on "jemalloc" => :recommended

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--enable-graphviz" if build.with? "graphviz"
    args << "--with-malloc=jemalloc" if build.with? "jemalloc"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "r3.h"
      int main() {
          node * n = r3_tree_create(1);
          r3_tree_free(n);
          return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                  "-lr3", "-I#{include}/r3"
    system "./test"
  end
end
